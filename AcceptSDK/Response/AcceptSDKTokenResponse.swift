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
    
    @objc convenience init(inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let opaqueDataDict = inDict[AcceptSDKTokenResponseKeys.kOpaqueDataKey] as? Dictionary<String,AnyObject> {
            self.opaqueData = OpaqueData(inDict:opaqueDataDict)
        }
        
        if let messagesDict = inDict[AcceptSDKTokenResponseKeys.kMessagesKey] as? Dictionary<String,AnyObject> {
            self.messages = Messages(inDict: messagesDict)
        }
    }
    
    @objc open func getOpaqueData() -> OpaqueData {
        return self.opaqueData
    }
    
    @objc open func getMessages() -> Messages {
        return self.messages
    }
}

open class OpaqueData: NSObject {
    fileprivate var dataDescriptor:String?
    fileprivate var dataValue:String?
    
    @objc convenience init (inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let descriptor = inDict[AcceptSDKTokenResponseKeys.kDataDescriptorKey] as? String {
            self.dataDescriptor      = descriptor
        }
        if let value = inDict[AcceptSDKTokenResponseKeys.kDataValueKey] as? String {
            self.dataValue      = value
        }
    }

    @objc open func getDataDescriptor()->String {
        return self.dataDescriptor!
    }
    
    @objc open func getDataValue() -> String {
        return self.dataValue!
    }
}

open class Messages: NSObject {
    fileprivate var resultCode: String!
    fileprivate var messages: Array<Message> = []
    
    @objc convenience init (inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let code = inDict[AcceptSDKTokenResponseKeys.kResultCodeKey] as? String {
            self.resultCode      = code
        }
        
        if let messageArr = inDict[AcceptSDKTokenResponseKeys.kMessageKey] as? Array<Dictionary<String,AnyObject>> {
            for message in messageArr {
                let messageDict = message as Dictionary<String, AnyObject>
                self.messages.append(Message(inDict: messageDict))
            }
        }
    }

    @objc convenience init (inMappingErrorDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let code = inMappingErrorDict[AcceptSDKTokenResponseKeys.kResultCodeKey] as? String {
            self.resultCode      = code
        }
        
        if let messageArr = inMappingErrorDict[AcceptSDKTokenResponseKeys.kMessageKey] as? Array<Dictionary<String,AnyObject>> {
            for message in messageArr {
                let messageDict = message as Dictionary<String, AnyObject>
                self.messages.append(Message(inMappingErrorDict: messageDict))
            }
        }
    }

    @objc convenience init (inError: NSError) {
        self.init()
        
        self.resultCode = AcceptSDKResponse.kResultCodeErrorValueKey

        self.messages.append(Message(inError: inError))
    }

//    convenience init (inError: Messages) {
//        self.init()
//        
//        self.resultCode = AcceptSDKResponse.kResultCodeErrorValueKey
//        
//        self.messages.append(inError.messages[0])
//    }

    @objc convenience init (withMessage: Message) {
        self.init()
        
        self.resultCode = AcceptSDKResponse.kResultCodeErrorValueKey
        
        self.messages.append(withMessage)
    }

    @objc open func getResultCode() -> String {
        return self.resultCode
    }
    
    @objc open func getMessages() -> Array<Message> {
        return self.messages
    }
}

open class Message: NSObject {
    fileprivate var code:String!
    fileprivate var text:String!
    
    @objc convenience init (inDict:Dictionary<String,AnyObject>) {
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

    @objc convenience init (inMappingErrorDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if (inMappingErrorDict[AcceptSDKTokenResponseKeys.kCodeKey] as? String) != nil {
            self.code      = "E_WC_14"
        }
        if let text = inMappingErrorDict[AcceptSDKTokenResponseKeys.kTextKey] as? String {
            self.text      = text
        }
    }
    
    @objc convenience init (inError: NSError) {
        self.init()
        
        self.code = "E_WC_02"//(inError.code as NSNumber).stringValue
        self.text = inError.localizedDescription
    }

    @objc convenience init (inErrorCode:String, inErrorMessage:String) {
        self.init()
        
        self.code = inErrorCode
        self.text = inErrorMessage
    }

    @objc open func getCode() -> String {
        return self.code
    }
    
    @objc open func getText() -> String {
        return self.text
    }
}
