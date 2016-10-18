//
//  AcceptSDKInternal.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

class AcceptSDKInternal {
    func getToken(_ paymentRequest: AcceptSDKRequest, success:@escaping (AcceptSDKTokenResponse)->(), failure:@escaping (AcceptSDKErrorResponse)->()) {
        let acceptSDKInteface = self.getTokenInterface()
        
        acceptSDKInteface.getToken(paymentRequest, success: {(response:AcceptSDKTokenResponse)->() in
            success(response)
            }, failure: {(inError:AcceptSDKErrorResponse)->() in
                failure(inError)
        })
    }
    
    func getTokenInterface()->AcceptSDKTokenInterface {
        let interfaceBuilder     = AcceptSDKTokenInterface()
        return interfaceBuilder
    }
}
