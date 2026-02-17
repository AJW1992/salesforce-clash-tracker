public with sharing abstract class ClashApiService implements IClashApiService {
    public static Id retry(Types serviceType, List<String> tags) {
        CredentialsService.patchClashApiCredential();
        return System.enqueueJob(new ClashApiService.Queued(serviceType, tags));
    }

    public static Date getDate(String dateString) {
        String yearMonthDay = dateString.substringBefore('T');
        Integer year = Integer.valueOf(yearMonthDay.substring(0, 4));
        Integer month = Integer.valueOf(yearMonthDay.substring(4, 6));
        Integer day = Integer.valueOf(yearMonthDay.substring(6, yearMonthDay.length()));

        return Date.newInstance(year, month, day);
    }

    public static Datetime getDatetime(String dateString) {
        String yearMonthDay = dateString.substringBefore('T');
        Integer year = Integer.valueOf(yearMonthDay.substring(0, 4));
        Integer month = Integer.valueOf(yearMonthDay.substring(4, 6));
        Integer day = Integer.valueOf(yearMonthDay.substring(6, yearMonthDay.length()));

        String hourMinuteSecond = dateString.substringAfter('T').substringBefore('.');
        Integer hour = Integer.valueOf(hourMinuteSecond.substring(0, 2));
        Integer minute = Integer.valueOf(hourMinuteSecond.substring(2, 4));
        Integer second = Integer.valueOf(hourMinuteSecond.substring(4, hourMinuteSecond.length()));

        String milliseconds = dateString.substringAfter('.').substringBefore('Z');

        return Datetime.newInstanceGMT(year, month, day, hour, minute, second);
    }

    protected HttpRequest request;
    protected HttpResponse response;

    public void execute() {
        Http client = new Http();
        this.response = client.send(this.request);

        Integer statusCode = response.getStatusCode();
        if (statusCode == 403) {
            /**
             * NOTE: observed behavior in scratch orgs where Ip Address is frequently changing between 2-3 values
             *       refactor self healing API key strategy to create subsequent keys with all known ip address values
             */
            AccessException ex = (AccessException) JSON.deserialize(response.getBody(), AccessException.class);
            ex.setIpAddress();
            throw ex;
        } else {
            // TODO: refactor this generic exception
            // throw new ClashAPIException(response);
        }
    }

    public abstract void handleServiceResponse();

    public abstract void setRequest(Map<String, String> argumentsByParameter);

    public class AccessException extends Exception {
        public String reason;
        public String message;
        public String ipAddress;

        private void setIpAddress() {
            Pattern ipAddressRelaxedPattern = Pattern.compile('\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}');
            Matcher ipAddressRelaxedMatcher = ipAddressRelaxedPattern.matcher(message);

            if (ipAddressRelaxedMatcher.find()) {
                ipAddress = message.substring(ipAddressRelaxedMatcher.start(), ipAddressRelaxedMatcher.end());
            }
        }
    }

    // NOTE: can't implement Schedulable and Queueable with same class (runtime ExecutionException)
    // NOTE: can't implement Schedulable on an inner type; results in undefined behavior due to absence of ApexClassId property used by platform to run Schedulables (observed jobs silently failing with no log)
    public abstract class Async {
        protected Types serviceType;
        protected List<String> tags;

        public Async(Types serviceType, List<String> tags) {
            this.serviceType = serviceType;
            this.tags = tags;
        }

        protected void invokeService() {
            // NOTE: review this to potentially decouple from concrete references to service layer
            switch on serviceType {
                when CLANS {
                    // invoke something from ClansService as needed
                } when CLAN_WARS {
                    ClanWarsService.processWars(tags);
                } when PLAYERS {
                    PlayersService.upsertPlayers(tags);
                } when else {
                    // TODO: throw exception
                }
            }
        }
    }

    public class Queued extends Async implements Queueable, Database.AllowsCallouts {
        public Queued(Types serviceType, List<String> tags) {
            super(serviceType, tags);
        }

        public void execute(QueueableContext qc) {
            this.invokeService();
        }
    }

    public enum Types {
        CLANS,
        CLAN_WARS,
        PLAYERS
    }
}