public with sharing class ClashDeveloperLoginServiceImpl implements IClashDeveloperLoginService {
    // NOTE: inner types are specific to the API version of the external service and thus controlled by a specific implementation
    private class Auth {
        String uid;
        String token;

        // returned as response header `Set-Cookie`
        String cookie;
    }

    private class Developer {
        String id;
        String name;
        String game;
        String email;
        String tier;
        String prevLoginTs;
        String prevLoginIp;
        String prevLoginUa;
    }

    private class Login {
        Status status;
        Integer sessionExpiresInSeconds;
        Auth auth;
        Developer developer;
        String temporaryAPIToken;
        String swaggerUrl;
    }

    private class Status {
        Integer code;
        String message;
    }

    // NOTE: custom Apex return types are agnostic to inner types used by specific implementation
    public ClashDeveloperLoginService.SessionInfo login() {
        String reqBody = '"email":"{0}","password":"{1}"';

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Clash_Developer/api/login');
        req.setMethod('POST');
        req.setBody('{' + String.format(reqBody, new String[]{'{!$Credential.Clash_Developer.Email}', '{!$Credential.Clash_Developer.Password}'}) + '}');

        HttpResponse res = new Http().send(req);

        Login loginRes = (Login) JSON.deserialize(res.getBody(), Login.class);

        ClashDeveloperLoginService.SessionInfo sessionInfo = new ClashDeveloperLoginService.SessionInfo();

        // NOTE: cookie obtained from login is required alongside access token to authorize subsequent POST requests on host developer.clashofclans.com
        sessionInfo.cookie = res.getHeader('Set-Cookie');
        sessionInfo.token = loginRes.auth.token;
        return sessionInfo;
    }
}