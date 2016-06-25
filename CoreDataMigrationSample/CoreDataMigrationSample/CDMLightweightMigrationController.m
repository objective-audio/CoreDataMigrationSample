//
//  CDMLightweightMigrationController.m
//

#import "CDMDataController.h"
#import "CDMFileUtils.h"
#import "CDMLightweightMigrationController.h"

@implementation CDMLightweightMigrationController

- (void)migrateWithCompletionHandler:(MigrateCompletionHandler)completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CDMDataController *dataController = [[CDMDataController alloc] initWithStoreURL:[CDMFileUtils sourceStoreURL]];

        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

        [dataController.dataStore.mainContext save];

        dataController.migrationTime = CFAbsoluteTimeGetCurrent() - startTime;

        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(dataController);
        });
    });
}

@end
