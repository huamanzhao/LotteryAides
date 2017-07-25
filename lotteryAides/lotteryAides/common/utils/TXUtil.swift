//
//  TXUtils.swift
//  Heymow
//
//  Created by zhouchao on 16/4/12.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import Foundation
import UIKit
import Photos
import HealthKit

class TXUtil: NSObject {
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
    
    static func checkPhoneNumInput(_ phoneNumber : String) -> Bool{
        let MOBILE = "^[1][3,4,5,7,8][0-9]{9}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBILE)
        if regextestmobile.evaluate(with: phoneNumber){
            return true
        }else{
            return false
        }
    }
    
    static func checkIDNumber(_ idNumber : String) -> Bool{
        let IDNUMBER = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}[xX0-9]$"
        let regextestid = NSPredicate(format: "SELF MATCHES %@", IDNUMBER)
        if regextestid.evaluate(with: idNumber){
            return true
        }else{
            return false
        }
    }
    
    static func checkPassword(_ passWord : String) -> Bool{
//        let PASSWORD = "^[0-9a-zA-Z_]+{6,25}$"
        let PASSWORD = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,25}$"
        let regextestpass = NSPredicate(format: "SELF MATCHES %@", PASSWORD)
        if regextestpass.evaluate(with: passWord){
            return true
        }else{
            return false
        }
    }
    
    //检测字符串长度是否在指定长度范围内，一个汉字占两个字符位
    static func checkWordLength(_ word: String, maxLen: Int) -> Bool {
        let CHINESE = "^[\\u4E00-\\u9FA5]$"     //中文字符
        let regextestpass = NSPredicate(format: "SELF MATCHES %@", CHINESE)
        
        var length = 0
        for char in word.characters {
            let character = String(char)
            if regextestpass.evaluate(with: character) {
                length += 2
            }
            else {
                length += 1
            }
        }
        
        return maxLen >= length
    }
    
    static func getCurrentDeviceModel() -> String{
        let name = UnsafeMutablePointer<utsname>.allocate(capacity: 1)
        uname(name)
        let machine = withUnsafePointer(to: &name.pointee.machine, { (ptr) -> String? in
            
            let int8Ptr = unsafeBitCast(ptr, to: UnsafePointer<CChar>.self)
            return String(cString: int8Ptr)
        })
        name.deallocate(capacity: 1)
        if machine == "iPhone1,1"{
            return "iPhone 2G"
        }else if machine == "iPhone1,2"{
            return "iPhone 3G"
        }else if machine == "iPhone2,1"{
            return "iPhone 3GS"
        }else if machine == "iPhone3,1"{
            return "iPhone 4"
        }else if machine == "iPhone3,2"{
            return "iPhone 4"
        }else if machine == "iPhone3,3"{
            return "iPhone 4"
        }else if machine == "iPhone4,1"{
            return "iPhone 4S"
        }else if machine == "iPhone5,1"{
            return "iPhone 5"
        }else if machine == "iPhone5,2"{
            return "iPhone 5"
        }else if machine == "iPhone5,3"{
            return "iPhone 5c"
        }else if machine == "iPhone5,4"{
            return "iPhone 5c"
        }else if machine == "iPhone6,1"{
            return "iPhone 5s"
        }else if machine == "iPhone6,2"{
            return "iPhone 5s"
        }else if machine == "iPhone7,1"{
            return "iPhone 6 Plus"
        }else if machine == "iPhone7,2"{
            return "iPhone 6"
        }else if machine == "iPhone8,1"{
            return "iPhone 6S Plus"
        }else if machine == "iPhone8,2"{
            return "iPhone 6S"
        }else if machine == "iPod1,1"{
            return "iPod Touch 1G"
        }else if machine == "iPod2,1"{
            return "iPod Touch 2G"
        }else if machine == "iPod3,1"{
            return "iPod Touch 3G"
        }else if machine == "iPod4,1"{
            return "iPod Touch 4G"
        }else if machine == "iPod5,1"{
            return "iPod Touch 5G"
        }else if machine == "iPad1,1"{
            return "iPad 1G"
        }else if machine == "iPad2,1"{
            return "iPad 2"
        }else if machine == "iPad2,2"{
            return "iPad 2"
        }else if machine == "iPad2,3"{
            return "iPad 2"
        }else if machine == "iPad2,4"{
            return "iPad 2"
        }else if machine == "iPad2,5"{
            return "iPad Mini 1G"
        }else if machine == "iPad2,6"{
            return "iPad Mini 1G"
        }else if machine == "iPad2,7"{
            return "iPad Mini 1G"
        }else if machine == "iPad3,1"{
            return "iPad 3"
        }else if machine == "iPad3,2"{
            return "iPad 3"
        }else if machine == "iPad3,3"{
            return "iPad 3"
        }else if machine == "iPad3,4"{
            return "iPad 4"
        }else if machine == "iPad3,5"{
            return "iPad 4"
        }else if machine == "iPad3,6"{
            return "iPad 4"
        }else if machine == "iPad4,1"{
            return "iPad Air"
        }else if machine == "iPad4,2"{
            return "iPad Air"
        }else if machine == "iPad4,3"{
            return "iPad Air"
        }else if machine == "iPad4,4"{
            return "iPad Mini 2G"
        }else if machine == "iPad4,5"{
            return "iPad Mini 2G"
        }else if machine == "iPad4,6"{
            return "iPad Mini 2G"
        }else{
            return "unknown device"
        }
    }
    /*
     只传入年月日
     */
    func getTimesFromStartDate(_ startDate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: startDate + " 00:00:00")
        return NSString(format: "%.0f000", date!.timeIntervalSince1970) as String
    }
    
    /*
     只传入年月日
     */
    func getTimesFromEndDate(_ endDate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: endDate + " 23:59:59")
        return NSString(format: "%.0f000", date!.timeIntervalSince1970) as String
    }
    
    //MARK: 键盘弹出、退出动画
    
    /*
     * 获取键盘高度
     */
