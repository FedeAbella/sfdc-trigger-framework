@isTest
@SuppressWarnings('PMD.ExcessiveParameterList') // Number of parameters required by StubProvider Interface
public class ITriggerValidatorStub implements System.StubProvider {
    /**
     * @description Allows setting the return value of calls to the stub
     */
    public Boolean isTriggerValid { private get; set; }

    /**
     * @description Implementation of System.StubProvider contract for mocking calls to the stubbed class
     * @param stubbedObject the stubbed object used by the Stub API
     * @param stubbedMethodName the name of the invoked method
     * @param returnType the return type of the invoked method
     * @param listOfParamTypes the list of parameter types passed to the invoked method
     * @param listOfParamNames the list of paramenter Names passed to the invoked method
     * @param listOfArgs the list of actual arguments passed to the invoked method
     * @return whether calls to the validator return a valid trigger run or not
     */
    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName,
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames,
        List<Object> listOfArgs
    ) {
        return this.isTriggerValid;
    }
}
