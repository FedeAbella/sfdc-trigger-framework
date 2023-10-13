@isTest
@SuppressWarnings('PMD.ExcessiveParameterList') // Number of parameters required by StubProvider Interface
public class ITriggerHandlerStub implements System.StubProvider {
    public static final Map<String, TriggerOperation> METHOD_NAME_OPERATION_MAP = new Map<String, TriggerOperation>{
        'beforeInsert' => TriggerOperation.BEFORE_INSERT,
        'afterInsert' => TriggerOperation.AFTER_INSERT,
        'beforeUpdate' => TriggerOperation.BEFORE_UPDATE,
        'afterUpdate' => TriggerOperation.AFTER_UPDATE,
        'beforeDelete' => TriggerOperation.BEFORE_DELETE,
        'afterDelete' => TriggerOperation.AFTER_DELETE,
        'afterUndelete' => TriggerOperation.AFTER_UNDELETE
    };

    /**
     * @description Allows retrieving what method was called when one of the trigger operation methods is called
     */
    public TriggerOperation requestedOperation { get; private set; }

    /**
     * @description Implementation of System.StubProvider contract for mocking calls to the stubbed class
     * @param stubbedObject the stubbed object used by the Stub API
     * @param stubbedMethodName the name of the invoked method
     * @param returnType the return type of the invoked method
     * @param listOfParamTypes the list of parameter types passed to the invoked method
     * @param listOfParamNames the list of paramenter Names passed to the invoked method
     * @param listOfArgs the list of actual arguments passed to the invoked method
     * @return null
     */
    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName,
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames,
        List<Object> listOfArgs
    ) {
        this.requestedOperation = METHOD_NAME_OPERATION_MAP.get(stubbedMethodName);
        return null;
    }
}
