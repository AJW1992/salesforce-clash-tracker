# Salesforce Clash Tracker
A demonstrative Salesforce project that implements the fflib Apex Commons and Apex Mocks enterprise frameworks. This project highlights an approach to ISV style Salesforce development with proper separation of concerns, testability, and maintainability.

### Key Features
- Enterprise-grade codebase architecture using fflib patterns
- Singleton approach to core project class implementations
- Isolated unit testing with Apex Mocks backed by the Stub API
- Integration testing with required test data setup
- CI/CD patterns to support the development lifecycle

### Dependencies
[![Apex Commons](https://img.shields.io/badge/Apex-Commons-blue?logo=salesforce)](https://github.com/apex-enterprise-patterns/fflib-apex-common)
[![Apex Mocks](https://img.shields.io/badge/Apex-Mocks-blue?logo=salesforce)](https://github.com/apex-enterprise-patterns/fflib-apex-mocks)

## Setup Instructions

### Headless Scratch Org Creation via JWT OAuth2 Flow
Create a custom connected app in a dev hub org, ensuring the callback url uses an available port `OPEN_PORT`.
    
    http://localhost:OPEN_PORT/OauthRedirect

`OPEN_PORT` may adjust dynamically in headless environments
This callback URL is generally case sensitive and must specify a redirect endpoint following the port

**Note:** at the time of this project's creation, external client apps are not supported for this use case. It is likely that they will be in the future as they are planned as the long-term replacement to connected apps.

### Specify Minimum Scopes
- Perform requests at any time (refresh_token, offline_access)
- Manage user data via APIs (api)
- Manage user data via Web browsers (web)

### One-Time Enablement for JWT OAuth2 Flow
The CI/CD user responsible for creating scratch orgs must have a refresh token established in the respective DevHub for the specified connected app. Run the following command from your terminal:
    
    sf org login web
        --instance-url https://login.salesforce.com
        --alias DEV_HUB_ALIAS
        --client-id CUSTOM_CONNECTED_APP_CLIENT_ID

The prompt for consumer secret can be ignored depending on configuration of custom connected app; if unsuccessful, try again and copy/paste consumer secret in when prompted. In headless environments, login will be handled through a JWT flow that already specifies a custom connected app and this login via the web UI will not be needed.

Ensure the `sfdx-project.json` file specifies sfdcLoginUrl as:
    
    https://test.salesforce.com

To test the custom connected app configuration for use with scratch orgs run the following command:
    
    sf org create scratch -a SCRATCH_ORG_ALIAS -f config/custom-scratch-def.json -v DEV_HUB_ALIAS

Review the generated org configuration in your user's `.sfdx` folder and confirm the custom connected app client Id has been used.

## Notes

### CI/CD Artifacts
Note that artifcat outputs **must** be validated to ensure that sensitive data (i.e., keys, access tokens, etc.) are not exposed in public facing logs. The workflows associated with this project create artifacts for all scripts executed as a means of demonstration; this is acceptable when associated with private repositories but not suitable for public repositories. Review all artifact outputs before placing them in a public facing repository.

### TypeScript Support
The latest iteration of the Salesforce CLI tools should handle TypeScript compilation via `sf project deploy` namespace commands. Alternatviely, compile TypeScript prior to deployment as a pre-commit hook, place JavaScript assets in the build directory and exclude source `*.ts` and `*.ts-meta.xml` files from the build directory root.

## Other Resources
[![Salesforce DX](https://img.shields.io/badge/Salesforce-DX-00A1E0?logo=salesforce)](https://developer.salesforce.com/tools/sfdxcli)