public with sharing class CredentialsService {
    public static void createClashApiCredential() {
        service().createClashApiCredential();
    }

    public static void patchClashApiCredential() {
        service().patchClashApiCredential();
    }

    public static void createClashDeveloperCredential(String email, String password) {
        service().createClashDeveloperCredential(email, password);
    }

    public static void patchClashDeveloperCredential(String email, String password) {
        service().patchClashDeveloperCredential(email, password);
    }

    private static ICredentialsService service() {
        return (ICredentialsService) Application.Service.newInstance(ICredentialsService.class);
    }
}