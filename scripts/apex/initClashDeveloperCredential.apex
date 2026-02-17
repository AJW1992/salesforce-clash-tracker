// NOTE: placeholder values only for initialization
ConnectApi.CredentialInput input = getCredentialInput(
    'Clash_Developer',
    'Admin',
    ConnectApi.CredentialAuthenticationProtocol.Custom,
    ConnectApi.CredentialPrincipalType.NamedPrincipal,
    new Map<String, String> { 'Email' => 'EMAIL', 'Password' => 'PASSWORD' }
);

// NOTE: use createCredential to add authentication parameters to an existing external credential with a specific authentication protocal, principal name and principal type (i.e. initalize auth params for first time)
// NOTE: the docs specify patchCredential as updating a credential and updateCredential to be used for replacing a credential's authentication parameters; the difference is ambiguous and seems to have the same result
ConnectApi.Credential resultCredential = ConnectApi.NamedCredentials.createCredential(input);
Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(resultCredential));
for (String key : resultMap.keySet()) {
    System.debug(key + ': ' + resultMap.get(key));
}

private static ConnectApi.CredentialInput getCredentialInput(String credentialName, String principalName, ConnectApi.CredentialAuthenticationProtocol authProtocol, ConnectApi.CredentialPrincipalType principalType, Map<String, String> authValuesByParameterName) {
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