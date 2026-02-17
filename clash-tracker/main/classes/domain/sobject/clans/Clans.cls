public with sharing class Clans extends fflib_SObjects implements IClans {
    public Clans(List<Clan__c> records) {
        super(records);
    }

    public class Clan {
		public String tag;
		public String name;
		public String type;
		public String description;
		public Location location;
		public Boolean isFamilyFriendly;
		public BadgeUrls badgeUrls;
		public Integer clanLevel;
		public Integer clanPoints;
		public Integer clanBuilderBasePoints;
		public Integer clanCapitalPoints;
		public League capitalLeague;
		public Integer requiredTrophies;
		public String warFrequency;
		public Integer warWinStreak;
		public Integer warWins;
		public Integer warTies;
		public Integer warLosses;
		public Boolean isWarLogPublic;
		public League warLeague;
		public Integer members;
		public List<Member> memberList;
		public List<Label> labels;
		public Integer requiredBuilderBaseTrophies;
		public Integer requiredTownhallLevel;
		public ClanCapital clanCapital;
		public ChatLanguage chatLanguage;
	}

	public class BadgeUrls {
		public String small;
		public String large;
		public String medium;
	}

	public class ChatLanguage {
		public Integer id;
		public String name;
		public String languageCode;
	}

	public class ClanCapital {
		public Integer capitalHallLevel;
		public List<District> districts;
	}

	public class District {
		public Integer id;
		public String name;
		public Integer districtHallLevel;
	}
	
	public class Element {
		public String type;
		public Integer id;
	}

	public class House {
		public List<Element> elements;
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

	public class Location {
		public Integer id;
		public String name;
		public Boolean isCountry;
	}

	public class Member {
		public String tag;
		public String name;
		public String role;
		public Integer townHallLevel;
		public Integer expLevel;
		public League league;
		public Integer trophies;
		public Integer builderBaseTrophies;
		public Integer clanRank;
		public Integer previousClanRank;
		public Integer donations;
		public Integer donationsReceived;
		public House house;
		public League builderBaseLeague;
	}

    public class Constructor implements fflib_IDomainConstructor {
        public fflib_SObjects construct(List<Object> objects) {
            return new Clans((List<SObject>) objects);
        }
    }
}