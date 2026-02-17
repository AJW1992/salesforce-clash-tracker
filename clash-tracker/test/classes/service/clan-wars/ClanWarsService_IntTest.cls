// NOTE: integration test makes most sense using the default implementation of the service defined by the Application class
@IsTest
private class ClanWarsService_IntTest {
    @TestSetup
    static void makeData() {
        List<Clan__c> clans = TestDataFactory.getClans(
            new List<String> { 'Clan1', 'Clan2' },
            new List<String> { 'Tag1', 'Tag2' }
        );

        List<Player__c> players = TestDataFactory.getPlayers(
            new List<String> { 'Player1', 'Player2', 'Player3', 'Player4', 'Player5', 'Player6' },
            new List<String> { 'Tag1', 'Tag2', 'Tag3', 'Tag4', 'Tag5', 'Tag6' },
            false
        );
        players[0].Clan__r = new Clan__c(Tag__c = 'Tag1');
        players[1].Clan__r = new Clan__c(Tag__c = 'Tag1');
        players[2].Clan__r = new Clan__c(Tag__c = 'Tag1');
        players[3].Clan__r = new Clan__c(Tag__c = 'Tag2');
        players[4].Clan__r = new Clan__c(Tag__c = 'Tag2');
        players[5].Clan__r = new Clan__c(Tag__c = 'Tag2');
        insert players;
    }

    @IsTest
    static void processSingleWar_givenEndState_shouldFinalizePerformancesAndScheduleNextClanWarsService() {
        // given
        Test.setMock(HttpCalloutMock.class, new MockClanWarsHttpResponse('warEnded'));

        // when
        Test.startTest();
        ClanWarsService.processWars(new List<String> { 'Tag1' });
        Test.stopTest();

        // then
        Assert.areEqual(1, [SELECT COUNT() FROM Clan_War__c], '1 Clan War should exist');
        Assert.areEqual(6, [SELECT COUNT() FROM Clan_War_Performance__c], '6 Clan War Performances should exist');
        // TODO: assert which Clan/Clan War each record relates to
        // TODO: assert for scheduling of next job
    }

    private class MockClanWarsHttpResponse implements HttpCalloutMock {
        private String state;

