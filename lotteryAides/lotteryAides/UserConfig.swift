//
//  UserConfig.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation


class UserConfig: AnyObject {
    private var phone = ""
    private var password = ""
    private var adUrl = ""
    private var promptStatus = "0"  //协约状态，0：正常，1：异常
    private var userType = USER_TYPE_BASIC
    private var needGuide = true
    private var notifyOn = true
    
    private var userDefault : UserDefaults!
    private let default_phone  = "default_phone"
    private let default_password  = "default_password"
    private let default_status = "default_status"
    private let default_type   = "default_type"
    private let default_adUrl  = "default_adUrl"
    private let default_guide  = "default_guide"
    private let default_nofity  = "default_nofity"
    
    init() {
        userDefault = UserDefaults.standard
    }
    
    static func getInstance() -> UserConfig {
        let app = UIApplication.shared.delegate as! AppDelegate
        
        return app.getUserConfig()
    }
    
    func getPhone() -> String {
        return phone
    }
    
    func getPassword() -> String {
        return password
    }
    
    func getStatus() -> String {
        return promptStatus
    }
    
    func getUserType() -> String {
        return userType
    }
    
    func getADUrl() -> String {
        return adUrl
    }
    
    func getNeedGuide() -> Bool {
        return needGuide
    }
    
    func getNotifyOn() -> Bool {
        return notifyOn
    }
    
    func setPhone(_ phone: String) {
        self.phone = phone
    }
    
    func setPassword(_ password: String) {
        self.password = password
    }
    
    func setPromptStatus(_ status: String) {
        self.promptStatus = status
    }
    
    func setADUrl(_ url: String) {
        self.adUrl = url
    }
    
    func setNeedGuide(_ need: Bool) {
        self.needGuide = need
    }
    
    func setUserType(_ type: String) {
        self.userType = type
    }
    
    func setNotifyOn(_ on: Bool) {
        self.notifyOn = on
    }
    
    func saveUserInfo() {
        userDefault.setValue(phone, forKey: default_phone)
        userDefault.setValue(password, forKey: default_password)
        userDefault.setValue(promptStatus, forKey: default_status)
        userDefault.setValue(userType, forKey: default_type)
        userDefault.setValue(adUrl, forKey: default_adUrl)
        userDefault.setValue("\(needGuide)", forKey: default_guide)
        userDefault.setValue("\(notifyOn)", forKey: default_nofity)
        
        userDefault.synchronize()
    }
    
    func getLocalUserInfo() {
        phone = readLocalData(default_phone)
        password = readLocalData(default_password)
        
        let localStatus = readLocalData(default_status)
        if !localStatus.isEmpty {
            promptStatus = localStatus
        }
        
        let localType = readLocalData(default_type)
        if !localType.isEmpty {
            userType = localType
        }
        
        
        adUrl = readLocalData(default_adUrl)
        
        let localGuide = readLocalData(default_guide)
        if !localGuide.isEmpty {
            needGuide = localGuide == "true" ? true : false
        }
        
        
        let localNotify = readLocalData(default_nofity)
        if !localNotify.isEmpty {
            notifyOn = localNotify == "true" ? true : false
        }
        
    }
    
    
    //清空所有配置信息
    func clearData() {
        //清空登录信息
        userDefault.setValue(nil, forKey: default_phone)
        userDefault.setValue(nil, forKey: default_password)
        
        phone = ""
        password = ""
        
        userDefault.synchronize()
    }
    
    func readLocalData(_ key: String) -> String {
        var result = userDefault.string(forKey: key)
        if result == nil  {
            result = ""
        }
        
        return result!
    }
    
    static func updateLotteryList(_ list: [LotteryInfo]) {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.updateLotteryList(list)
    }
    
    static func appendPublish(_ publish: LotteryPublish) {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.appendPublish(publish)
    }
    
    static func getLotteryList() -> [LotteryInfo] {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.lotteryList
    }
    
    static func getWaitingLotteries() -> [LotteryInfo] {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.waitingLotteries
    }
    
    static func getPublishLotteries() -> [LotteryInfo] {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.publishLotteries
    }
    
    static func getLuckyLotteries() -> [LotteryInfo] {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.luckyLotteries
    }
    
    static func getPublishList() -> [LotteryPublish] {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.publishList
    }
}
