@isTest
private class TriggerValidator_NoMetadataTest {
    @IsTest
    static void validatesAllTriggersByDefault() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            for (TriggerOperation operation : TriggerOperation.values()) {
                Assert.isTrue(
                    validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                    'By default, TriggerValidator should validate any trigger operation to run'
                );
            }
        }
    }

    @IsTest
    static void doesNotValidateAnyOperationsIfObjectBypassed() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            TriggerValidator.bypassTrigger(Account.getSObjectType());
            for (TriggerOperation operation : TriggerOperation.values()) {
                Assert.isFalse(
                    validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                    'No Trigger Operations should be validated if the object is bypassed'
                );
            }
        }
    }

    @IsTest
    static void doesNotValidateBypassedOperationButValidatesAllOthers() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            TriggerOperation bypassedOperation = TriggerOperation.BEFORE_INSERT;
            TriggerValidator.bypassTrigger(Account.getSObjectType(), bypassedOperation);
            for (TriggerOperation operation : TriggerOperation.values()) {
                if (operation == bypassedOperation) {
                    Assert.isFalse(
                        validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                        'Bypassed operation should not be validated to run'
                    );
                } else {
                    Assert.isTrue(
                        validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                        'Non bypassed operations should be validated to run'
                    );
                }
            }
        }
    }

    @IsTest
    static void validatesAllOperationsIfBypassedObjectIsCleared() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerValidator.bypassTrigger(Account.getSObjectType());
            TriggerValidator.clearTriggerBypass(Account.getSObjectType());
            TriggerValidator validator = new TriggerValidator();
            for (TriggerOperation operation : TriggerOperation.values()) {
                Assert.isTrue(
                    validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                    'All Trigger operations should be validated if a bypassed object is cleared'
                );
            }
        }
    }

    @IsTest
    static void validatesClearedOperationIfPreviouslyBypassed() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            TriggerOperation clearedOperation = TriggerOperation.BEFORE_INSERT;
            for (TriggerOperation operation : TriggerOperation.values()) {
                TriggerValidator.bypassTrigger(Account.getSObjectType(), operation);
                if (operation == clearedOperation) {
                    TriggerValidator.clearTriggerBypass(Account.getSObjectType(), operation);
                    Assert.isTrue(
                        validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                        'Cleared operation should be validated to run'
                    );
                } else {
                    Assert.isFalse(
                        validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                        'Non cleared operations should not be validated to run'
                    );
                }
            }
        }
    }

    @IsTest
    static void doesNotValidateClearedOperationIfObjectIsBypassed() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            TriggerOperation clearedOperation = TriggerOperation.BEFORE_INSERT;
            TriggerValidator.bypassTrigger(Account.getSObjectType());
            TriggerValidator.clearTriggerBypass(Account.getSObjectType(), clearedOperation);
            Assert.isFalse(
                validator.isTriggerValidatedToRun(Account.getSObjectType(), clearedOperation),
                'Clearing a particular operation does not validate it while object remains bypassed'
            );
        }
    }

    @IsTest
    static void validatesAllTriggersIfAllBypassesAreCleared() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        TriggerValidator.bypassTrigger(Account.getSObjectType());
        for (TriggerOperation operation : TriggerOperation.values()) {
            TriggerValidator.bypassTrigger(Contact.getSObjectType(), operation);
        }

        TriggerValidator.clearAllTriggerBypasses();
        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            for (TriggerOperation operation : TriggerOperation.values()) {
                Assert.isTrue(
                    validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                    'TriggerValidator should validate any trigger operation to run after bypasses were cleared'
                );
            }
        }
    }
}
