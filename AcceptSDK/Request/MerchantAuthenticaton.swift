//
//  MerchantAuthenticaton.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/16/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation


public class MerchantAuthenticaton {
    public var name:String?
    public var fingerPrint:FingerPrint?
    public var clientKey: String?
    public var mobileDeviceId:String?
    
    func validate(mecrhantAuth: MerchantAuthenticaton, successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {
        
        var intermediateResult = true
        var errorResponse:AcceptSDKErrorResponse?

        if ((self.clientKey?.isEmpty) == nil && self.fingerPrint == nil) {
            failureHandler(withResponse: AcceptSDKErrorResponse.getSDKErrorResponse("E_WC_18", message: "Client key is required."))
            return
        }
        
        if let key = self.clientKey {
            //no validation for clientKey
            if let errorResponse = self.validateOptionalFileds(self.name, inDeviceId: self.mobileDeviceId) {
                failureHandler(withResponse: errorResponse)
            } else {
                successHandler(isSuccess: true)
            }
        } else {
            self.fingerPrint!.validate(self.fingerPrint!, successHandler: { (isSuccess) -> () in
                if let errorResponse = self.validateOptionalFileds(self.name, inDeviceId: self.mobileDeviceId) {
                    failureHandler(withResponse: errorResponse)
                } else {
                    successHandler(isSuccess: true)
                }
            }, failureHandler: failureHandler)
        }
    }
    
    func validateOptionalFileds(inName: String?, inDeviceId: String?) -> AcceptSDKErrorResponse? {
        
        var intermediateResult = true
        var errorResponse:AcceptSDKErrorResponse?

        if let validName = inName {
            if isValidName(validName) {
            } else {
                intermediateResult = false
                errorResponse = AcceptSDKErrorResponse.getSDKErrorResponse("E_WC_17", message: "Please provide valid card holder name.")
            }
        }
        
        if let deviceId = inDeviceId {
            if isValidMobileDeviceId(deviceId) {
            } else {
                intermediateResult = false
                errorResponse = AcceptSDKErrorResponse.getSDKErrorResponse("EC_WC_1001", message: "Invalid Mobile device id")
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
}