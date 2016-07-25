//
//  TokenDataTests.swift
//  AcceptSDKTests
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/15/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation
import XCTest

class TokenDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
    }
    
    func testCreditCardValidationFailsWhenEmpty() {
        let request = Token()
        request.cardNumber = ""
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid, "Should return false when card number is empty")
    }
    
    func testCreditCardValidationFailsWhenContainsAlphaNumeric() {
        let request = Token()
        request.cardNumber = "a67675"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid, "Card number should not be alpa numeric")
    }
    
    func testCreditCardValidationFailsWhenContainsNegativeNunber() {
        let request = Token()
        request.cardNumber = "-9989"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid, "Card number should not be a negative")
    }

    func testCreditCardValidationFailsWhenContainsDecimal() {
        let request = Token()
        request.cardNumber = "1908.8"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid, "Card number should not contain decimal places")
    }

    func testCreditCardValidationFailsWhenLessThan4Characters() {
        let request = Token()
        request.cardNumber = "234"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid)
    }
    
    func testCreditCardValidationFailsWhenGreaterThan4AndLessThan16Characters() {
        let request = Token()
        request.cardNumber = "234787"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid)
    }
    
    func testCreditCardValidationFailsWhenLuhnAlgorithmFails() {
        let request = Token()
        request.cardNumber = "1234567891234567"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid, "testCreditCardValidationFailsWhenLuhnAlgorithmFails fails")
    }
    
    func testCreditCardValidationFailsWhenContainsSpaces() {
        let request = Token()
        request.cardNumber = "1123 135 345 123"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertFalse(isValid, "testCreditCardValidationFailsWhenLuhnAlgorithmFails fails")
    }
    
    func testCreditCardValidationSuccess() {
        let request = Token()
        request.cardNumber = "378282246310005"
        
        let isValid = request.isValidCardNumber(request.cardNumber)
        XCTAssertTrue(isValid, "testCreditCardValidationSuccess fails")
    }
    
    func testValidateExpirationMonthFailsWhenNumberOfCharactersIsMoreThan2() {
        let request = Token()
        request.expirationMonth = "122"
        
        XCTAssertFalse(request.isValidExpirationMonth(request.expirationMonth), "testExpirationMonthFailsWhenNumberOfCharactersIsMoreThan2 fails")
    }
    
    func testValidateExpirationMonthReturnsTruesWhenNumberOfCharactersIs1() {
        let request = Token()
        request.expirationMonth = "1"
        
        XCTAssertTrue(request.isValidExpirationMonth(request.expirationMonth), "testValidateExpirationMonthReturnsTruesWhenNumberOfCharactersIs1 fails")
    }
    
    func testValidateExpirationMonthReturnsFalseWhenMonthLessThan1() {
        let request = Token()
        request.expirationMonth = "0"
        
        XCTAssertFalse(request.isValidExpirationMonth(request.expirationMonth), "testValidateExpirationMonthReturnsFalseWhenMonthLessThan1 fails")
    }
    
    func testValidateExpirationMonthReturnFalseWhenMonthGreaterThan12() {
        let request = Token()
        request.expirationMonth = "15"
        
        XCTAssertFalse(request.isValidExpirationMonth(request.expirationMonth), "testValidateExpirationMonthReturnFalseWhenMonthGreaterThan12 fails")
    }
    
    func testValidateExpirationMonthReturnsTrueWhenNumberOfCharactersIs2() {
        let request = Token()
        request.expirationMonth = "11"
        
        XCTAssertTrue(request.isValidExpirationMonth(request.expirationMonth), "testValidateExpirationMonthReturnsTrueWhenNumberOfCharactersIs2 fails")
    }
    
    func testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsLessThan2() {
        let request = Token()
        request.expirationYear = "5"
        
        XCTAssertFalse(request.isValidExpirationYear(request.expirationMonth), "testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsLessThan2 fails")
    }
    
    func testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsGreaterThan4() {
        let request = Token()
        request.expirationYear = "53453"
        
        XCTAssertFalse(request.isValidExpirationYear(request.expirationMonth), "testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsGreaterThan4 fails")
    }
    
    func testValidateExpirationYearReturnsFalseWhenNotNumber() {
        let request = Token()
        request.expirationYear = "abcd"
        
        XCTAssertFalse(request.isValidExpirationYear(request.expirationMonth), "testValidateExpirationYearReturnsFalseWhenNotNumber fails")
    }
    
    func testValidateExpirationMonthReturnsTrueWhenValidYearWith4Characters() {
        let request = Token()
        request.expirationYear = "2028"
        
        XCTAssertTrue(request.isValidExpirationYear(request.expirationYear), "testValidateExpirationMonthReturnsTrueWhenValidYearWith2Characters fails")
    }

    func testValidateExpirationMonthReturnsTrueWhenValidYearWith2Characters() {
        let request = Token()
        request.expirationYear = "28"
        
        XCTAssertTrue(request.isValidExpirationYear(request.expirationYear), "testValidateExpirationMonthReturnsTrueWhenValidYearWith2Characters fails")
    }
    
    func testValidateExpirationDateReturnsFalseWhenYearExpired() {
        let request = Token()
        request.expirationYear = "1990"
        request.expirationMonth = "11"

        XCTAssertFalse(request.isValidExpirationDate(request.expirationMonth, inYear: request.expirationYear), "testValidateExpirationDateReturnsFalseWhenYearExpired fails")
    }
    
    func testValidateExpirationDateReturnsTrueWhenForFutureExpirationDate() {
        let request = Token()
        request.expirationYear = "2020"
        request.expirationMonth = "11"
        
        XCTAssertTrue(request.isValidExpirationDate(request.expirationMonth, inYear: request.expirationYear), "testValidateExpirationDateReturnsTrueWhenForFutureExpirationDate fails")
    }
    
    func testValidateZipReturnsFalseWhenEmptyString() {
        let request = Token()
        request.zip = ""

        XCTAssertFalse(request.isValidZip(request.zip!), "testValidateZipReturnsFalseWhenEmptyString fails")
    }
    
    func testValidateZipReturnsFalseWhenOnlySpacesString() {
        let request = Token()
        request.zip = "    "
        
        XCTAssertFalse(request.isValidZip(request.zip!), "Zip code has only spaces")
    }

    func testValidateZipReturnsFalseWhenStartWithSpace() {
        let request = Token()
        request.zip = " dhjqwhdjqwd"
        
        XCTAssertFalse(request.isValidZip(request.zip!), "Zip code cann't start with spaces")
    }
    
    func testValidateZipReturnsFalseWhenEndsWithSpace() {
        let request = Token()
        request.zip = "4563 "
        
        XCTAssertFalse(request.isValidZip(request.zip!), "Zip code cann't end with spaces")
    }

    func testValidateZipReturnsFalseWhenNumberOfCharactersGreaterThan20() {
        let request = Token()
        request.zip = "z7676777786767678678678678"
        
        XCTAssertFalse(request.isValidZip(request.zip!), "testValidateZipReturnsFalseWhenNumberOfCharactersGreaterThan20 fails")
    }
    
    func testValidateZipReturnsTrueWhenZipIsValid() {
        let request = Token()
        request.zip = "560085"
        
        XCTAssertTrue(request.isValidZip(request.zip!), "testValidateZipReturnsTrueWhenZipIsValid fails")
    }
    
    func testValidateFullNameReturnsFalseWhenEmptyString() {
        let request = Token()
        request.fullName = ""
        
        XCTAssertFalse(request.isValidFullName(request.fullName!), "testValidateFullNameReturnsFalseWhenEmptyString fails")
    }
    
    func testValidateFullNameReturnsFalseWhenOnlySpacesString() {
        let request = Token()
        request.fullName = "   "
        
        XCTAssertFalse(request.isValidFullName(request.fullName!), "Full name contains only spaces")
    }
    
    func testValidateFullNameReturnsFalseWhenNumberOfCharactersGreaterThan64() {
        let request = Token()
        request.fullName = "some really really long name whose length is more than sixty four characters which required to validate"
        
        XCTAssertFalse(request.isValidFullName(request.fullName!), "testValidateFullNameReturnsFalseWhenNumberOfCharactersGreaterThan64 fails")
    }
    
    func testValidateFullNameReturnsTrueWhenValidName() {
        let request = Token()
        request.fullName = "john doe"
        
        XCTAssertTrue(request.isValidFullName(request.fullName!), "testValidateFullNameReturnsTrueWhenValidName fails")
    }
    
    func testValidateCardCodeReturnsFalseWhenEmptyString() {
        let request = Token()
        request.cardCode = ""
        
        XCTAssertFalse(request.isValidCardCode(request.cardCode!), "testValidateCardCodeReturnsFalseWhenEmptyString fails")
    }
    
    func testValidateCardCodeReturnsFalseWhenMinimumCharactersLessThan3() {
        let request = Token()
        request.cardCode = "12"
        
        XCTAssertFalse(request.isValidCardCode(request.cardCode!), "testValidateCardCodeReturnsFalseWhenMinimumCharactersLessThan3 fails")
    }
    
    func testValidateCardCodeReturnsFalseWhenMinimumCharactersGreaterThan4() {
        let request = Token()
        request.cardCode = "12345"
        
        XCTAssertFalse(request.isValidCardCode(request.cardCode!), "testValidateCardCodeReturnsFalseWhenMinimumCharactersGreaterThan4 fails")
    }
    
    func testValidateCardCodeReturnsTrueWhenMinimumCharactersEqualTo3() {
        let request = Token()
        request.cardCode = "123"
        
        XCTAssertTrue(request.isValidCardCode(request.cardCode!), "testValidateCardCodeReturnsTrueWhenMinimumCharactersEqualTo3 fails")
    }
    
    func testValidateCardCodeReturnsTrueWhenMinimumCharactersEqualTo4() {
        let request = Token()
        request.cardCode = "1234"
        
        XCTAssertTrue(request.isValidCardCode(request.cardCode!), "testValidateCardCodeReturnsTrueWhenMinimumCharactersEqualTo4 fails")
    }
 
    func testTokenValidationErrorCodeE_WC_05() {
        let request = self.getValidTokenRequest()
        request.cardNumber = "671"
        
        let expectation = expectationWithDescription("Card Number error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_05", "Card number Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid credit card number.", "Card number Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testTokenValidationErrorCodeE_WC_06() {
        let request = self.getValidTokenRequest()
        request.expirationMonth = "21"
        
        let expectation = expectationWithDescription("Expiration month error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_06", "Expiration month Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid expiration month.", "Expiration month Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testTokenValidationErrorCodeE_WC_07() {
        let request = self.getValidTokenRequest()
        request.expirationYear = "29088"
        
        let expectation = expectationWithDescription("Expiration year error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_07", "Expiration year Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid expiration year.", "Expiration year Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testTokenValidationErrorCodeE_WC_08() {
        let request = self.getValidTokenRequest()
        request.expirationYear = "1999"
        request.expirationMonth = "11"
        
        let expectation = expectationWithDescription("Expiration date error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_08", "Expiration date Error code mapping is wrong")
                XCTAssertEqual(errorText, "Expiration date must be in the future.", "Expiration date Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testCardCodeMinLengthValidationErrorCodeE_WC_15() {
        let request = self.getValidTokenRequest()
        request.cardCode = "1"
        let expectation = expectationWithDescription("Card code min length error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_15", "CardCode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid CVV.", "CardCode Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    func testCardCodeMaxLengthValidationErrorCodeE_WC_15() {
        let request = self.getValidTokenRequest()
        request.cardCode = "12345"
        let expectation = expectationWithDescription("Card code max length error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_15", "CardCode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid CVV.", "CardCode Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    func testCardCodeNullValidationErrorCodeE_WC_15() {
        let request = self.getValidTokenRequest()
        request.cardCode = ""
        let expectation = expectationWithDescription("Empty card code error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_15", "CardCode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid CVV.", "CardCode Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testZipcodeNullValidationErrorCodeE_WC_16() {
        let request = self.getValidTokenRequest()
        request.zip = ""
        let expectation = expectationWithDescription("Empty zip code error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_16", "Zipcode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid Zip code.", "Zipcode Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testZipcodeMaxLengthValidationErrorCodeE_WC_16() {
        let request = self.getValidTokenRequest()
        request.zip = "123456789012345678901"
        let expectation = expectationWithDescription("Max length of zip code error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_16", "Zipcode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid Zip code.", "Zipcode Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFullnameLengthValidationErrorCodeE_WC_17() {
        let request = self.getValidTokenRequest()
        request.fullName = "some really really long name whose length is more than sixty four characters which required to validate"
        let expectation = expectationWithDescription("Max length of fullname error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_17", "Fullname Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid card holder name.", "Fullname Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFullnameEmptyStringValidationErrorCodeE_WC_17() {
        let request = self.getValidTokenRequest()
        request.fullName = ""
        let expectation = expectationWithDescription("Empty fullname error mapping failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_17", "Fullname Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid card holder name.", "Fullname Error text mapping is wrong")
                
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testTokenValidationSuccess() {
        let request = getValidTokenRequest()
        
        let expectation = expectationWithDescription("Token validation failed")
        
        request.validate(request, successHandler: { (isSuccess) -> () in
            XCTAssertTrue(isSuccess)
            
            expectation.fulfill()
            }, failureHandler: { (withResponse) -> () in
        })
        
        waitForExpectationsWithTimeout(1) { error in
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
