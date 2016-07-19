//
//  AcceptSDKTokenInterface.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

class AcceptSDKTokenInterface: AcceptSDKBaseInterface {
    
    func getToken(paymentRequest: AcceptSDKRequest, success:AcceptSDKCompletionHandlers.AcceptSDKSuccessHandler, failure:(AcceptSDKErrorResponse)->()) {
        let tokenAPIBuilder = AcceptSDKTokenAPIBuilder()
        let urlString = tokenAPIBuilder.getTokenAPIUrl()
        
        let interfaceBuilder     = AcceptSDKTokenInterfaceBuilder()

        let bodyParameterDictionary = interfaceBuilder.getRequestJSONString(paymentRequest)

        let httpConnection = HttpConnection()
        httpConnection.performPostRequest(urlString, httpHeaders: nil, bodyParameters: bodyParameterDictionary,
                        success: { (inDict:Dictionary<String, AnyObject>) -> () in
                                self.handleResponse(inDict,
                                    successHandler: { (isSuccess) -> () in
                                                    success(withResponse: AcceptSDKTokenResponse(inDict:inDict))
                                                    },
                                    failureHandler: { (isSuccess) -> () in
                                                    failure(AcceptSDKErrorResponse(inMappingErrorDict: inDict))
                                                    })},
                        failure: { (inError:NSError) -> () in
                                failure(AcceptSDKErrorResponse(inError: inError))
        })
    }
    
    private func handleResponse(response:Dictionary<String, AnyObject>,successHandler:(isSuccess:Bool)->(),failureHandler:(isSuccess:Bool)->()) {
        let messagesDict = response[AcceptSDKResponse.kMessagesKey]
        let statusCode = messagesDict![AcceptSDKResponse.kResultCodeKey] as? String
        if  statusCode == AcceptSDKResponse.kResultCodeOkValueKey {
            successHandler(isSuccess:true)
        } else if statusCode == AcceptSDKResponse.kResultCodeErrorValueKey {
            failureHandler(isSuccess:false)
        } else {
            //some thing is missing!
            print("error handling missing!!!")
        }
    }

}