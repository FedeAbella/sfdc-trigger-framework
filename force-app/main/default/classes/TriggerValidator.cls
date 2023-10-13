/**
 * @description Implementation of ITriggerValidatorInterface, allows checking for whether a particular trigger operation
 * for a given object is allowed to run. Allows using Trigger_Setting__mdt records to disable trigger operations or
 * entire triggers for an object, as well as bypassing a trigger only for that transaction.
 */
public with sharing class TriggerValidator implements ITriggerValidatorInterface {
    private static final Map<TriggerOperation, SObjectField> OPERATION_DISABLED_FIELD_MAP = new Map<TriggerOperation, SObjectField>{
        TriggerOperation.BEFORE_INSERT => Trigger_Setting__mdt.Before_Insert_Disabled__c,
        TriggerOperation.AFTER_INSERT => Trigger_Setting__mdt.After_Insert_Disabled__c,
        TriggerOperation.BEFORE_UPDATE => Trigger_Setting__mdt.Before_Update_Disabled__c,
        TriggerOperation.AFTER_UPDATE => Trigger_Setting__mdt.After_Update_Disabled__c,
        TriggerOperation.BEFORE_DELETE => Trigger_Setting__mdt.Before_Delete_Disabled__c,
        TriggerOperation.AFTER_DELETE => Trigger_Setting__mdt.After_Delete_Disabled__c,
        TriggerOperation.AFTER_UNDELETE => Trigger_Setting__mdt.After_Undelete_Disabled__c
    };

    @testVisible
    private static Map<SObjectType, Trigger_Setting__mdt> triggerMetadataMap;
    private static Set<SObjectType> bypassedTriggeringObjects;
    private static Map<SObjectType, Set<TriggerOperation>> bypassedObjectOperationsMap;

    static {
        getTriggerMetadataRecords();
        bypassedTriggeringObjects = new Set<SObjectType>();
        bypassedObjectOperationsMap = new Map<SObjectType, Set<TriggerOperation>>();
    }

    /**
     * @description Validates whether a given Trigger Operation is allowed to run for a given object type
     * @param objectType the SObjectType to validate triggers for
     * @param operation the Trigger Operation being validated for that object type
     * @return whether that Trigger Operation is allowed to run for that object type
     */
    public Boolean isTriggerValidatedToRun(SObjectType objectType, TriggerOperation operation) {
        return !isTriggerDisabled(objectType) &&
            !isTriggerDisabled(objectType, operation) &&
            !isTriggerBypassed(objectType) &&
            !isTriggerBypassed(objectType, operation);
    }

    /**
     * @description Checks whether the entire trigger for a given object type is globally disabled via custom metadata
     * @param objectType the SObjectType to check
     * @return whether all trigger operations for this object are globally disabled via custom metadata
     */
    public static Boolean isTriggerDisabled(SObjectType objectType) {
        return triggerMetadataMap.containsKey(objectType) && triggerMetadataMap.get(objectType).Trigger_Disabled__c;
    }

    /**
     * @description Checks whether the entire trigger for a given object was bypassed for this transaction
     * @param objectType the SObjectType to check
     * @return whether all trigger operations for this object are bypassed for this transaction
     */
    public static Boolean isTriggerBypassed(SObjectType objectType) {
        return bypassedTriggeringObjects.contains(objectType);
    }

    /**
     * @description Checks whether a particular trigger operation is globally disabled from running for a given object,
     * via custom metadata
     * @param objectType the SObject type to check
     * @param operation the trigger operation to check
     * @return whether that trigger operation is globally disabled from running for that object type in custom metadata
     */
    public static Boolean isTriggerDisabled(SObjectType objectType, TriggerOperation operation) {
        SObjectField indicatingField = OPERATION_DISABLED_FIELD_MAP.get(operation);
        return isTriggerDisabled(objectType) ||
            (triggerMetadataMap.containsKey(objectType) &&
            (Boolean) triggerMetadataMap.get(objectType).get(indicatingField));
    }

    /**
     * @description Checks whether a particular trigger operation was bypassed for this transaction
     * @param objectType the SObject type to check
     * @param operation the trigger operation to check
     * @return whether that trigger operation for that object is bypassed for this transaction
     */
    public static Boolean isTriggerBypassed(SObjectType objectType, TriggerOperation operation) {
        return isTriggerBypassed(objectType) ||
            (bypassedObjectOperationsMap.containsKey(objectType) &&
            bypassedObjectOperationsMap.get(objectType).contains(operation));
    }

    /**
     * @description Sets all trigger operations for a given object to be bypassed in this transaction
     * @param objectType the SObjectType for which to bypass triggers
     */
    public static void bypassTrigger(SObjectType objectType) {
        bypassedTriggeringObjects.add(objectType);
    }

    /**
     * @description Sets a particular trigger operation for a given object to be bypassed in this transaction
     * @param objectType the SObjectType for which to bypass the operation
     * @param operation the particular
     */
    public static void bypassTrigger(SObjectType objectType, TriggerOperation operation) {
        if (!bypassedObjectOperationsMap.containsKey(objectType)) {
            bypassedObjectOperationsMap.put(objectType, new Set<TriggerOperation>());
        }
        bypassedObjectOperationsMap.get(objectType).add(operation);
    }

    /**
     * @description Clears all trigger bypasses for a given object that have been set up in this transaction
     * @param objectType the SObjectType for which to clear all bypassed triggers
     */
    public static void clearTriggerBypass(SObjectType objectType) {
        bypassedTriggeringObjects.remove(objectType);
        bypassedObjectOperationsMap.remove(objectType);
    }

    /**
     * @description Clears a particular trigger operation for a given object from being bypassed in this transaction
     * @param objectType the SObjectType for which to clear the bypassed operation
     * @param operation the trigger operation to clear the bypass for
     */
    public static void clearTriggerBypass(SObjectType objectType, TriggerOperation operation) {
        bypassedObjectOperationsMap.get(objectType)?.remove(operation);
    }

    /**
     * @description Clears all trigger bypasses set up in this transaction
     */
    public static void clearAllTriggerBypasses() {
        bypassedTriggeringObjects.clear();
        bypassedObjectOperationsMap.clear();
    }

    /**
     * @description Builds a map of Trigger_Setting__mdt records mapped by their SObjectTypes, only the first time
     * this class is invoked during a transaction.
     */
    private static void getTriggerMetadataRecords() {
        List<Trigger_Setting__mdt> allTriggerMetadata = [
            SELECT
                Object__r.QualifiedApiName,
                Trigger_Disabled__c,
                Before_Insert_Disabled__c,
                After_Insert_Disabled__c,
                Before_Update_Disabled__c,
                After_Update_Disabled__c,
                Before_Delete_Disabled__c,
                After_Delete_Disabled__c,
                After_Undelete_Disabled__c
            FROM Trigger_Setting__mdt
            WITH SYSTEM_MODE
        ];

        triggerMetadataMap = new Map<SObjectType, Trigger_Setting__mdt>();
        for (Trigger_Setting__mdt metadataRecord : allTriggerMetadata) {
            triggerMetadataMap.put(
                Schema.getGlobalDescribe().get(metadataRecord.Object__r.QualifiedApiName),
                metadataRecord
            );
        }
    }
}
