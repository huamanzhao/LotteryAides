//
//  TxExtUIImage.swift
//  Heymow
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension UIImage {
    /** 源于色彩的UIImage，可自定义size */
    class func imageWithColor(_ color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1), size: CGSize = CGSize(width: 1, height: 1), cornerRadius: CGFloat = 0.0) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        //开启一个图形上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        //获取图形上下文
        let context = UIGraphicsGetCurrentContext()
        
        let thumbPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        context!.addPath(thumbPath.cgPath)
        context!.setFillColor(color.cgColor)
        context!.fillPath()
        
        //获取图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        return image!;
    }
    
    /** 源于色彩的UIImage，可自定义size */
    class func borderWithColor(_ color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1), size: CGSize = CGSize(width: 1, height: 1), borderWidth: CGFloat = 1.0, cornerRadius: CGFloat = 0.0) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        //开启一个图形上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        //获取图形上下文
        let context = UIGraphicsGetCurrentContext()
        
        let maxX = size.width
        let maxY = size.height

        //绘制曲线
        context!.move(to: CGPoint(x: maxX, y: 0))
//        CGContextAddArcToPoint(context!, maxX, 0, maxX, maxY, cornerRadius)
//        CGContextAddArcToPoint(context!, maxX, maxY, 0, maxY, cornerRadius)
//        CGContextAddArcToPoint(context!, 0, maxY, 0, 0, cornerRadius)
//        CGContextAddArcToPoint(context!, 0, 0, maxX, 0, cornerRadius)
        context?.addArc(tangent1End: CGPoint(x: maxX, y: 0), tangent2End: CGPoint(x: maxX, y: maxY), radius: cornerRadius)
        context?.addArc(tangent1End: CGPoint(x: maxX, y: maxY), tangent2End: CGPoint(x: 0, y: maxY), radius: cornerRadius)
        context?.addArc(tangent1End: CGPoint(x: 0, y: maxY), tangent2End: CGPoint(x: 0, y: 0), radius: cornerRadius)
        context?.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: maxX, y: 0), radius: cornerRadius)
        //闭合path，绘制直线5
        context!.closePath()
//        CGContextSetLineDash(context, 0, [5,4], 2)//虚线的长度与间隔
        context!.setLineWidth(borderWidth)
        context!.setStrokeColor(color.cgColor)
        context!.drawPath(using: CGPathDrawingMode.stroke)//绘制路径
        
//        let thumbPath = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: cornerRadius)
//        CGContextAddPath(context, thumbPath.CGPath)
//        CGContextSetStrokeColorWithColor(context, color.CGColor)
//        CGContextSetLineWidth(context, borderWidth)
//        CGContextDrawPath(context, CGPathDrawingMode.Stroke)//绘制路径
        
        //获取图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        return image!;
    }
    
    /* 调用这个方法绘制一个虚线框图片 */
    class func dashBorderImageWith(_ rect: CGRect, color: CGColor, borderWidth: Int) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let radius:CGFloat = 5.0
        let buttonRect = rect
        context!.move(to: CGPoint(x: buttonRect.maxX, y: buttonRect.minY))
        //绘制曲线
//        CGContextAddArcToPoint(context!, buttonRect.maxX, buttonRect.minY, buttonRect.maxX, buttonRect.maxY, radius)
//        CGContextAddArcToPoint(context!,buttonRect.maxX, buttonRect.maxY, buttonRect.minX, buttonRect.maxY, radius)
//        CGContextAddArcToPoint(context!, buttonRect.minX, buttonRect.maxY, buttonRect.minX, buttonRect.minY, radius)
//        CGContextAddArcToPoint(context!, buttonRect.minX, buttonRect.minY, buttonRect.maxX, buttonRect.minY, radius)
        
        context?.addArc(tangent1End: CGPoint(x: buttonRect.maxX, y: buttonRect.minY), tangent2End: CGPoint(x: buttonRect.maxX, y: buttonRect.maxY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: buttonRect.maxX, y: buttonRect.maxY), tangent2End: CGPoint(x: buttonRect.minX, y: buttonRect.maxY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: buttonRect.minX, y: buttonRect.maxY), tangent2End: CGPoint(x: buttonRect.minX, y: buttonRect.minY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: buttonRect.minX, y: buttonRect.minY), tangent2End: CGPoint(x: buttonRect.maxX, y: buttonRect.minY), radius: radius)
        //闭合path，绘制直线5
        context!.closePath()
//        CGContextSetLineDash(context!, 0, [5,1], 2)//虚线的长度与间隔
        context?.setLineDash(phase: 0, lengths: [5,1])
        //曲线边框与内部渲染
        context!.setStrokeColor(color)
//        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)//
        context!.drawPath(using: CGPathDrawingMode.stroke)//绘制路径
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithTintColor(_ tintColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tintColor, blendMode: CGBlendMode.destinationIn)
    }
    
    func imageWithGradientTintColor(_ tintColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tintColor, blendMode: CGBlendMode.overlay)
    }
    
    func imageWithTintColor(_ tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        
        draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        
        if (blendMode != CGBlendMode.destinationIn) {
            self.draw(in: bounds, blendMode:  CGBlendMode.destinationIn, alpha: 1.0)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage!
    }
    
    //设置图片的透明度
    func imageByApplyingAlpha(_ alpha: CGFloat) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
//        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
//        context?.scaleBy(x: 1, y: -1)
//        context?.translateBy(x: 0, y: -area.size.height)
//        context?.setBlendMode(.multiply)
        context?.setAlpha(CGFloat(alpha))
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
/** 将图片缓存到本地 并返回它的路径 */

extension UIImage {
    func fixOrientation(_ image: UIImage) -> UIImage{
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        switch image.imageOrientation {
        case UIImageOrientation.down:
            break
        case UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case UIImageOrientation.left:
            break
        case UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0);
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
            
        case UIImageOrientation.right:
            break
        case UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        default:
            break
        }
        
        switch (image.imageOrientation) {
        case UIImageOrientation.upMirrored:
            break
        case UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            break;
            
        case UIImageOrientation.leftMirrored:
            break
        case UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            break;
        default:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)
        ctx!.concatenate(transform)
        
        switch image.imageOrientation {
        case UIImageOrientation.left:
            break
        case UIImageOrientation.leftMirrored:
            break
        case UIImageOrientation.right:
            break
        case UIImageOrientation.rightMirrored:
            ctx!.draw(image.cgImage!, in: CGRect(x: 0,y: 0,width: image.size.height,height: image.size.width))
        default:
            ctx!.draw(image.cgImage!, in: CGRect(x: 0,y: 0,width: image.size.width,height: image.size.height))
        }
        let cgImage = ctx!.makeImage()
        let img = UIImage(cgImage: cgImage!)
        return img
    }
    
  
    
    func writeImageToLocal() -> String {
        let data = UIImageJPEGRepresentation(self, 0.5)
        
        //保存到tmp目录下
        let tempPath = NSTemporaryDirectory()
        let timeStr = TXDateUtil.formatDate("yyMMddHHmmssSS", date: Date())
        let imagePath = tempPath + "\(timeStr).jpg"
        
        let fm = FileManager.default
        do {
            try fm.createDirectory(atPath: tempPath, withIntermediateDirectories: true, attributes: nil)
            try fm.createFile(atPath: imagePath, contents: data, attributes: nil)
        }catch {
            
        }
        
        return imagePath
    }
}
