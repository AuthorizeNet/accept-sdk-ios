//
//  FingerPrint.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/16/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class FingerPrint {
    open var hashValue:String = String()
    open var sequence:String = String()
    open var timestamp:String = String()
    open var currencyCode:String?
    open var amount:String = String()

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
    
    func validate(_ successHandler:(_ isSuccess:Bool)->(),failureHandler:(_ withResponse:AcceptSDKErrorResponse)->()) {

        if self.hashValue.isEmpty == false {
            if isValidTimestamp() {
                if self.sequence.isEmpty == false {
                    if self.isValidAmount() {
                        successHandler(true)
                    } else {
                        failureHandler(self.getSDKErrorResponse("E_WC_13", message: "Invalid Fingerprint."))
                    }
                } else {
                    failureHandler(self.getSDKErrorResponse("E_WC_12", message: "Sequence attribute should not be blank."))
                }
            } else {
                failureHandler(self.getSDKErrorResponse("E_WC_11", message: "Please provide valid timestamp in utc."))
            }
        } else {
            failureHandler(self.getSDKErrorResponse("E_WC_09", message: "Fingerprint hash should not be blank."))
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
    
    
    func getSDKErrorResponse(_ withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }
}
