//
//  HomeAwayTests.swift
//  HomeAwayTests
//
//  Created by Nex on 9/25/19.
//  Copyright © 2019 nsn. All rights reserved.
//

import XCTest
@testable import HomeAway

class HomeAwayTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
//    func test1() {
//        let app = XCUIApplication()
//        let table =  app.tables.element(boundBy: 0)
//    }
//
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
