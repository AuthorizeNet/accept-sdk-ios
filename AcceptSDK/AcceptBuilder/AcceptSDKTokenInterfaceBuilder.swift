//
//  AcceptSDKTokenInterfaceBuilder.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/11/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

struct AcceptSDKTokenAPIRequest{
    static let kSecurePaymentContainerRequestKey    = "securePaymentContainerRequest"
    static let kMerchantAuthenticationKey           = "merchantAuthentication"
    static let kNameKey                             = "name"
    static let kClientKeyKey                        = "clientKey"
    static let kDataKey                             = "data"
    static let kTypeKey                             = "type"
    static let kIdKey                               = "id"
    static let kTokenKey                            = "token"
    static let kCardNumberKey                       = "cardNumber"
    static let kExpirationDateKey                   = "expirationDate"
    static let kFingerPrintKey                      = "fingerPrint"
    static let kHashValueKey                        = "hashValue"
    static let kSequenceKey                         = "sequence"
    static let kTimestampKey                        = "timestamp"
    static let kCurrencyCodeKey                     = "currencyCode"
    static let kAmountKey                           = "amount"
    static let kCardCodeKey                         = "cardCode"
    static let kZipKey                              = "zip"
    static let kFullNameKey                         = "fullName"
    static let kClientId                            = "clientId"
}

class AcceptSDKTokenInterfaceBuilder: AcceptSDKBaseInterfaceBuilder {
    
    var name:String?
    var clientKey:String?
    var requestType:String?
    var merchantId:String?
    var cardNumber:String?
    var expirationDate:String?

    func withName(_ inName:String)-> Self {
        self.name = inName
        return self
    }

    func withClientKey(_ inClientKey:String)-> Self {
        self.clientKey = inClientKey
        return self
    }

    func withRequestType(_ inRequestType:String)-> Self {
        self.requestType = inRequestType
        return self
    }

    func withMerchantId(_ inMerchantId:String)-> Self {
        self.merchantId = inMerchantId
        return self
    }
    
    func withCardNumber(_ inCardNumber:String)-> Self {
        self.cardNumber = inCardNumber
        return self
    }

    func withExpirationDate(_ inExpirationDate:String)-> Self {
        self.expirationDate = inExpirationDate
        return self
    }
    
    func buildInterface()->AcceptSDKTokenInterface {
        let acceptSDKInterface = AcceptSDKTokenInterface()
        
        return acceptSDKInterface
    }
    
    func getRequestJSONString(_ request: AcceptSDKRequest) -> String {
        var jsonStr: String = String("")
        
        let nameKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kNameKey, value: request.merchantAuthentication.name)
        
        //fingerprint
        var fingerPrintArrayStr = String()
        var fingerPrintDictKeyValueStr = String()
        
        var clientKeyValueStr = String()
        if let clientStr = request.merchantAuthentication.clientKey {
            clientKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kClientKeyKey, value: clientStr)
        } else {
            var sequenceStr = String()
            var currenctCodeStr = String()
            var amountStr = String()
            
            let hashValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kHashValueKey, value: request.merchantAuthentication.fingerPrint!.fingerPrintHashValue)
            sequenceStr = self.createJSONString(AcceptSDKTokenAPIRequest.kSequenceKey, value: request.merchantAuthentication.fingerPrint!.sequence)

//            if let seq = request.merchantAuthentication.fingerPrint!.sequence {
//                sequenceStr = self.createJSONString(AcceptSDKTokenAPIRequest.kSequenceKey, value: seq)
//            }
            let timestampStr = self.createJSONString(AcceptSDKTokenAPIRequest.kTimestampKey, value: request.merchantAuthentication.fingerPrint!.timestamp)
            if let currenctCode = request.merchantAuthentication.fingerPrint!.currencyCode {
                currenctCodeStr = self.createJSONString(AcceptSDKTokenAPIRequest.kCurrencyCodeKey, value: currenctCode)
            }
            
            amountStr = self.createJSONString(AcceptSDKTokenAPIRequest.kAmountKey, value: request.merchantAuthentication.fingerPrint!.amount)

