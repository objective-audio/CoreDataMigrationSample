//
//  CDMCustomMigrationController.m
//

#import "CDMCustomMigrationController.h"
#import "CDMDataController.h"
#import "CDMFileUtils.h"

@implementation CDMCustomMigrationController

- (void)migrateWithCompletionHandler:(MigrateCompletionHandler)completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectModel *sourceModel = [CDMFileUtils modelWithName:CDMCoreDataModelName version:1];
        NSManagedObjectModel *destinationModel = [CDMFileUtils modelWithName:CDMCoreDataModelName version:2];
        NSMappingModel *mappingModel =
            [CDMFileUtils mappingModelWithName:CDMCoreDataModelName sourceVersion:1 destinationVersion:2];

        CDMDataController *dataController = nil;

        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

        NSMigrationManager *migrationManager =
            [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];

        if ([migrationManager migrateStoreFromURL:[CDMFileUtils sourceStoreURL]
                                             type:NSSQLiteStoreType
                                          options:nil
                                 withMappingModel:mappingModel
                                 toDestinationURL:[CDMFileUtils destinationStoreURL]
                                  destinationType:NSSQLiteStoreType
                               destinationOptions:nil
                                            error:nil]) {
            dataController = [[CDMDataController alloc] initWithStoreURL:[CDMFileUtils destinationStoreURL]];

            dataController.migrationTime = CFAbsoluteTimeGetCurrent() - startTime;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(dataController);
        });
    });
}

@end
