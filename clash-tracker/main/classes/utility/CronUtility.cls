public with sharing class CronUtility {
    public static String getCronExpressionForNextScheduledJob(String dateString, Integer bufferMinutes) {
        return getCronExpressionForNextScheduledJob(ClashApiService.getDatetime(dateString).addMinutes(bufferMinutes));
    }

    public static String getCronExpressionForNextScheduledJob(Datetime dt, Integer bufferMinutes) {
        return getCronExpressionForNextScheduledJob(dt.addMinutes(bufferMinutes));
    }

    private static String getCronExpressionForNextScheduledJob(Datetime dt) {
        String second = String.valueOf(dt.second());
        String minute = String.valueOf(dt.minute());
        String hour = String.valueOf(dt.hour());
        String day = String.valueOf(dt.day());
        String month = String.valueOf(dt.month());
        String year = String.valueOf(dt.year());

        return String.join(new List<String> {second, minute, hour, day, month, '?', year}, ' ');
    }
}