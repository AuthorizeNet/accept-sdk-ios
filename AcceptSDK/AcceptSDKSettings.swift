//
//  AcceptSDKSettings.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

public class AcceptSDKSettings : NSObject {
    
    static let sharedInstance = AcceptSDKSettings()

    var acceptSDKEnvironment : String?

    static func setAcceptSDKEnvironment(environment: String) {
        sharedInstance.acceptSDKEnvironment = environment;
    }
}