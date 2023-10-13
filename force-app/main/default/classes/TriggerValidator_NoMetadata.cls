/**
 * @description Implementation of ITriggerValidatorInterface, allows checking for whether a particular trigger operation
 * for a given object is allowed to run. Allows bypassing entire triggers or particular methods
 */
public with sharing class TriggerValidator_NoMetadata implements ITriggerValidatorInterface {
    private static Set<SObjectType> bypassedTriggeringObjects;
    private static Map<SObjectType, Set<TriggerOperation>> bypassedObjectOperationsMap;

    static {
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
        return !isTriggerBypassed(objectType) && !isTriggerBypassed(objectType, operation);
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
}
