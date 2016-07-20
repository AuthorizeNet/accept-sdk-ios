//
//  MerchantAuthenticationTests.swift
//  AcceptSDK
//
//  Created by MMA on 7/20/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import XCTest

class MerchantAuthenticationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testValidateNameReturnsFalseWhenEmptyString() {
        let request = getValidMerchantAuthentication()
        request.name = ""
        
        XCTAssertFalse(request.isValidName(request.name!), "Name cann't be empty")
    }
    
    func testValidateNameReturnsFalseWhenLengthGreaterThan25() {
        let request = getValidMerchantAuthentication()
        request.name = "some name with characters count greater than twenty five"
        
        XCTAssertFalse(request.isValidName(request.name!), "Name cann't contain more than 25 characters")
    }
    
    func testValidateNameReturnsTrueWhenValid() {
        let request = getValidMerchantAuthentication()
        request.name = "valid name"
        
        XCTAssertTrue(request.isValidName(request.name!), "Not a valid name")
    }

    func testValidateNameReturnsTrueWhenValidAlphaNumeric() {
        let request = getValidMerchantAuthentication()
        request.name = "ajw12ujhg12"
        
        XCTAssertTrue(request.isValidName(request.name!), "Not a valid name")
    }

    func testValidateMobileDeviceIdReturnsFalseWhenEmptyString() {
        let request = getValidMerchantAuthentication()
        request.mobileDeviceId = ""
        
        XCTAssertFalse(request.isValidMobileDeviceId(request.mobileDeviceId!), "Mobile device id cann't be empty")
    }

    func testValidateMobileDeviceIdReturnsFalseWhenLengthGreaterThan60() {
        let request = getValidMerchantAuthentication()
        request.mobileDeviceId = "hhghdg767sagd-8789sgdhjsadtsagcqwq-jshdasd73-476df-98rhtr-hdgsjks0-936hdsj-8763gdh-dhjshdyt-7463gdhjst"
        
        XCTAssertFalse(request.isValidMobileDeviceId(request.mobileDeviceId!), "Mobile device id cann't contain more than 60 characters")
    }

    func testValidateMobileDeviceIdReturnsTrueWhenValid() {
        let request = getValidMerchantAuthentication()
        request.mobileDeviceId = "h67hgf-hfjjf7-98hdkks-9nnbb"
        
        XCTAssertTrue(request.isValidMobileDeviceId(request.mobileDeviceId!), "Not a valid mobile device id")
    }

    func getValidMerchantAuthentication() -> MerchantAuthenticaton {
        let request = MerchantAuthenticaton()
        request.name = "ValidName"
        request.clientKey = "27gshfgjew87efb"
        request.mobileDeviceId = "fhhyh-dhdu7un-08790jb"
        request.fingerPrint = self.getValidFingerprintRequest()

        return request
    }
    
    func getValidFingerprintRequest() -> FingerPrint {
        let fingerprintRequest =  FingerPrint(inHashValue: "abcd123",inSequence: "abc",inTimestamp: "123456789",inCurrencyCode: "USD",inAmount: "12.54")
        
        return fingerprintRequest!
    }
}
