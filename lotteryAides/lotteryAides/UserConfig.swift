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
    private var promptStatus = "0"
    private var userType = BASIC_TYPE
    private var adUrl = ""
    private var needGuide = true
    
    private var userDefault : UserDefaults!
    private let default_phone  = "default_phone"
    private let default_status = "default_status"
    private let default_type   = "default_type"
    private let default_adUrl  = "default_adUrl"
    private let default_guide  = "default_guide"
    
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
    
    func setPhone(_ phone: String) {
        self.phone = phone
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
    
    func saveUserInfo() {
        userDefault.setValue(phone, forKey: default_phone)
        userDefault.setValue(promptStatus, forKey: default_status)
        userDefault.setValue(userType, forKey: default_type)
        userDefault.setValue(adUrl, forKey: default_adUrl)
        userDefault.setValue("\(needGuide)", forKey: default_guide)
        
        userDefault.synchronize()
    }
    
    func getLocalUserInfo() {
        phone = readLocalData(default_phone)
        promptStatus = readLocalData(default_status)
        userType = readLocalData(default_type)
        adUrl = readLocalData(default_adUrl)
        let needStr = readLocalData(default_guide)
        needGuide = needStr == "true" ? true : false
    }
    
    
    //清空所有配置信息
    func clearData() {
        //清空登录信息
        userDefault.setValue(nil, forKey: default_phone)
        userDefault.setValue(nil, forKey: default_status)
        
        phone = ""
        promptStatus = "0"
        
        userDefault.synchronize()
    }
    
    func readLocalData(_ key: String) -> String {
        var result = userDefault.string(forKey: key)
        if result == nil {
            result = ""
        }
        
        return result!
    }
}
