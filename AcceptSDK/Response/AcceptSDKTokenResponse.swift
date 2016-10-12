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

open class AcceptSDKTokenResponse: NSObject {
    fileprivate var opaqueData:OpaqueData!
    fileprivate var messages:Messages!
    
    convenience init(inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let opaqueDataDict = inDict[AcceptSDKTokenResponseKeys.kOpaqueDataKey] as? Dictionary<String,AnyObject> {
            self.opaqueData = OpaqueData(inDict:opaqueDataDict)
        }
        
        if let messagesDict = inDict[AcceptSDKTokenResponseKeys.kMessagesKey] as? Dictionary<String,AnyObject> {
            self.messages = Messages(inDict: messagesDict)
        }
    }
    
    open func getOpaqueData() -> OpaqueData {
        return self.opaqueData
    }
    
    open func getMessages() -> Messages {
        return self.messages
    }
}

open class OpaqueData {
    fileprivate var dataDescriptor:String?
    fileprivate var dataValue:String?
    
    convenience init (inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let descriptor = inDict[AcceptSDKTokenResponseKeys.kDataDescriptorKey] as? String {
            self.dataDescriptor      = descriptor
        }
        if let value = inDict[AcceptSDKTokenResponseKeys.kDataValueKey] as? String {
            self.dataValue      = value
        }
    }

    open func getDataDescriptor()->String {
        return self.dataDescriptor!
    }
    
    open func getDataValue() -> String {
        return self.dataValue!
    }
}

open class Messages {
    fileprivate var resultCode: String!
    fileprivate var messages: Array<Message> = []
    
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

    open func getResultCode() -> String {
        return self.resultCode
    }
    
    open func getMessages() -> Array<Message> {
        return self.messages
    }
}

open class Message {
    fileprivate var code:String!
    fileprivate var text:String!
    
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

    open func getCode() -> String {
        return self.code
    }
    
    open func getText() -> String {
        return self.text
    }
}
