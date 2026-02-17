public with sharing class ClanWarsServiceImpl extends ClashApiService implements IClanWarsService {
    /**
     * war states enum reference:
     *      GROUP_NOT_FOUND, NOT_IN_WAR, PREPARATION, WAR, ENDED
     */
    private List<Clan_War__c> clanWarRecords = new List<Clan_War__c>();

    public void processWars(List<String> clanTags) {
        try {
            // NOTE: external service does not support bulk format and multiple requests must be sent one-by-one
            for (String clanTag : clanTags) {
                setRequest(new Map<String, String> { 'tag' => clanTag.remove('#') });

                // NOTE: explicit use of 'this' for clarity; inherited from ClashApiService base class
                this.execute();
                handleServiceResponse();
            }

            if (clanWarRecords.size() > 0) {
                fflib_ISObjectUnitOfWork singletonUow = Application.ClashTrackerUnitOfWork.getInstance();
                IClanWars clanWarsDomain = ClanWars.newInstance(clanWarRecords);
                clanWarsDomain.registerNewRecords(singletonUow);

                singletonUow.commitWork();
            }
        } catch (Exception ex) {
            String apiResponse = this.response.getBody();
            if (apiResponse.length() > 32700) {
                apiResponse = apiResponse.substring(0, 32700);
            }
            apiResponse = String.valueOf(this.response.getStatusCode()) + '\n' + apiResponse;

            // TODO: refactor according to a more robust design
            insert new Apex_Debug_Log__c(
                Name = ex.getTypeName() + ' @ ' + String.valueOf(System.now()),
                Inbound_Message__c = ex.getStackTraceString(),
                Type__c = 'Error',
                Message__c = String.valueOf(ex.getLineNumber()) + ': ' + ex.getMessage(),
                Outbound_Message__c = apiResponse
            );
        }
    }

    public override void setRequest(Map<String, String> argumentsByParameter) {
        // NOTE: explicit use of 'this' for clarity; inherited from ClashApiService base class
        this.request = new HttpRequest();
        request.setEndpoint('callout:Clash_API/v1/clans/%23' + argumentsByParameter.get('tag') + '/currentwar');
        request.setMethod('GET');
    }

    // TODO: ideally, support native upsert which is not part of standard fflib unit of work; extend fflib_SObjectUnitOfWork to support native upsert
    public override void handleServiceResponse() {
        for (ClanWars.War w : new List<ClanWars.War> { (ClanWars.War) JSON.deserialize(this.response.getBody(), ClanWars.War.class) }) {
            // NOTE: clanTag not available in response if clan is not in war; always fetch from request endpoint for consistency
            String clanTag = this.request.getEndpoint().substringBetween('%23', '/');
            String jobName = 'Check War for ' + clanTag + ' @ ';
            Datetime dt = System.now();
            Integer bufferMinutes = 1440;

            if (w.state.equalsIgnoreCase('preparation') || w.state.equalsIgnoreCase('inWar')) {
                // TODO: player tags across all clans in context should be collected before enqueuing job
                System.enqueueJob(new ClashApiService.Queued(Types.PLAYERS, getPlayerTags(w)));
                jobName = jobName.replace('Check War', 'End War');
                dt = ClashApiService.getDatetime(w.endTime);
                bufferMinutes = 2;
            } else if (w.state.equalsIgnoreCase('warEnded')) {
                finalizeClanWarPerformances(w);
            }

            scheduleNextRun(clanTag, jobName, dt, bufferMinutes);
        }
    }

    private List<String> getPlayerTags(ClanWars.War w) {
        List<String> playerTags = new List<String>();

        for (ClanWars.Member player : w.clan.members) {
            playerTags.add(player.tag.remove('#'));
        }

        return playerTags;
    }

    private void finalizeClanWarPerformances(ClanWars.War w) {
        Clan_War__c clanWar = new Clan_War__c(
            Name = w.clan.name + ' vs. ' + w.opponent.name,
            Clan__r = new Clan__c(Tag__c = w.clan.tag.remove('#').toUpperCase()),
            Preparation_Time__c = ClashApiService.getDatetime(w.preparationStartTime),
            Start_Time__c = ClashApiService.getDatetime(w.startTime),
            End_Time__c = ClashApiService.getDatetime(w.endTime),
            State__c = w.state,
            Outcome__c = getOutcome(w)
        );
        clanWarRecords.add(clanWar);

        addClanWarPerformances(w, clanWar);
    }

    private String getOutcome(ClanWars.War w) {
        return
            w.clan.stars > w.opponent.stars ? 'Win' :
            w.clan.stars < w.opponent.stars ? 'Lose' :
            w.clan.destructionPercentage > w.opponent.destructionPercentage ? 'Win' :
            w.clan.destructionPercentage < w.opponent.destructionPercentage ? 'Lose' :
            'Draw';
    }

    private void addClanWarPerformances(ClanWars.War w, Clan_War__c clanWar) {
        for (ClanWars.Member player : w.clan.members) {
            /**
             * NOTE: war roster is immutable and set prior to warEnded state; all players will exist
             */
            addPlayerClanWarPerformances(player, clanWar);
        }
    }

    private void addPlayerClanWarPerformances(ClanWars.Member player, Clan_War__c clanWar) {
        List<Clan_War_Performance__c> clanWarPerformanceRecords = new List<Clan_War_Performance__c>();

        if (player.attacks == null) {
            player.attacks = getMissedAttacks(2, player.tag);
        } else if (player.attacks.size() == 1) {
            player.attacks.addAll(getMissedAttacks(1, player.tag));
        }

        for (ClanWars.Attack attack : player.attacks) {
            clanWarPerformanceRecords.add(
                new Clan_War_Performance__c(
                    Attacker__r = new Player__c(Tag__c = player.tag.remove('#').toUpperCase()),
                    Destruction_Percentage__c = attack.destructionPercentage,
                    Stars__c = attack.stars
                )
            );
        }
        /**
         * NOTE: this seems like bad design to instantiate a new ClanWarsPerformance domain for each player
         *      singleton with ability to add more records in dynamically?
         */
        fflib_ISObjectUnitOfWork singletonUow = Application.ClashTrackerUnitOfWork.getInstance();
        IClanWarPerformances clanWarPerformancesDomain = ClanWarPerformances.newInstance(clanWarPerformanceRecords);
        clanWarPerformancesDomain.registerNewRecords(singletonUow, clanWar);
    }

    private List<ClanWars.Attack> getMissedAttacks(Integer missedAttacks, String playerTag) {
        List<ClanWars.Attack> attacks = new List<ClanWars.Attack>();
        
        for (Integer i = 0; i < missedAttacks; i++) {
            // NOTE: should probably distinguish between a true miss and 0 star / 0 percent
            ClanWars.Attack attack = new ClanWars.Attack();
            attack.attackerTag = playerTag;
            attack.destructionPercentage = 0;
            attack.stars = 0;
            
            attacks.add(attack);     
        }

        return attacks;
    }

    private void scheduleNextRun(String clanTag, String jobName, Datetime dt, Integer bufferMinutes) {
        System.schedule(
            jobName + String.valueOf(dt.addMinutes(bufferMinutes)) + ' : ' + System.UUID.randomUUID().toString(),
            CronUtility.getCronExpressionForNextScheduledJob(dt, bufferMinutes),
            new ClashApiServiceSchedulable(ClashApiService.Types.CLAN_WARS, new List<String> { clanTag })
        );
    }
}