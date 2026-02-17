public with sharing class ClansServiceImpl extends ClashApiService implements IClansService {
    private List<Player__c> playerRecords = new List<Player__c>();

    public void registerForTracking(List<String> clanTags) {
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        // NOTE: external service does not support bulk format and multiple requests must be sent one-by-one
        for (String clanTag : clanTags) {
            setRequest(new Map<String, String> { 'tag' => clanTag.remove('#') });

            // NOTE: explicit use of 'this' for clarity; inherited from ClashApiService base class
            this.execute();
            handleServiceResponse();
        }

        IPlayers playersDomain = Players.newInstance(playerRecords);

        // TODO: ideally, support native upsert which is not part of standard fflib unit of work; extend fflib_SObjectUnitOfWork to support native upsert
        playersDomain.insertClanMembers(uow);
        uow.commitWork();

        initializeWarTracking(clanTags);
    }

    public override void setRequest(Map<String, String> argumentsByParameter) {
        // NOTE: explicit use of 'this' for clarity; inherited from ClashApiService base class
        this.request = new HttpRequest();
        request.setEndpoint('callout:Clash_API/v1/clans/%23' + argumentsByParameter.get('tag'));
        request.setMethod('GET');
    }

    public override void handleServiceResponse() {
        for (Clans.Clan c : new List<Clans.Clan> { (Clans.Clan) JSON.deserialize(this.response.getBody(), Clans.Clan.class) }) {
            addPlayers(playerRecords, c);
        }
    }

    private void addPlayers(List<Player__c> playerRecords, Clans.Clan c) {
        for (Clans.Member clanMember : c.memberList) {
            playerRecords.add(
                new Player__c(
                    Name = clanMember.name,
                    Tag__c = clanMember.tag,
                    Clan__r = new Clan__c(Tag__c = c.tag.remove('#').toUpperCase()),
                    Town_Hall_Level__c = clanMember.townHallLevel,
                    Role__c = clanMember.role
                )
            );
        }
    }

    private void initializeWarTracking(List<String> clanTags) {
        System.enqueueJob(new ClashApiService.Queued(Types.CLAN_WARS, clanTags));
    }
}