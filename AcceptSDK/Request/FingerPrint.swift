//
//  FingerPrint.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/16/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

public class FingerPrint {
    public var hashValue:String = String()
    public var sequence:String = String()
    public var timestamp:String = String()
    public var currencyCode:String?
    public var amount:String = String()

    public init?(inHashValue: String, inSequence: String, inTimestamp: String, inCurrencyCode: String?, inAmount: String?) {
//        guard inHashValue.characters.count > 0 else {return nil}
//        guard inTimestamp.characters.count > 0 else {return nil}
        
        self.hashValue = inHashValue
        self.timestamp = inTimestamp
        self.sequence = inSequence
        if let unwrappedCurrencyCode = inCurrencyCode {
            self.currencyCode = unwrappedCurrencyCode
        }
        if let unwrappedAmount = inAmount {
            self.amount = unwrappedAmount
        }
    }
    
    func validate(successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {

        if self.hashValue.isEmpty == false {
            if isValidTimestamp() {
                if self.sequence.isEmpty == false {
                    if self.isValidAmount() {
                        successHandler(isSuccess: true)
                    } else {
                        failureHandler(withResponse: self.getSDKErrorResponse("E_WC_13", message: "Invalid Fingerprint."))
                    }
                } else {
                    failureHandler(withResponse: self.getSDKErrorResponse("E_WC_12", message: "Sequence attribute should not be blank."))
                }
            } else {
                failureHandler(withResponse: self.getSDKErrorResponse("E_WC_11", message: "Please provide valid timestamp in utc."))
            }
        } else {
            failureHandler(withResponse: self.getSDKErrorResponse("E_WC_09", message: "Fingerprint hash should not be blank."))
        }
    }
    
    func isValidTimestamp() -> Bool {
        var isValid = false
        
        if ((self.timestamp.characters.count > 0) && AcceptSDKStringValidator.isAlphanumeric(self.timestamp) == false) && (AcceptSDKStringValidator.isStringIsNegativeNumber(self.timestamp) == false) && (AcceptSDKStringValidator.isStringContainsDecimalCharacter(self.timestamp) == false) {
            isValid = true
        }
        
        return isValid
    }
    
    func isValidAmount() -> Bool {
        var isValid = false
        
        /*
        if let indexForCharacterInString = inAmount.characters.indexOf(".") {
            let subStr = inAmount.substringFromIndex(indexForCharacterInString)
            
            if (subStr.characters.count - 1) == 2{
                isValid = true
            }
        }
        */
        
        let amt = Double(self.amount)
        if AcceptSDKStringValidator.isAlphanumeric(self.amount) == false && amt > 0 {
            isValid = true
        }

        return isValid
    }
    
    
    func getSDKErrorResponse(withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }
}