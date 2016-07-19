//
//  AcceptSDKBaseURLBuilder.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

class AcceptSDKBaseURLBuilder {
    private var baseurl:String!
    private var scheme:String!
    private var environmentURL:String!
    private var type:String!
    private var version:String!
    
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
