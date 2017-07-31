//
//  ExtString.swift
//  Heymow
//
//  Created by Icefly on 16/4/28.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension String {
    func isPhoneNumber() -> Bool {
        let MOBILE_PATTEN = "^[1][3,4,5,7,8][0-9]{9}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBILE_PATTEN)
        
        if regextestmobile.evaluate(with: self) == true {
            return true
        }
        
        return false
    }
    
    func isValidPassword() -> Bool {
        let MOBILE_PATTEN = "^[0-9a-zA-Z]{6,8}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBILE_PATTEN)
        
        if regextestmobile.evaluate(with: self) == true {
            return true
        }
        
        return false
    }
    
    //字符串转换成CGFloat
    public func toCGFloat() -> CGFloat {
        if let number = NumberFormatter().number(from: self) {
            return CGFloat(number)
        }
        
        return 0.0
    }
    
    //字符串转换成CGFloat
    public func toFloat() -> Float {
        if let number = NumberFormatter().number(from: self) {
            return Float(number)
        }
        
        return 0.0
    }
    
    
}

