public with sharing class ClashTrackerSetupController {
    /**
     * this should eventually be used to help with the initial setup of deployed credentials
     * avoids the need to know specific API names required as auth parameters that cannot be deployed
     */
    @AuraEnabled
    public static Response initialize(/* USER_SUPPLIED */) {
        Response res = new Response();
        
        try {
            // CredentialsService.initialize(USER_SUPPLIED);
        } catch (Exception ex) {
            // TODO: meaningful error handling for unhandled exception
        }

        return res;
    }

    private class Response {
        @AuraEnabled public Boolean isSuccess;
    }
}