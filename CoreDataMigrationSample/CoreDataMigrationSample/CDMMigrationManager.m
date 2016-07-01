//
//  CDMMigrationManager.m
//

#import "CDMMigrationManager.h"
#import "CDMTypes.h"

@implementation CDMMigrationManager {
    NSMutableDictionary *_cacheNames;
    NSMutableDictionary *_fetchedCacheObjects;
}

- (NSFetchRequest *)fetchRequestForSourceEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate {
    // EntityMappingからfetchRequestを使えるようにNSMigrationManagerのサブクラスで実装。$managerでアクセスできる
    // デフォルトで用意されている fetchRequestForSourceEntityNamed:predicateString: を使うならいらない

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.sourceContext];
    request.includesSubentities = NO;
    request.predicate = predicate;

    return request;
}

#pragma mark -

- (void)addCacheName:(NSString *)name entityName:(NSString *)entityName {
    NSMutableSet *names = [self cacheNamesForEntity:entityName];
    [names addObject:name];
}

- (NSManagedObject *)fetchCacheObjectForName:(NSString *)name entityName:(NSString *)entityName {
    NSDictionary *objects = [self fetchedObjectsForEntity:entityName];
    return [objects objectForKey:name];
}

- (NSMutableSet *)cacheNamesForEntity:(NSString *)entity {
    NSMutableDictionary *names = [self cacheNames];
    NSMutableSet *namesForEntity = [names objectForKey:entity];
    if (!namesForEntity) {
        namesForEntity = [[NSMutableSet alloc] init];
        [names setObject:namesForEntity forKey:entity];
    }
    return namesForEntity;
}

- (NSMutableDictionary *)cacheNames {
    if (!_cacheNames) {
        _cacheNames = [[NSMutableDictionary alloc] init];
    }
    return _cacheNames;
}

- (NSDictionary *)fetchedObjectsForEntity:(NSString *)entityName {
    NSMutableDictionary *objects = [self fetchedCacheObjects];
    NSMutableDictionary *objectsForEntity = [objects objectForKey:entityName];
    if (!objectsForEntity) {
        objectsForEntity = [[NSMutableDictionary alloc] init];
        [objects setObject:objectsForEntity forKey:entityName];

        NSSet *namesForEntity = [self cacheNamesForEntity:entityName];
        NSArray *fetchedObjects = [[self class] fetchObjectsWithEntityName:entityName
                                                                    forKey:CDMNameKey
                                                              sourceValues:namesForEntity
                                                                 inContext:self.destinationContext];

        for (NSManagedObject *object in fetchedObjects) {
            NSString *name = [object valueForKey:CDMNameKey];
            [objectsForEntity setObject:object forKey:name];
        }
    }

    return objectsForEntity;
}

- (NSMutableDictionary *)fetchedCacheObjects {
    if (!_fetchedCacheObjects) {
        _fetchedCacheObjects = [[NSMutableDictionary alloc] init];
    }
    return _fetchedCacheObjects;
}

+ (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
                                 forKey:(NSString *)key
                           sourceValues:(NSSet *)values
                              inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    fetchRequest.includesSubentities = NO;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K IN %@", key, values];
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
