//
//  AcceptSDKTokenResposnse.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

struct AcceptSDKTokenResponseKeys {
    static let kOpaqueDataKey       = "opaqueData"
    static let kDataDescriptorKey   = "dataDescriptor"
    static let kDataValueKey        = "dataValue"
    static let kMessagesKey         = "messages"
    static let kResultCodeKey       = "resultCode"
    static let kMessageKey          = "message"
    static let kCodeKey             = "code"
    static let kTextKey             = "text"
}

public class AcceptSDKTokenResponse: NSObject {
    private var opaqueData:OpaqueData!
    private var messages:Messages!
    
    convenience init(inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let opaqueDataDict = inDict[AcceptSDKTokenResponseKeys.kOpaqueDataKey] as? Dictionary<String,AnyObject> {
            self.opaqueData = OpaqueData(inDict:opaqueDataDict)
        }
        
        if let messagesDict = inDict[AcceptSDKTokenResponseKeys.kMessagesKey] as? Dictionary<String,AnyObject> {
            self.messages = Messages(inDict: messagesDict)
        }
    }
    
    public func getOpaqueData() -> OpaqueData {
        return self.opaqueData
    }
    
    public func getMessages() -> Messages {
        return self.messages
    }
}

public class OpaqueData {
    private var dataDescriptor:String?
    private var dataValue:String?
    
    convenience init (inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let descriptor = inDict[AcceptSDKTokenResponseKeys.kDataDescriptorKey] as? String {
            self.dataDescriptor      = descriptor
        }
        if let value = inDict[AcceptSDKTokenResponseKeys.kDataValueKey] as? String {
            self.dataValue      = value
        }
    }

    public func getDataDescriptor()->String {
        return self.dataDescriptor!
    }
    
    public func getDataValue() -> String {
        return self.dataValue!
    }
}

public class Messages {
    private var resultCode: String!
    private var messages: Array<Message> = []
    
    convenience init (inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let code = inDict[AcceptSDKTokenResponseKeys.kResultCodeKey] as? String {
            self.resultCode      = code
        }
        
        if let messageArr = inDict[AcceptSDKTokenResponseKeys.kMessageKey] as? Array<Dictionary<String,AnyObject>> {
            for message in messageArr {
                if let messageDict = message as? Dictionary<String, AnyObject> {
                    self.messages.append(Message(inDict: messageDict))
                }
            }
        }
    }

    convenience init (inMappingErrorDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let code = inMappingErrorDict[AcceptSDKTokenResponseKeys.kResultCodeKey] as? String {
            self.resultCode      = code
        }
        
        if let messageArr = inMappingErrorDict[AcceptSDKTokenResponseKeys.kMessageKey] as? Array<Dictionary<String,AnyObject>> {
            for message in messageArr {
                if let messageDict = message as? Dictionary<String, AnyObject> {
                    self.messages.append(Message(inMappingErrorDict: messageDict))
                }
            }
        }
    }

    convenience init (inError: NSError) {
        self.init()
        
        self.resultCode = AcceptSDKResponse.kResultCodeErrorValueKey

        self.messages.append(Message(inError: inError))
    }

    convenience init (inError: Messages) {
        self.init()
        
        self.resultCode = AcceptSDKResponse.kResultCodeErrorValueKey
        
        self.messages.append(inError.messages[0])
    }

    convenience init (withMessage: Message) {
        self.init()
        
        self.resultCode = AcceptSDKResponse.kResultCodeErrorValueKey
        
        self.messages.append(withMessage)
    }

    public func getResultCode() -> String {
        return self.resultCode
    }
    
    public func getMessages() -> Array<Message> {
        return self.messages
    }
}

public class Message {
    private var code:String!
    private var text:String!
    
    convenience init (inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let code = inDict[AcceptSDKTokenResponseKeys.kCodeKey] as? String {
            if code == "I00001" {
                self.code = "I_WC_01"
            } else {
                self.code      = code
            }
        }
        if let text = inDict[AcceptSDKTokenResponseKeys.kTextKey] as? String {
            self.text      = text
        }
    }

    convenience init (inMappingErrorDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let code = inMappingErrorDict[AcceptSDKTokenResponseKeys.kCodeKey] as? String {
            self.code      = "E_WC_14"
        }
        if let text = inMappingErrorDict[AcceptSDKTokenResponseKeys.kTextKey] as? String {
            self.text      = text
        }
    }
    
    convenience init (inError: NSError) {
        self.init()
        
        self.code = "E_WC_02"//(inError.code as NSNumber).stringValue
        self.text = inError.localizedDescription
    }

    convenience init (inErrorCode:String, inErrorMessage:String) {
        self.init()
        
        self.code = inErrorCode
        self.text = inErrorMessage
    }

    public func getCode() -> String {
        return self.code
    }
    
    public func getText() -> String {
        return self.text
    }
}