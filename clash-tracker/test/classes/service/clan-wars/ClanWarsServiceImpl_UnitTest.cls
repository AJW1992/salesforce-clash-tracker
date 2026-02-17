@IsTest
private class ClanWarsServiceImpl_UnitTest {
    @IsTest
	static void processWars_givenEndState_shouldFinalizePerformancesAndScheduleNextClanWarsService() {
        // given mock setup
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork unitOfWorkMock = (fflib_ISObjectUnitOfWork) mocks.mock(fflib_ISObjectUnitOfWork.class);
		IClanWars clanWarsDomainMock = (IClanWars) mocks.mock(IClanWars.class);

		mocks.startStubbing();
        mocks.when(clanWarsDomainMock.getType()).thenReturn(Clan_War__c.SObjectType);
        ((IClanWars) mocks.doAnswer(new RegisterNewRecordsMock(), clanWarsDomainMock)).registerNewRecords(unitOfWorkMock);
        mocks.stopStubbing();
        
        Application.Domain.setMock(clanWarsDomainMock);
        Application.ClashTrackerUnitOfWork.setMock(unitOfWorkMock);
        Test.setMock(HttpCalloutMock.class, new MockClanWarsHttpResponse());
        
        // when service invoked
        Test.startTest();
        new ClanWarsServiceImpl().processWars(new List<String> {'#CLAN_TAG'});
        Test.stopTest();
        
        // then verify behavior
        ((IClanWars) mocks.verify(clanWarsDomainMock, mocks.times(1).description('registerNewRecords method called once with a unit of work as its argument'))).registerNewRecords(unitOfWorkMock);
	}

    private class MockClanWarsHttpResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody(
                '{' +
                    '"state": "warEnded",' +
                    '"teamSize": 25,' +
                    '"attacksPerMember": 2,' +
                    '"preparationStartTime": "20250412T215854.000Z",' +
                    '"startTime": "20250413T215854.000Z",' +
                    '"endTime": "20250414T275054.000Z",' +
                    '"clan": {' +
                        '"tag": "#CLAN_TAG",' +
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
                                '"tag": "#8Y2GGUJJ2",' +
                                '"name": "Tony Montana",' +
                                '"townhallLevel": 16,' +
                                '"mapPosition": 4,' +
                                '"attacks": [' +
                                    '{' +
                                        '"attackerTag": "#8Y2GGUJJ2",' +
                                        '"defenderTag": "#DEFENDER_TAG",' +
                                        '"stars": 3,' +
                                        '"destructionPercentage": 100,' +
                                        '"order": 33,' +
                                        '"duration": 112' +
                                    '},' +
                                    '{' +
                                        '"attackerTag": "#8Y2GGUJJ2",' +
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
                                '"tag": "#PLAYER_TAG",' +
                                '"name": "Red",' +
                                '"townhallLevel": 16,' +
                                '"mapPosition": 4,' +
                                '"attacks": [' +
                                    '{' +
                                        '"attackerTag": "#2CYU9YLJ8",' +
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
                                '"tag": "#28ULGV2YU",' +
                                '"name": "Blue",' +
                                '"townhallLevel": 16,' +
                                '"mapPosition": 4,' +
                                '"opponentAttacks": 2,' +
                                '"bestOpponentAttack": {' +
                                    '"attackerTag": "#28ULGV2YU",' +
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

    public class RegisterNewRecordsMock implements fflib_Answer {
        public Object answer(fflib_InvocationOnMock iom) {
            fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork) iom.getArgument(0);
            uow.registerNew(new List<Clan_War__c> { new Clan_War__c(Name = 'Test War') });
            return null;
        }
    }
}