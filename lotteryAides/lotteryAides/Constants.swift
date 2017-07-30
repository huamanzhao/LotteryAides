//
//  Util.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/26.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation

let SENIOR_TYPE = "senior"
let BASIC_TYPE  = "basic"


/*正式服务地址 */
let serverUrl = "https://www.szlexuetang.com/"


//缓存路径
let cacheUrl = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/Caches"

struct Constants {
    //屏幕尺寸获取
    static let screenSize   = UIScreen.main.bounds.size
    static let screenWidth  = UIScreen.main.bounds.maxX
    static let screenHeight = UIScreen.main.bounds.maxY
    static let screenCenter = CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY / 2)
    
    //系统颜色设置
//    static var bgColor = UIColor(hex: 0x1b1b1b)
//    static var subBgColor = UIColor(hex: 0x202020)
    static var textColor = UIColor(hex: 0xDDDDDD)
//    static var sectionTextColor = UIColor(hex: 0x888888)
    
    static var mainColor = UIColor(hex: 0xf9d247)   //杏黄
    static var subColor = UIColor(hex: 0xd42d38)    //玫红
//    static var barColor = UIColor(hex: 0xf9d247)
//    
//    static var detailBg = UIColor.white
    static var deatilSubBg = UIColor(hex: 0xeeeeee)
    
    static let serverBaseUrl = serverUrl
}
