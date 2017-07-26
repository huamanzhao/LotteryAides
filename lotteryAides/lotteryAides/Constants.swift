//
//  ZCUtil.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/26.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation


/*本地服务地址 */
let localServerUrl  = "http://192.168.4.88:8080/HealthService"

/*正式服务地址 */
let serverUrl = "http://www.techealth.cn"
let imageUrl = "http://www.techealth.cn/HealthService"

/*Test服务地址 */
let serverUrlTest = "http://www.techealth.cn:8080/HealthService"
let imageUrlTest = "http://www.techealth.cn:8080/HealthService"

let plistUrl = "https://dn-hebca.qbox.me/qjtree1225.plist"
let downloadPlist = "itms-services://?action=download-manifest&url=https://dn-hebca.qbox.me/qjtree1225.plist"

let chunyuTestUrl = "https://test.chunyu.me"
let chunyuUrl = "https://www.chunyuyisheng.com"
let farmUrl = "http://www.techealth.cn:8080/HealthServiceTest/live.html#https://open.ys7.com/view/h5/4289d1a6d4154960aea6f81e938ae1ad"

//缓存路径
let cacheUrl = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/Caches"

struct ZCConstants {
    //屏幕尺寸获取
    static let screenSize   = UIScreen.main.bounds
    static let screenWidth  = UIScreen.main.bounds.maxX
    static let screenHeight = UIScreen.main.bounds.maxY
    static let screenCenter = CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY / 2)
    
    //系统颜色设置
    static var bgColor = UIColor(hex: 0x1b1b1b)
    static var subBgColor = UIColor(hex: 0x202020)
    static var textColor = UIColor(hex: 0xDDDDDD)
    static var sectionTextColor = UIColor(hex: 0x888888)
    
    static var mainColor = UIColor(hex: 0x8ec232)   //草绿
    static var subColor = UIColor(hex: 0x79cc32)
    static var barColor = UIColor(hex: 0x262626)
    
    static var detailBg = UIColor.white
    static var deatilSubBg = UIColor(hex: 0xeeeeee)
    
    static let serverBaseUrl = serverUrlTest
    static let imageBaseUrl = serverUrlTest
}
