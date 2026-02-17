public with sharing class ClashDeveloperKeyService {
    public static String getKey(String ipAddress) {
        return service().getKey(ipAddress);
    }

    private static IClashDeveloperKeyService service() {
        return (IClashDeveloperKeyService) Application.Service.newInstance(IClashDeveloperKeyService.class);
    }
}