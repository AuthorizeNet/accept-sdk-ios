//
//  AcceptSDKSettings.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

open class AcceptSDKSettings : NSObject {
    
    static let sharedInstance = AcceptSDKSettings()

    var acceptSDKEnvironment : String?

    static func setAcceptSDKEnvironment(_ environment: String) {
        sharedInstance.acceptSDKEnvironment = environment;
    }
}
