public with sharing class PlayerTriggerHandler extends fflib_SObjectDomain {
    public PlayerTriggerHandler(List<Player__c> players) {
        super(players);
    }

    // called as part of handling process for before insert context
    public override void onApplyDefaults() {
        for (Player__c player : (List<Player__c>) this.Records) {
            player.Tag__c = player.Tag__c.removeStart('#').toUpperCase();
        }
    }

    // called as part of handling process for after update context
    public override void onValidate(Map<Id, SObject> existingRecords) {
        for (Player__c player : (List<Player__c>) this.Records) {
            Player__c existingPlayer = (Player__c) existingRecords.get(player.Id);
            if (!player.Tag__c.equalsIgnoreCase(existingPlayer.Tag__c)) {
                player.Tag__c.addError(error('Tag cannot be modified after creation', player, Player__c.Tag__c));
            }
        }
    }

    // no default behavior, explicitly call onValidate for before update context
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        onValidate(existingRecords);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new PlayerTriggerHandler(sObjectList);
        }
    }
}