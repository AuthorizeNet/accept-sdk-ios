
//
//  IAPHttp.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

let HTTP_TIMEOUT = TimeInterval(30)

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
        let result = NSMutableURLRequest(url: URL(string: self.url!)!)
//        result.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        result.setValue("application/json", forHTTPHeaderField: "Accept")
        result.timeoutInterval = HTTP_TIMEOUT
        result.httpMethod = self.method!
        
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

class HTTP: NSObject, URLSessionDelegate {
    
    func request(_ request : HttpRequest) -> HTTPResponse {
        
        let urlRequest : NSMutableURLRequest = request.urlRequest()
                
        return self.requestSynchronousData(urlRequest as URLRequest)
        
    }
    
    fileprivate func requestSynchronousData(_ request: URLRequest) -> HTTPResponse {
        let httpResponse = HTTPResponse()
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request, completionHandler: {
            taskData, response, error -> () in
            if (error != nil) {
                httpResponse.error = error as NSError?
            }
            else if let castedResponse = response as? HTTPURLResponse {
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
            
            semaphore.signal();
        })
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return httpResponse
    }

    fileprivate func getErrorResponse(_ responseDict:Dictionary<String, AnyObject>)->String? {
        var errorMessage:String?
        if  let errorArray = responseDict[HTTPErrorKeys.kErrorsKey] as? [[String:String]] {
            if let error = errorArray.first {
                errorMessage = error[HTTPErrorKeys.kErrorMessageKey]
            }
        }
        return errorMessage
    }

    fileprivate func serializeJson (_ json : Dictionary <String, AnyObject>) -> Data? {
        let result : Data? = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        return result;
    }
    
    fileprivate func deserializeData (_ data : Data) -> Dictionary<String, AnyObject>? {
        var jsonDict:Dictionary<String, AnyObject> = [:]
        do{
            jsonDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
        }
        catch _ as NSError{
            //todo handle error
        }
        return jsonDict
        
    }
}

extension NSMutableURLRequest {
    @objc func setBodyContent(_ contentStr: String?) {
        self.httpBody = contentStr!.data(using: String.Encoding.utf8)
    }
}
