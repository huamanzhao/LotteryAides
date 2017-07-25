//
//  TxExtextension UIFont {     static func defaultFontOfSize(fontSize: CGFloat) -> UIFont {         var font = UIFont(name: "PingFangSC-Light", size: fontSize)          if font == nil {             font = UIFont.swift
//  Heymow
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension UIFont {
    static func defaultFontOfSize(_ fontSize: CGFloat, fitScreen: Bool = false) -> UIFont {
        let targetSize = fitScreen ? getResizePoint(fontSize) : fontSize
        var font = UIFont(name: "FZLanTingKanHei-R-GBK", size: targetSize)
        
        if font == nil {
            font = UIFont.systemFont(ofSize: targetSize)
        }
        
        return font!
    }
    
    static func dcBlackFontOfSize(_ fontSize: CGFloat, fitScreen: Bool = false) -> UIFont {
        let targetSize = fitScreen ? getResizePoint(fontSize) : fontSize
        return UIFont(name: "DINCond-Black", size: targetSize)!
    }
        
    static func getResizePoint(_ fontSize: CGFloat) -> CGFloat {
        let deviceModel = TXUtil.getCurrentDeviceModel()
        var reSize = fontSize
        
        if deviceModel.contains("Plus") {
            reSize = reSize * 1.2
        } else if deviceModel.contains("6") {
            reSize = reSize * 1.1
        }
        
        return reSize
    }
}

extension UIFont {
    class var defaultFontFamily: String { return "FZLanTingKanHei-R-GBK" }
    override open class func initialize() {
        struct Static {
            static var token: Int = 0
        }

//        dispatch_once(&Static.token) {
//            if self == UIFont.self {
//                swizzleSystemFont()
//            }
//        }
        DispatchQueue.once(token: "font_default") { 
            if self == UIFont.self {
                swizzleSystemFont()
            }
        }
    }
    
    fileprivate class func swizzleSystemFont(){
        //替换掉preferredFontForTextStyle方法
//        let systemPreferredFontMethod = class_getClassMethod(self, #selector(UIFont.preferredFont(forTextStyle:)(_:)))
        let systemPreferredFontMethod = class_getClassMethod(self, #selector(UIFont.preferredFont(forTextStyle:)))
        let mySystemPreferredFontMethod = class_getClassMethod(self, #selector(UIFont.myPreferredFontForTextStyle(_:)))
        method_exchangeImplementations(systemPreferredFontMethod, mySystemPreferredFontMethod)
        
        //替换掉systemFontOfSize方法
        let systemFontMethod = class_getClassMethod(self, #selector(UIFont.systemFont(ofSize:)))
        let mySystemFontMethod = class_getClassMethod(self, #selector(UIFont.mySystemFontOfSize(_:)))
        method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        
        //替换掉boldSystemFontOfSize方法
//        let boldSystemFontMethod = class_getClassMethod(self, #selector(UIFont.boldSystemFontOfSize(_:)))
//        let myBoldSystemFontMethod = class_getClassMethod(self, #selector(UIFont.myBoldSystemFontOfSize(_:)))
//        method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        
        //替换掉italicSystemFontOfSize方法
        let italicSystemFontMethod = class_getClassMethod(self, #selector(UIFont.italicSystemFont(ofSize:)))
        let myItalicSystemFontMethod = class_getClassMethod(self, #selector(UIFont.myItalicSystemFontOfSize(_:)))
        method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
    }
}
// MARK: - New Font Methods
extension UIFont {
    @objc fileprivate class func myPreferredFontForTextStyle(_ style: String) -> UIFont {
        let defaultFont = myPreferredFontForTextStyle(style)
        let newDescriptor = defaultFont.fontDescriptor.withFamily(defaultFontFamily)
        return UIFont(descriptor: newDescriptor, size: defaultFont.pointSize)
    }
    
    @objc fileprivate class func mySystemFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return myDefaultFontOfSize(fontSize)
    }
    
    @objc fileprivate class func myBoldSystemFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return myDefaultFontOfSize(fontSize, withTraits: .traitBold)
    }
    
    @objc fileprivate class func myItalicSystemFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return myDefaultFontOfSize(fontSize, withTraits: .traitItalic)
    }
    
    fileprivate class func myDefaultFontOfSize(_ fontSize: CGFloat, withTraits traits: UIFontDescriptorSymbolicTraits = []) -> UIFont {
        let descriptor = UIFontDescriptor(name: defaultFontFamily, size: fontSize).withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: fontSize)
    }
}
