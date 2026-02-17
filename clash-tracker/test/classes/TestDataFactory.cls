@IsTest
public class TestDataFactory {
    /**
     * Creates a single Clan__c record with the specified name and tag, and inserts it by default.
     *
     * @param name The name of the clan.
     * @param tag The tag of the clan.
     * @return The created Clan__c record.
     */
    public static Clan__c getSingleClan(String name, String tag) {
        return getSingleClan(name, tag, true);
    }

    /**
     * Creates a single Clan__c record with the specified name and tag.
     *
     * @param name The name of the clan.
     * @param tag The tag of the clan.
     * @param shouldCommit If true, inserts the clan record into the database.
     * @return The created Clan__c record.
     */
    public static Clan__c getSingleClan(String name, String tag, Boolean shouldCommit) {
        Clan__c clan = new Clan__c(Name = name, Tag__c = tag);

        if (shouldCommit) {
            insert clan;
        }

        return clan;
    }

    /**
     * Creates multiple Clan__c records with the specified names and tags, and inserts them by default.
     *
     * @param names List of clan names.
     * @param tags List of clan tags.
     * @return List of created Clan__c records.
     */
    public static List<Clan__c> getClans(List<String> names, List<String> tags) {
        return getClans(names, tags, true);
    }

    /**
     * Creates multiple Clan__c records with the specified names and tags.
     *
     * @param names List of clan names.
     * @param tags List of clan tags.
     * @param shouldCommit If true, inserts the clan records into the database.
     * @return List of created Clan__c records.
     */
    public static List<Clan__c> getClans(List<String> names, List<String> tags, Boolean shouldCommit) {
        List<Clan__c> clans = new List<Clan__c>();
        for (Integer i = 0; i < names.size() && i < tags.size(); i++) {
            clans.add(new Clan__c(Name = names[i], Tag__c = tags[i]));
        }

        if (shouldCommit) {
            insert clans;
        }

        return clans;
    }
    
    /**
     * Creates a single Player__c record with the specified name and tag, and inserts it by default.
     *
     * @param name The name of the player.
     * @param tag The tag of the player.
     * @return The created Player__c record.
     */
    public static Player__c getSinglePlayer(String name, String tag) {
        return getSinglePlayer(name, tag, true);
    }

    /**
     * Creates a single Player__c record with the specified name and tag.
     *
     * @param name The name of the player.
     * @param tag The tag of the player.
     * @param shouldCommit If true, inserts the player record into the database.
     * @return The created Player__c record.
     */
    public static Player__c getSinglePlayer(String name, String tag, Boolean shouldCommit) {
        Player__c player = new Player__c(Name = name, Tag__c = tag);
        
        if (shouldCommit) {
            insert player;
        }
        
        return player;
    }

    /**
     * Creates multiple Player__c records with the specified names and tags, and inserts them by default.
     *
     * @param names List of player names.
     * @param tags List of player tags.
     * @return List of created Player__c records.
     */
    public static List<Player__c> getPlayers(List<String> names, List<String> tags) {
        return getPlayers(names, tags, true);
    }

    /**
     * Creates multiple Player__c records with the specified names and tags.
     *
     * @param names List of player names.
     * @param tags List of player tags.
     * @param shouldCommit If true, inserts the player records into the database.
     * @return List of created Player__c records.
     */
    public static List<Player__c> getPlayers(List<String> names, List<String> tags, Boolean shouldCommit) {
        List<Player__c> players = new List<Player__c>();
        for (Integer i = 0; i < names.size() && i < tags.size(); i++) {
            players.add(new Player__c(Name = names[i], Tag__c = tags[i]));
        }
        
        if (shouldCommit) {
            insert players;
        }
        
        return players;
    }
}
