//
//  MerchantAuthenticaton.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/16/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation


public class MerchantAuthenticaton {
    public var name = String()
    public var fingerPrint:FingerPrint?
    public var clientKey: String?
    public var mobileDeviceId:String?
    
    func validate(successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {
        
        if ((self.clientKey?.isEmpty) == nil && self.fingerPrint == nil) {
            failureHandler(withResponse: self.getSDKErrorResponse("E_WC_18", message: "Client key is required."))
            return
        }
        
        if let key = self.clientKey {
            //todo change this..redundant check
            if key.characters.count > 0 {
                if let errorResponse = self.validateOptionalFileds(self.name, inDeviceId: self.mobileDeviceId) {
                    failureHandler(withResponse: errorResponse)
                } else {
                    successHandler(isSuccess: true)
                }
            }
        } else {
            self.fingerPrint!.validate({ (isSuccess) -> () in
                if let errorResponse = self.validateOptionalFileds(self.name, inDeviceId: self.mobileDeviceId) {
                    failureHandler(withResponse: errorResponse)
                } else {
                    successHandler(isSuccess: true)
                }
            }, failureHandler: failureHandler)
        }
    }
    
    func validateOptionalFileds(inName: String?, inDeviceId: String?) -> AcceptSDKErrorResponse? {
        
        var errorResponse:AcceptSDKErrorResponse?

        if let validName = inName {
            if isValidName(validName) {
            } else {
                errorResponse = self.getSDKErrorResponse("E_WC_10", message: "Please provide valid apiloginid.")
            }
        }
        
        if let deviceId = inDeviceId {
            if isValidMobileDeviceId(deviceId) {
            } else {
                errorResponse = self.getSDKErrorResponse("E_WC_04", message: "Please provide mandatory fileds")
            }
        }

        return errorResponse
    }
    
    func isValidName(inName:String) -> Bool {
        var isValid = false
        
        if inName.characters.count >= 1 &&  inName.characters.count <= 25 {
            isValid = true
        }
        
        return isValid
    }
    
    func isValidMobileDeviceId(inValidMobileDeviceId:String) -> Bool {
        var isValid = false
        
        if inValidMobileDeviceId.characters.count >= 1 &&  inValidMobileDeviceId.characters.count <= 60 {
            isValid = true
        }
        
        return isValid
    }
    
    func getSDKErrorResponse(withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }

}