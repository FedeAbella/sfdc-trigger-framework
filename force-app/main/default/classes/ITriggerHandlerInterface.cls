/**
 * @description Interface to be implemented by Trigger Helpers called from TriggerDispatcher
 */
public interface ITriggerHandlerInterface {
    /**
     * @description Signature for logic that is to be run on Before Insert trigger context when this Helper is used
     * @param newRecords the list of records being inserted
     */
    void beforeInsert(List<SObject> newRecords);

    /**
     * @description Signature for logic that is to be run on After Insert trigger context when this Helper is used
     * @param newRecordsMap the map of records being inserted, mapped by their ids
     */
    void afterInsert(Map<Id, SObject> newRecordsMap);

    /**
     * @description Signature for logic that is to be run on Before Update trigger context when this Helper is used
     * @param oldRecordsMap the map of old versions of records being updated, mapped by their ids
     * @param newRecordsMap the map of new versions of records being updated, mapped by their ids
     */
    void beforeUpdate(Map<Id, SObject> oldRecordsMap, Map<Id, SObject> newRecordsMap);

    /**
     * @description Signature for logic that is to be run on After Update trigger context when this Helper is used
     * @param oldRecordsMap the map of old versions of records being updated, mapped by their ids
     * @param newRecordsMap the map of new versions of records being updated, mapped by their ids
     */
    void afterUpdate(Map<Id, SObject> oldRecordsMap, Map<Id, SObject> newRecordsMap);

    /**
     * @description Signature for logic that is to be run on Before Delete trigger context when this Helper is used
     * @param oldRecordsMap the map of records being deleted, mapped by their ids
     */
    void beforeDelete(Map<Id, SObject> oldRecordsMap);

    /**
     * @description Signature for logic that is to be run on After Delete trigger context when this Helper is used
     * @param oldRecordsMap the map of records being deleted, mapped by their ids
     */
    void afterDelete(Map<Id, SObject> oldRecordsMap);

    /**
     * @description Signature for logic that is to be run on After Undelete trigger context when this Helper is used
     * @param newRecordsMap the map of records being undeleted, mapped by their ids
     */
    void afterUndelete(Map<Id, SObject> newRecordsMap);
}
