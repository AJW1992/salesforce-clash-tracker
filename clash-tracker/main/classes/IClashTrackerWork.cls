public interface IClashTrackerWork extends fflib_SObjectUnitOfWork.IDoWork {
    void setUpsertExternalIdField(Schema.SObjectType sObjectType, Schema.SObjectField fieldToken);
    void registerUpsert(SObject record);
}