//
//  CDMEntityBMigrationPolicy.m
//

#import "CDMEntityBMigrationPolicy.h"
#import "CDMMigrationManager.h"
#import "CDMMigrationUtils.h"
#import "CDMTypes.h"

@implementation CDMEntityBMigrationPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance
                                      entityMapping:(NSEntityMapping *)mapping
                                            manager:(CDMMigrationManager *)manager
                                              error:(NSError *__autoreleasing *)error {
    // Destinationにオブジェクトを生成
    NSManagedObject *dInstance = [NSEntityDescription insertNewObjectForEntityForName:CDMEntityBName
                                                               inManagedObjectContext:manager.destinationContext];

    // SourceのオブジェクトからDestinationのオブジェクトに属性をコピー
    [CDMMigrationUtils copyAttributesFromSourceInstance:sInstance
                                  toDestinationInstance:dInstance
                                          entityMapping:mapping];

    // 関連付けのためにEntityAのIDとなるnameの値を保存
    NSManagedObject *sRelationship = [sInstance valueForKey:CDMRelationshipKey];
    NSString *entityAName = [sRelationship valueForKey:CDMNameKey];
    if (entityAName) {
        [manager addCacheName:entityAName entityName:CDMEntityAName];
    }

    // 関連のステージを実行するためにMigrationManagerに登録
    [manager associateSourceInstance:sInstance withDestinationInstance:dInstance forEntityMapping:mapping];

    return YES;
}

- (BOOL)createRelationshipsForDestinationInstance:(NSManagedObject *)dInstance
                                    entityMapping:(NSEntityMapping *)mapping
                                          manager:(CDMMigrationManager *)manager
                                            error:(NSError *__autoreleasing *)error {
    // ここの処理は、モデルの構成によってもっと調整する必要がある

    // DestinationのオブジェクトからSourceのオブジェクトを取得
    NSManagedObject *sInstance =
        [manager sourceInstancesForEntityMappingNamed:mapping.name destinationInstances:@[dInstance]].firstObject;

    // EntityMappingから関連を走査
    for (NSPropertyMapping *propertyMapping in mapping.relationshipMappings) {
        if (!propertyMapping.valueExpression) {
            continue;
        }

        if ([propertyMapping.name isEqualToString:CDMRelationshipKey]) {
            // Sourceのオブジェクトから関連先のEntityAのnameを取得
            NSManagedObject *sRelationship = [sInstance valueForKey:CDMRelationshipKey];
            NSString *entityAName = [sRelationship valueForKey:CDMNameKey];

            // nameからEntityAのオブジェクトを取得。
            NSManagedObject *dRelationship = [manager fetchCacheObjectForName:entityAName entityName:CDMEntityAName];

            // オブジェクトを関連にセット
            if (dRelationship) {
                [dInstance setValue:dRelationship forKey:CDMRelationshipKey];
            }
        }
    }
    return YES;
}

@end
