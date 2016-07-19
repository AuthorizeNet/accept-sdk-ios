//
//  AcceptSDKTokenAPIBuilder.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

private struct AcceptSDKTokenAPIBuilderKeys {
    static let kTokenAPI             = "request.api"
}

class AcceptSDKTokenAPIBuilder: AcceptSDKBaseURLBuilder {
    
    override init() {
        super.init()
    }
    
    func getTokenAPIUrl()->String {
        return super.getBaseURL()+"/"+AcceptSDKTokenAPIBuilderKeys.kTokenAPI
    }
}