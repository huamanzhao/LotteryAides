//
//  TXExtGradientLayer.swift
//  Heymow
//
//  Created by qizidong on 16/5/6.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension UIView {
    func insertGradientLayer(_ colors: [CGColor] = [TXSettings.mainColor.cgColor], locations: [CGFloat] = [0, 0.5, 1.0]) -> CAGradientLayer {
        var newColors = colors
        
        if newColors.count == 1 {
            let components = colors[0].components
            let color = UIColor(red: (components?[0])!*0.7, green: (components?[1])!*0.7, blue: (components?[2])!*0.7, alpha: 1).cgColor
            newColors.insert(color, at: 0)
            newColors.append(color)
        }
        
        let colorLayer = CAGradientLayer()
        colorLayer.colors = newColors
        colorLayer.locations = locations as [NSNumber]?
        colorLayer.startPoint = CGPoint(x: 0, y: 0.5)
        colorLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(colorLayer, at: 0)
        return colorLayer
    }
    
    func insertDashBorderLayer(_ borderColor: CGColor, fillColor: CGColor) -> CAShapeLayer {
        let borderLayer = CAShapeLayer()
        borderLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width-2, height: self.frame.height-1), cornerRadius: self.cornerRadius).cgPath
        borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width-2, height: self.frame.height-1)//self.bounds
        borderLayer.lineWidth = 1
        borderLayer.lineDashPattern = [5, 5]
        borderLayer.strokeColor = borderColor
        borderLayer.strokeStart = 0
        borderLayer.strokeEnd = 1
        borderLayer.fillColor = fillColor
        borderLayer.lineCap = "square"
//        self.layer.insertSublayer(borderLayer, atIndex: 0)
        return borderLayer
    }
    
    func drawDashLineImage(_ rect: CGRect) -> UIImageView {//这个方法绘制了一张虚线图片并返回
        let imageView = UIImageView(frame: rect)
//        imageView.backgroundColor = UIColor.blueColor()
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let dashLineGap = rect.maxX * 0.05                  //设置虚线距离左右距离
        let dashLineY: CGFloat = 10
        //UIColor.lightGrayColor().setStroke()
        context!.setStrokeColor(TXSettings.mainColor.cgColor)
        context!.move(to: CGPoint(x: rect.minX + dashLineGap, y: rect.maxY - dashLineY))
        context!.addLine(to: CGPoint(x: rect.maxX - dashLineGap, y: rect.maxY - dashLineY))
//        CGContextSetLineDash(context!, 0, [2, 1], 1)
        context?.setLineDash(phase: 0, lengths: [2, 1])
        context!.strokePath()
        let dashLine = UIGraphicsGetImageFromCurrentImageContext()
        imageView.image = dashLine
        UIGraphicsEndImageContext()
        return imageView
    }
}

extension UIView {    
    @IBInspectable var cornerRadius: CGFloat {  //重点是IBInspectable
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
