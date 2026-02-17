public with sharing class ClashDeveloperLoginService {
    public static SessionInfo login() {
        return service().login();
    }

    public static IClashDeveloperLoginService service() {
        return (IClashDeveloperLoginService) Application.Service.newInstance(IClashDeveloperLoginService.class);
    }

    // NOTE: publically available data structure defined at static service class level for implementation level classes to map to
    public class SessionInfo {
        public String cookie;
        public String token;
    }
}