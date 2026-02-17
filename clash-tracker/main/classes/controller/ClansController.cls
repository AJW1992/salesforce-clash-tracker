public with sharing class ClansController {
    @AuraEnabled
    public static Response registerForTracking(String clanTag) {
        Response res = new Response();
        
        try {
            ClansService.registerForTracking(new List<String> { clanTag });
            res.isSuccess = true;
            res.message = 'Tracking registration successful';
            res.description = '';
        } catch (ClashApiService.AccessException ex) {
            Id jobId = ClashApiService.retry(ClashApiService.Types.CLANS, new List<String> { clanTag });
            System.debug('NOTE: caught ClashApiService.AccessException; retrying(' + jobId + ')');
            if (jobId != null) {
                // TODO: enqueue can fail, handle this
            }

            res.isSuccess = true;
            res.message = 'Tracking registration pending';
            res.description = ex.getMessage();
        } catch (Exception ex) {
            // TODO: meaningful error handling for unhandled exception
            res.isSuccess = false;
            res.message = 'Tracking registration failed';
            res.description = ex.getMessage();
        }

        return res;
    }

    private static void handleAccessException() {

    }

    private class Response {
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String message;
        @AuraEnabled public String description;
    }
}