public with sharing class ClashDeveloperKeyServiceImpl implements IClashDeveloperKeyService {
    public String getKey(String ipAddress) {
        IDeveloperKeys developerKeysDomain = DeveloperKeys.newInstance((DeveloperKeys.ClashDeveloperSession) JSON.deserialize(getKeys(), DeveloperKeys.ClashDeveloperSession.class));
        DeveloperKeys.ClashDeveloperSession session = (DeveloperKeys.ClashDeveloperSession) developerKeysDomain.getObjects()[0];

        DeveloperKeys.Key selectedKey = selectKey(ipAddress, session);
        if (selectedKey == null) {
            selectedKey = createKey(ipAddress, session);
        }

        return selectedKey.key;
    }

    private DeveloperKeys.Key selectKey(String ipAddress, DeveloperKeys.ClashDeveloperSession session) {
        List<DeveloperKeys.Key> keys = session.keys;
        DeveloperKeys.Key selectedKey;

        for (DeveloperKeys.Key k : keys) {
            List<String> ipAddresses = k.cidrRanges;

            if (String.join(k.cidrRanges, ';').contains(ipAddress)) {
                selectedKey = k;
                break;
            } 
        }

        return selectedKey;
    }

    private String getKeys() {
        HttpRequest getKeysReq = getRequest('list');
        HttpResponse getKeysRes = new Http().send(getKeysReq);
        
        return getKeysRes.getBody();
    }

    private DeveloperKeys.Key createKey(String ipAddress, DeveloperKeys.ClashDeveloperSession session) {
        HttpRequest createKeyReq = getRequest('create');

        DeveloperKeys.KeyRequest newKey = new DeveloperKeys.KeyRequest();
        newKey.name = 'SFDC: ' + UserInfo.getOrganizationId();
        newKey.description = System.URL.getOrgDomainUrl().toExternalForm();
        newKey.cidrRanges = new List<String> { ipAddress };
        createKeyReq.setBody(JSON.serialize(newKey));

        HttpResponse createKeyRes = new Http().send(createKeyReq);

        DeveloperKeys.ClashDeveloperSession sessionRes = (DeveloperKeys.ClashDeveloperSession) JSON.deserialize(createKeyRes.getBody(), DeveloperKeys.ClashDeveloperSession.class);

        return selectKey(ipAddress, session);
    }

    // TODO: implement /revoke endpoint to delete keys (requires key id)

    private HttpRequest getRequest(String endpoint) {
        ClashDeveloperLoginService.SessionInfo sessionInfo = ClashDeveloperLoginService.login();

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:Clash_Developer/api/apikey/' + endpoint);
        
        String bearerToken = 'Bearer ' + sessionInfo.token;
        req.setHeader('Authorization', bearerToken);
        req.setHeader('Cookie', sessionInfo.cookie);
        
        return req;
    }
}