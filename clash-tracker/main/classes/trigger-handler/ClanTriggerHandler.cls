public with sharing class ClanTriggerHandler extends fflib_SObjectDomain {
    public ClanTriggerHandler(List<Clan__c> clans) {
        super(clans);
    }

    // called as part of handling process for before insert context
    public override void onApplyDefaults() {
        for (Clan__c clan : (List<Clan__c>) this.Records) {
            clan.Tag__c = clan.Tag__c.removeStart('#').toUpperCase();
        }
    }

    // called as part of handling process for after update context
    public override void onValidate(Map<Id, SObject> existingRecords) {
        for (Clan__c clan : (List<Clan__c>) this.Records) {
            Clan__c existingClan = (Clan__c) existingRecords.get(clan.Id);
            if (!clan.Tag__c.equalsIgnoreCase(existingClan.Tag__c)) {
                clan.Tag__c.addError(error('Tag cannot be modified after creation', clan, Clan__c.Tag__c));
            }
        }
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ClanTriggerHandler(sObjectList);
        }
    }
}