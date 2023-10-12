/**
 * @description Handles validating whether a given trigger and/or trigger operation should run, and routing to the
 * appropriate login in the given trigger handler.
 */
public with sharing class TriggerDispatcher {
    private static final String OUTSIDE_TRIGGER_EXCEPTION_MESSAGE = 'Trigger Dispatcher called outside of Trigger execution';
    private static final String NULL_HANDLER_VALIDATOR_EXCEPTION_MESSAGE = 'Trigger Dispatcher requires non-null handler and validator';

    @TestVisible
    private TriggerOperation operation;
    @TestVisible
    private SObjectType objectType;

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
     * @param validator a Validator class that implements ITriggerValidatorInterface and provides logic to check
     * whether a particular trigger operation should run
     */
    public void run(ITriggerHandlerInterface handler, ITriggerValidatorInterface validator) {
        if (!validateRun(handler, validator)) {
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
    private Boolean validateRun(ITriggerHandlerInterface handler, ITriggerValidatorInterface validator) {
        if (this.objectType == null || this.operation == null) {
            throw new TriggerDispatcherException(OUTSIDE_TRIGGER_EXCEPTION_MESSAGE);
        }
        if (handler == null || validator == null) {
            throw new TriggerDispatcherException(NULL_HANDLER_VALIDATOR_EXCEPTION_MESSAGE);
        }
        return validator.isTriggerValidatedToRun(this.objectType, this.operation) && !handler.isDisabled();
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
     * @description Custom Exception class
     */
    public class TriggerDispatcherException extends Exception {
    }
}
