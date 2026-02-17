public with sharing class PlayersServiceImpl extends ClashApiService implements IPlayersService {
    private List<Player__c> playerRecords = new List<Player__c>();

    public void upsertPlayers(List<String> playerTags) {
        fflib_ISObjectUnitOfWork uow = Application.ClashTrackerUnitOfWork.getInstance();
        IClashTrackerWork work = new ClashTrackerWork(new List<Schema.SObjectType> {
            Player__c.SObjectType
        });
        work.setUpsertExternalIdField(Player__c.SObjectType, Player__c.Tag__c);

        // NOTE: external service does not support bulk format and multiple requests must be sent one-by-one
        for (String playerTag : playerTags) {
            setRequest(new Map<String, String> { 'tag' => playerTag.remove('#') });

            // NOTE: explicit use of 'this' for clarity; inherited from ClashApiService base class
            this.execute();
            handleServiceResponse();
        }

        IPlayers playersDomain = Players.newInstance(playerRecords);
        playersDomain.upsertPlayers(uow, work);
        
        try {
            uow.commitWork();
        } catch (Exception ex) {
            // TODO: discard players looking up to non-existent clan records and retry
        }
        
    }

    public override void handleServiceResponse() {
        for (Players.Player player : new List<Players.Player> { (Players.Player) JSON.deserialize(this.response.getBody(), Players.Player.class) }) {
            playerRecords.add(
                new Player__c(
                    Name = player.name,
                    /**
                     * NOTE:
                     *      the '#' character is trimmed in before context triggers
                     *      failing to trim this before DML results in a duplicate external Id error
                     *      the normalized value will already exist for existing players
                     *      the upserted record won't match properly at upsert time
                     */ 
                    Tag__c = player.tag.remove('#'),
                    Town_Hall_Level__c = player.townHallLevel,
                    War_Stars__c = player.warStars,
                    /**
                     * NOTE:
                     *      if a player has changed clans and the new clan isn't tracked, this will fail on commitWork
                     *      treat as transient error and retry after removing the culprit player(s)
                     */
                    Clan__r = new Clan__c(Tag__c = player.clan.tag.remove('#').toUpperCase())
                )
            );
        }
    }

    public override void setRequest(Map<String, String> argumentsByParameter) {
        // NOTE: explicit use of 'this' for clarity; inherited from ClashApiService base class
        this.request = new HttpRequest();
        request.setEndpoint('callout:Clash_API/v1/players/%23' + argumentsByParameter.get('tag'));
        request.setMethod('GET');
    }
}