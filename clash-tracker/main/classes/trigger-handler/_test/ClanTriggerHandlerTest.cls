@IsTest
private class ClanTriggerHandlerTest {
    @IsTest
    static void testOnApplyDefaults() {
        List<Clan__c> clans = new List<Clan__c> {
            new Clan__c(Name = 'Clan A', Tag__c = '#abc123'),
            new Clan__c(Name = 'Clan B', Tag__c = '#def456')
        };

        System.Test.startTest();
        insert clans;
        System.Test.stopTest();

        List<Clan__c> insertedClans = [SELECT Id, Name, Tag__c FROM Clan__c ORDER BY Name];
        for (Clan__c clan : insertedClans) {
            Assert.areEqual(true, !clan.Tag__c.contains('#'), 'The Tag__c field should have been stripped of a leading # character and converted to upper case');
        }
    }

    @IsTest
    static void testOnValidate() {
        insert new List<Clan__c> {
            new Clan__c(Name = 'Clan A', Tag__c = '#abc123')
        };

        List<Clan__c> insertedClans = [SELECT Id, Name, Tag__c FROM Clan__c ORDER BY Name];
        try {
            for (Clan__c clan : insertedClans) {
                clan.Tag__c = 'altered';
            }
            update insertedClans;

            Assert.fail('Custom validation exception expected');
        } catch (Exception ex) {
            Assert.areEqual(true, ex != null, 'An exception should have been caught');
        }
    }
}