//
//  CDMTypes.m
//

#import <Foundation/Foundation.h>

NSString *const CDMLightweightMigrationSetupSegueIdentifier = @"lightweight";
NSString *const CDMCustomMigrationSetupSegueIdentifier = @"custom";
NSString *const CDMSeparateMigrationSetupSegueIdentifier = @"separate";
NSString *const CDMMigrationSegueIdentifier = @"migration";
NSString *const CDMEntitiesSegueIdentifier = @"entities";

NSString *const CDMCoreDataModelName = @"Model";
NSString *const CDMCoreDataSourceStoreFileName = @"SourceData.sqlite";
NSString *const CDMCoreDataDestinationStoreFileName = @"DestinationData.sqlite";

NSString *const CDMEntityAName = @"EntityA";
NSString *const CDMEntityBName = @"EntityB";
NSString *const CDMNameKey = @"name";
NSString *const CDMGroupKey = @"group";
NSString *const CDMRelationshipKey = @"relationship";

NSUInteger const CDMMigrationGroupCount = 8;
