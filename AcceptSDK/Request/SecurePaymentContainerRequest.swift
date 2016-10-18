//
//  SecurePaymentContainerRequest.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/16/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation
import UIKit

enum WebCheckOutTypeEnum: String {
    //case kPAN       = "PAN"
    case kToken     = "TOKEN"
}

open class SecurePaymentContainerRequest {
    open var webCheckOutDataType:WebCheckOutDataType = WebCheckOutDataType()
    
    func validate(_ successHandler:@escaping (_ isSuccess:Bool)->(),failureHandler:(_ withResponse:AcceptSDKErrorResponse)->()) {
        self.webCheckOutDataType.validate(successHandler, failureHandler: failureHandler)
    }
}

open class WebCheckOutDataType {
    var type = WebCheckOutTypeEnum.kToken.rawValue
    var id = UIDevice.current.identifierForVendor!.uuidString
    open var token:Token = Token()
    
    func validate(_ successHandler:@escaping (_ isSuccess:Bool)->(),failureHandler:(_ withResponse:AcceptSDKErrorResponse)->()) {
        
        if isValidType() {
            if (isValidId()) {
                self.token.validate({ (isSuccess) -> () in
                    successHandler(true)
                    }, failureHandler: failureHandler)
            } else {
                failureHandler(self.getSDKErrorResponse("E_WC_04", message: "Invalid id"))
            }
        } else {
            failureHandler(self.getSDKErrorResponse("E_WC_04", message: "Invalid type"))
            return
        }
        
    }
    
    func isValidType() -> Bool {
        var isValid = false
        
        if self.type.characters.count > 0 {
            isValid = true
        }
        
        return isValid
    }
    
    func isValidId() -> Bool {
        var isValid = false
        
        if self.id.characters.count >= 1  && self.id.characters.count <= 64 {
            isValid = true
        }
        
        return isValid
    }
    
    func getSDKErrorResponse(_ withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }
}

open class Token {
    open var cardNumber:String = String()
//    public var expirationDate:String = String()
    open var expirationMonth = String()
    open var expirationYear = String()
    open var cardCode:String?
    open var zip:String?
    open var fullName:String?

    func validate(_ successHandler:(_ isSuccess:Bool)->(),failureHandler:(_ withResponse:AcceptSDKErrorResponse)->()) {
        if isValidCardNumber() {
            if isValidExpirationMonth() {
                if isValidExpirationYear() {
                    if isValidExpirationDate() {
                        var intermediateResult = true
                        var errorResponse:AcceptSDKErrorResponse?
                        
                        if let zipCode = self.zip {
                            if isValidZip(zipCode) {
                            } else {
                                intermediateResult = false
                                errorResponse = self.getSDKErrorResponse("E_WC_16", message: "Please provide valid Zip code.")
                            }
                        }
                        if let fName = self.fullName {
                            if isValidFullName(fName) {
                            } else {
                                intermediateResult = false
                                errorResponse = self.getSDKErrorResponse("E_WC_17", message: "Please provide valid card holder name.")
                            }
                        }
                        if let code = self.cardCode {
                            if isValidCardCode(code) {
                            } else {
                                intermediateResult = false
                                errorResponse = self.getSDKErrorResponse("E_WC_15", message: "Please provide valid CVV.")
                            }
                        }
                        
                        if intermediateResult {
                            successHandler(true)
                        } else {
                            failureHandler(errorResponse!)
                        }
                    } else {
                        failureHandler(self.getSDKErrorResponse("E_WC_08", message: "Expiration date must be in the future."))
                    }
                } else {
                    failureHandler(self.getSDKErrorResponse("E_WC_07", message: "Please provide valid expiration year."))
                }
            } else {
                failureHandler(self.getSDKErrorResponse("E_WC_06", message: "Please provide valid expiration month."))
            }
        } else {
            failureHandler(self.getSDKErrorResponse("E_WC_05", message: "Please provide valid credit card number."))
        }
    }
    
    func isValidCardNumber() -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()

        if ((AcceptSDKStringValidator.isAlphanumeric(self.cardNumber) == false) && (AcceptSDKStringValidator.isStringContainsDecimalCharacter(self.cardNumber) == false) && (AcceptSDKStringValidator.isStringIsNegativeNumber(self.cardNumber) == false) && self.cardNumber.characters.count >= 4 &&  self.cardNumber.characters.count <= 16 && validator.validateCardWithLuhnAlgorithm(self.cardNumber)) {
            isValid = true
        }
        
        return isValid
    }
    
    func isValidExpirationMonth() -> Bool {
        
        if (self.expirationMonth.characters.count == 1)
        {
            if ((self.expirationMonth == "0") == false) {
                self.expirationMonth = "0" + self.expirationMonth
            }
        }

        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()
        
        if self.expirationMonth.characters.count >= 1 &&  self.expirationMonth.characters.count <= 2 && validator.validateMonthWithString(self.expirationMonth) {
            isValid = true
        }
        
        return isValid
    }

    func isValidExpirationYear() -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()
        
        if validator.validateYearWithString(self.expirationYear) {
            isValid = true
        }
        
        return isValid
    }

    func isValidExpirationDate() -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()

        if /*inDateStr.characters.count >= 4 &&  inDateStr.characters.count <= 7 && */validator.validateExpirationDate(self.expirationMonth, inYear:self.expirationYear) {
            isValid = true
        }
        
        return isValid
    }

    func isValidZip(_ inZip:String) -> Bool {
        var isValid = false
        
        if inZip.characters.count >= 1 && inZip.characters.count <= 20 && (AcceptSDKStringValidator.isStringContainsOnlySpaces(inZip) == false) && (AcceptSDKStringValidator.isStringContainsSpaceAtBeginningAndEnd(inZip) == false) {
            isValid = true
        }
        
        return isValid
    }

    func isValidFullName(_ inFullName:String) -> Bool {
        var isValid = false
        
        if inFullName.characters.count >= 1 && inFullName.characters.count <= 64 && (AcceptSDKStringValidator.isStringContainsOnlySpaces(inFullName) == false) {
            isValid = true
        }
        
        return isValid
    }
    
    func isValidCardCode(_ inCardCode:String) -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()

        if validator.validateSecurityCodeWithString(inCardCode) {
            isValid = true
        }
        
        return isValid
    }
    
    func getSDKErrorResponse(_ withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }
    
}
