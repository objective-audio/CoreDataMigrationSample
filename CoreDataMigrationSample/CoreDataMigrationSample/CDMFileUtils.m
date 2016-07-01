//
//  CDMFileUtils.m
//

#import "CDMFileUtils.h"
#import "CDMTypes.h"

@implementation CDMFileUtils

+ (NSURL *)sourceStoreURL {
    NSString *storePath =
        [[[self class] documentDirectoryPath] stringByAppendingPathComponent:CDMCoreDataSourceStoreFileName];
    return [[NSURL alloc] initFileURLWithPath:storePath];
}

+ (NSURL *)destinationStoreURL {
    NSString *storePath =
        [[[self class] documentDirectoryPath] stringByAppendingPathComponent:CDMCoreDataDestinationStoreFileName];
    return [[NSURL alloc] initFileURLWithPath:storePath];
}

+ (NSString *)documentDirectoryPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

+ (void)removeDocumentDirectoryContents {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *documentDirectoryPath = [self documentDirectoryPath];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentDirectoryPath error:nil];
    for (NSString *content in contents) {
        NSString *path = [documentDirectoryPath stringByAppendingPathComponent:content];
        [fileManager removeItemAtPath:path error:nil];
    }
}

+ (BOOL)moveFileFromURL:(NSURL *)fromURL toURL:(NSURL *)toURL {
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    if ([fileManager fileExistsAtPath:[toURL path]]) {
        if (![fileManager removeItemAtURL:toURL error:nil]) {
            return NO;
        }
    }

    return [fileManager moveItemAtURL:fromURL toURL:toURL error:nil];
}

+ (NSManagedObjectModel *)modelWithName:(NSString *)name version:(NSUInteger)version {
    NSString *versionString = version < 1 ? @"" : [[NSString alloc] initWithFormat:@" %@", @(version)];

    NSURL *modelURL =
        [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@.momd/%@%@", name, name, versionString]
                                withExtension:@"mom"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

+ (NSMappingModel *)mappingModelWithName:(NSString *)name
                           sourceVersion:(NSUInteger)sourceVersion
                      destinationVersion:(NSUInteger)destinationVersion {
    NSURL *mappingModelURL = [[NSBundle mainBundle]
        URLForResource:[NSString stringWithFormat:@"%@%@-%@", name, @(sourceVersion), @(destinationVersion)]
         withExtension:@"cdm"];

    return [[NSMappingModel alloc] initWithContentsOfURL:mappingModelURL];
}

@end