//            if let amt = request.merchantAuthentication.fingerPrint!.amount {
//                amountStr = self.createJSONString(AcceptSDKTokenAPIRequest.kAmountKey, value: amt)
//            }
            
            fingerPrintArrayStr = self.createJSONArray(NSArray(arrayLiteral: hashValueStr, sequenceStr, timestampStr, currenctCodeStr, amountStr) as! Array<String>)
            fingerPrintDictKeyValueStr = self.createJSONDict(AcceptSDKTokenAPIRequest.kFingerPrintKey, valueString: fingerPrintArrayStr)
        }
        
        var authenticationArrayStr = String()
        
        authenticationArrayStr = self.createJSONArray(NSArray(arrayLiteral: nameKeyValueStr, clientKeyValueStr, fingerPrintDictKeyValueStr) as! Array<String>)
        
        let merchantAuthenticationDictStr = self.createJSONDict(AcceptSDKTokenAPIRequest.kMerchantAuthenticationKey, valueString: authenticationArrayStr)
        
        let typeKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kTypeKey, value: request.securePaymentContainerRequest.webCheckOutDataType.type)
        let idKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kIdKey, value: request.securePaymentContainerRequest.webCheckOutDataType.id)

        //token dict
        let cardNumberKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kCardNumberKey, value: (request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber))
        
        let expiryDate = (request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth + request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear)
        let expirationDateKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kExpirationDateKey, value: expiryDate)
        
        var cvvKeyValueStr = String()
        if let ccode = request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode {
            cvvKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kCardCodeKey, value: ccode)
        }
        var zipKeyValueStr = String()
        var fullNameKeyValueStr = String()
        if let zip = request.securePaymentContainerRequest.webCheckOutDataType.token.zip {
            zipKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kZipKey, value: zip)
        }
        if let fName = request.securePaymentContainerRequest.webCheckOutDataType.token.fullName {
            fullNameKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kFullNameKey, value: fName)
        }
        let cardDetailsArrayStr = self.createJSONArray(NSArray(arrayLiteral: cardNumberKeyValueStr, expirationDateKeyValueStr, cvvKeyValueStr, zipKeyValueStr, fullNameKeyValueStr) as! Array<String>)
        let tokenDictKeyValueStr = self.createJSONDict(AcceptSDKTokenAPIRequest.kTokenKey, valueString: cardDetailsArrayStr)
        
        let dataArrayStr = self.createJSONArray(NSArray(arrayLiteral: typeKeyValueStr, idKeyValueStr, tokenDictKeyValueStr) as! Array<String>)
        let dataDictStr = self.createJSONDict(AcceptSDKTokenAPIRequest.kDataKey, valueString: dataArrayStr)
        
        let clientIdKeyValueStr = self.createJSONString(AcceptSDKTokenAPIRequest.kClientId, value: request.clientId)
        let finalArrayStr = self.createJSONArray(NSArray(arrayLiteral: merchantAuthenticationDictStr, clientIdKeyValueStr, dataDictStr) as! Array<String>)
        jsonStr = self.createJSONFinalDict(AcceptSDKTokenAPIRequest.kSecurePaymentContainerRequestKey, valueString: finalArrayStr)

        return jsonStr
    }
    
    func createJSONString(_ withKey: String, value: String) -> String {
        let jsonStr = String(format: "\"%@\":\"%@\"", withKey, value)
        
        return jsonStr
    }
    
    func createJSONArray(_ arrayOfKeyValuePairs: Array<String>) -> String {
        var jsonStr:String = ""
        
        var index = 1
        
        for pair in arrayOfKeyValuePairs {
            if pair.count > 0 {
                if index < arrayOfKeyValuePairs.count {
                    jsonStr = jsonStr + pair + ","
                } else {
                    jsonStr = jsonStr + pair
                }
            }
            index += 1
        }
        
        let lastChar = jsonStr.last!
        if lastChar == "," {
            jsonStr = String(jsonStr[..<jsonStr.index(before: jsonStr.endIndex)])
        }

        return jsonStr
    }
    
    func createJSONDict(_ key: String, valueString: String) -> String {
        let jsonStr = String(format: "\"%@\":{ %@ }", key, valueString)

        return jsonStr
    }
    
    func createJSONFinalDict(_ key: String, valueString: String) -> String {
        let jsonStr = String(format: "{\"%@\":{ %@ }}", key, valueString)
        
        return jsonStr
    }
}
