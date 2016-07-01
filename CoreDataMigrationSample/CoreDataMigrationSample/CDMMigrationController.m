//
//  CDMMigrationController.m
//

#import "CDMDataController.h"
#import "CDMFileUtils.h"
#import "CDMMigrationController.h"
#import "CDMTypes.h"

@implementation CDMMigrationController

- (void)setupWithCompletionHandler:(VoidHandler)completionHandler {
    [CDMFileUtils removeDocumentDirectoryContents];

    UBICoreDataStore *dataStore =
        [[UBICoreDataStore alloc] initWithModel:[CDMFileUtils modelWithName:CDMCoreDataModelName version:1]
                                       storeURL:[CDMFileUtils sourceStoreURL]];

    NSManagedObjectContext *privateContext = [dataStore.mainContext newPrivateQueueContext];

    [privateContext performBlock:^{
        for (uint32_t i = 0; i < 10000; i++) {
            @autoreleasepool {
                NSManagedObject *objectA = [NSEntityDescription insertNewObjectForEntityForName:CDMEntityAName
                                                                         inManagedObjectContext:privateContext];

                [objectA setValue:@(i % CDMMigrationGroupCount) forKey:CDMGroupKey];
                [objectA setValue:[[NSString alloc] initWithFormat:@"A-%05u", i] forKey:CDMNameKey];

                NSManagedObject *objectB = [NSEntityDescription insertNewObjectForEntityForName:CDMEntityBName
                                                                         inManagedObjectContext:privateContext];

                [objectB setValue:@(i % CDMMigrationGroupCount) forKey:CDMGroupKey];
                [objectB setValue:[[NSString alloc] initWithFormat:@"B-%05u", i] forKey:CDMNameKey];

                [objectA setValue:objectB forKey:CDMRelationshipKey];

                if (!(i % 100) && i > 0) {
                    [privateContext saveToPersistentStore];
                    [privateContext reset];
                }
            }
        }

        [privateContext saveToPersistentStore];
        [privateContext reset];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completionHandler();
        });
    }];
}

- (void)migrateWithCompletionHandler:(MigrateCompletionHandler)completionHandler {
    assert(0);
}

@end
