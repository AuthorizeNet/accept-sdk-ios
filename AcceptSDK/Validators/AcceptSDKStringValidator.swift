//
//  AcceptSDKStringValidator.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/13/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

extension String {
    static func space() -> String {
        return " "
    }
    
    static func comma() -> String {
        return ","
    }

    static func dot() -> String {
        return "."
    }

    static func percent() -> String {
        return "%"
    }

    static func newLine() -> String {
        return "\n"
    }

    static func carriageReturn() -> String {
        return "\r"
    }

    static func qrCodeItemSeparator() -> String {
        return "<|>"
    }

    static func addressPartsSeparator() -> String {
        return ", "
    }

    static func stateAndZipCodeSeparator() -> String {
        return String.space()
    }

    static func underline() -> String {
        return "_"
    }

    static func passwordDot() -> String {
        let kUnichar:UniChar = 0x00B7
        return String(kUnichar)
    }
}


class AcceptSDKStringValidator {
    
    class func isEmpty(paramString:String) -> Bool {
        var result = false
        
        if paramString.isEmpty {
            result = true
        } else {
            let tempString = paramString.stringByReplacingOccurrencesOfString(String.space(), withString: String())
            if tempString.characters.count < 0 {
                result = true
            }
        }
        return result;
    }
    
    class func isNumber(paramString:String) -> Bool {
        var result = true
        
        if paramString.characters.count == 0 {
            result = false
        } else {
            let tempString = paramString.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
            
            if tempString.characters.count > 0 {
                result = false
            }
        }

        return result;
    }
    
    class func isAlphanumeric(paramString:String) -> Bool {
        var result = true
        
        if paramString.characters.count == 0 {
            result = false
        } else {
            if self.isNumber(paramString) {
                result = false
            } else {
                let trimmedString = paramString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet())
                
                if trimmedString.characters.count > 0 {
                    result = false
                }
            }
        }
        
        return result;
    }

    class func isStringContainsOnlySpaces(inString: String) -> Bool {
        var result = true
        
        let trimmedStr = inString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if trimmedStr.characters.count > 0 {
            result = false
        }
        
        return result
    }
    
    class func isStringContainsSpaceAtBeginningAndEnd(inString: String) -> Bool {
        var result = false
        
        let startStr = String(inString[inString.startIndex])
        let endStr = inString.substringFromIndex(inString.endIndex.predecessor())
        
        if  startStr == String.space() || endStr == String.space() {
            result = true
        }
        
        return result
    }
    
    class func isStringContainsDecimalCharacter(inString: String) -> Bool {
        var result = false
        
        let trimmedStr = inString.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
        
        if trimmedStr.characters.count > 0 {
            result = true
        }
        
        return result
    }
    
    class func isStringIsNegativeNumber(inString: String) -> Bool {
        var result = false
        
        if inString.characters.count > 0 {
            let startStr = String(inString[inString.startIndex])
            
            if startStr == "-" {
                result = true
            }
        }
        
        return result
    }
}