//    func getKeyBoardHeight() -> CGFloat {
//        var keyboardHeight = NSUserDefaults.standardUserDefaults().objectForKey("keyBoardHeight")
//        
//        if keyboardHeight == nil {
//            keyboardHeight = 224  //首次弹出时，textfieldAppear先于keyboardShow, UserDefault尚未获取到键盘高度
//        }
//        
//        let height = keyboardHeight as! CGFloat
//        
//        return height
//    }
//    
//    /*
//     * 键盘弹出，视图上移的动画
//     */
//    func keyboardAppearAnimation(inView currView:UIView, textBottom bottom:CGFloat) {
//        let keyboardHeight = HBUtil().getKeyBoardHeight()
//        
//        keyboardShowOffset = keyboardHeight - (currView.frame.size.height - bottom);
//        if keyboardShowOffset > 0 {
//            UIView.animateWithDuration(0.3) { () -> Void in
//                var viewFrame = currView.frame
//                viewFrame.origin.y -= keyboardShowOffset!
//                currView.frame = viewFrame
//            }
//        }
//    }
//    
//    /*
//     * 键盘收起，视图下移的动画
//     */
//    func keyboardDisappearAnimation(inView currView:UIView) {
//        UIView.animateWithDuration(0.2) { () -> Void in
//            var viewFrame = currView.frame
//            viewFrame.origin.y += keyboardShowOffset!
//            currView.frame = viewFrame
//        }
//    }
    
    /*
     * 键盘高度变化，视图上下移动的动画
     func keyboardFrameChangedAnimation(currHeight:CGFloat) {
     UIView.animateWithDuration(0.25) { () -> Void in
     let prevHeight  = HBUtil().getKeyBoardHeight()
     
     let window: UIWindow = UIApplication.sharedApplication().keyWindow!
     let currView = window.rootViewController?.view
     var viewFrame = currView?.frame
     viewFrame?.origin.y -= currHeight - prevHeight
     currView?.frame = viewFrame!
     }
     }
     */
    
    /* 生成数据库的主键ID */
    static func generateID() -> String {
        let uuid = UUID().uuidString
//        let id = uuid.stringByReplacingOccurrencesOfString("-", withString: "").lowercased()
        let id = uuid.replacingOccurrences(of: "-", with: "").lowercased()
        return id
    }
    
    static func getImageUrl (_ imageUrlStr: String) -> URL {
        var imageUrl = URL(string: imageUrlStr)
        
//        if !imageUrlStr.isEmpty {
//            return NSURL(string: "http://file.ynet.com/2/1604/29/11244835.jpg")!
//        }
        
        if !imageUrlStr.contains("http://") {
            imageUrl = URL(string: TXConstants.imageBaseUrl + "/" + imageUrlStr)
        }
        
        return imageUrl!
    }
    
    static func getImageSize(_ imageUrlStr: String?) -> CGSize? {
        if imageUrlStr == nil {
            return nil
        }
        
        //图片地址的格式一般为：abcdefg_560X800.jpg
        if !imageUrlStr!.contains(".") || !imageUrlStr!.contains("_") || !imageUrlStr!.contains("X"){
            return nil
        }
        
        //取"_"后面的部分 560X800.jpg
        let sizeString = imageUrlStr!.components(separatedBy: "_")[1]
        //取“.”前面的部分 abcdefg_560X800
        let prefix = sizeString.components(separatedBy: ".")[0]
        //取宽高
        let sizeArr = prefix.components(separatedBy: "X")
        if let width  = Double(sizeArr[0]) {
            if let height = Double(sizeArr[1]) {
                let size = CGSize(width: CGFloat(width), height: CGFloat(height))
                return size
            }
        }
        
        return nil
    }

