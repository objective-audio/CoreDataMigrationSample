//
//  CDMDataController.m
//

#import "CDMDataController.h"
#import "CDMTypes.h"

@interface CDMDataController ()

@property (nonatomic) UBICoreDataStore *dataStore;

@end

@implementation CDMDataController

- (instancetype)initWithStoreURL:(NSURL *)storeURL {
    self = [super init];
    if (self) {
        self.dataStore = [[UBICoreDataStore alloc] initWithModelName:CDMCoreDataModelName storeURL:storeURL];
    }
    return self;
}

- (NSDictionary<NSString *, id> *)metadata {
    NSPersistentStoreCoordinator *coordinator = self.dataStore.mainContext.persistentStoreCoordinator;
    NSPersistentStore *store = self.dataStore.mainContext.persistentStoreCoordinator.persistentStores.lastObject;

    return [coordinator metadataForPersistentStore:store];
}

- (NSUInteger)entityCount {
    return self.dataStore.managedObjectModel.entities.count;
}

- (NSString *)entityNameAtIndex:(NSUInteger)index {
    return self.dataStore.managedObjectModel.entities[index].name;
}

@end
