//
//  AcceptSDKPaymentRequest.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

open class AcceptSDKRequest: NSObject {
    @objc open var merchantAuthentication:MerchantAuthenticaton = MerchantAuthenticaton()
    @objc open var securePaymentContainerRequest:SecurePaymentContainerRequest = SecurePaymentContainerRequest()
    @objc let clientId = "accept-sdk-ios-1.0.0"
    
    @objc func validate(_ successHandler:@escaping (_ isSuccess:Bool)->(),failureHandler:@escaping (_ withResponse:AcceptSDKErrorResponse)->()) {
        self.merchantAuthentication.validate({_ in
            self.securePaymentContainerRequest.validate(successHandler, failureHandler: failureHandler)
            }, failureHandler: failureHandler)
    }
}
