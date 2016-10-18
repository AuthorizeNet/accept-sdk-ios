//
//  AcceptSDKPaymentRequest.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

open class AcceptSDKRequest: NSObject {
    open var merchantAuthentication:MerchantAuthenticaton = MerchantAuthenticaton()
    open var securePaymentContainerRequest:SecurePaymentContainerRequest = SecurePaymentContainerRequest()
    let clientId = "accept-sdk-ios-1.0.0"
    
    func validate(_ successHandler:@escaping (_ isSuccess:Bool)->(),failureHandler:@escaping (_ withResponse:AcceptSDKErrorResponse)->()) {
        self.merchantAuthentication.validate({_ in
            self.securePaymentContainerRequest.validate(successHandler, failureHandler: failureHandler)
            }, failureHandler: failureHandler)
    }
}
