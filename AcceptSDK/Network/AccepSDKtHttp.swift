
//
//  IAPHttp.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

let HTTP_TIMEOUT = NSTimeInterval(30)

private struct HTTPStatusCode {
    static let kHTTPSuccessCode         = 200
    static let kHTTPCreationSuccessCode = 201
}

class HttpRequest {
    var method : String?
    var url : String?
    var httpHeaders : Dictionary <String, AnyObject>?
    var bodyParameters: String?
    
    init(httMethod : String, url : String, httpHeaders : Dictionary <String, AnyObject>?, bodyParameters : String?){
        self.method = httMethod
        self.url = url
        
        if let parameters = httpHeaders {
            self.httpHeaders = parameters
        }
        
        if let parameters = bodyParameters {
            self.bodyParameters = parameters
        }
    }
    
    internal func urlRequest () -> NSMutableURLRequest {
        let result = NSMutableURLRequest(URL: NSURL(string: self.url!)!)
//        result.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        result.setValue("application/json", forHTTPHeaderField: "Accept")
        result.timeoutInterval = HTTP_TIMEOUT
        result.HTTPMethod = self.method!
        
        if let parameters = self.bodyParameters {
            result.setBodyContent(parameters)
        }

        if let parameters = self.httpHeaders {
            for (headerField, value) in parameters {
                result.setValue(value as? String, forHTTPHeaderField: headerField)
            }
        }
        
        return result
    }
}

private struct HTTPErrorKeys {
    static let kErrorsKey = "errors"
    static let kErrorTypeKey = "type"
    static let kErrorMessageKey = "message"
}

struct HTTPErrorResponseCode {
    static let apiErrorResponseCode = 4000
    static let kErrorDictionaryKey  = "Error_Info_Dict"
}

class HTTPResponse {
    var code : Int?
    var body : Dictionary <String, AnyObject>?
    var error : NSError?
    
    init () {
    }
}

class HTTP: NSObject, NSURLSessionDelegate {
    
    func request(request : HttpRequest) -> HTTPResponse {
        
        let urlRequest : NSMutableURLRequest = request.urlRequest()
                
        return self.requestSynchronousData(urlRequest)
        
    }
    
    private func requestSynchronousData(request: NSURLRequest) -> HTTPResponse {
        let httpResponse = HTTPResponse()
        
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        let sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            taskData, response, error -> () in
            if (error != nil) {
                httpResponse.error = error
            }
            else if let castedResponse = response as? NSHTTPURLResponse {
                let bodyDict = self.deserializeData(taskData!)
                
                if HTTPStatusCode.kHTTPSuccessCode == castedResponse.statusCode || HTTPStatusCode.kHTTPCreationSuccessCode == castedResponse.statusCode {
                    httpResponse.body = bodyDict
                } else {
                    let (errorMessage) = self.getErrorResponse(bodyDict!)
                    if let message = errorMessage {
                        httpResponse.error = NSError(domain: message, code: castedResponse.statusCode, userInfo:[NSLocalizedDescriptionKey:message,HTTPErrorResponseCode.kErrorDictionaryKey:bodyDict!])
                    }else {
                        httpResponse.error = NSError(domain: "BadResponse", code: castedResponse.statusCode, userInfo:nil)
                    }
                }
            }
            
            dispatch_semaphore_signal(semaphore);
        })
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return httpResponse
    }

    private func getErrorResponse(responseDict:Dictionary<String, AnyObject>)->String? {
        var errorMessage:String?
        if  let errorArray = responseDict[HTTPErrorKeys.kErrorsKey] as? [[String:String]] {
            if let error = errorArray.first {
                errorMessage = error[HTTPErrorKeys.kErrorMessageKey]
            }
        }
        return errorMessage
    }

    private func serializeJson (json : Dictionary <String, AnyObject>) -> NSData? {
        let result : NSData? = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        
        return result;
    }
    
    private func deserializeData (data : NSData) -> Dictionary<String, AnyObject>? {
        var jsonDict:Dictionary<String, AnyObject> = [:]
        do{
            jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
        }
        catch let error as NSError{
            //todo handle error
        }
        return jsonDict
        
    }
}

extension NSMutableURLRequest {
    func setBodyContent(contentStr: String?) {
        self.HTTPBody = contentStr!.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
