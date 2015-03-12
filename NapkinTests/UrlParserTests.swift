//
//  UrlParserTests.swift
//  Napkin
//
//  Created by Cameron Hotchkies on 3/12/15.
//  Copyright (c) 2015 Srs Biznas. All rights reserved.
//

import Cocoa
import XCTest

class UrlParserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleUrl() {
        var parser = UrlParserImpl(rawUrl: "domain?aaa=bbb")
        
        var arguments = parser.arguments()
        XCTAssertNotNil(arguments, "URL arguments are missing")
        XCTAssertEqual(1, arguments.count, "Incorrect number of arguments")
        
        var arg1 = arguments[0]
        XCTAssertEqual("aaa", arg1["key"]!, "Key value did not match")
        XCTAssertEqual("bbb", arg1["value"]!, "Value value did not match")
    }
    
    func testNonUrl() {
        var parser = UrlParserImpl(rawUrl: "domain-aaa|bbb")
        
        var arguments = parser.arguments()
        XCTAssertNotNil(arguments, "URL arguments should be an empty list")
        XCTAssertEqual(0, arguments.count, "Incorrect number of arguments")
    }
    
    func testEncodedUrl() {
        var parser = UrlParserImpl(rawUrl: "domain?aaa=bbb&cc%2Cc=%5B1%5D")
        
        var arguments = parser.arguments()
        XCTAssertNotNil(arguments, "URL arguments are missing")
        XCTAssertEqual(2, arguments.count, "Incorrect number of arguments")
        
        var arg1 = arguments[0]
        XCTAssertEqual("aaa", arg1["key"]!, "Key value 1 did not match")
        XCTAssertEqual("bbb", arg1["value"]!, "Value value 1 did not match")
        
        var arg2 = arguments[1]
        XCTAssertEqual("cc,c", arg2["key"]!, "Key value 2 did not match")
        XCTAssertEqual("[1]", arg2["value"]!, "Value value 2 did not match")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
