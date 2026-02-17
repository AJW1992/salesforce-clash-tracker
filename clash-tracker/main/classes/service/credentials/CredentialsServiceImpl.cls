public with sharing class CredentialsServiceImpl implements ICredentialsService {
    public void createClashApiCredential() {
        String ipAddress = CurrentIpAddressService.getIpAddress();
        String key = ClashDeveloperKeyService.getKey(ipAddress);

        ConnectApi.CredentialInput input = getCredentialInput(
            'Clash_API',
            'Admin',
            ConnectApi.CredentialAuthenticationProtocol.Custom,
            ConnectApi.CredentialPrincipalType.NamedPrincipal,
            new Map<String, String> { 'Key' => key }
        );

        // NOTE: need to figure out the exception type thrown to caller if this fails
        ConnectApi.Credential resultCredential = ConnectApi.NamedCredentials.createCredential(input);
    }

    public void patchClashApiCredential() {
        String ipAddress = CurrentIpAddressService.getIpAddress();
        String key = ClashDeveloperKeyService.getKey(ipAddress);

        ConnectApi.CredentialInput input = getCredentialInput(
            'Clash_API',
            'Admin',
            ConnectApi.CredentialAuthenticationProtocol.Custom,
            ConnectApi.CredentialPrincipalType.NamedPrincipal,
            new Map<String, String> { 'Key' => key }
        );

        // NOTE: need to figure out the exception type thrown to caller if this fails
        ConnectApi.Credential resultCredential = ConnectApi.NamedCredentials.patchCredential(input);
    }
    
    public void createClashDeveloperCredential(String email, String password) {
        ConnectApi.CredentialInput input = getCredentialInput(
            'Clash_Developer',
            'Admin',
            ConnectApi.CredentialAuthenticationProtocol.Custom,
            ConnectApi.CredentialPrincipalType.NamedPrincipal,
            new Map<String, String> { 'Email' => email, 'Password' => password }
        );

        // NOTE: need to figure out the exception type thrown to caller if this fails
        ConnectApi.Credential resultCredential = ConnectApi.NamedCredentials.createCredential(input);
    }

    public void patchClashDeveloperCredential(String email, String password) {
        ConnectApi.CredentialInput input = getCredentialInput(
            'Clash_Developer',
            'Admin',
            ConnectApi.CredentialAuthenticationProtocol.Custom,
            ConnectApi.CredentialPrincipalType.NamedPrincipal,
            new Map<String, String> { 'Email' => email, 'Password' => password }
        );

        // NOTE: need to figure out the exception type thrown to caller if this fails
        ConnectApi.Credential resultCredential = ConnectApi.NamedCredentials.patchCredential(input);
    }

    private ConnectApi.CredentialInput getCredentialInput(String credentialName, String principalName, ConnectApi.CredentialAuthenticationProtocol authProtocol, ConnectApi.CredentialPrincipalType principalType, Map<String, String> authValuesByParameterName) {
        ConnectApi.CredentialInput input = new ConnectApi.CredentialInput();
        input.externalCredential = credentialName;
        input.authenticationProtocol = authProtocol;
        input.principalName = principalName;
        input.principalType = principalType;

        Map<String, ConnectApi.CredentialValueInput> authParameters = new Map<String, ConnectApi.CredentialValueInput>();
        for (String parameterName : authValuesByParameterName.keySet()) {
            ConnectApi.CredentialValueInput authParam = new ConnectApi.CredentialValueInput();
            authParam.encrypted = true;
            authParam.value = authValuesByParameterName.get(parameterName);

            authParameters.put(parameterName, authParam);
        }
        input.credentials = authParameters;

        return input;
    }
}