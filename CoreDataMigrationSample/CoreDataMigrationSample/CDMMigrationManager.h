//
//  CDMMigrationManager.h
//

#import <CoreData/CoreData.h>

@interface CDMMigrationManager : NSMigrationManager

- (void)addCacheName:(NSString *)name entityName:(NSString *)entityName;
- (NSManagedObject *)fetchCacheObjectForName:(NSString *)name entityName:(NSString *)entityName;

@end
