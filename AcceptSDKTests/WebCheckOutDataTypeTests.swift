//
//  WebCheckOutDataTypeTests.swift
//  AcceptSDK
//
//  Created by MMA on 7/20/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import XCTest

class WebCheckOutDataTypeTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testTypeInitializesToTokenString() {
        let request = WebCheckOutDataType()

        XCTAssertEqual(request.type, WebCheckOutTypeEnum.kToken.rawValue, "Type is not initialized to TOKEN")
    }
    
    func testValidateTypeReturnsFalseWhenEmptyString() {
        let request = WebCheckOutDataType()
        request.type = ""

        XCTAssertFalse(request.isValidType(request.type), "Type cann't be empty and should initialize to TOKEN")
    }

    func testValidateTypeReturnsTrueWhenValidString() {
        let request = WebCheckOutDataType()
        
        XCTAssertTrue(request.isValidType(request.type), "Type cann't be empty and should initialize to TOKEN")
    }
    
    func testValidateIdReturnsFalseWhenEmptyString() {
        let request = WebCheckOutDataType()
        request.id = ""
        
        XCTAssertFalse(request.isValidId(request.id), "Id cann't be empty")
    }

    func testTypeInitializesToUUIDString() {
        let request = WebCheckOutDataType()
        
        XCTAssertEqual(request.id, UIDevice.currentDevice().identifierForVendor!.UUIDString, "Id is not initialized to TOKEN")
    }

    func testValidateIdReturnsFalseWhenCharactersGreaterThan64() {
        let request = WebCheckOutDataType()
        request.id = "some really really long name whose length is more than sixty four characters which required to validate"
        
        XCTAssertFalse(request.isValidId(request.id), "Id cann't be more than 64 characters")
    }

    func testValidateIdReturnsTrueWhenValidString() {
        let request = WebCheckOutDataType()
        request.id = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        XCTAssertTrue(request.isValidId(request.id), "Id cann't be empty")
    }
}
