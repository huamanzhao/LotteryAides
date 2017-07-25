//
//  TXExtLabel.swift
//  Heymow
//
//  Created by Icefly on 16/5/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable var fitScreen: Bool {
        get {
            return self.fitScreen
        }
        
        set {
            if newValue {
                fontFitScreen()
            }
        }
    }
    
    func fontFitScreen() {
        //根据屏幕尺寸计算出适配的大小
        let fitSize = UIFont.getResizePoint(self.font.pointSize)
        
        //重新获取适配后的字体
        self.font = self.font.withSize(fitSize)
    }
}

extension UILabel {
    override open class func initialize() {
        struct Static {
            static var token: Int = 0
        }
        DispatchQueue.once(token: "label_default") {
            if self == UILabel.self {
                swizzleSystemLabel()
            }
        }
//        dispatch_once(&Static.token) {
//            if self == UILabel.self {
//                swizzleSystemLabel()
//            }
//        }
        
    }
    
    fileprivate class func swizzleSystemLabel() {
        //替换掉init方法
//        let systemInitSelector = #selector(NSObject.init)
//        let myInitSelector = #selector(UILabel.objInit)
//        
//        let systemInitMethod = class_getInstanceMethod(self, systemInitSelector)
//        let myInitMethod = class_getInstanceMethod(self, myInitSelector)
//        
//        //交换两个方法的实现
//        TXUtil.swizzleMethodImplements(self, originalSelector: systemInitSelector,
//                                       targetSelector: myInitSelector,
//                                       originalImpl: systemInitMethod,
//                                       targetImpl: myInitMethod)
        
        //替换掉initWithFrame方法
//        let systemInitWithFrameSelector = #selector(UILabel.init(frame:))
//        let myInitWithFrameSelector = #selector(UILabel.myInit(_:))
//
//        let systemInitWithFrameMethod = class_getInstanceMethod(self, systemInitWithFrameSelector)
//        let myInitWithFrameMethod = class_getInstanceMethod(self, myInitWithFrameSelector)
//        
//        TXUtil.swizzleMethodImplements(self, originalSelector: systemInitWithFrameSelector,
//                                       targetSelector: myInitWithFrameSelector,
//                                       originalImpl: systemInitWithFrameMethod,
//                                       targetImpl: myInitWithFrameMethod)
        
        //替换掉awakeFromNib方法
        let systemAwakeFromNibSelector = #selector(UILabel.awakeFromNib)
        let myAwakeFromNibSelector = #selector(UILabel.myAwakeFromNib)

        let systemAwakeFromNibMethod = class_getInstanceMethod(self, systemAwakeFromNibSelector)
        let myAwakeFromNibMethod = class_getInstanceMethod(self, myAwakeFromNibSelector)
        
        TXUtil.swizzleMethodImplements(self, originalSelector: systemAwakeFromNibSelector,
                                       targetSelector: myAwakeFromNibSelector,
                                       originalImpl: systemAwakeFromNibMethod!,
                                       targetImpl: myAwakeFromNibMethod!)
    }
}

// MARK: - New Font Methods
extension UILabel {
    @objc func objInit() {
        self.objInit()
        replaceSystemFont()
    }
    
    @objc func myInit(_ frame: CGRect) {
        self.myInit(frame)
        replaceSystemFont()
    }
    
    @objc func myAwakeFromNib() {
        self.myAwakeFromNib()
        replaceSystemFont()
    }
    
    func replaceSystemFont() {
        //替换掉系统默认字体，但不修改在xib中单独设置过的字体
        if self.font.fontDescriptor.postscriptName == ".SFUIText-Regular" {
            let font = UIFont.defaultFontOfSize(self.font.pointSize)
            self.font = font
        }
    }
}
