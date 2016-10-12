//
//  AcceptSDKBaseURLBuilder.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

class AcceptSDKBaseURLBuilder {
    fileprivate var baseurl:String!
    fileprivate var scheme:String!
    fileprivate var environmentURL:String!
    fileprivate var type:String!
    fileprivate var version:String!
    
    init(){
        self.scheme         = "https"
        self.environmentURL = AcceptSDKSettings.sharedInstance.acceptSDKEnvironment
        self.type           = "xml"
        self.version        = "v1"
        self.baseurl        = String(format: "%@://%@/%@/%@", arguments: [self.scheme, self.environmentURL, self.type, self.version])
    }
    
    func getBaseURL()->String {
        return self.baseurl
    }
}
