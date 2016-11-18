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
    
    fileprivate let requestQueue : DispatchQueue
    fileprivate let responseQueue : DispatchQueue
    
    init () {
        self.requestQueue = DispatchQueue(label: "AcceptSDKRequestQueue", attributes: [])
        self.responseQueue = DispatchQueue.main
        self.http = HTTP()
    }
    
    func performPostRequest(_ url : String, httpHeaders : Dictionary<String, AnyObject>?, bodyParameters:String?, success : @escaping (Dictionary<String, AnyObject>) -> (), failure : @escaping (NSError) -> ()) {
        self.performRequestAsynchronously(url, method: "POST", httpHeaders: httpHeaders, bodyParameters: bodyParameters, success: success, failure: failure)
    }

    func performRequestAsynchronously (_ url : String, method : String, httpHeaders : Dictionary<String, AnyObject>?, bodyParameters:String?, success : @escaping (Dictionary<String, AnyObject>) -> (), failure : @escaping (NSError) -> ()) {
        
        self.requestQueue.async(execute: {
            
            let request = HttpRequest(httMethod: method, url: url, httpHeaders: httpHeaders, bodyParameters:bodyParameters)

            let response : HTTPResponse = self.http!.request(request)
            
            self.responseQueue.async(execute: {
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

