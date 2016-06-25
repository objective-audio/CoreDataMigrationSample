//
//  CDMJoin.m
//

#import "CDMJoin.h"

@interface CDMJoin ()

@property (nonatomic, copy) VoidHandler joinedHandler;
@property (nonatomic) NSUInteger count;
@property (nonatomic) uint32_t flags;
@property (nonatomic) uint32_t compareFlags;

@end

@implementation CDMJoin

- (instancetype)initWithCount:(NSUInteger)count joinedHandler:(VoidHandler)completionHandler {
    self = [super init];
    if (self) {
        assert(completionHandler);
        assert(count <= 32);

        self.joinedHandler = completionHandler;
        self.count = count;
        self.flags = 0;
        self.compareFlags = 0;

        for (NSUInteger i = 0; i < count; i++) {
            self.compareFlags |= 1 << i;
        }
    }
    return self;
}

- (void)setFlag:(NSUInteger)flag {
    assert(flag < 32);

    self.flags |= 1 << flag;

    if ((self.flags & self.compareFlags) == self.compareFlags) {
        self.joinedHandler();
        self.joinedHandler = NULL;
    }
}

@end
