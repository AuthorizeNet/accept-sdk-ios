//
//  AcceptSDKHandler.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

@objc public enum AcceptSDKEnvironment: Int {
    case ENV_LIVE //= "api.authorize.net"
    case ENV_TEST //= "apitest.authorize.net"
    
    public typealias RawValue = String

    public var rawValue: RawValue {
        switch self {
        case .ENV_LIVE:
            return "api.authorize.net"
        case .ENV_TEST:
            return "apitest.authorize.net"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "api.authorize.net":
            self = .ENV_LIVE
        case "apitest.authorize.net":
            self = .ENV_TEST
        default:
            self = .ENV_LIVE
        }
    }

}

open class AcceptSDKHandler : NSObject {
    
    public override init() {
        super.init()
    }
    
    @objc public init?(environment: AcceptSDKEnvironment) {
        super.init()
        
        let settings = AcceptSDKSettings.sharedInstance
        settings.acceptSDKEnvironment = environment.rawValue
    }
    
    @objc open func getTokenWithRequest(_ inRequest: AcceptSDKRequest, successHandler:@escaping (AcceptSDKTokenResponse)->(),failureHandler:@escaping (AcceptSDKErrorResponse)->()) {
        
        inRequest.validate({ (isSuccess) -> () in
            let sdkInternal = AcceptSDKInternal()
            sdkInternal.getToken(inRequest, success: successHandler, failure: failureHandler)
            }, failureHandler: failureHandler)
    }
}
