// convenience script for data cleanup
List<Clan__c> clans = [SELECT Id FROM Clan__c];
List<Clan_War__c> clanWars = [SELECT Id FROM Clan_War__c];
List<Clan_War_Performance__c> warPerformances = [SELECT Id FROM Clan_War_Performance__c];
List<Player__c> players = [SELECT Id FROM Player__c];

delete clans;
delete clanWars;
delete warPerformances;
delete players;