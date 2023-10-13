@isTest
private class TriggerValidatorTest {
    @IsTest
    static void mapsAllMetadataRecordsCorrectly() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        List<Trigger_Setting__mdt> existingMetadataRecords = [
            SELECT
                Object__r.QualifiedApiName,
                Trigger_Disabled__c,
                Before_Insert_Disabled__c,
                After_Insert_Disabled__c,
                Before_Update_Disabled__c,
                After_Update_Disabled__c,
                Before_Delete_Disabled__c,
                After_Delete_Disabled__c,
                After_Undelete_Disabled__c
            FROM Trigger_Setting__mdt
        ];

        System.runAs(runningUser) {
            Assert.areEqual(
                existingMetadataRecords.size(),
                TriggerValidator.triggerMetadataMap.size(),
                'Trigger Validator metadata map should contain all existing metadata records'
            );
            for (Trigger_Setting__mdt metadataRecord : existingMetadataRecords) {
                Assert.isTrue(
                    TriggerValidator.triggerMetadataMap.containsKey(
                        Schema.getGlobalDescribe().get(metadataRecord.Object__r.QualifiedApiName)
                    ),
                    'TriggerValidator class should have all existing Trigger_Setting__mdt records in its internal variable'
                );
                Assert.areEqual(
                    metadataRecord,
                    TriggerValidator.triggerMetadataMap.get(
                        Schema.getGlobalDescribe().get(metadataRecord.Object__r.QualifiedApiName)
                    ),
                    'Mapped records should match the actual records'
                );
            }
        }
    }

    @IsTest
    static void validatesAllTriggersByDefault() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        TriggerValidator.triggerMetadataMap.clear();

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
        TriggerValidator.triggerMetadataMap.clear();

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
        TriggerValidator.triggerMetadataMap.clear();

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
        TriggerValidator.triggerMetadataMap.clear();

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
        TriggerValidator.triggerMetadataMap.clear();

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
        TriggerValidator.triggerMetadataMap.clear();

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
        TriggerValidator.triggerMetadataMap.clear();

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

    @IsTest
    static void doesNotValidateAnyOperationsIfObjectTriggerIsDisabled() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        TriggerValidator.triggerMetadataMap.clear();

        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            TriggerValidator.triggerMetadataMap.put(
                Account.getSObjectType(),
                new Trigger_Setting__mdt(Trigger_Disabled__c = true)
            );
            for (TriggerOperation operation : TriggerOperation.values()) {
                Assert.isFalse(
                    validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                    'No Trigger Operations should be validated if trigger is disabled via metadata'
                );
            }
        }
    }

    @IsTest
    static void doesNotValidateDisabledOperatioButValidatesAllOthers() {
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        TriggerValidator.triggerMetadataMap.clear();

        System.runAs(runningUser) {
            TriggerValidator validator = new TriggerValidator();
            TriggerOperation bypassedOperation = TriggerOperation.BEFORE_INSERT;
            TriggerValidator.triggerMetadataMap.put(
                Account.getSObjectType(),
                new Trigger_Setting__mdt(
                    Trigger_Disabled__c = false,
                    Before_Insert_Disabled__c = true,
                    After_Insert_Disabled__c = false,
                    Before_Update_Disabled__c = false,
                    After_Update_Disabled__c = false,
                    Before_Delete_Disabled__c = false,
                    After_Delete_Disabled__c = false,
                    After_Undelete_Disabled__c = false
                )
            );

            for (TriggerOperation operation : TriggerOperation.values()) {
                if (operation == bypassedOperation) {
                    Assert.isFalse(
                        validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                        'Operation should not be validated to run if disabled in metadata'
                    );
                } else {
                    Assert.isTrue(
                        validator.isTriggerValidatedToRun(Account.getSObjectType(), operation),
                        'Non disabled operations should be validated to run'
                    );
                }
            }
        }
    }
}
