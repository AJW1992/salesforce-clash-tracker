@IsTest
private class ClanWarsService_UnitTest {
    @IsTest
    static void processWarsEntryPoint_shouldInvokeServiceImplementation() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IClanWarsService clanWarsServiceImplMock = (IClanWarsService) mocks.mock(IClanWarsService.class);

        mocks.startStubbing();
        ((IClanWarsService) mocks.doAnswer(new ProcessWarsMock(), clanWarsServiceImplMock)).processWars(new List<String> { '#CLAN_TAG' });
        mocks.stopStubbing();

        Application.Service.setMock(IClanWarsService.class, clanWarsServiceImplMock);
        
        Test.startTest();
        ClanWarsService.processWars(new List<String> {'#CLAN_TAG'});
        Test.stopTest();

        ((IClanWarsService) mocks.verify(clanWarsServiceImplMock, mocks.times(1).description('processWars method called once with a list of clan tags as its argument'))).processWars(new List<String> {'#CLAN_TAG'});
    }

    private class ProcessWarsMock implements fflib_Answer {
        public Object answer(fflib_InvocationOnMock invocation) {
            // NOTE: we don't need to do anything here, this is called to allow mocks.verify to know the expected method was invoked
            return null;
        }
    }
}