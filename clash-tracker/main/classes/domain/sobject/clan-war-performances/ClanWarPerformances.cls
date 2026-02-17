public with sharing class ClanWarPerformances extends fflib_SObjects implements IClanWarPerformances {
    private static IClanWarPerformances Instance;

    public static IClanWarPerformances getInstance(List<Clan_War_Performance__c> performances) {
        if (Instance == null) {
            Instance = newInstance(performances);
        } else {
            List<Clan_War_Performance__c> allRecords = (List<Clan_War_Performance__c>) Instance.getRecords();
            allRecords.addAll(performances);
            ((fflib_Objects) Instance).setObjects(allRecords);
        }

        return Instance;
    }

	public static IClanWarPerformances newInstance(List<Clan_War_Performance__c> performances) {
        return (IClanWarPerformances) Application.Domain.newInstance(performances);
    }

    private ClanWarPerformances(List<Clan_War_Performance__c> records) {
        super(records);
    }

	public void registerNewRecords(fflib_ISObjectUnitOfWork uow, Clan_War__c clanWar) {
		for (Clan_War_Performance__c performance : (List<Clan_War_Performance__c>) this.getRecords()) {
			uow.registerNew(performance, Clan_War_Performance__c.Clan_War__c, clanWar);
		}
	}

    public class Constructor implements fflib_IDomainConstructor {
        public fflib_SObjects construct(List<Object> objects) {
            return new ClanWarPerformances((List<SObject>) objects);
        }
    }
}