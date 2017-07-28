//
//  ExtUIImageView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/27.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation


extension UIImageView {
    func setImageTintColor(_ color: UIColor) {
        for sub in self.subviews {
            if sub.isKind(of: UIImage.self) {
//                let image = sub as! UIImage
//                image.tintColor = color
            }
        }
    }
}
