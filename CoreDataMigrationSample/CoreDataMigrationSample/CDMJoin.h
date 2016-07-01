//
//  CDMJoin.h
//

#import <Foundation/Foundation.h>
#import "CDMTypes.h"

@interface CDMJoin : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCount:(NSUInteger)count joinedHandler:(VoidHandler)completionHandler;

- (void)setFlag:(NSUInteger)flag;

@end
