//
//  AcceptSDKCardFieldsValidator.swift
//  AcceptSDK
//
//  Created by Ramamurthy, Rakesh Ramamurthy on 7/13/16.
//  Copyright © 2016 Ramamurthy, Rakesh Ramamurthy. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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

open class AcceptSDKCardFieldsValidator: NSObject {
    
    public override init() {
    }
    
    @objc open func cardExpirationYearMin() -> Int {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = (gregorian as NSCalendar?)?.components(.year, from: Date())
        return (components?.year)! % 100
    }
    
    @objc func validateCardNumberWithString(_ inCardNumber: String) -> Bool {
        var result = false
        
        let tempCardNumber = inCardNumber.replacingOccurrences(of: String.space(), with: String())
        
        if AcceptSDKStringValidator.isNumber(tempCardNumber) {
            if ((tempCardNumber.count >= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardNumberCharacterCountMin) &&
                tempCardNumber.count <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardNumberCharacterCountMax) {
                result = true
            }
        }
        return result
    }
    
    @objc func validateMonthWithString(_ inMonth: String) -> Bool {
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

    @objc func validateYearWithString(_ inYear: String) -> Bool {
        var result = false
        
        if ((inYear.count != 2) || (inYear.count != 4)) {
            result = false
        }
        
        if inYear.count == 2 {
            if AcceptSDKStringValidator.isNumber(inYear) {
                let yearNumber = Int(inYear)
                
                if ((yearNumber >= self.cardExpirationYearMin()%100) &&
                    (yearNumber <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationYearMax)) {
                    result = true
                }
            }
        } else if inYear.count == 4 {
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

    @objc open func validateSecurityCodeWithString(_ inSecurityCode: String) -> Bool {
        var result = false
        
        if AcceptSDKStringValidator.isNumber(inSecurityCode) {
            if ((inSecurityCode.count == AcceptSDKCardFieldsValidatorConstants.kInAppSDKSecurityCodeCharacterCountMin) ||
                (inSecurityCode.count == AcceptSDKCardFieldsValidatorConstants.kInAppSDKSecurityCodeCharacterCountMax)) {
                result = true
            }
        }

        return result
    }
    
    @objc func validateZipCodeWithString(_ inZipCode: String) -> Bool {
        var result = false
        
        if AcceptSDKStringValidator.isNumber(inZipCode) {
            if (inZipCode.count == AcceptSDKCardFieldsValidatorConstants.kInAppSDKZipCodeCharacterCountMax) {
                result = true
            }
        }
        
        return result
    }
    
    //!--------------------------------------------- advance validation -----------------------------------
    
    @objc open func validateCardWithLuhnAlgorithm(_ inCardNumber: String) -> Bool {
        var result = false
        
        let tempCardNumber = inCardNumber.replacingOccurrences(of: String.space(), with: String())
        
        if inCardNumber.count > 0 {
            let elementsCount = tempCardNumber.count
            var arrayOfIntegers = [Int?](repeating: nil, count: elementsCount)

            for (index, _) in tempCardNumber.enumerated() {
                let charIndex = tempCardNumber.index(tempCardNumber.startIndex, offsetBy: index)
                let tempStr = String(tempCardNumber.suffix(from: charIndex))
                let singleCharacter = String(tempStr.prefix(1))//String(tempStr.characters.first)
                
                arrayOfIntegers[tempCardNumber.count - 1 - index] = Int(singleCharacter)
            }
            
            for (index, _) in tempCardNumber.enumerated() {
                if index%2 != 0 {
                    arrayOfIntegers[index] = arrayOfIntegers[index]! * 2
                }
            }
            
            var theSum = 0
            for (index, _) in tempCardNumber.enumerated() {
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

    @objc open func validateExpirationDate(_ inMonth: String, inYear:String) -> Bool {
        var result = false

        if (self.validateMonthWithString(inMonth) && self.validateYearWithString(inYear)) {
            //---  now date
            let nowDate = Date()
            
            //--- date expiration
            var comps = DateComponents()
            comps.day = 1
            comps.month = Int(inMonth)!
            if inYear.count == 2 {
                comps.year = 2000+Int(inYear)!
            } else if inYear.count == 4 {
                comps.year = Int(inYear)!
            }
            
            let expirationDate = Calendar.current.date(from: comps)
            
            //--- next month after expiration
            var monthComponents = DateComponents()
            monthComponents.month = 1
            
            let nextDayAfterExpirationDate = (Calendar.current as NSCalendar).date(byAdding: monthComponents, to: expirationDate!, options: NSCalendar.Options(rawValue: 0))
            
            let timeIntervalSinceDate = nextDayAfterExpirationDate!.timeIntervalSince(nowDate)
            result = (timeIntervalSinceDate > 0)
        }

        return result
    }
    
    @objc func validateExpirationDate(_ inExpirationDate: String) -> Bool {
        var result = false
        
        let monthRange = inExpirationDate.startIndex..<inExpirationDate.index(inExpirationDate.startIndex, offsetBy: 2)
        let month = inExpirationDate[monthRange]
        
        let yearRange = inExpirationDate.index(inExpirationDate.startIndex, offsetBy: 2)..<inExpirationDate.endIndex
        let year = inExpirationDate[yearRange]

        if self.validateExpirationDate(String(month), inYear: String(year)) {
            result = true
        }
        
        return result
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[start ..< end])
    }
}
