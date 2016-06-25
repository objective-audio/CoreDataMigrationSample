//
//  CDMMigrationUtils.h
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface CDMMigrationUtils : NSObject

// MappingModelを分割
+ (NSArray<NSMappingModel *> *)mappingModelsForEntityName:(NSString *)entityName
                                         fromMappingModel:(NSMappingModel *)fromMappingModel;

// オブジェクトの全属性をコピー
+ (void)copyAttributesFromSourceInstance:(NSManagedObject *)sInstance
                   toDestinationInstance:(NSManagedObject *)dInstance
                           entityMapping:(NSEntityMapping *)mapping;

@end
