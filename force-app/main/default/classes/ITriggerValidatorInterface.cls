/**
 * @description Interface to be implemented by Trigger Validator classes, which check if trigger operations are
 * allowed to run for certain objects and operations.
 */
public interface ITriggerValidatorInterface {
    /**
     * @description Validates whether a given Trigger Operation is allowed to run for a given object type
     * @param objectType the SObjectType to validate triggers for
     * @param operation the Trigger Operation being validated for that object type
     * @return whether that Trigger Operation is allowed to run for that object type
     */
    Boolean isTriggerValidatedToRun(SObjectType objectType, TriggerOperation operation);
}
