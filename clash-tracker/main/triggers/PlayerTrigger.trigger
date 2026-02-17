trigger PlayerTrigger on Player__c (before insert, before update) {
    fflib_SObjectDomain.triggerHandler(PlayerTriggerHandler.class);
}