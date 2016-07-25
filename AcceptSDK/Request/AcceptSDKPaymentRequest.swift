//
//  AcceptSDKPaymentRequest.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

public class AcceptSDKRequest: NSObject {
    public var merchantAuthentication:MerchantAuthenticaton = MerchantAuthenticaton()
    public var securePaymentContainerRequest:SecurePaymentContainerRequest = SecurePaymentContainerRequest()
    
    func validate(successHandler:(isSuccess:Bool)->(),failureHandler:(withResponse:AcceptSDKErrorResponse)->()) {
        self.merchantAuthentication.validate({_ in
            self.securePaymentContainerRequest.validate(successHandler, failureHandler: failureHandler)
            }, failureHandler: failureHandler)
    }
}