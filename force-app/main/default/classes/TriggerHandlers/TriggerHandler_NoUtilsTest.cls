@isTest
private class TriggerHandler_NoUtilsTest {
    @IsTest
    static void exposesIdempotentBeforeInsertMethod() {
        User runningUser = [SELECT Id FROM User WHERE Id = :userInfo.getUserId()];
        System.runAs(runningUser) {
            TriggerHandler_NoUtilsMock handlerMock = new TriggerHandler_NoUtilsMock();
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
            TriggerHandler_NoUtilsMock handlerMock = new TriggerHandler_NoUtilsMock();
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
            TriggerHandler_NoUtilsMock handlerMock = new TriggerHandler_NoUtilsMock();
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
            TriggerHandler_NoUtilsMock handlerMock = new TriggerHandler_NoUtilsMock();
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
            TriggerHandler_NoUtilsMock handlerMock = new TriggerHandler_NoUtilsMock();
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
            TriggerHandler_NoUtilsMock handlerMock = new TriggerHandler_NoUtilsMock();
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
            TriggerHandler_NoUtilsMock handlerMock = new TriggerHandler_NoUtilsMock();
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
