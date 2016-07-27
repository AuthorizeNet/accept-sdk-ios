//
//  AcceptSDKCardFieldsValidator.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/13/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation

public struct AcceptSDKCardFieldsValidatorConstants {
    public static let kInAppSDKCardNumberCharacterCountMin:Int = 12
    public static let kInAppSDKCardNumberCharacterCountMax:Int = 19
    public static let kInAppSDKCardExpirationMonthMin:Int = 1
    public static let kInAppSDKCardExpirationMonthMax:Int = 12
    public static let kInAppSDKCardExpirationYearMax:Int = 99
    public static let kInAppSDKSecurityCodeCharacterCountMin:Int = 3
    public static let kInAppSDKSecurityCodeCharacterCountMax:Int = 4
    public static let kInAppSDKZipCodeCharacterCountMax:Int = 5
}

public class AcceptSDKCardFieldsValidator {
    
    public init() {
    }
    
    public func cardExpirationYearMin() -> Int {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = gregorian?.components(.Year, fromDate: NSDate())
        return (components?.year)! % 100
    }
    
    func validateCardNumberWithString(inCardNumber: String) -> Bool {
        var result = false
        
        let tempCardNumber = inCardNumber.stringByReplacingOccurrencesOfString(String.space(), withString: String())
        
        if AcceptSDKStringValidator.isNumber(tempCardNumber) {
            if ((tempCardNumber.characters.count >= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardNumberCharacterCountMin) &&
                tempCardNumber.characters.count <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardNumberCharacterCountMax) {
                result = true
            }
        }
        return result
    }
    
    func validateMonthWithString(inMonth: String) -> Bool {
        var result = false
        
        if AcceptSDKStringValidator.isNumber(inMonth) {
            let monthNumber = Int(inMonth)
            
            if ((monthNumber >= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationMonthMin) &&
                (monthNumber <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationMonthMax)) {
                result = true
            }
        }

        return result
    }

    func validateYearWithString(inYear: String) -> Bool {
        var result = false
        
        if ((inYear.characters.count != 2) || (inYear.characters.count != 4)) {
            result = false
        }
        
        if inYear.characters.count == 2 {
            if AcceptSDKStringValidator.isNumber(inYear) {
                let yearNumber = Int(inYear)
                
                if ((yearNumber >= self.cardExpirationYearMin()%100) &&
                    (yearNumber <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationYearMax)) {
                    result = true
                }
            }
        } else if inYear.characters.count == 4 {
            if AcceptSDKStringValidator.isNumber(inYear) {
                let yearNumber = Int(inYear)
                
                if yearNumber >= self.cardExpirationYearMin() {
                    result = true
                }
            }
        } else {
            result = false
        }
        
        return result
    }

    public func validateSecurityCodeWithString(inSecurityCode: String) -> Bool {
        var result = false
        
        if AcceptSDKStringValidator.isNumber(inSecurityCode) {
            if ((inSecurityCode.characters.count == AcceptSDKCardFieldsValidatorConstants.kInAppSDKSecurityCodeCharacterCountMin) ||
                (inSecurityCode.characters.count == AcceptSDKCardFieldsValidatorConstants.kInAppSDKSecurityCodeCharacterCountMax)) {
                result = true
            }
        }

        return result
    }
    
    func validateZipCodeWithString(inZipCode: String) -> Bool {
        var result = false
        
        if AcceptSDKStringValidator.isNumber(inZipCode) {
            if (inZipCode.characters.count == AcceptSDKCardFieldsValidatorConstants.kInAppSDKZipCodeCharacterCountMax) {
                result = true
            }
        }
        
        return result
    }
    
    //!--------------------------------------------- advance validation -----------------------------------
    
    public func validateCardWithLuhnAlgorithm(inCardNumber: String) -> Bool {
        var result = false
        
        let tempCardNumber = inCardNumber.stringByReplacingOccurrencesOfString(String.space(), withString: String())
        
        if inCardNumber.characters.count > 0 {
            let elementsCount = tempCardNumber.characters.count
            var arrayOfIntegers = [Int?](count:elementsCount, repeatedValue: nil)

            for (index, _) in tempCardNumber.characters.enumerate() {
                let charIndex = tempCardNumber.startIndex.advancedBy(index)
                let tempStr = String(tempCardNumber.characters.suffixFrom(charIndex))
                let singleCharacter = String(tempStr.characters.prefix(1))//String(tempStr.characters.first)
                
                arrayOfIntegers[tempCardNumber.characters.count - 1 - index] = Int(singleCharacter)
            }
            
            for (index, _) in tempCardNumber.characters.enumerate() {
                if index%2 != 0 {
                    arrayOfIntegers[index] = arrayOfIntegers[index]! * 2
                }
            }
            
            var theSum = 0
            for (index, _) in tempCardNumber.characters.enumerate() {
                if arrayOfIntegers[index] > 9 {
                    theSum += arrayOfIntegers[index]! / 10
                    theSum += arrayOfIntegers[index]! % 10
                } else {
                    theSum += arrayOfIntegers[index]!
                }
            }
            
            if ((theSum != 0) && ((theSum % 10) == 0)) {
                result = true
            }
        }
        return result
    }

    public func validateExpirationDate(inMonth: String, inYear:String) -> Bool {
        var result = false

        if (self.validateMonthWithString(inMonth) && self.validateYearWithString(inYear)) {
            //---  now date
            let nowDate = NSDate()
            
            //--- date expiration
            let comps = NSDateComponents()
            comps.day = 1
            comps.month = Int(inMonth)!
            if inYear.characters.count == 2 {
                comps.year = 2000+Int(inYear)!
            } else if inYear.characters.count == 4 {
                comps.year = Int(inYear)!
            }
            
            let expirationDate = NSCalendar.currentCalendar().dateFromComponents(comps)
            
            //--- next month after expiration
            let monthComponents = NSDateComponents()
            monthComponents.month = 1
            
            let nextDayAfterExpirationDate = NSCalendar.currentCalendar().dateByAddingComponents(monthComponents, toDate: expirationDate!, options: NSCalendarOptions(rawValue: 0))
            
            let timeIntervalSinceDate = nextDayAfterExpirationDate!.timeIntervalSinceDate(nowDate)
            result = (timeIntervalSinceDate > 0)
        }

        return result
    }
    
    func validateExpirationDate(inExpirationDate: String) -> Bool {
        var result = false
        
        let monthRange = inExpirationDate.startIndex..<inExpirationDate.startIndex.advancedBy(2)
        let month = inExpirationDate[monthRange]
        
        let yearRange = inExpirationDate.startIndex.advancedBy(2)..<inExpirationDate.endIndex
        let year = inExpirationDate[yearRange]

        if self.validateExpirationDate(month, inYear: year) {
            result = true
        }
        
        return result
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}