//
//  AcceptSDKHandler.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

public enum AcceptSDKEnvironment: String {
    case ENV_LIVE = "api.authorize.net"
    case ENV_TEST = "apitest.authorize.net"
}

open class AcceptSDKHandler : NSObject {
    
    public override init() {
        super.init()
    }
    
    public init?(environment: AcceptSDKEnvironment) {
        super.init()
        
        let settings = AcceptSDKSettings.sharedInstance
        settings.acceptSDKEnvironment = environment.rawValue
    }
    
    open func getTokenWithRequest(_ inRequest: AcceptSDKRequest, successHandler:@escaping (AcceptSDKTokenResponse)->(),failureHandler:@escaping (AcceptSDKErrorResponse)->()) {
        
        inRequest.validate({ (isSuccess) -> () in
            let sdkInternal = AcceptSDKInternal()
            sdkInternal.getToken(inRequest, success: successHandler, failure: failureHandler)
            }, failureHandler: failureHandler)
    }
}
