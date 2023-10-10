/**
 * @description Interface to be implemented by Trigger Helpers called from TriggerDispatcher
 */
public interface ITriggerHandlerInterface {
    /**
     * @description Allows each helper to define custom logic for
     * not running.
     * @return Whether the Helper is disabled from running
     */
    Boolean isDisabled();

    /**
     * @description Contains logic that is to be run on Before Insert trigger context when this Helper is used
     */
    void beforeInsert();

    /**
     * @description Contains logic that is to be run on After Insert trigger context when this Helper is used
     */
    void afterInsert();

    /**
     * @description Contains logic that is to be run on Before Update trigger context when this Helper is used
     */
    void beforeUpdate();

    /**
     * @description Contains logic that is to be run on After Update trigger context when this Helper is used
     */
    void afterUpdate();

    /**
     * @description Contains logic that is to be run on Before Delete trigger context when this Helper is used
     */
    void beforeDelete();

    /**
     * @description Contains logic that is to be run on After Delete trigger context when this Helper is used
     */
    void afterDelete();

    /**
     * @description Contains logic that is to be run on After Undelete trigger context when this Helper is used
     */
    void afterUndelete();
}
