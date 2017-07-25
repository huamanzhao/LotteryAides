//
//  TXExtString.swift
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
    
//    var md5String: String{
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
//        
//        CC_MD5(str!, strLen, result);
//        
//        let hash = NSMutableString();
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i]);
//        }
//        result.deinitialize();
//        
//        return String(format: hash as String)
//    }
    
    //字符串按照指定格式转换成NSDate
    public func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
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

