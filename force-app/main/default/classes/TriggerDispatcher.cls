/**
 * @description Handles validating whether a given trigger and/or trigger operation should run, and routing to the
 * appropriate login in the given trigger handler.
 */
public with sharing class TriggerDispatcher {
    private static final String OUTSIDE_TRIGGER_EXCEPTION_MESSAGE = 'Trigger Dispatcher called outside of Trigger execution';
    private static final String NULL_HANDLER_EXCEPTION_MESSAGE = 'Trigger Dispatcher called with null handler';
    private static final Map<System.TriggerOperation, SObjectField> OPERATION_DISABLED_FIELD_MAP = new Map<System.TriggerOperation, SObjectField>{
        System.TriggerOperation.BEFORE_INSERT => Trigger_Setting__mdt.Before_Insert_Disabled__c,
        System.TriggerOperation.AFTER_INSERT => Trigger_Setting__mdt.After_Insert_Disabled__c,
        System.TriggerOperation.BEFORE_UPDATE => Trigger_Setting__mdt.Before_Update_Disabled__c,
        System.TriggerOperation.AFTER_UPDATE => Trigger_Setting__mdt.After_Update_Disabled__c,
        System.TriggerOperation.BEFORE_DELETE => Trigger_Setting__mdt.Before_Delete_Disabled__c,
        System.TriggerOperation.AFTER_DELETE => Trigger_Setting__mdt.After_Delete_Disabled__c,
        System.TriggerOperation.AFTER_UNDELETE => Trigger_Setting__mdt.After_Undelete_Disabled__c
    };

    private static Map<SObjectType, Trigger_Setting__mdt> triggerMetadataMap;
    private static Set<SObjectType> bypassedTriggeringObjects;
    private static Map<SObjectType, Set<System.TriggerOperation>> bypassedObjectOperationsMap;

    @TestVisible
    private System.TriggerOperation operation;
    @TestVisible
    private SObjectType objectType;

    static {
        getTriggerMetadataStates();
        bypassedTriggeringObjects = new Set<SObjectType>();
        bypassedObjectOperationsMap = new Map<SObjectType, Set<System.TriggerOperation>>();
    }

    /**
     * @description TriggerDispatcher constructor. Sets the object type and operation of the current trigger run. If
     * constructed outside of a trigger, both are null.
     */
    public TriggerDispatcher() {
        this.operation = Trigger.operationType;
        this.objectType = getCurrentTriggerSObjectType();
    }

    /**
     * @description Dispatches current triggering object and operation to the appropriate logic, provided by a Handler
     * that implements ITriggerHandlerInterface
     * @param handler a Handler class that implements ITriggerHandlerInterface and provides the logic to perform
     */
    public void run(ITriggerHandlerInterface handler) {
        if (!validateRun(handler)) {
            return;
        }

        switch on this.operation {
            when BEFORE_INSERT {
                handler.beforeInsert(Trigger.new);
            }
            when AFTER_INSERT {
                handler.afterInsert(Trigger.newMap);
            }
            when BEFORE_UPDATE {
                handler.beforeUpdate(Trigger.oldMap, Trigger.newMap);
            }
            when AFTER_UPDATE {
                handler.afterUpdate(Trigger.oldMap, Trigger.newMap);
            }
            when BEFORE_DELETE {
                handler.beforeDelete(Trigger.oldMap);
            }
            when AFTER_DELETE {
                handler.afterDelete(Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                handler.afterUndelete(Trigger.newMap);
            }
        }
    }

    @TestVisible
    private Boolean validateRun(ITriggerHandlerInterface handler) {
        if (this.objectType == null || this.operation == null) {
            throw new TriggerDispatcherException(OUTSIDE_TRIGGER_EXCEPTION_MESSAGE);
        }
        if (handler == null) {
            throw new TriggerDispatcherException(NULL_HANDLER_EXCEPTION_MESSAGE);
        }
        return !isTriggerDisabled(this.objectType) &&
            !isTriggerDisabled(this.objectType, this.operation) &&
            !isTriggerBypassed(this.objectType) &&
            !isTriggerBypassed(this.objectType, this.operation) &&
            !handler.isDisabled();
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
    public static Boolean isTriggerDisabled(SObjectType objectType, System.TriggerOperation operation) {
        SObjectField indicatingField = OPERATION_DISABLED_FIELD_MAP.get(operation);
        return triggerMetadataMap.containsKey(objectType) &&
            (Boolean) triggerMetadataMap.get(objectType).get(indicatingField);
    }

    /**
     * @description Checks whether a particular trigger operation was bypassed for this transaction
     * @param objectType the SObject type to check
     * @param operation the trigger operation to check
     * @return whether that trigger operation for that object is bypassed for this transaction
     */
    public static Boolean isTriggerBypassed(SObjectType objectType, System.TriggerOperation operation) {
        return bypassedObjectOperationsMap.containsKey(objectType) &&
            bypassedObjectOperationsMap.get(objectType).contains(operation);
    }

    /**
     * @description Returns the object that triggers are currently being run for, or null if called outside a trigger
     * operation
     * @return the SObjectType of the currently triggering object
     */
    public static SObjectType getCurrentTriggerSObjectType() {
        if (!Trigger.isExecuting) {
            return null;
        }
        return Trigger.isDelete ? (Trigger.old).getSObjectType() : Trigger.new.getSObjectType();
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
    public static void bypassTrigger(SObjectType objectType, System.TriggerOperation operation) {
        if (!bypassedObjectOperationsMap.containsKey(objectType)) {
            bypassedObjectOperationsMap.put(objectType, new Set<System.TriggerOperation>());
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
    public static void clearTriggerBypass(SObjectType objectType, System.TriggerOperation operation) {
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
    private static void getTriggerMetadataStates() {
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

    /**
     * @description Custom Exception class
     */
    public class TriggerDispatcherException extends Exception {
    }
}
