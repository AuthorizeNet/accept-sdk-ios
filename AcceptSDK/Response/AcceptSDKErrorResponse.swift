//
//  AcceptSDKErrorResponse.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/13/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

public class AcceptSDKErrorResponse: NSObject {
    private var messages:Messages!
    
    convenience init(inDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let messagesDict = inDict[AcceptSDKTokenResponseKeys.kMessagesKey] as? Dictionary<String,AnyObject> {
            self.messages = Messages(inDict: messagesDict)
        }
    }
    
    convenience init(inMappingErrorDict:Dictionary<String,AnyObject>) {
        self.init()
        
        if let messagesDict = inMappingErrorDict[AcceptSDKTokenResponseKeys.kMessagesKey] as? Dictionary<String,AnyObject> {
            self.messages = Messages(inMappingErrorDict: messagesDict)
        }
    }

    convenience init(inError: NSError) {
        self.init()
        
        self.messages = Messages(inError: inError)
    }

    convenience init(withMessage: Message) {
        self.init()
        
        self.messages = Messages(withMessage: withMessage)
    }

    public func getMessages() -> Messages {
        return self.messages
    }
}