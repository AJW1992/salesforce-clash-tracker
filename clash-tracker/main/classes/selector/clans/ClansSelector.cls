public inherited sharing class ClansSelector extends fflib_SObjectSelector implements IClansSelector {
    public static IClansSelector newInstance() {
        return (IClansSelector) Application.Selector.newInstance(Clan__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Clan__c.Id,
            Clan__c.Name,
            Clan__c.Tag__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Clan__c.SObjectType;
    }
}