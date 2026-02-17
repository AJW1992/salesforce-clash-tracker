public with sharing class CurrentIpAddressService {
    public static String getIpAddress() {
        return service().getIpAddress();
    }

    private static ICurrentIpAddressService service() {
        return (ICurrentIpAddressService) Application.Service.newInstance(ICurrentIpAddressService.class);
    }
}