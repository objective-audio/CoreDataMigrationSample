//
//  CDMDataController.h
//

#import <Foundation/Foundation.h>
#import "UBICoreData.h"

@interface CDMDataController : NSObject

@property (nonatomic, readonly) UBICoreDataStore *dataStore;
@property (nonatomic, readonly) NSDictionary<NSString *, id> *metadata;
@property (nonatomic) CFTimeInterval migrationTime;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithStoreURL:(NSURL *)storeURL;

- (NSUInteger)entityCount;
- (NSString *)entityNameAtIndex:(NSUInteger)index;

@end
