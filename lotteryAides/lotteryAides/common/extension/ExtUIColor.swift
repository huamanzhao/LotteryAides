//
//  UIColorExtension.swift
//  Heymow
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
}


