//
//  CDMMigrationController.h
//

#import <Foundation/Foundation.h>
#import "CDMTypes.h"

@class CDMDataController;

typedef void (^MigrateCompletionHandler)(CDMDataController *dataController);

@interface CDMMigrationController : NSObject

- (void)setupWithCompletionHandler:(VoidHandler)completionHandler;
- (void)migrateWithCompletionHandler:(MigrateCompletionHandler)completionHandler;

@end
