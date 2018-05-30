//
//  MerchantAuthenticaton.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/16/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation


open class MerchantAuthenticaton: NSObject {
    @objc open var name = String()
    @objc open var fingerPrint: FingerPrint?
    @objc open var clientKey: String?
    @objc open var mobileDeviceId:String?
    
    @objc func validate(_ successHandler:@escaping (_ isSuccess:Bool)->(),failureHandler:@escaping (_ withResponse:AcceptSDKErrorResponse)->()) {
        
        if ((self.clientKey?.isEmpty) == nil && self.fingerPrint == nil) {
            failureHandler(self.getSDKErrorResponse("E_WC_18", message: "Client key is required."))
            return
        }
        
        if let key = self.clientKey {
            //todo change this..redundant check
            if key.count > 0 {
                if let errorResponse = self.validateOptionalFileds(self.name, inDeviceId: self.mobileDeviceId) {
                    failureHandler(errorResponse)
                } else {
                    successHandler(true)
                }
            }
        } else {
            self.fingerPrint!.validate({ (isSuccess) -> () in
                if let errorResponse = self.validateOptionalFileds(self.name, inDeviceId: self.mobileDeviceId) {
                    failureHandler(errorResponse)
                } else {
                    successHandler(true)
                }
            }, failureHandler: failureHandler)
        }
    }
    
    @objc func validateOptionalFileds(_ inName: String?, inDeviceId: String?) -> AcceptSDKErrorResponse? {
        
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
    
    @objc func isValidName(_ inName:String) -> Bool {
        var isValid = false
        
        if inName.count >= 1 &&  inName.count <= 25 {
            isValid = true
        }
        
        return isValid
    }
    
    @objc func isValidMobileDeviceId(_ inValidMobileDeviceId:String) -> Bool {
        var isValid = false
        
        if inValidMobileDeviceId.count >= 1 &&  inValidMobileDeviceId.count <= 60 {
            isValid = true
        }
        
        return isValid
    }
    
    @objc func getSDKErrorResponse(_ withCode: String, message:String) -> AcceptSDKErrorResponse {
        let message = Message(inErrorCode: withCode, inErrorMessage: message)
        return AcceptSDKErrorResponse(withMessage: message)
    }

}
