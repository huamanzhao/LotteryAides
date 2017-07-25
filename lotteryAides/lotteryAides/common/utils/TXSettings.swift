//
//  TXConfigs.swift
//  Heymow
//  
//  Created by Icefly on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//
//  该类用于储存系统中的全局变量，变量的值可以被任何类修改和读取（谨慎多线程的问题！）
//

import UIKit

struct TXSettings {
    //系统颜色设置
    static var bgColor = UIColor(hex: 0x1b1b1b)
    static var subBgColor = UIColor(hex: 0x202020)
    static var textColor = UIColor(hex: 0xDDDDDD)
    static var sectionTextColor = UIColor(hex: 0x888888)
    
    //static var mainColor = UIColor(hex: 0xd60808) //鲜红
    static var mainColor = UIColor(hex: 0x8ec232)   //草绿
    //static var mainColor = UIColor(hex: 0xa9a9a9) //浅灰
    //static var mainColor = UIColor(hex: 0xe3be87) //淡金色
    static var subColor = UIColor(hex: 0x79cc32)
    static var barColor = UIColor(hex: 0x262626)
    
    static var detailBg = UIColor.white
    static var deatilSubBg = UIColor(hex: 0xeeeeee)
    
    //当前登录用户信息
    static var customerId: String?
    static var personalInfo: TXPersonalInfo?
    static let healthIndex = "self_healthIndex"
    
    //需要缓存的全局变量
//    static var gymItemDic = [String: TXGymItem]()
    /* 这个需要修改成 shop */
    static var shopItemDic = [String: TXShopItem]()
}
