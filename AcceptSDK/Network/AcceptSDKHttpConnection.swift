//
//  HttpConnection.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

class HttpConnection{
    var http : HTTP?
    
    private let requestQueue : dispatch_queue_t
    private let responseQueue : dispatch_queue_t
    
    init () {
        self.requestQueue = dispatch_queue_create("AcceptSDKRequestQueue", nil)
        self.responseQueue = dispatch_get_main_queue()
        self.http = HTTP()
    }
    
    func performPostRequest(url : String, httpHeaders : Dictionary<String, AnyObject>?, bodyParameters:String?, success : (Dictionary<String, AnyObject>) -> (), failure : (NSError) -> ()) {
        self.performRequestAsynchronously(url, method: "POST", httpHeaders: httpHeaders, bodyParameters: bodyParameters, success: success, failure: failure)
    }

    func performRequestAsynchronously (url : String, method : String, httpHeaders : Dictionary<String, AnyObject>?, bodyParameters:String?, success : (Dictionary<String, AnyObject>) -> (), failure : (NSError) -> ()) {
        
        dispatch_async(self.requestQueue, {
            
            let request = HttpRequest(httMethod: method, url: url, httpHeaders: httpHeaders, bodyParameters:bodyParameters)

            let response : HTTPResponse = self.http!.request(request)
            
            dispatch_async(self.responseQueue, {
                if response.error != nil {
                    failure(response.error!)
                }
                else {
                    success(response.body!)
                }
            })
        })
    }
}

