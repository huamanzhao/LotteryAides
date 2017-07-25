//
//  TXNotificationUtil.swift
//  Heymow
//
//  Created by Icefly on 16/10/19.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

let refreshLoginEvent = "refreshLoginEvent"     //登录状态发生变化的通知
let refreshFocusEvent = "refreshFocusEvent"     //关注状态发生变化的通知
let refreshGroupEvent = "refreshGroupEvent"     //圈子状态发生变化的通知
let refreshMomentEvent = "refreshMomentEvent"   //动态状态发生变化的通知
let refreshShopListEvent = "refreshShopListEvent"
let refreshConsumeEvent = "refreshConsumeEvent"
let refreshGymCardEvent = "refreshGymCardEvent"
let refreshCardListEvent = "refreshCardListEvent"
let refreshSportInfoEvent = "refreshSportInfoEvent"         //运动数据发生变化的通知
let refreshHealthRecordEvent = "refreshHealthRecordEvent"   //健康档案数据发生变化的通知
let refreshHealthProfileEvent = "refreshHealthProfileEvent"   //健康档案上传的通知

class TXEventUtil: NSObject {
    static func postEvent(_ eventName: String, object: NSObject? = nil) {
        let notification = Notification(name: Notification.Name(rawValue: eventName), object: object)
        NotificationCenter.default.post(notification)
    }
    
    static func registEvent(_ observer: AnyObject, selector: Selector, eventName: String) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: eventName), object: nil)
    }
    
    static func removeEvent(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
}
