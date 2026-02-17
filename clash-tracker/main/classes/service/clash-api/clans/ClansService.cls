public with sharing class ClansService {
    public static void registerForTracking(List<String> clanTags) {
        service().registerForTracking(clanTags);
    }

    public static void handleServiceResponse() {
        service().handleServiceResponse();
    }

    private static IClansService service() {
		return (IClansService) Application.Service.newInstance(IClansService.class);
	}
}