public with sharing class ClanWarsService {
    public static void processWars(List<String> clanTags) {
        service().processWars(clanTags);
    }

    private static IClanWarsService service() {
		return (IClanWarsService) Application.Service.newInstance(IClanWarsService.class);
	}
}