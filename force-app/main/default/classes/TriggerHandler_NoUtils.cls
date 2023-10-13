/**
 * @description Abstract class used to implement Trigger Handler logics, ensuring they all implement the required
 * interface to be called from TriggerDispatcher.
 */
public with sharing abstract class TriggerHandler_NoUtils implements ITriggerHandlerInterface {
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
}
