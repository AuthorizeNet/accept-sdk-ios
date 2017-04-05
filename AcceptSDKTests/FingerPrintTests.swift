//
//  FingerPrintTests.swift
//  AcceptSDK
//
//  Created by MMA on 7/20/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import XCTest

class FingerPrintTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmptyTimestampReturnsFalse() {
        let request = getValidFingerprintRequest()
        request.timestamp = ""
        
        XCTAssertFalse(request.isValidTimestamp(), "Timestamp value should not be empty")
    }

    func testAlphaNumericTimestampReturnsFalse() {
        let request = getValidFingerprintRequest()
        request.timestamp = "23473hv232"
        
        XCTAssertFalse(request.isValidTimestamp(), "Timestamp value should contains only numbers")
    }
    
    func testNegativeTimestampReturnsFalse() {
        let request = getValidFingerprintRequest()
        request.timestamp = "-2987665"
        
        XCTAssertFalse(request.isValidTimestamp(), "Timestamp value should not be negative numbers")
    }

    func testFloatingNumberTimestampReturnsFalse() {
        let request = getValidFingerprintRequest()
        request.timestamp = "945.87665"
        
        XCTAssertFalse(request.isValidTimestamp(), "Timestamp value should not contains decimal numbers")
    }

    func testValidTimestampReturnsTrue() {
        let request = getValidFingerprintRequest()
        request.timestamp = "94587665"
        
        XCTAssertTrue(request.isValidTimestamp(), "Timestamp value is not valid")
    }

    func testAmountValidationReturnsFalseWhenNotNumber() {
        let request = getValidFingerprintRequest()
        request.amount = "ghwq"
        
        XCTAssertFalse(request.isValidAmount(), "Amount should be number")
    }

    func testNegativeAmountValidationReturnsFalse() {
        let request = getValidFingerprintRequest()
        request.amount = "-12"
        
        XCTAssertFalse(request.isValidAmount(), "Amount should not be negative")
    }
    
    func testAmountValidationSuccess() {
        let request = getValidFingerprintRequest()
        request.amount = "12.99"
        
        XCTAssertTrue(request.isValidAmount(), "Amount is not a valid number")
    }
    
    func testEmptyHashvalueErrorCodeE_WC_09() {
        let request = self.getValidFingerprintRequest()
        request.fingerPrintHashValue = ""
        
        let exp = expectation(description: "Empty hashvalue error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_09", "Empty hashvalue Error code mapping is wrong")
                XCTAssertEqual(errorText, "Fingerprint hash should not be blank.", "Empty hashvalueError text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testEmptySequenceErrorCodeE_WC_12() {
        let request = self.getValidFingerprintRequest()
        request.sequence = ""
        
        let exp = expectation(description: "Empty sequence error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_12", "Empty sequence Error code mapping is wrong")
                XCTAssertEqual(errorText, "Sequence attribute should not be blank.", "Empty sequence text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testEmptyAmountErrorCodeE_WC_13() {
        let request = self.getValidFingerprintRequest()
        request.amount = ""
        
        let exp = expectation(description: "Empty Amount error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_13", "Empty Amount Error code mapping is wrong")
                XCTAssertEqual(errorText, "Invalid Fingerprint.", "Empty Amount text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testNegativeAmountErrorCodeE_WC_13() {
        let request = self.getValidFingerprintRequest()
        request.amount = "-12"
        
        let exp = expectation(description: "Negative Amount error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_13", "Negative Amount Error code mapping is wrong")
                XCTAssertEqual(errorText, "Invalid Fingerprint.", "Negative Amount text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testNegativeTimestampErrorCodeE_WC_13() {
        let request = self.getValidFingerprintRequest()
        request.timestamp = "-12324424a"
        
        let exp = expectation(description: "Invalid Timestamp error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_11", "Invalid Timestamp Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid timestamp in utc.", "Invalid Timestamp text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testFingerPrintValidationSuccess() {
        let request = getValidFingerprintRequest()
        
        let exp = expectation(description: "FingerPrint validation failed")
        
        request.validate({ (isSuccess) -> () in
            XCTAssertTrue(isSuccess)
            
            exp.fulfill()
            }, failureHandler: { (withResponse) -> () in
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func getValidFingerprintRequest() -> FingerPrint {
        let fingerprintRequest =  FingerPrint(inHashValue: "abcd123",inSequence: "abc",inTimestamp: "123456789",inCurrencyCode: "USD",inAmount: "12.54")
        
        return fingerprintRequest!
    }
}
