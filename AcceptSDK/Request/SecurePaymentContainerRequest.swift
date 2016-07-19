//
//  SecurePaymentContainerRequest.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/16/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

public enum WebCheckOutTypeEnum: String {
    case kPAN       = "PAN"
    case kToken     = "TOKEN"
}

public class SecurePaymentContainerRequest {
    public var webCheckOutDataType:WebCheckOutDataType = WebCheckOutDataType()
    
    func validate(request: SecurePaymentContainerRequest, successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {
        self.webCheckOutDataType.validate(request.webCheckOutDataType, successHandler: successHandler, failureHandler: failureHandler)
    }
}

public class WebCheckOutDataType {
    var type = WebCheckOutTypeEnum.kToken.rawValue
    var id = UIDevice.currentDevice().identifierForVendor!.UUIDString
    public var token:Token = Token()
    
    func validate(request: WebCheckOutDataType, successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {
        
        if isValidType(self.type) {
            if (isValidId(self.id)) {
                self.token.validate(self.token, successHandler:{ (isSuccess) -> () in
                    successHandler(isSuccess: true)
                    }, failureHandler: failureHandler)
            } else {
                failureHandler(withResponse: self.getSDKErrorResponse("EC_WC_1002", message: "Invalid id"))
            }
        } else {
            failureHandler(withResponse: self.getSDKErrorResponse("EC_WC_1001", message: "Invalid type"))
        }
        
    }
    
    func isValidType(type:String) -> Bool {
        var isValid = false
        
        if self.type.characters.count > 0 {
            isValid = true
        }
        
        return isValid
    }
    
    func isValidId(inId:String) -> Bool {
        var isValid = false
        
        if self.id.characters.count >= 1  && self.id.characters.count <= 64 {
            isValid = true
        }
        
        return isValid
    }
    
    func getSDKErrorResponse(withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }
}

public class Token {
    public var cardNumber:String = String()
//    public var expirationDate:String = String()
    public var expirationMonth = String()
    public var expirationYear = String()
    public var cardCode:String?
    public var zip:String?
    public var fullName:String?

    func validate(request: Token, successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {
        if isValidCardNumber(self.cardNumber) {
            if isValidExpirationMonth(self.expirationMonth) {
                if isValidExpirationYear(self.expirationYear) {
                    if isValidExpirationDate(self.expirationMonth, inYear: self.expirationYear) {
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
                            successHandler(isSuccess: true)
                        } else {
                            failureHandler(withResponse: errorResponse!)
                        }
                    } else {
                        failureHandler(withResponse: self.getSDKErrorResponse("E_WC_08", message: "Expiration date must be in the future."))
                    }
                } else {
                    failureHandler(withResponse: self.getSDKErrorResponse("E_WC_07", message: "Please provide valid expiration year."))
                }
            } else {
                failureHandler(withResponse: self.getSDKErrorResponse("E_WC_06", message: "Please provide valid expiration month."))
            }
        } else {
            failureHandler(withResponse: self.getSDKErrorResponse("E_WC_05", message: "Please provide valid credit card number."))
        }
    }
    
    func isValidCardNumber(inNumber:String) -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()

        if inNumber.characters.count >= 4 &&  inNumber.characters.count <= 16 && validator.validateCardWithLuhnAlgorithm(self.cardNumber){
            isValid = true
        }
        
        return isValid
    }
    
    func isValidExpirationMonth(inMonthStr:String) -> Bool {
        
        if (self.expirationMonth.characters.count == 1)
        {
            if ((self.expirationMonth == "0") == false) {
                self.expirationMonth = "0".stringByAppendingString(self.expirationMonth)
            }
        }

        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()
        
        if inMonthStr.characters.count >= 1 &&  inMonthStr.characters.count <= 2 && validator.validateMonthWithString(inMonthStr) {
            isValid = true
        }
        
        return isValid
    }

    func isValidExpirationYear(inYearStr:String) -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()
        
        if validator.validateYearWithString(inYearStr) {
            isValid = true
        }
        
        return isValid
    }

    func isValidExpirationDate(inMonth: String, inYear:String) -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()

        if /*inDateStr.characters.count >= 4 &&  inDateStr.characters.count <= 7 && */validator.validateExpirationDate(inMonth, inYear:inYear) {
            isValid = true
        }
        
        return isValid
    }

    func isValidZip(inZip:String) -> Bool {
        var isValid = false
        
        if inZip.characters.count >= 1 &&  inZip.characters.count <= 20 {
            isValid = true
        }
        
        return isValid
    }

    func isValidFullName(inFullName:String) -> Bool {
        var isValid = false
        
        if inFullName.characters.count >= 1 &&  inFullName.characters.count <= 64 {
            isValid = true
        }
        
        return isValid
    }
    
    func isValidCardCode(inCardCode:String) -> Bool {
        var isValid = false
        let validator = AcceptSDKCardFieldsValidator()

        if validator.validateSecurityCodeWithString(inCardCode) {
            isValid = true
        }
        
        return isValid
    }
    
    func getSDKErrorResponse(withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }
}