//
//    static func getGroupImage(avatar: String) -> UIImage {
//        var image : UIImage = UIImage(named: "bg_family")!  //默认图片
//        if avatar != "" {
//            let imageUrl = HBUtil.getImageUrl(avatar)
//            if  let imageData = NSData(contentsOfURL: imageUrl) {
//                if let newImage = UIImage(data: imageData) {
//                    image = newImage
//                }
//            }
//        }
//        
//        return image
//    }
    
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
    
    //TODO
    static func getRegistTime() -> Date {
        
//        let timeInterval = Double(TXUserConfig.getInstance().getSelfInfo().createTime)
//        if timeInterval == nil {
//            return NSDate()
//        }
        
       // let registDate = NSDate(timeIntervalSince1970: timeInterval! / 1000)
        
//        return registDate
        return Date()
    }
    
    //根据ID获取商圈名称
    static func getAreaNameById(_ areaId: String) -> String {
        if areaId.isEmpty {
            return "空"
        }
        
        //TODO
        return "商圈"
    }
    
    //获取目标地点到自己的距离
    static func getDistanceToMe() -> String {
        //TODO
        
        return "1.4km"
    }
    
    //显示可读米数
    static func getReadableDistance(_ distance: Double) -> String {
        if distance > 1000 {
            return NSString(format: "%.1fkm", distance/1000) as String
        }else if distance < 100 {
            return "<100m"
        }else if distance <= 1000 {
            return NSString(format: "%.0fm", distance) as String
        }
        return "1"
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
    
    /** 创建二维码 */
    static func createQRCode(_ string: String) -> UIImage {
        // 建立一个滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        // 重设滤镜的初始值
        qrFilter!.setDefaults()
        // 通过 KVC 设置滤镜的内容
        qrFilter!.setValue(string.data(using: String.Encoding.utf8, allowLossyConversion: true), forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        // 输出图像
        let ciImage = qrFilter!.outputImage
        // 打印生成图片的大小，生成的图像 23 * 23
        print(ciImage!.extent)
        
        // 过滤图像单色彩以及`形变`的滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter!.setDefaults()
        colorFilter!.setValue(ciImage, forKey: "inputImage")
        // 不能直接用 UIColor 转换，会崩溃
        //  colorFilter.setValue(UIColor.redColor().CIColor, forKey: "inputColor0")
        // 前景色
        colorFilter!.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        // 背景色
        colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let transform = CGAffineTransform(scaleX: 9, y: 9)
        let transformImage = colorFilter!.outputImage!.applying(transform)
        
        let codeImage = UIImage(ciImage: transformImage)
        /* 合成二维码时中间的头像部位 */
        let avatarImage = UIImage(named: "qrCode_image")
        
        let QRImage = insertAvatarImage(codeImage, avatarImage: avatarImage!)
        return QRImage
    }
    
    /** 合成二维码中心图像 */
    static func insertAvatarImage(_ codeImage: UIImage, avatarImage: UIImage) -> UIImage {
        
        let size = codeImage.size
        // 1. 开启图像的上下文
        UIGraphicsBeginImageContext(size)
        // 2. 绘制二维码图像
        codeImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 3. 计算头像的大小
        let w = size.width * 0.25
        let h = size.height * 0.25
        let x = (size.width - w) * 0.5
        let y = (size.height - h) * 0.5
        
        avatarImage.draw(in: CGRect(x: x, y: y, width: w, height: h))
        // 4. 从上下文中取出图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func formatCodeNo (_ code: String) -> String {
        var codeStrs = [NSString]()
        var codeStr: NSString = code as NSString
        
        while codeStr.length >= 4 {
            codeStrs.append(codeStr.substring(to: 4) as NSString)
            codeStr = codeStr.substring(from: 4) as NSString
        }
        
        if codeStr.length > 0 {
            codeStrs.append(codeStr)
        }
        
        var codeNo = ""
        for (index, str) in codeStrs.enumerated() {
            codeNo.append(str as String)
            if index < codeStrs.count - 1 {
                codeNo.append(" ")
            }
        }
        
        return codeNo
    }

}
