//
//  ExtUIView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

private func roundbyunit(_ num: Double, _ unit: inout Double) -> Double {
    let remain = modf(num, &unit)
    if (remain > unit / 2.0) {
        return ceilbyunit(num, &unit)
    } else {
        return floorbyunit(num, &unit)
    }
}
private func ceilbyunit(_ num: Double, _ unit: inout Double) -> Double {
    return num - modf(num, &unit) + unit
}

private func floorbyunit(_ num: Double, _ unit: inout Double) -> Double {
    return num - modf(num, &unit)
}

private func pixel(_ num: Double) -> Double {
    var unit = 0.0
    switch Int(UIScreen.main.scale) {
    case 1: unit = 1.0 / 1.0
    case 2: unit = 1.0 / 2.0
    case 3: unit = 1.0 / 3.0
    default: unit = 0.0
    }
    
    return roundbyunit(num, &unit)
}


extension UIView {
    func addCorner(_ radius: CGFloat) {
        self.addCorner(radius: radius, borderWidth: 1, backColor: UIColor.clear, borderColor: UIColor.black)
    }
    
    func addCorner(radius: CGFloat,
                   borderWidth: CGFloat,
                   backColor: UIColor,
                   borderColor: UIColor) {
        let image = drawRectWithRoundedCorner(radius: radius, borderWidth: borderWidth, backgroundColor: backColor, borderColor: borderColor)
        let imageView = UIImageView(image: image)
        self.insertSubview(imageView, at: 0)
    }
    
    func drawRectWithRoundedCorner(radius: CGFloat,
                                   borderWidth: CGFloat,
                                   backgroundColor: UIColor,
                                   borderColor: UIColor) -> UIImage {
        let sizeToFit = CGSize(width: pixel(Double(self.bounds.size.width)), height: Double(self.bounds.size.height))
        let halfBorderWidth = CGFloat(borderWidth / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(borderWidth)
        context.setStrokeColor(borderColor.cgColor)
        context.setFillColor(backgroundColor.cgColor)
        
        let width = sizeToFit.width, height = sizeToFit.height
        let startPoint =   CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth)
        
        let rightDownOut = CGPoint(x: width - halfBorderWidth, y: height - halfBorderWidth)
        let rightDownIn  = CGPoint(x: width - radius - halfBorderWidth, y: height - halfBorderWidth)
        
        let leftDownOut = CGPoint(x: halfBorderWidth, y: height - halfBorderWidth)
        let leftDownIn = CGPoint(x: halfBorderWidth, y: height - radius - halfBorderWidth)
        
        let leftUpOut = CGPoint(x: halfBorderWidth, y: halfBorderWidth)
        let leftUpIn = CGPoint(x: width - halfBorderWidth, y: halfBorderWidth)
        
        let rightUpOut = CGPoint(x: width - halfBorderWidth, y: halfBorderWidth)
        let rightUpIn = CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth)
        
        context.move(to: startPoint)  // 开始坐标右边开始
        context.addArc(tangent1End: rightDownOut, tangent2End: rightDownIn, radius: radius) //右下角圆弧
        context.addArc(tangent1End: leftDownOut, tangent2End: leftDownIn, radius: radius)   //左下角圆弧
        context.addArc(tangent1End: leftUpOut, tangent2End: leftUpIn, radius: radius)       //左上角
        context.addArc(tangent1End: rightUpOut, tangent2End: rightUpIn, radius: radius)     //右上角
        
        context.drawPath(using: .fillStroke)
        
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
}

extension UIImage {
    func drawRectWithRoundedCorner(_ radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        let size = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: size)
        
        let context = UIGraphicsGetCurrentContext()!
        context.addPath(path.cgPath)
        
        self.draw(in: rect)
        
        context.drawPath(using: .fillStroke)
        
        let output = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return output
    }
}

extension UIImageView {
    /**
     * !!!只有当 imageView 不为nil 时，调用此方法才有效果
     * param: radius 圆角半径
     */
    override func addCorner(_ radius: CGFloat) {
        self.image = self.image!.drawRectWithRoundedCorner(radius, self.bounds.size)
    }
}
