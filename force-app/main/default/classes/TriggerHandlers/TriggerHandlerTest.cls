@isTest
private class TriggerHandlerTest {
    @IsTest
    static void returnsFalseOnAllContextCheckMethodsOutsideTriggerContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Assert.isFalse(
                handlerMock.isBeforeInsert(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isAfterInsert(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isBeforeUpdate(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isAfterUpdate(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isBeforeDelete(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isAfterDelete(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isInsert(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isUpdate(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isDelete(),
                'Context checking method should return false outside trigger context'
            );
            Assert.isFalse(
                handlerMock.isUndelete(),
                'Context checking method should return false outside trigger context'
            );
        }
    }

    @IsTest
    static void correctlyIdentifiesBeforeInsertContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_INSERT;
            Assert.isTrue(
                handlerMock.isBeforeInsert(),
                'Before insert context checking method should return true on before insert context'
            );
            Assert.isFalse(
                handlerMock.isAfterInsert(),
                'After insert context checking method should return false on before insert context'
            );
            Assert.isTrue(
                handlerMock.isInsert(),
                'Insert context checking method should return true on either before insert or after insert method'
            );
            Assert.isFalse(
                handlerMock.isUpdate(),
                'Update context checking method should return false when context is neither before update or after update'
            );
            Assert.isFalse(
                handlerMock.isDelete(),
                'Delete context checking method should return false when context is neither before delete or after delete'
            );
            Assert.isFalse(
                handlerMock.isUndelete(),
                'Undelete context checking method should return false outside after undelete context'
            );
        }
    }

    @IsTest
    static void correctlyIdentifiesAfterInsertContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_INSERT;
            Assert.isFalse(
                handlerMock.isBeforeInsert(),
                'Before insert context checking method should return false on after insert context'
            );
            Assert.isTrue(
                handlerMock.isAfterInsert(),
                'After insert context checking method should return true on after insert context'
            );
            Assert.isTrue(
                handlerMock.isInsert(),
                'Insert context checking method should return true on either before insert or after insert method'
            );
            Assert.isFalse(
                handlerMock.isUpdate(),
                'Update context checking method should return false when context is neither before update or after update'
            );
            Assert.isFalse(
                handlerMock.isDelete(),
                'Delete context checking method should return false when context is neither before delete or after delete'
            );
            Assert.isFalse(
                handlerMock.isUndelete(),
                'Undelete context checking method should return false outside after undelete context'
            );
        }
    }

    @IsTest
    static void correctlyIdentifiesBeforeUpdateContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_UPDATE;
            Assert.isTrue(
                handlerMock.isBeforeUpdate(),
                'Before update context checking method should return true on before update context'
            );
            Assert.isFalse(
                handlerMock.isAfterUpdate(),
                'After update context checking method should return false on before update context'
            );
            Assert.isTrue(
                handlerMock.isUpdate(),
                'Update context checking method should return true on either before update or after update method'
            );
            Assert.isFalse(
                handlerMock.isInsert(),
                'Insert context checking method should return false when context is neither before insert or after insert'
            );
            Assert.isFalse(
                handlerMock.isDelete(),
                'Delete context checking method should return false when context is neither before delete or after delete'
            );
            Assert.isFalse(
                handlerMock.isUndelete(),
                'Undelete context checking method should return false outside after undelete context'
            );
        }
    }

