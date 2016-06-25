//
//  CDMSeparateMigrationController.m
//

#import "CDMDataController.h"
#import "CDMFileUtils.h"
#import "CDMMigrationManager.h"
#import "CDMMigrationUtils.h"
#import "CDMSeparateMigrationController.h"
#import "CDMTypes.h"

@implementation CDMSeparateMigrationController

- (void)migrateWithCompletionHandler:(MigrateCompletionHandler)completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMappingModel *originalMappingModel =
            [CDMFileUtils mappingModelWithName:CDMCoreDataModelName sourceVersion:1 destinationVersion:2];

        NSMutableArray<NSMappingModel *> *mappingModels = [[NSMutableArray alloc] init];

        // EntityA -> EntityB の順番でそれぞれ8分割したMappingModelを生成
        for (NSString *entityName in @[CDMEntityAName, CDMEntityBName]) {
            [mappingModels addObjectsFromArray:[CDMMigrationUtils mappingModelsForEntityName:entityName
                                                                            fromMappingModel:originalMappingModel]];
        }

        NSManagedObjectModel *sourceModel = [CDMFileUtils modelWithName:CDMCoreDataModelName version:1];
        NSManagedObjectModel *destinationModel = [CDMFileUtils modelWithName:CDMCoreDataModelName version:2];

        BOOL success = YES;

        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

        // 分割されたMappingModelの数だけマイグレーションを繰り返す
        for (NSMappingModel *mappingModel in mappingModels) {
            @autoreleasepool {
                NSMigrationManager *migrationManager =
                    [[CDMMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];

                if (![migrationManager migrateStoreFromURL:[CDMFileUtils sourceStoreURL]
                                                      type:NSSQLiteStoreType
                                                   options:nil
                                          withMappingModel:mappingModel
                                          toDestinationURL:[CDMFileUtils destinationStoreURL]
                                           destinationType:NSSQLiteStoreType
                                        destinationOptions:nil
                                                     error:nil]) {
                    success = NO;
                    break;
                }

                [migrationManager.sourceContext reset];
                [migrationManager.destinationContext save];
                [migrationManager.destinationContext reset];
            }
        }

        CDMDataController *dataController = nil;

        if (success) {
            dataController = [[CDMDataController alloc] initWithStoreURL:[CDMFileUtils destinationStoreURL]];

            dataController.migrationTime = CFAbsoluteTimeGetCurrent() - startTime;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(dataController);
        });
    });
}

@end
