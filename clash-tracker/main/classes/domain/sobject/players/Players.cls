public with sharing class Players extends fflib_SObjects implements IPlayers {
    public static IPlayers newInstance(List<Player__c> players) {
        return (IPlayers) Application.Domain.newInstance(players);
    }

    public Players(List<Player__c> players) {
        super(players);
    }

    public class Player {
        public String tag;
        public String name;
        public Integer townHallLevel;
        public Integer townHallWeaponLevel;
        public Integer expLevel;
        public Integer trophies;
        public Integer bestTrophies;
        public Integer warStars;
        public Integer attackWins;
        public Integer defenseWins;
        public Integer builderHallLevel;
        public Integer builderBaseTrophies;
        public Integer bestBuilderBaseTrophies;
        public String role;
        public String warPreference;
        public Integer donations;
        public Integer donationsReceived;
        public Integer clanCapitalContributions;
        public Clan clan;
        public League league;
        public League builderBaseLeague;
        public LegendStatistics legendStatistics;
        public List<Achievement> achievements;
        public PlayerHouse playerHouse;
        public List<Label> labels;
        public List<Troop> troops;
        public List<Hero> heroes;
        public List<HeroEquipment> heroEquipment;
        public List<Spell> spells;
    }
	
	public class Achievement {
		public String name;
		public Integer stars;
		public Integer value;
		public Integer target;
		public String info;
		public String completionInfo;
		public String village;
	}

	public class BadgeUrls {
		public String small;
		public String large;
		public String medium;
	}

	public class Clan {
		public String tag;
		public String name;
		public Integer clanLevel;
		public BadgeUrls badgeUrls;
	}

	public class Element {
		public String type;
		public Integer id;
	}

	public class Hero {
		public String name;
		public Integer level;
		public Integer maxLevel;
		public List<HeroEquipment> equipment;
		public String village;
	}

	public class HeroEquipment {
		public String name;
		public Integer level;
		public Integer maxLevel;
		public String village;
	}

	public class IconUrls {
		public String small;
		public String tiny;
		public String medium;
	}

	public class Label {
		public Integer id;
		public String name;
		public IconUrls iconUrls;
	}

	public class League {
		public Integer id;
		public String name;
		public IconUrls iconUrls;
	}

	public class LegendStatistics {
		public Integer legendTrophies;
		public Season previousSeason;
		public Season bestSeason;
		public Season currentSeason;
	}

	public class PlayerHouse {
		public List<Element> elements;
	}

	public class Season {
		public String id;
		public Integer rank;
		public Integer trophies;
	}

	public class Spell {
		public String name;
		public Integer level;
		public Integer maxLevel;
		public String village;
	}

	public class Troop {
		public String name;
		public Integer level;
		public Integer maxLevel;
		public String village;
	}

    public void insertClanMembers(fflib_ISObjectUnitOfWork uow) {
        // NOTE: explicit use of 'this' for clarity; inherited from fflib_SObjects base class
        uow.registerNew((List<Player__c>) this.getRecords());
    }

	public void upsertPlayers(fflib_ISObjectUnitOfWork uow, IClashTrackerWork work) {
        // NOTE: explicit use of 'this' for clarity; inherited from fflib_SObjects base class
        for (Player__c player : (List<Player__c>) this.getRecords()) {
            work.registerUpsert(player);
        }

		uow.registerWork(work);
    }

    public class Constructor implements fflib_IDomainConstructor {
        public fflib_SObjects construct(List<Object> players) {
            return new Players((List<SObject>) players);
        }
    }
}