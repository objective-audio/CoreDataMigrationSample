//
//  CDMFileUtils.h
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface CDMFileUtils : NSObject

+ (NSURL *)sourceStoreURL;
+ (NSURL *)destinationStoreURL;
+ (NSString *)documentDirectoryPath;
+ (void)removeDocumentDirectoryContents;
+ (BOOL)moveFileFromURL:(NSURL *)fromURL toURL:(NSURL *)toURL;

+ (NSManagedObjectModel *)modelWithName:(NSString *)name version:(NSUInteger)version;
+ (NSMappingModel *)mappingModelWithName:(NSString *)name
                           sourceVersion:(NSUInteger)sourceVersion
                      destinationVersion:(NSUInteger)destinationVersion;

@end