    @IsTest
    static void correctlyIdentifiesAfterUpdateContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_UPDATE;
            Assert.isFalse(
                handlerMock.isBeforeUpdate(),
                'Before update context checking method should return false on after update context'
            );
            Assert.isTrue(
                handlerMock.isAfterUpdate(),
                'After update context checking method should return false on before update context'
            );
            Assert.isTrue(
                handlerMock.isUpdate(),
                'Update context checking method should return true on either before update or after update method'
            );
            Assert.isFalse(
                handlerMock.isInsert(),
                'Insert context checking method should return false when context is neither before insert or after insert'
            );
            Assert.isFalse(
                handlerMock.isDelete(),
                'Delete context checking method should return false when context is neither before delete or after delete'
            );
            Assert.isFalse(
                handlerMock.isUndelete(),
                'Undelete context checking method should return false outside after undelete context'
            );
        }
    }

    @IsTest
    static void correctlyIdentifiesBeforeDeleteContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_DELETE;
            Assert.isTrue(
                handlerMock.isBeforeDelete(),
                'Before delete context checking method should return true on before delete context'
            );
            Assert.isFalse(
                handlerMock.isAfterDelete(),
                'After delete context checking method should return false on before delete context'
            );
            Assert.isTrue(
                handlerMock.isDelete(),
                'Delete context checking method should return true on either before delete or after delete method'
            );
            Assert.isFalse(
                handlerMock.isInsert(),
                'Insert context checking method should return false when context is neither before insert or after insert'
            );
            Assert.isFalse(
                handlerMock.isUpdate(),
                'Update context checking method should return false when context is neither before update or after update'
            );
            Assert.isFalse(
                handlerMock.isUndelete(),
                'Undelete context checking method should return false outside after undelete context'
            );
        }
    }

    @IsTest
    static void correctlyIdentifiesAfterDeleteContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_DELETE;
            Assert.isFalse(
                handlerMock.isBeforeDelete(),
                'Before delete context checking method should return false on after delete context'
            );
            Assert.isTrue(
                handlerMock.isAfterDelete(),
                'After delete context checking method should return true on after delete context'
            );
            Assert.isTrue(
                handlerMock.isDelete(),
                'Delete context checking method should return true on either before delete or after delete method'
            );
            Assert.isFalse(
                handlerMock.isInsert(),
                'Insert context checking method should return false when context is neither before insert or after insert'
            );
            Assert.isFalse(
                handlerMock.isUpdate(),
                'Update context checking method should return false when context is neither before update or after update'
            );
            Assert.isFalse(
                handlerMock.isUndelete(),
                'Undelete context checking method should return false outside after undelete context'
            );
        }
    }

    @IsTest
    static void correctlyIdentifiesAfterUndeleteContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_UNDELETE;
            Assert.isTrue(
                handlerMock.isUndelete(),
                'Undelete context checking method should return true after undelete method'
            );
            Assert.isFalse(
                handlerMock.isInsert(),
                'Insert context checking method should return false when context is neither before insert or after insert'
            );
            Assert.isFalse(
                handlerMock.isUpdate(),
                'Update context checking method should return false when context is neither before update or after update'
            );
            Assert.isFalse(
                handlerMock.isDelete(),
                'Delete context checking method should return false when context is neither before delete or after delete'
            );
        }
    }

    @IsTest
    static void returnsNullWhenGettingOldRecordsOutsideTriggerContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            Assert.isNull(TriggerHandler.getOldRecords(), 'Outside trigger context, getOldRecords always returns null');
        }
    }

    @IsTest
    static void returnsNullWhenGettingOldRecordVersionOutsideTriggerContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            Assert.isNull(
                TriggerHandler.getOldRecordVersion(generateTestId(Account.getSObjectType())),
                'Outside trigger context, getOldRecordVersion always returns null'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfNullRecordChangedField() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_INSERT;
            Assert.isFalse(
                handlerMock.isChanged(null, Account.Name),
                'Checking if a null record changed a field always returns false'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfNonNullRecordChangedNullField() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_INSERT;
            Assert.isFalse(
                handlerMock.isChanged(new Account(), null),
                'Checking if a non-null record changed a null field always returns false'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfFieldChangedInBeforeDeleteContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_DELETE;
            Assert.isFalse(
                handlerMock.isChanged(new Account(), Account.Name),
                'Checking if a field changed in a before delete context always returns false'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfFieldChangedInAfterDeleteContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_DELETE;
            Assert.isFalse(
                handlerMock.isChanged(new Account(), Account.Name),
                'Checking if a field changed in after delete context always returns false'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfFieldChangedInAfterUndeleteContext() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_UNDELETE;
            Assert.isFalse(
                handlerMock.isChanged(new Account(), Account.Name),
                'Checking if a field changed in after undelete context always returns false'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfNonPopulatedFieldChanged() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_INSERT;
            Assert.isFalse(
                handlerMock.isChanged(new Account(), Account.Name),
                'Checking if a non-populated field changed always returns false'
            );
        }
    }

    @IsTest
    static void returnsTrueWhenCheckingIfFieldChangedDuringBeforeInsert() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_INSERT;
            Assert.isTrue(
                handlerMock.isChanged(new Account(Name = 'Test Account'), Account.Name),
                'Checking if a field changed during before insert always returns true'
            );
        }
    }

    @IsTest
    static void returnsTrueWhenCheckingIfFieldChangedDuringAfterInsert() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.AFTER_INSERT;
            Assert.isTrue(
                handlerMock.isChanged(new Account(Name = 'Test Account'), Account.Name),
                'Checking if a field changed during after insert always returns true'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfFieldChangedAndOldRecordVersionDoesntExist() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_UPDATE;
            Assert.isFalse(
                handlerMock.isChanged(new Account(Name = 'Test Account'), Account.Name),
                'Checking if a field changed when old record version doesnt exist always returns false'
            );
        }
    }

    @IsTest
    static void returnsFalseWhenCheckingIfAnyFieldChangedAndNoneChanged() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_INSERT;
            Assert.isFalse(
                handlerMock.isAnyChanged(
                    new Account(Name = 'Test Account'),
                    new Set<SObjectField>{ Account.Description, Account.Type }
                ),
                'Checking if any field changed when none changed returns false'
            );
        }
    }

    @IsTest
    static void returnsTrueWhenCheckingIfAnyFieldChangedAndAtLeastOneChanged() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            handlerMock.isTriggerExecuting = true;
            handlerMock.operation = TriggerOperation.BEFORE_INSERT;
            Assert.isTrue(
                handlerMock.isAnyChanged(
                    new Account(Name = 'Test Account'),
                    new Set<SObjectField>{ Account.Name, Account.Description, Account.Type }
                ),
                'Checking if any field changed when at least one changed returns true'
            );
        }
    }

    @IsTest
    static void exposesIdempotentBeforeInsertMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Account triggeringAccountWitness = new Account(Name = 'Test Account');
            List<Account> accounts = new List<Account>{ triggeringAccountWitness.clone(true, true, true, true) };
            Test.startTest();
            handlerMock.beforeInsert(accounts);
            Assert.areEqual(
                triggeringAccountWitness,
                accounts.get(0),
                'Virtual method should not modify records in any way'
            );
            Assert.isTrue(noSideEffects(), 'Virtual method should not have side effects');
            Test.stopTest();
        }
    }

    @IsTest
    static void exposesIdempotentAfterInsertMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Account triggeringAccountWitness = new Account(
                Id = generateTestId(Account.getSObjectType()),
                Name = 'Test Account'
            );
            Map<Id, Account> accountsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => triggeringAccountWitness.clone(true, true, true, true)
            };
            Test.startTest();
            handlerMock.afterInsert(accountsMap);
            Assert.areEqual(
                triggeringAccountWitness,
                accountsMap.get(triggeringAccountWitness.Id),
                'Virtual method should not modify records in any way'
            );
            Assert.isTrue(noSideEffects(), 'Virtual method should not have side effects');
            Test.stopTest();
        }
    }

    @IsTest
    static void exposesIdempotentBeforeUpdateMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Account triggeringAccountWitness = new Account(
                Id = generateTestId(Account.getSObjectType()),
                Name = 'Test Account'
            );
            Account newAccountVersionWitness = triggeringAccountWitness.clone(true, true, true, true);
            newAccountVersionWitness.Name = 'Modified Test Account';

            Map<Id, Account> oldRecordsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => triggeringAccountWitness.clone(true, true, true, true)
            };
            Map<Id, Account> newRecordsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => newAccountVersionWitness.clone(true, true, true, true)
            };
            Test.startTest();
            handlerMock.beforeUpdate(oldRecordsMap, newRecordsMap);
            Assert.areEqual(
                oldRecordsMap.values().get(0),
                triggeringAccountWitness,
                'Virtual method should not modify old record versions in any way'
            );
            Assert.areEqual(
                newRecordsMap.values().get(0),
                newAccountVersionWitness,
                'Virtual method should not modify new record versions in any way'
            );
            Assert.isTrue(noSideEffects(), 'Virtual method should not have side effects');
            Test.stopTest();
        }
    }

    @IsTest
    static void exposesIdempotentAfterUpdateMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Account triggeringAccountWitness = new Account(
                Id = generateTestId(Account.getSObjectType()),
                Name = 'Test Account'
            );
            Account newAccountVersionWitness = triggeringAccountWitness.clone(true, true, true, true);
            newAccountVersionWitness.Name = 'Modified Test Account';

            Map<Id, Account> oldRecordsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => triggeringAccountWitness.clone(true, true, true, true)
            };
            Map<Id, Account> newRecordsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => newAccountVersionWitness.clone(true, true, true, true)
            };
            Test.startTest();
            handlerMock.afterUpdate(oldRecordsMap, newRecordsMap);
            Assert.areEqual(
                oldRecordsMap.values().get(0),
                triggeringAccountWitness,
                'Virtual method should not modify old record versions in any way'
            );
            Assert.areEqual(
                newRecordsMap.values().get(0),
                newAccountVersionWitness,
                'Virtual method should not modify new record versions in any way'
            );
            Assert.isTrue(noSideEffects(), 'Virtual method should not have side effects');
            Test.stopTest();
        }
    }

    @IsTest
    static void exposesIdempotentBeforeDeleteMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Account triggeringAccountWitness = new Account(
                Id = generateTestId(Account.getSObjectType()),
                Name = 'Test Account'
            );

            Map<Id, Account> oldRecordsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => triggeringAccountWitness.clone(true, true, true, true)
            };
            Test.startTest();
            handlerMock.beforeDelete(oldRecordsMap);
            Assert.areEqual(
                oldRecordsMap.values().get(0),
                triggeringAccountWitness,
                'Virtual method should not modify old record versions in any way'
            );
            Assert.isTrue(noSideEffects(), 'Virtual method should not have side effects');
            Test.stopTest();
        }
    }

    @IsTest
    static void exposesIdempotentAfterDeleteMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Account triggeringAccountWitness = new Account(
                Id = generateTestId(Account.getSObjectType()),
                Name = 'Test Account'
            );

            Map<Id, Account> oldRecordsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => triggeringAccountWitness.clone(true, true, true, true)
            };
            Test.startTest();
            handlerMock.afterDelete(oldRecordsMap);
            Assert.areEqual(
                oldRecordsMap.values().get(0),
                triggeringAccountWitness,
                'Virtual method should not modify old record versions in any way'
            );
            Assert.isTrue(noSideEffects(), 'Virtual method should not have side effects');
            Test.stopTest();
        }
    }

    @IsTest
    static void exposesIdempotentAfterUndeleteMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandlerMock handlerMock = new TriggerHandlerMock();
            Account triggeringAccountWitness = new Account(
                Id = generateTestId(Account.getSObjectType()),
                Name = 'Test Account'
            );

            Map<Id, Account> newRecordsMap = new Map<Id, Account>{
                triggeringAccountWitness.Id => triggeringAccountWitness.clone(true, true, true, true)
            };
            Test.startTest();
            handlerMock.afterUndelete(newRecordsMap);
            Assert.areEqual(
                newRecordsMap.values().get(0),
                triggeringAccountWitness,
                'Virtual method should not modify old record versions in any way'
            );
            Assert.isTrue(noSideEffects(), 'Virtual method should not have side effects');
            Test.stopTest();
        }
    }

    private static Boolean noSideEffects() {
        return Limits.getAsyncCalls() == 0 &&
            Limits.getCallouts() == 0 &&
            Limits.getDmlStatements() == 0 &&
            Limits.getEmailInvocations() == 0 &&
            Limits.getFutureCalls() == 0 &&
            Limits.getMobilePushApexCalls() == 0 &&
            Limits.getPublishImmediateDML() == 0 &&
            Limits.getQueries() == 0 &&
            Limits.getQueueableJobs() == 0 &&
            Limits.getSoslQueries() == 0;
    }

    private static Id generateTestId(SObjectType objectType) {
        return objectType.getDescribe(Schema.SObjectDescribeOptions.DEFERRED).getKeyPrefix() + '0'.repeat(12);
    }
}
