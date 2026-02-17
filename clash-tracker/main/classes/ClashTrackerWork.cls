public class ClashTrackerWork implements IClashTrackerWork {
    private Map<String, List<SObject>> m_upsertRecordsPerType = new Map<String, List<SObject>>();
    private Map<String, Schema.SObjectField> m_externalIdToUpsertPerType = new Map<String, Schema.SObjectField>();

    public ClashTrackerWork(List<Schema.SObjectType> sObjectTypes) {
        for (Schema.SObjectType sObjType : sObjectTypes) {
            String sObjectName = sObjType.getDescribe().getName();
            m_upsertRecordsPerType.put(sObjectName, new List<SObject>());
        }
    }
    /**
     * Set an external Id field to upsert on for a given type
     * 
     * @param sObjectType The SObjectType to set an upsert field for
     * @param fieldToken The external Id SObjectField to upsert on for the given type
     * 
     * TODO: find a way to ensure this is called for every type that will have upsert on external id performed
     */
    public void setUpsertExternalIdField(Schema.SObjectType sObjType, Schema.SObjectField fieldToken) {
        m_externalIdToUpsertPerType.put(sObjType.getDescribe().getName(), fieldToken);
    }

    public void registerUpsert(SObject record) {
        // TODO: determine type, add to relevant m_upsertRecordsPerType entry
        List<SObject> currentRecordsForType = m_upsertRecordsPerType.get(record.getSObjectType().getDescribe().getName());
        currentRecordsForType.add(record);
    }

    public void doWork() {
        // TODO: generally support different modes
        AccessLevel level = AccessLevel.SYSTEM_MODE;

        for (String sObjectName : m_upsertRecordsPerType.keySet()) {
            List<SObject> records = m_upsertRecordsPerType.get(sObjectName);
            Schema.SObjectField externalIdField = m_externalIdToUpsertPerType.get(sObjectName);

            if (records.size() > 0) {
                Type objListType = Type.ForName('List<' + records[0].getSObjectType() + '>');
                List<SObject> typedList = (List<SObject>) objListType.newInstance();
                typedList.addAll(records);

                Database.upsert(typedList, externalIdField, true, level);
            }
        }
    }
}