@IsTest
private class PlayerTriggerHandlerTest {
    @IsTest
    static void testOnApplyDefaults() {
        List<Player__c> players = new List<Player__c> {
            new Player__c(Name = 'Player A', Tag__c = '#abc123'),
            new Player__c(Name = 'Player B', Tag__c = '#def456')
        };

        System.Test.startTest();
        insert players;
        System.Test.stopTest();

        List<Player__c> insertedplayers = [SELECT Id, Name, Tag__c FROM Player__c ORDER BY Name];
        for (Player__c player : insertedplayers) {
            Assert.areEqual(true, !player.Tag__c.contains('#'), 'The Tag__c field should have been stripped of a leading # character and converted to upper case');
        }
    }

    @IsTest
    static void testOnValidate() {
        insert new List<Player__c> {
            new Player__c(Name = 'Player A', Tag__c = '#abc123')
        };

        List<Player__c> insertedPlayers = [SELECT Id, Name, Tag__c FROM Player__c ORDER BY Name];
        try {
            for (Player__c player : insertedplayers) {
                player.Tag__c = 'altered';
            }
            update insertedPlayers;

            Assert.fail('Custom validation exception expected');
        } catch (Exception ex) {
            Assert.areEqual(true, ex != null, 'An exception should have been caught');
        }
    }
}