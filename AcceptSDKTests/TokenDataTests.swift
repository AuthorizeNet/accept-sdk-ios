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
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid, "Should return false when card number is empty")
    }
    
    func testCreditCardValidationFailsWhenContainsAlphaNumeric() {
        let request = Token()
        request.cardNumber = "a67675"
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid, "Card number should not be alpa numeric")
    }
    
    func testCreditCardValidationFailsWhenContainsNegativeNunber() {
        let request = Token()
        request.cardNumber = "-9989"
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid, "Card number should not be a negative")
    }

    func testCreditCardValidationFailsWhenContainsDecimal() {
        let request = Token()
        request.cardNumber = "1908.8"
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid, "Card number should not contain decimal places")
    }

    func testCreditCardValidationFailsWhenLessThan4Characters() {
        let request = Token()
        request.cardNumber = "234"
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid)
    }
    
    func testCreditCardValidationFailsWhenGreaterThan4AndLessThan16Characters() {
        let request = Token()
        request.cardNumber = "234787"
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid)
    }
    
    func testCreditCardValidationFailsWhenLuhnAlgorithmFails() {
        let request = Token()
        request.cardNumber = "1234567891234567"
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid, "testCreditCardValidationFailsWhenLuhnAlgorithmFails fails")
    }
    
    func testCreditCardValidationFailsWhenContainsSpaces() {
        let request = Token()
        request.cardNumber = "1123 135 345 123"
        
        let isValid = request.isValidCardNumber()
        XCTAssertFalse(isValid, "testCreditCardValidationFailsWhenLuhnAlgorithmFails fails")
    }
    
    func testCreditCardValidationSuccess() {
        let request = Token()
        request.cardNumber = "378282246310005"
        
        let isValid = request.isValidCardNumber()
        XCTAssertTrue(isValid, "testCreditCardValidationSuccess fails")
    }
    
    func testValidateExpirationMonthFailsWhenNumberOfCharactersIsMoreThan2() {
        let request = Token()
        request.expirationMonth = "122"
        
        XCTAssertFalse(request.isValidExpirationMonth(), "testExpirationMonthFailsWhenNumberOfCharactersIsMoreThan2 fails")
    }
    
    func testValidateExpirationMonthReturnsTruesWhenNumberOfCharactersIs1() {
        let request = Token()
        request.expirationMonth = "1"
        
        XCTAssertTrue(request.isValidExpirationMonth(), "testValidateExpirationMonthReturnsTruesWhenNumberOfCharactersIs1 fails")
    }
    
    func testValidateExpirationMonthReturnsFalseWhenMonthLessThan1() {
        let request = Token()
        request.expirationMonth = "0"
        
        XCTAssertFalse(request.isValidExpirationMonth(), "testValidateExpirationMonthReturnsFalseWhenMonthLessThan1 fails")
    }
    
    func testValidateExpirationMonthReturnFalseWhenMonthGreaterThan12() {
        let request = Token()
        request.expirationMonth = "15"
        
        XCTAssertFalse(request.isValidExpirationMonth(), "testValidateExpirationMonthReturnFalseWhenMonthGreaterThan12 fails")
    }
    
    func testValidateExpirationMonthReturnsTrueWhenNumberOfCharactersIs2() {
        let request = Token()
        request.expirationMonth = "11"
        
        XCTAssertTrue(request.isValidExpirationMonth(), "testValidateExpirationMonthReturnsTrueWhenNumberOfCharactersIs2 fails")
    }
    
    func testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsLessThan2() {
        let request = Token()
        request.expirationYear = "5"
        
        XCTAssertFalse(request.isValidExpirationYear(), "testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsLessThan2 fails")
    }
    
    func testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsGreaterThan4() {
        let request = Token()
        request.expirationYear = "53453"
        
        XCTAssertFalse(request.isValidExpirationYear(), "testValidateExpirationYearReturnsFalseWhenNumberOfCharactersIsGreaterThan4 fails")
    }
    
    func testValidateExpirationYearReturnsFalseWhenNotNumber() {
        let request = Token()
        request.expirationYear = "abcd"
        
        XCTAssertFalse(request.isValidExpirationYear(), "testValidateExpirationYearReturnsFalseWhenNotNumber fails")
    }
    
    func testValidateExpirationMonthReturnsTrueWhenValidYearWith4Characters() {
        let request = Token()
        request.expirationYear = "2028"
        
        XCTAssertTrue(request.isValidExpirationYear(), "testValidateExpirationMonthReturnsTrueWhenValidYearWith2Characters fails")
    }

    func testValidateExpirationMonthReturnsTrueWhenValidYearWith2Characters() {
        let request = Token()
        request.expirationYear = "28"
        
        XCTAssertTrue(request.isValidExpirationYear(), "testValidateExpirationMonthReturnsTrueWhenValidYearWith2Characters fails")
    }
    
    func testValidateExpirationDateReturnsFalseWhenYearExpired() {
        let request = Token()
        request.expirationYear = "1990"
        request.expirationMonth = "11"

        XCTAssertFalse(request.isValidExpirationDate(), "testValidateExpirationDateReturnsFalseWhenYearExpired fails")
    }
    
    func testValidateExpirationDateReturnsTrueWhenForFutureExpirationDate() {
        let request = Token()
        request.expirationYear = "2020"
        request.expirationMonth = "11"
        
        XCTAssertTrue(request.isValidExpirationDate(), "testValidateExpirationDateReturnsTrueWhenForFutureExpirationDate fails")
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
        
        let exp = expectation(description: "Card Number error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_05", "Card number Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid credit card number.", "Card number Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testTokenValidationErrorCodeE_WC_06() {
        let request = self.getValidTokenRequest()
        request.expirationMonth = "21"
        
        let exp = expectation(description: "Expiration month error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_06", "Expiration month Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid expiration month.", "Expiration month Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testTokenValidationErrorCodeE_WC_07() {
        let request = self.getValidTokenRequest()
        request.expirationYear = "29088"
        
        let exp = expectation(description: "Expiration year error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_07", "Expiration year Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid expiration year.", "Expiration year Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testTokenValidationErrorCodeE_WC_08() {
        let request = self.getValidTokenRequest()
        request.expirationYear = "1999"
        request.expirationMonth = "11"
        
        let exp = expectation(description: "Expiration date error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_08", "Expiration date Error code mapping is wrong")
                XCTAssertEqual(errorText, "Expiration date must be in the future.", "Expiration date Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testCardCodeMinLengthValidationErrorCodeE_WC_15() {
        let request = self.getValidTokenRequest()
        request.cardCode = "1"
        let exp = expectation(description: "Card code min length error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_15", "CardCode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid CVV.", "CardCode Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    func testCardCodeMaxLengthValidationErrorCodeE_WC_15() {
        let request = self.getValidTokenRequest()
        request.cardCode = "12345"
        let exp = expectation(description: "Card code max length error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_15", "CardCode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid CVV.", "CardCode Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    func testCardCodeNullValidationErrorCodeE_WC_15() {
        let request = self.getValidTokenRequest()
        request.cardCode = ""
        let exp = expectation(description: "Empty card code error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_15", "CardCode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid CVV.", "CardCode Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testZipcodeNullValidationErrorCodeE_WC_16() {
        let request = self.getValidTokenRequest()
        request.zip = ""
        let exp = expectation(description: "Empty zip code error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_16", "Zipcode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid Zip code.", "Zipcode Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testZipcodeMaxLengthValidationErrorCodeE_WC_16() {
        let request = self.getValidTokenRequest()
        request.zip = "123456789012345678901"
        let exp = expectation(description: "Max length of zip code error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_16", "Zipcode Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid Zip code.", "Zipcode Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFullnameLengthValidationErrorCodeE_WC_17() {
        let request = self.getValidTokenRequest()
        request.fullName = "some really really long name whose length is more than sixty four characters which required to validate"
        let exp = expectation(description: "Max length of fullname error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_17", "Fullname Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid card holder name.", "Fullname Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFullnameEmptyStringValidationErrorCodeE_WC_17() {
        let request = self.getValidTokenRequest()
        request.fullName = ""
        let exp = expectation(description: "Empty fullname error mapping failed")
        
        request.validate({ (isSuccess) -> () in
            }, failureHandler: { (withResponse) -> () in
                let errorCode = withResponse.getMessages().getMessages()[0].getCode()
                let errorText = withResponse.getMessages().getMessages()[0].getText()
                
                XCTAssertEqual(errorCode, "E_WC_17", "Fullname Error code mapping is wrong")
                XCTAssertEqual(errorText, "Please provide valid card holder name.", "Fullname Error text mapping is wrong")
                
                exp.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testTokenValidationSuccess() {
        let request = getValidTokenRequest()
        
        let exp = expectation(description: "Token validation failed")
        
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

    func getValidTokenRequest() -> Token {
        let tokenRequest = Token()
        
        tokenRequest.cardNumber = "378282246310005"
        tokenRequest.cardCode = "123"
        tokenRequest.expirationMonth = "11"
        tokenRequest.expirationYear = "2023"
        
        return tokenRequest
    }
}
