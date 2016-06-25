//
//  CoreDataMigrationSampleTests.m
//

#import <XCTest/XCTest.h>
#import "CDMJoin.h"

@interface CoreDataMigrationSampleTests : XCTestCase

@end

@implementation CoreDataMigrationSampleTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testJoin {
    __block BOOL called = NO;

    CDMJoin *join = [[CDMJoin alloc] initWithCount:2
                                     joinedHandler:^{
                                         called = YES;
                                     }];

    XCTAssertFalse(called);

    [join setFlag:0];

    XCTAssertFalse(called);

    [join setFlag:0];

    XCTAssertFalse(called);

    [join setFlag:2];

    XCTAssertFalse(called);

    [join setFlag:1];

    XCTAssertTrue(called);
}

@end
