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
    public var sequence:String?
    public var timestamp:String = String()
    public var currencyCode:String?
    public var amount:String?

    public init?(inHashValue: String, inSequence: String?, inTimestamp: String, inCurrencyCode: String?, inAmount: String?) {
//        guard inHashValue.characters.count > 0 else {return nil}
//        guard inTimestamp.characters.count > 0 else {return nil}
        
        self.hashValue = inHashValue
        self.timestamp = inTimestamp
        if let unwrappedSequence = inSequence {
            self.sequence = unwrappedSequence
        }
        if let unwrappedCurrencyCode = inCurrencyCode {
            self.currencyCode = unwrappedCurrencyCode
        }
        if let unwrappedAmount = inAmount {
            self.amount = unwrappedAmount
        }
    }
    
    func validate(fingerPrint: FingerPrint, successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {

        if self.hashValue.isEmpty == false {
            if self.timestamp.isEmpty == false {
                successHandler(isSuccess: true)
            } else {
                failureHandler(withResponse: self.getSDKErrorResponse("E_WC_11", message: "Please provide valid timestamp in utc."))
            }
        } else {
            failureHandler(withResponse: self.getSDKErrorResponse("E_WC_09", message: "Fingerprint hash should not be blank."))
        }
    }
    
    func getSDKErrorResponse(withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }
}