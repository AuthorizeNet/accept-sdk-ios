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

        XCTAssertFalse(request.isValidType(), "Type cann't be empty and should initialize to TOKEN")
    }

    func testValidateTypeReturnsTrueWhenValidString() {
        let request = WebCheckOutDataType()
        
        XCTAssertTrue(request.isValidType(), "Type cann't be empty and should initialize to TOKEN")
    }
    
    func testValidateIdReturnsFalseWhenEmptyString() {
        let request = WebCheckOutDataType()
        request.id = ""
        
        XCTAssertFalse(request.isValidId(), "Id cann't be empty")
    }

    func testTypeInitializesToUUIDString() {
        let request = WebCheckOutDataType()
        
        XCTAssertEqual(request.id, UIDevice.current.identifierForVendor!.uuidString, "Id is not initialized to TOKEN")
    }

    func testValidateIdReturnsFalseWhenCharactersGreaterThan64() {
        let request = WebCheckOutDataType()
        request.id = "some really really long name whose length is more than sixty four characters which required to validate"
        
        XCTAssertFalse(request.isValidId(), "Id cann't be more than 64 characters")
    }

    func testValidateIdReturnsTrueWhenValidString() {
        let request = WebCheckOutDataType()
        request.id = UIDevice.current.identifierForVendor!.uuidString
        
        XCTAssertTrue(request.isValidId(), "Id cann't be empty")
    }
    
    func testWebCheckOutDataTypeValidation() {
        let request = WebCheckOutDataType()
        request.token.cardNumber = "378282246310005"
        request.token.cardCode = "123"
        request.token.expirationMonth = "11"
        request.token.expirationYear = "2023"

        let exp = expectation(description: "WebCheckOutDataType validation failed")
        
        request.validate({ (isSuccess) -> () in
            XCTAssertTrue(isSuccess)
            
            exp.fulfill()
            }, failureHandler: {_ in
                
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testWebCheckOutDataTypeValidationErrorCodeE_WC_04() {
        let request = WebCheckOutDataType()
        request.type = ""
        request.token = self.getValidTokenRequest()
        
        let exp = expectation(description: "WebCheckOutDataType validation failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_04", "Type Error code mapping is wrong")
                XCTAssertEqual(errorText, "Invalid type", "Type Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testWebCheckOutDataIdValidationErrorCodeE_WC_04() {
        let request = WebCheckOutDataType()
        request.id = ""
        request.token = self.getValidTokenRequest()
        
        let exp = expectation(description: "WebCheckOutDataType validation failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_04", "Type Error code mapping is wrong")
                XCTAssertEqual(errorText, "Invalid id", "Type Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func getValidTokenRequest() -> Token {
        let tokenRequest = Token()
        
        tokenRequest.cardNumber = "378282246310005"
        tokenRequest.cardCode = "123"
        tokenRequest.expirationMonth = "11"
        tokenRequest.expirationYear = "2023"
        
        return tokenRequest
    }
}
