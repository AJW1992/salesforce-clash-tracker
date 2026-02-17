trigger ClanTrigger on Clan__c (before insert, after update) {
    fflib_SObjectDomain.triggerHandler(ClanTriggerHandler.class);
}