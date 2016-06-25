//
//  CDMMigrationUtils.m
//

#import "CDMMigrationUtils.h"
#import "CDMTypes.h"

@implementation CDMMigrationUtils

+ (NSArray<NSMappingModel *> *)mappingModelsForEntityName:(NSString *)entityName
                                         fromMappingModel:(NSMappingModel *)fromMappingModel {
    NSMutableArray<NSMappingModel *> *mappingModels = [[NSMutableArray alloc] initWithCapacity:CDMMigrationGroupCount];

    NSString *migrationPolicyClassName = [[NSString alloc] initWithFormat:@"CDM%@MigrationPolicy", entityName];

    // ここでは１つのエンティティにつき8個に分割する
    for (NSInteger groupIndex = 0; groupIndex < CDMMigrationGroupCount; groupIndex++) {
        // MappingModelをコピー
        NSMappingModel *newMappingModel = [fromMappingModel copy];

        for (NSEntityMapping *entityMapping in newMappingModel.entityMappings) {
            // 必要なエンティティだけ残す
            NSString *sourceEntityName = entityMapping.sourceEntityName;
            if ([sourceEntityName isEqualToString:entityName]) {
                // MigrationPolicyのクラス名をセット
                entityMapping.entityMigrationPolicyClassName = migrationPolicyClassName;

                // Filter Predicateを差し替える（分割以外にフィルターしたい条件があればここで加える）
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", CDMGroupKey, @(groupIndex)];
                entityMapping.sourceExpression = [self sourceExpressionWithEntityName:entityName predicate:predicate];
                newMappingModel.entityMappings = @[entityMapping];
                break;
            }
        }

        [mappingModels addObject:newMappingModel];
    }

    return mappingModels;
}

+ (NSExpression *)sourceExpressionWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate {
    // CDMMigrationManagerのメソッドを呼ぶためのNSExpressionを生成

    NSExpression *entityNameExpression = [NSExpression expressionForConstantValue:entityName];
    NSExpression *predicateExpression = [NSExpression expressionForConstantValue:predicate];
    NSExpression *functionExpression =
        [NSExpression expressionForFunction:[NSExpression expressionWithFormat:@"$manager"]
                               selectorName:@"fetchRequestForSourceEntityNamed:predicate:"
                                  arguments:@[entityNameExpression, predicateExpression]];
    NSExpression *contextExpression = [NSExpression expressionWithFormat:@"$manager.sourceContext"];
    NSExpression *fetchRequestExpression =
        [NSFetchRequestExpression expressionForFetch:functionExpression context:contextExpression countOnly:NO];
    return fetchRequestExpression;
}

+ (void)copyAttributesFromSourceInstance:(NSManagedObject *)sInstance
                   toDestinationInstance:(NSManagedObject *)dInstance
                           entityMapping:(NSEntityMapping *)mapping {
    // オブジェクトの属性全てをコピーする

    for (NSPropertyMapping *propertyMapping in mapping.attributeMappings) {
        id value = [propertyMapping.valueExpression
            expressionValueWithObject:nil
                              context:[[NSMutableDictionary alloc] initWithObjectsAndKeys:sInstance, @"source", nil]];
        if (value) {
            [dInstance setValue:value forKey:propertyMapping.name];
        }
    }
}

@end
