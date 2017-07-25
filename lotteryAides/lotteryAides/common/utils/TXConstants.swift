//
//  TXCommon.swift
//  Heymow
//
//  Created by Icely on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//
//  该类用于储存系统中的全局常量，常量的值可以被任何类读取，但无法被修改
//

import UIKit

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

struct TXConstants {
    //屏幕尺寸获取
    static let screenSize   = UIScreen.main.bounds
    static let screenWidth  = UIScreen.main.bounds.maxX
    static let screenHeight = UIScreen.main.bounds.maxY
    static let screenCenter = CGPoint(x: UIScreen.main.bounds.maxX / 2, y: UIScreen.main.bounds.maxY / 2)
    
    static let shareStr = "在万千姿态中寻找自己，热爱健身，定期体检，健康是首共鸣的歌，与你相伴，让生活更精彩！"
    static let agreementUrl = serverUrlTest+"/privacyStatement.jsp"
    
    static let serverBaseUrl = serverUrlTest
    static let imageBaseUrl = serverUrlTest
}
