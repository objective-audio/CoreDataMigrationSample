//
//  CDMEntityAMigrationPolicy.m
//

#import "CDMEntityAMigrationPolicy.h"
#import "CDMMigrationUtils.h"
#import "CDMTypes.h"

@implementation CDMEntityAMigrationPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance
                                      entityMapping:(NSEntityMapping *)mapping
                                            manager:(NSMigrationManager *)manager
                                              error:(NSError *__autoreleasing *)error {
    // Destinationにオブジェクトを生成
    NSManagedObject *dInstance = [NSEntityDescription insertNewObjectForEntityForName:CDMEntityAName
                                                               inManagedObjectContext:manager.destinationContext];

    // SourceのオブジェクトからDestinationのオブジェクトに属性をコピー
    [CDMMigrationUtils copyAttributesFromSourceInstance:sInstance
                                  toDestinationInstance:dInstance
                                          entityMapping:mapping];

    // EntityAはEntityBより先にオブジェクトを生成するので関連付けをしない

    return YES;
}

@end
