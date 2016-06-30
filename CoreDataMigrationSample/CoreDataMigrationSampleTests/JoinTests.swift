//
//  JoinTests.swift
//

import XCTest
@testable import CoreDataMigrationSample

class JoinTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        var called: Bool = false
        
        let join = Join.init(count: 2) {
            called = true
        }
        
        XCTAssertFalse(called)
        
        join.setFlag(0)
        
        XCTAssertFalse(called)
        
        join.setFlag(0)
        
        XCTAssertFalse(called);
        
        join.setFlag(2)
        
        XCTAssertFalse(called);
        
        join.setFlag(1)
        
        XCTAssertTrue(called);
    }
}
