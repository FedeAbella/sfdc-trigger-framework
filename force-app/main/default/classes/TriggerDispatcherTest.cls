@isTest
private class TriggerDispatcherTest {
    @IsTest
    static void hasNullObjectAndOperationIfConstructedOutsideTrigger() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            Assert.isNull(
                dispatcher.objectType,
                'Dispatcher object type should be null when constructed outside Trigger context'
            );
            Assert.isNull(
                dispatcher.operation,
                'Dispatcher Trigger Operation should be null when constructed outside Trigger context'
            );
        }
    }

    @IsTest
    static void throwsExceptionIfRunWithNullObjectType() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.operation = TriggerOperation.BEFORE_INSERT;
            try {
                dispatcher.run(null, null);
                Assert.fail('Dispatcher should throw exception if called with null object type');
            } catch (Exception e) {
                Assert.isInstanceOfType(
                    e,
                    TriggerDispatcher.TriggerDispatcherException.class,
                    'Thrown exception should be of custom exception class'
                );
                Assert.areEqual(
                    TriggerDispatcher.OUTSIDE_TRIGGER_EXCEPTION_MESSAGE,
                    e.getMessage(),
                    'Exception message should indicate being called outside trigger context'
                );
            }
        }
    }

    @IsTest
    static void throwsExceptionIfRunWithNullOperation() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            try {
                dispatcher.run(null, null);
                Assert.fail('Dispatcher should throw exception if called with null operation');
            } catch (Exception e) {
                Assert.isInstanceOfType(
                    e,
                    TriggerDispatcher.TriggerDispatcherException.class,
                    'Thrown exception should be of custom exception class'
                );
                Assert.areEqual(
                    TriggerDispatcher.OUTSIDE_TRIGGER_EXCEPTION_MESSAGE,
                    e.getMessage(),
                    'Exception message should indicate being called outside trigger context'
                );
            }
        }
    }

    @IsTest
    static void throwsExceptionIfRunWithNullHandler() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.BEFORE_INSERT;
            try {
                ITriggerValidatorStub stubProviderInstance = new ITriggerValidatorStub();
                stubProviderInstance.isTriggerValid = true;
                ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                    ITriggerValidatorInterface.class,
                    stubProviderInstance
                );
                dispatcher.run(null, validatorStub);
                Assert.fail('Dispatcher should throw exception if called with null handler');
            } catch (Exception e) {
                Assert.isInstanceOfType(
                    e,
                    TriggerDispatcher.TriggerDispatcherException.class,
                    'Thrown exception should be of custom exception class'
                );
                Assert.areEqual(
                    TriggerDispatcher.NULL_HANDLER_VALIDATOR_EXCEPTION_MESSAGE,
                    e.getMessage(),
                    'Exception message should indicate being called with null handler or validator'
                );
            }
        }
    }

    @IsTest
    static void throwsExceptionIfRunWithNullValidator() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.BEFORE_INSERT;
            try {
                ITriggerHandlerStub stubProviderInstance = new ITriggerHandlerStub();
                stubProviderInstance.isHandlerDisabled = false;
                ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                    ITriggerHandlerInterface.class,
                    stubProviderInstance
                );
                dispatcher.run(handlerStub, null);
                Assert.fail('Dispatcher should throw exception if called with null validator');
            } catch (Exception e) {
                Assert.isInstanceOfType(
                    e,
                    TriggerDispatcher.TriggerDispatcherException.class,
                    'Thrown exception should be of custom exception class'
                );
                Assert.areEqual(
                    TriggerDispatcher.NULL_HANDLER_VALIDATOR_EXCEPTION_MESSAGE,
                    e.getMessage(),
                    'Exception message should indicate being called with null handler or validator'
                );
            }
        }
    }

    @IsTest
    static void doesNotCallAnyHelperMethodIfValidatorDoesntValidateRun() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.BEFORE_INSERT;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = false;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.isNull(
                handlerStubProvider.requestedOperation,
                'No handler operation methods should be called if trigger is not validated to run'
            );
        }
    }

    @IsTest
    static void doesNotCallAnyHelperMethodIfHandlerIsDisabled() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.BEFORE_INSERT;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = true;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.isNull(
                handlerStubProvider.requestedOperation,
                'No handler operation methods should be called if handler is not validated to run'
            );
        }
    }

    @IsTest
    static void callsBeforeInsertMethodIfValidAndOperationTypeIsBeforeInsert() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.BEFORE_INSERT;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.areEqual(
                TriggerOperation.BEFORE_INSERT,
                handlerStubProvider.requestedOperation,
                'When context operation is BEFORE_INSERT, the handler\'s beforeInsert method should be called'
            );
        }
    }

    @IsTest
    static void callsAfterInsertMethodIfValidAndOperationTypeIsAfterInsert() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.AFTER_INSERT;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.areEqual(
                TriggerOperation.AFTER_INSERT,
                handlerStubProvider.requestedOperation,
                'When context operation is AFTER_INSERT, the handler\'s afterInsert method should be called'
            );
        }
    }

    @IsTest
    static void callsBeforeUpdateMethodIfValidAndOperationTypeIsBeforeUpdate() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.BEFORE_UPDATE;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.areEqual(
                TriggerOperation.BEFORE_UPDATE,
                handlerStubProvider.requestedOperation,
                'When context operation is BEFORE_UPDATE, the handler\'s beforeUpdate method should be called'
            );
        }
    }

    @IsTest
    static void callsAfterUpdateMethodIfValidAndOperationTypeIsAfterUpdate() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.AFTER_UPDATE;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.areEqual(
                TriggerOperation.AFTER_UPDATE,
                handlerStubProvider.requestedOperation,
                'When context operation is AFTER_UPDATE, the handler\'s afterUpdate method should be called'
            );
        }
    }

    @IsTest
    static void callsBeforeDeleteMethodIfValidAndOperationTypeIsBeforeDelete() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.BEFORE_DELETE;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.areEqual(
                TriggerOperation.BEFORE_DELETE,
                handlerStubProvider.requestedOperation,
                'When context operation is BEFORE_DELETE, the handler\'s beforeDelete method should be called'
            );
        }
    }

    @IsTest
    static void callsAfterDeleteMethodIfValidAndOperationTypeIsAfterDelete() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.AFTER_DELETE;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.areEqual(
                TriggerOperation.AFTER_DELETE,
                handlerStubProvider.requestedOperation,
                'When context operation is AFTER_DELETE, the handler\'s afterDelete method should be called'
            );
        }
    }

    @IsTest
    static void callsAfterUndeleteMethodIfValidAndOperationTypeIsAfterUndelete() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerDispatcher dispatcher = new TriggerDispatcher();
            dispatcher.objectType = Account.getSObjectType();
            dispatcher.operation = TriggerOperation.AFTER_UNDELETE;
            ITriggerValidatorStub validatorStubProvider = new ITriggerValidatorStub();
            validatorStubProvider.isTriggerValid = true;
            ITriggerValidatorInterface validatorStub = (ITriggerValidatorInterface) Test.createStub(
                ITriggerValidatorInterface.class,
                validatorStubProvider
            );
            ITriggerHandlerStub handlerStubProvider = new ITriggerHandlerStub();
            handlerStubProvider.isHandlerDisabled = false;
            ITriggerHandlerInterface handlerStub = (ITriggerHandlerInterface) Test.createStub(
                ITriggerHandlerInterface.class,
                handlerStubProvider
            );
            dispatcher.run(handlerStub, validatorStub);
            Assert.areEqual(
                TriggerOperation.AFTER_UNDELETE,
                handlerStubProvider.requestedOperation,
                'When context operation is AFTER_UNDELETE, the handler\'s afterUndelete method should be called'
            );
        }
    }
}
