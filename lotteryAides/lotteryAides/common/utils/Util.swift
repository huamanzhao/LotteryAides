//
//  Utils.swift
//  Heymow
//
//  Created by zhouchao on 16/4/12.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import Foundation
import UIKit
import Photos
import HealthKit

class Util: NSObject {
    //检查是否为整型数据
    static func chechNumber(_ value: String) -> Bool {
        let NUMBER = "[0-9]?"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", NUMBER)
        if regextestmobile.evaluate(with: value){
            return true
        }else{
            return false
        }
    }
    
    static let chineseNumber = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
    static func convertChineseNumber(_ number: Int) -> String {
        if (number < 0 || number > 9) {
            return ""
        } else {
            return chineseNumber[number]
        }
    }
    
    static func getLabelHeight (_ content: String, font:UIFont, width: CGFloat) -> CGFloat {
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let boundingRect = content.boundingRect(with: CGSize(width: width, height: 10000.0), options: options, attributes: [NSFontAttributeName:font], context: nil)
        return boundingRect.size.height
    }
    
    /** 交换两个方法的实现（使A方法名指向B方法的实现，使B方法名指向A方法的实现） */
    static func swizzleMethodImplements (_ clazz: AnyClass, originalSelector: Selector, targetSelector: Selector, originalImpl: Method, targetImpl: Method) {
        //使original的方法名（引用），指向target方法的实现
        //注：之所以使用class_addMethod，是因为还需要保留original方法的实现，以备下面使用
        let didAddMethod = class_addMethod(clazz, originalSelector,
                                           method_getImplementation(targetImpl),
                                           method_getTypeEncoding(targetImpl));
        
        if (didAddMethod) {
            //使target的方法名（引用），指向original方法的实现
            class_replaceMethod(clazz, targetSelector,
                                method_getImplementation(originalImpl),
                                method_getTypeEncoding(originalImpl));
        } else {
            //若操作未成功，则直接交换两个方法的实现
            method_exchangeImplementations(originalImpl, targetImpl)
        }
    }
    
    //获取系统版本号
    static func getSystemVersion() -> Float {
        return UIDevice.current.systemVersion.toFloat()
    }

}
