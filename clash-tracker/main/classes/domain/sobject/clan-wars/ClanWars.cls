public with sharing class ClanWars extends fflib_SObjects implements IClanWars {
	public static IClanWars newInstance(List<Clan_War__c> clanWars) {
        return (IClanWars) Application.Domain.newInstance(clanWars);
    }

    public ClanWars(List<Clan_War__c> records) {
        super(records);
    }

    public class War {
        public String state;
        public Integer teamSize;
        public Integer attacksPerMember;
        public String preparationStartTime;
        public String warStartTime;
        public String startTime;
        public String endTime;
        public Clan clan;
        public Clan opponent;
    }

	public class Attack {
		public String attackerTag;
		public String defenderTag;
		public Integer stars;
		public Integer destructionPercentage;
		public Integer order;
		public Integer duration;
	}

	public class BadgeUrls {
		public String small;
		public String large;
		public String medium;
	}

	public class Clan {
		public String tag;
		public String name;
		public BadgeUrls badgeUrls;
		public Integer clanLevel;
		public Integer attacks;
		public Integer stars;
		public Double destructionPercentage;
		public List<Member> members;
	}

	public class Member {
		public String tag;
		public String name;
		public Integer townhallLevel;
		public Integer mapPosition;
		public Integer opponentAttacks;
		public Attack bestOpponentAttack;
		public List<Attack> attacks;
	}

	public void registerNewRecords(fflib_ISObjectUnitOfWork uow) {
		uow.registerNew((List<Clan_War__c>) this.getRecords());
	}

    public class Constructor implements fflib_IDomainConstructor {
        public fflib_SObjects construct(List<Object> objects) {
            return new ClanWars((List<SObject>) objects);
        }
    }
}