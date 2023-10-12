/**
 * @description Abstract class used to implement Trigger Handler logics, ensuring they all implement the required
 * interface to be called from TriggerDispatcher, while providing useful auxiliary methods.
 */
public with sharing abstract class TriggerHandler implements ITriggerHandlerInterface {
    private static final String ID_FIELD = 'Id';

    @testVisible
    protected Boolean isHandlerDisabled;
    @testVisible
    private Boolean isTriggerExecuting;
    @testVisible
    private System.TriggerOperation operation;

    /**
     * @description TriggerHandler constructor. Sets whether this is being constructed from within a trigger context,
     * and what trigger operation is being performed. Defaults the handler to not be disabled.
     */
    public TriggerHandler() {
        isHandlerDisabled = false;
        isTriggerExecuting = Trigger.isExecuting;
        operation = Trigger.operationType;
    }

    /**
     * @description Checks whether the Handler is currently disabled from running.
     * @return whether the handler is currently disabled
     */
    public virtual Boolean isDisabled() {
        return isHandlerDisabled;
    }
    /**
     * @description Handles the logic that is to be performed on Before Insert operations.
     * @param newRecords the list of records being inserted
     */
    public virtual void beforeInsert(List<SObject> newRecords) {
    }
    /**
     * @description Handles the logic that is to be performed on After Insert operations.
     * @param newRecordsMap the map of records being inserted, mapped by their ids
     */
    public virtual void afterInsert(Map<Id, SObject> newRecordsMap) {
    }
    /**
     * @description Handles the logic that is to be performed on Before Update operations.
     * @param oldRecordsMap the map of old versions of records being updated, mapped by their ids
     * @param newRecordsMap the map of new versions of records being updated, mapped by their ids
     */
    public virtual void beforeUpdate(Map<Id, SObject> oldRecordsMap, Map<Id, SObject> newRecordsMap) {
    }
    /**
     * @description Handles the logic that is to be performed on After Update operations.
     * @param oldRecordsMap the map of old versions of records being updated, mapped by their ids
     * @param newRecordsMap the map of new versions of records being updated, mapped by their ids
     */
    public virtual void afterUpdate(Map<Id, SObject> oldRecordsMap, Map<Id, SObject> newRecordsMap) {
    }
    /**
     * @description Handles the logic that is to be performed on Before Delete operations.
     * @param oldRecordsMap the map of records being deleted, mapped by their ids
     */
    public virtual void beforeDelete(Map<Id, SObject> oldRecordsMap) {
    }
    /**
     * @description Handles the logic that is to be performed on After Delete operations.
     * @param oldRecordsMap the map of records being deleted, mapped by their ids
     */
    public virtual void afterDelete(Map<Id, SObject> oldRecordsMap) {
    }
    /**
     * @description Handles the logic that is to be performed on After Undelete operations.
     * @param newRecordsMap the map of records being undeleted, mapped by their ids
     */
    public virtual void afterUndelete(Map<Id, SObject> newRecordsMap) {
    }

    protected Boolean isBeforeInsert() {
        return this.isTriggerExecuting && this.operation == System.TriggerOperation.BEFORE_INSERT;
    }

    protected Boolean isAfterInsert() {
        return this.isTriggerExecuting && this.operation == System.TriggerOperation.AFTER_INSERT;
    }

    protected Boolean isInsert() {
        return this.isBeforeInsert() || this.isAfterInsert();
    }

    protected Boolean isBeforeUpdate() {
        return this.isTriggerExecuting && this.operation == System.TriggerOperation.BEFORE_UPDATE;
    }

    protected Boolean isAfterUpdate() {
        return this.isTriggerExecuting && this.operation == System.TriggerOperation.AFTER_UPDATE;
    }

    protected Boolean isUpdate() {
        return this.isBeforeUpdate() || this.isAfterUpdate();
    }

    protected Boolean isBeforeDelete() {
        return this.isTriggerExecuting && this.operation == System.TriggerOperation.BEFORE_DELETE;
    }

    protected Boolean isAfterDelete() {
        return this.isTriggerExecuting && this.operation == System.TriggerOperation.AFTER_DELETE;
    }

    protected Boolean isDelete() {
        return this.isBeforeDelete() || this.isAfterDelete();
    }

    protected Boolean isUndelete() {
        return this.isTriggerExecuting && this.operation == System.TriggerOperation.AFTER_UNDELETE;
    }

    /**
     * @description If within a trigger operation that has old record versions, retrieves a list of those
     * @return a list of sobjects representing the old versions of records in this trigger operation, if any
     */
    public static List<SObject> getOldRecords() {
        return Trigger.oldMap?.values();
    }

    /**
     * @description If within a trigger operation that has old record versions, retrieves the old version of a record
     * in this trigger operation, given the record Id, if such old version exists
     * @param recordId the Id of the record to get the old version of
     * @return the old version of the record in this trigger operation, if one exists
     */
    public static SObject getOldRecordVersion(Id recordId) {
        return Trigger.oldMap?.get(recordId);
    }

    protected Boolean isChanged(SObject newRecordVersion, SObjectField field) {
        if (newRecordVersion == null || field == null || (!this.isInsert() && !this.isUpdate())) {
            return false;
        }

        SObjectField idField = newRecordVersion.getSObjectType()
            .getDescribe(Schema.SObjectDescribeOptions.DEFERRED)
            .fields.getMap()
            .get(ID_FIELD);
        SObject oldRecordVersion = getOldRecordVersion((Id) newRecordVersion.get(idField));

        Map<String, Object> populatedFields = newRecordVersion.getPopulatedFieldsAsMap();
        Map<String, Object> oldPopulatedFields = oldRecordVersion?.getPopulatedFieldsAsMap();
        String fieldName = field.getDescribe().getName();

        return populatedFields.containsKey(fieldName) &&
            (this.isInsert() ||
            (this.isUpdate() &&
            oldRecordVersion != null &&
            (populatedFields.get(fieldName) != oldPopulatedFields.get(fieldName))));
    }

    protected Boolean isAnyChanged(SObject newRecordVersion, Set<SObjectField> fields) {
        for (SObjectField field : fields) {
            if (isChanged(newRecordVersion, field)) {
                return true;
            }
        }
        return false;
    }
}