        public MockClanWarsHttpResponse(String state) {
            this.state = state;
        }

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(
                '{' +
                    '"state": "' + state + '",' +
                    '"teamSize": 25,' +
                    '"attacksPerMember": 2,' +
                    '"preparationStartTime": "20250412T215854.000Z",' +
                    '"startTime": "20250413T215854.000Z",' +
                    '"endTime": "20250414T275054.000Z",' +
                    '"clan": {' +
                        '"tag": "#Tag1",' +
                        '"name": "TheCakeIsALie",' +
                        '"badgeUrls": {' +
                            '"small": "https://api-assets.clashofclans.com/badges/BADGE.png",' +
                            '"large": "https://api-assets.clashofclans.com/badges/BADGE.png",' +
                            '"medium": "https://api-assets.clashofclans.com/badges/BADGE.png"' +
                        '},' +
                        '"clanLevel": 26,' +
                        '"attacks": 43,' +
                        '"stars": 63,' +
                        '"destructionPercentage": 87.04,' +
                        '"members": [' +
                            '{' +
                                '"tag": "#Tag1",' +
                                '"name": "Tony Montana",' +
                                '"townhallLevel": 16,' +
                                '"mapPosition": 4,' +
                                '"attacks": [' +
                                    '{' +
                                        '"attackerTag": "#Tag1",' +
                                        '"defenderTag": "#DEFENDER_TAG",' +
                                        '"stars": 3,' +
                                        '"destructionPercentage": 100,' +
                                        '"order": 33,' +
                                        '"duration": 112' +
                                    '},' +
                                    '{' +
                                        '"attackerTag": "#Tag1",' +
                                        '"defenderTag": "#DEFENDER_TAG",' +
                                        '"stars": 3,' +
                                        '"destructionPercentage": 100,' +
                                        '"order": 86,' +
                                        '"duration": 90' +
                                    '}' +
                                '],' +
                                '"opponentAttacks": 2,' +
                                '"bestOpponentAttack": {' +
                                    '"attackerTag": "#ATTACKER_TAG",' +
                                    '"defenderTag": "#DEFENDER_TAG",' +
                                    '"stars": 3,' +
                                    '"destructionPercentage": 100,' +
                                    '"order": 54,' +
                                    '"duration": 93' +
                                '}' +
                            '},' +
                            '{' +
                                '"tag": "#Tag2",' +
                                '"name": "Red",' +
                                '"townhallLevel": 16,' +
                                '"mapPosition": 4,' +
                                '"attacks": [' +
                                    '{' +
                                        '"attackerTag": "#Tag2",' +
                                        '"defenderTag": "#DEFENDER_TAG",' +
                                        '"stars": 0,' +
                                        '"destructionPercentage": 1,' +
                                        '"order": 33,' +
                                        '"duration": 112' +
                                    '}' +
                                '],' +
                                '"opponentAttacks": 2,' +
                                '"bestOpponentAttack": {' +
                                    '"attackerTag": "#ATTACKER_TAG",' +
                                    '"defenderTag": "#DEFENDER_TAG",' +
                                    '"stars": 2,' +
                                    '"destructionPercentage": 68,' +
                                    '"order": 54,' +
                                    '"duration": 93' +
                                '}' +
                            '},' +
                            '{' +
                                '"tag": "#Tag3",' +
                                '"name": "Blue",' +
                                '"townhallLevel": 16,' +
                                '"mapPosition": 4,' +
                                '"opponentAttacks": 2,' +
                                '"bestOpponentAttack": {' +
                                    '"attackerTag": "#ATTACKER_TAG",' +
                                    '"defenderTag": "#DEFENDER_TAG",' +
                                    '"stars": 2,' +
                                    '"destructionPercentage": 68,' +
                                    '"order": 54,' +
                                    '"duration": 93' +
                                '}' +
                            '}' +
                        ']' +
                    '},' +
                    '"opponent": {' +
                        '"tag": "#OPPONENT_CLAN_TAG",' +
                        '"name": "Haunted Mansion",' +
                        '"badgeUrls": {' +
                            '"small": "https://api-assets.clashofclans.com/badges/BADGE.png",' +
                            '"large": "https://api-assets.clashofclans.com/badges/BADGE.png",' +
                            '"medium": "https://api-assets.clashofclans.com/badges/BADGE.png"' +
                        '},' +
                        '"clanLevel": 22,' +
                        '"attacks": 43,' +
                        '"stars": 62,' +
                        '"destructionPercentage": 87.16,' +
                        '"members": [' +
                            '{' +
                                '"tag": "#OPPONENT_PLAYER_TAG",' +
                                '"name": "OPPONENT_PLAYER_NAME",' +
                                '"townhallLevel": 16,' +
                                '"mapPosition": 4,' +
                                '"attacks": [' +
                                    '{' +
                                        '"attackerTag": "#ATTACKER_TAG",' +
                                        '"defenderTag": "#DEFENDER_TAG",' +
                                        '"stars": 2,' +
                                        '"destructionPercentage": 63,' +
                                        '"order": 33,' +
                                        '"duration": 112' +
                                    '},' +
                                    '{' +
                                        '"attackerTag": "#ATTACKER_TAG",' +
                                        '"defenderTag": "#DEFENDER_TAG",' +
                                        '"stars": 3,' +
                                        '"destructionPercentage": 100,' +
                                        '"order": 86,' +
                                        '"duration": 90' +
                                    '}' +
                                '],' +
                                '"opponentAttacks": 2,' +
                                '"bestOpponentAttack": {' +
                                    '"attackerTag": "#ATTACKER_TAG",' +
                                    '"defenderTag": "#DEFENDER_TAG",' +
                                    '"stars": 2,' +
                                    '"destructionPercentage": 68,' +
                                    '"order": 54,' +
                                    '"duration": 93' +
                                '}' +
                            '}' +
                        ']' +
                    '}' +
                '}'
            );

            return response;
        }
    }
}