//
//  TXExtUIButton.swift
//  Heymow
//
//  Created by Icefly on 16/5/12.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension UIButton {
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
        if let titleLabel = self.titleLabel {
            //根据屏幕尺寸计算出适配的大小
            let fitSize = UIFont.getResizePoint(titleLabel.font.pointSize)
            
            //重新获取适配后的字体
            titleLabel.font = titleLabel.font.withSize(fitSize)
        }
    }
}

extension UIButton {
    override open class func initialize() {
        //由于initialize方法可能会被调用多次，使用dispatch_once确保方法互换只被调用一次
        struct Static {
            static var token: Int = 0
        }
        
//        dispatch_once(&Static.token) {
//            if self == UIButton.self {
//                swizzleSystemButton()
//            }
//        }
        
        DispatchQueue.once(token: "defaultButton") { 
            if self == UIButton.self {
                swizzleSystemButton()
            }
        }
        
    }
    
    fileprivate class func swizzleSystemButton() {
        //替换掉initWithFrame方法
        //获取两个方法的引用（也就是方法名）
//        let systemInitWithFrameSelector = #selector(UIButton.init(frame:))
//        let myInitWithFrameSelector = #selector(UIButton.myInit(_:))
//        
//        //获取两个方法的实现
//        let systemInitWithFrameMethod = class_getInstanceMethod(self, systemInitWithFrameSelector)
//        let myInitWithFrameMethod = class_getInstanceMethod(self, myInitWithFrameSelector)
//        
//        //交换两个方法的实现
//        TXUtil.swizzleMethodImplements(self, originalSelector: systemInitWithFrameSelector,
//                                       targetSelector: myInitWithFrameSelector,
//                                       originalImpl: systemInitWithFrameMethod,
//                                       targetImpl: myInitWithFrameMethod)
        
        //替换掉awakeFromNib方法（原理同上，注释略）
        let systemAwakeFromNibSelector = #selector(UIButton.awakeFromNib)
        let myAwakeFromNibSelector = #selector(UIButton.myAwakeFromNib)
        
        let systemAwakeFromNibMethod = class_getInstanceMethod(self, systemAwakeFromNibSelector)
        let myAwakeFromNibMethod = class_getInstanceMethod(self, myAwakeFromNibSelector)
        
        TXUtil.swizzleMethodImplements(self, originalSelector: systemAwakeFromNibSelector,
                                       targetSelector: myAwakeFromNibSelector,
                                       originalImpl: systemAwakeFromNibMethod!,
                                       targetImpl: myAwakeFromNibMethod!)
    }
}

// MARK: - New Font Methods
extension UIButton {
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
        if let titleLabel = self.titleLabel {
            if titleLabel.font.fontDescriptor.postscriptName == ".SFUIText-Regular" {
                let font = UIFont.defaultFontOfSize(titleLabel.font.pointSize)
                titleLabel.font = font
            }
        }
    }
}
