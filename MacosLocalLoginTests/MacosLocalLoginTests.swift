//
//  MacosLocalLoginTests.swift
//  MacosLocalLoginTests
//
//  Created by Philip Starner on 11/24/19.
//  Copyright © 2019 Philip Starner. All rights reserved.
//

import XCTest
@testable import MacosLocalLogin

class MacosLocalLoginTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    

    func testCreateUsernamePassword() {
        do {
            try KeychainManager.shared.saveToKeychain(userName: "test", password: "test")
            XCTAssertEqual(true, true, "We've passed testCreateUsernamePassword as no error was thrown")
        } catch {
            //note: running this test without testRemoveUsernamePassword will cause the test to fail as expected
            XCTAssertEqual(true, false, "We've failed testCreateUsernamePassword as error was thrown")
        }
    }
    
    func testLogin() {
        do {
            try KeychainManager.shared.loginFromKeychain(userName: "test", password: "test")
            XCTAssertEqual(true, true, "We've passed testLogin as no error was thrown")
        } catch {
            //note: running this test without testCreateUsernamePassword will cause the test to fail as expected
            XCTAssertEqual(true, false, "We've failed testLogin as error was thrown")
        }
    }
    
    func testRemoveUsernamePassword() {
        //note: removal must be done in same test method to ensure subsequent test pass of creation
        do {
            try KeychainManager.shared.removeFromKeychain()
            XCTAssertEqual(true, true, "We've passed testRemoveUsernamePassword as no error was thrown")
        } catch {
            XCTAssertEqual(true, false, "We've failed testRemoveUsernamePassword as error was thrown")
        }
    }

}
