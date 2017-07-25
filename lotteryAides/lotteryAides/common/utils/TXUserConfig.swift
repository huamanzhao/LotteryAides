//
//  TXUserDefaults.swift
//  Heymow
//
//  Created by Icefly on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//
//  对应原HBUserConfig，用于对配置文件进行读写
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


let LAST_LOGIN_DATE = "lastLoginDate"
let FIRST_LOGIN = "first_login"

struct Config {
    //首次安装
    static let firstInstall = "firstInstall"
    
    //登录信息
    static let firstLogin = "firstLogin"
    static let lastLoginDate = "lastLoginDate"
    
    //登录信息
    static let userName = "userName"            //用户名
    static let password = "password"            //登录密码（建议存放到KeyChain中）
    static let customerId = "customerId"        //用户ID
    static let unionId = "unionid"              //微信登录ID
    static let wxPassword = "wxPassword"        //微信登录密码
    
    //基本信息
    static let avatar = "self_avatar"           //头像
    static let name = "self_name"               //真实姓名
    static let gender = "self_gender"           //性别
    static let birthday = "self_birthday"       //出生日期
    static let cityId = "self_cityId"           //所在地
    static let height = "self_height"           //身高
    static let weight = "self_weight"           //体重（最近一次测量）
    
    //额外信息
    static let jobId = "self_jobId"             //工作ID（已弃用）
    static let level = "self_level"             //等级
    static let points = "self_points"           //积分
    static let healthIndex = "self_healthIndex" //健康指数排名
    static let createTime = "self_createTime"   //创建时间
    
    //外部平台凭证
    static let pushToken = "self_pushToken"     //极光推送凭证
    static let imToken = "self_userToken"       //实时聊天凭证
    static let ezCameraAccessToken = "ez_camera_accessToken"        //萤石摄像头凭证
    
    //配置信息
    static let showDrink = "drink_notification" //是否显示喝水提醒
    static let healthBg = "health_bgImage"      //健康界面背景图
    static let showGymCard = "show_gymCard"     //是否提示有未消费健身卡
    
    //健康档案
    static let bodyStyle = "body_style"         //体形信息
    
    //用户指引
    static let guide_main = "guide_main"                //首页指引
    static let guide_suggest = "guide_suggest"          //关注指引
    static let guide_group = "guide_group"              //圈子指引
    static let guide_post = "guide_post"                //发表动态指引
    static let guide_slidegym = "guide_slidegym"        //侧边栏红点
    static let guide_slidebar = "guide_sidebar"         //打开侧边栏指引
    static let guide_user_search = "guide_user_search"  //搜索用户指引
    static let guide_chat = "guide_chat"                //私信指引
    static let guide_clear = "guide_clear"              //清空消息指引
    static let guide_user_detail = "guide_user_detail"  //关注用户指引
    
    static let guide_gym_package = "guide_gym_package"  //套餐说明指引
    static let guide_package_list = "guide_package_list"//套餐列表指引
    static let guide_gym_list = "guide_gym_list"        //商户列表指引
    static let guide_gym_detail = "guide_gym_detail"    //商户详情指引
    static let guide_coupon = "guide_coupon"            //选择优惠券指引

    static let guide_buy_success = "guide_buy_success"  //购买成功指引
    static let guide_buy_card = "guide_card"            //使用健身卡指引
    static let guide_user_card = "guide_user_card"      //个人中心卡券指引
    static let guide_list_card = "guide_list_card"      //健身卡列表指引
    
    static let guide_use_success = "guide_use_success"  //消费成功指引
    static let guide_show_record = "guide_show_record"  //查看消费记录指引
    static let guide_user_record = "guide_user_record"  //个人中心消费记录指引
    static let guide_list_record = "guide_list_record"  //消费记录列表指引
    
    static let guide_user_coupon = "guide_user_coupon"  //个人中心优惠券指引
    
    
    static let guide_slidebar_shop = "guide_slidebar_shop"           //首页指引
    static let guide_slidebar_moment = "guide_slidebar_moment"       //首页指引
    
    //消息、通知红点提醒
    static let noticeState = "notice_state"
    static let focusNoticeState = "focus_notice_state"
    static let likeNoticeState = "like_notice_state"
    static let commentNoticeState = "comment_notice_state"
    static let applyNoticeState = "apply_notice_state"
    
    static let researchHistory = "research_history"
}

enum TXHealthAuthorType : String {
    case Undetermined = "undetermined"  //未决定
    case Denied       = "denied"        //已拒绝
    case Approved     = "approved"      //已同意
}

class TXUserConfig: NSObject {
    fileprivate static var instance: TXUserConfig!
    
    static func getInstance() -> TXUserConfig {
        if (instance == nil) {
            instance = TXUserConfig()
            instance.userDefault = UserDefaults.standard
        }
        
        return instance
    }
    
    fileprivate override init () {}
    
    var userDefault : UserDefaults!
    
    //获取当前登录用户的ID
    func getCustomerId() -> String {
        //如果缓存中有CustomerId，则直接返回
        if let customerId = TXSettings.customerId {
            return customerId
        }
        
        //否则从配置文件中读取并存入缓存
        let customerId = getAccountInfo().customerId
        TXSettings.customerId = customerId
        return customerId
    }
    
    //保存用户的登录信息
    //TODO:应使用钥匙串存储
    func saveAccountInfo(_ info: TXAccount) {
        userDefault.setValue(info.customerId, forKey: Config.customerId)
        userDefault.setValue(info.userName, forKey: Config.userName)
        userDefault.setValue(info.password, forKey: Config.password)
        userDefault.setValue(info.unionId, forKey: Config.unionId)
        userDefault.setValue(info.pushToken, forKey: Config.pushToken)
        userDefault.setValue(info.wxPassword, forKey: Config.wxPassword)
        userDefault.synchronize()
    }
    
    //读取用户的登录信息
    func getAccountInfo() -> TXAccount {
        let accountInfo = TXAccount()
        accountInfo.userName = readData(Config.userName)
        accountInfo.password = readData(Config.password)
        accountInfo.customerId = readData(Config.customerId)
        accountInfo.unionId = readData(Config.unionId)
        accountInfo.wxPassword = readData(Config.wxPassword)
        return accountInfo
    }

    //保存用户的基本信息
    func savePersonalInfo(_ info: TXPersonalInfo) {
        //基本属性
        userDefault.setValue(info.name, forKey: Config.name)
        userDefault.setValue(info.gender, forKey: Config.gender)
        userDefault.setValue(info.avatar, forKey: Config.avatar)
        
        //个人属性
        userDefault.setValue(info.birthday, forKey: Config.birthday)
        userDefault.setValue(info.height, forKey: Config.height)
        
//        //等级属性
//        userDefault.setValue(info.level, forKey: Config.level)
//        userDefault.setValue(info.points, forKey: Config.points)
//        userDefault.setValue(info.healthIndex, forKey: Config.healthIndex)
        
        //待定属性
        userDefault.setValue(info.createTime, forKey: Config.createTime)
        userDefault.setValue(info.jobId, forKey: Config.jobId)
        
        userDefault.synchronize()
    }
    
    //读取用户的基本信息
    func getPersonalInfo(_ useCache: Bool = true) -> TXPersonalInfo {
        if useCache {
            //如果缓存中有CustomerId，则直接返回
            if let personalInfo = TXSettings.personalInfo {
                return personalInfo
            }
        }
        
        let personalInfo = TXPersonalInfo()
        personalInfo.name = readData(Config.name)
        personalInfo.gender = readData(Config.gender)
        personalInfo.avatar = readData(Config.avatar)
        
        personalInfo.birthday = readData(Config.birthday)
        personalInfo.height = readData(Config.height)
        personalInfo.cityId = readData(Config.cityId)
        
//        personalInfo.level = readData(Config.level)
//        personalInfo.points = readData(Config.points)
//        personalInfo.healthIndex = readData(Config.healthIndex)
        
        personalInfo.createTime = readData(Config.createTime)
        personalInfo.jobId = readData(Config.jobId)
        
        if useCache {
            TXSettings.personalInfo = personalInfo
        }
        return personalInfo
    }
    
    func saveData(_ data: String, key: String) {
        userDefault.set(data, forKey: key)
        userDefault.synchronize()
    }
    
    func readData(_ key: String) -> String {
        var result = userDefault.string(forKey: key)
        if result == nil {
            result = ""
        }
        
        return result!
    }

    //从配置文件中读取界面颜色的配置方案
    func readStyle(_ styleName : String, defaultValue : Int) -> UIColor {
        let data = userDefault.object(forKey: styleName)
        var color: Int
        
        if (data != nil) {
            color = data as! Int
        } else {
            color = defaultValue
            userDefault.set(color, forKey: styleName)
            userDefault.synchronize()
        }
        
        return UIColor(hex: UInt(color))
    }
        
    //读取是否提醒有未消费健身卡
    func readShowGymCardConfig() -> Bool {
        let data = userDefault.object(forKey: Config.showGymCard)
        if data != nil {
            if data as! String == "true" {
                return true
            }else if data as! String == "false" {
                return false
            }else {
                return false
            }
        }else {
            return true
        }
    }
    
    func saveUserRecordItems(_ items : String) {
        let item = ["userRecordItems" : items]
        userDefault.set(item, forKey: self.getAccountInfo().customerId)
        userDefault.synchronize()
    }
    
    func getUserRecordItems() -> String {
        let item = userDefault.object(forKey: self.getAccountInfo().customerId) as? [String : String]
        if item != nil{
            return item!["userRecordItems"]!
        } else {
            return ""
        }
    }
    
    //初始化用户指引
    func initUserGuide(_ key: String) {
        if readData(key).isEmpty {
            saveData("true", key: key)
        }
    }
    
    func showGuide(_ key: String) -> Bool {
//        let showGuide = readData(key)
//        
//        if showGuide == "true" {
//            saveData("false", key: key)
//            return true
//        } else {
            return false
//        }
    }

    //存储摄像头授权
    func setEZCameraAccessToken(_ accessToken: String) {
        userDefault.setValue(accessToken, forKey: Config.ezCameraAccessToken)
        userDefault.synchronize()
    }

    //获取摄像头授权
    func getEZCameraAccessToken() -> String {
        if !readData(Config.ezCameraAccessToken).isEmpty {
            return readData(Config.ezCameraAccessToken)
        }
        return ""
    }
    
    //判断是否需要显示引导页：  首次安装、或者版本更新后需要显示引导页
    func checkGuidesPageNeeds() -> Bool {
        let currVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        let lastVersion = readData(Config.firstInstall)
        if lastVersion.isEmpty {    //首次安装
            saveData(currVersion, key: Config.firstInstall)
            
            return true
        }
        
        if lastVersion < currVersion {  //更新版本
            saveData(currVersion, key: Config.firstInstall)
            
            return true
        }
        
        return false
    }
    
    //清空所有配置信息
    func clearData () {
        //清空登录信息
        userDefault.setValue(nil, forKey: Config.lastLoginDate)
        
        //清空用户数据
        userDefault.setValue(nil, forKey: Config.userName)
        userDefault.setValue(nil, forKey: Config.password)
        userDefault.setValue(nil, forKey: Config.customerId)
        userDefault.setValue(nil, forKey: Config.unionId)
        
        //清空基本信息
        userDefault.setValue(nil, forKey: Config.avatar)
        userDefault.setValue(nil, forKey: Config.name)
        userDefault.setValue(nil, forKey: Config.gender)
        userDefault.setValue(nil, forKey: Config.birthday)
        userDefault.setValue(nil, forKey: Config.cityId)
        userDefault.setValue(nil, forKey: Config.height)
        userDefault.setValue(nil, forKey: Config.weight)
        
        //清空额外信息
        userDefault.setValue(nil, forKey: Config.jobId)
        userDefault.setValue(nil, forKey: Config.level)
        userDefault.setValue(nil, forKey: Config.points)
        userDefault.setValue(nil, forKey: Config.createTime)
        
        //清空配置信息
        userDefault.setValue(nil, forKey: Config.showDrink)
        userDefault.setValue(nil, forKey: Config.healthBg)
        userDefault.setValue(nil, forKey: Config.showGymCard)

        //清空摄像头授权
        userDefault.setValue(nil, forKey: Config.ezCameraAccessToken)
        
        //执行同步
        userDefault.synchronize()
        
        //清除缓存信息
        TXSettings.customerId = nil
        TXSettings.personalInfo = nil
    }
    
    /*
     * 用户身体指数 
     * bmi-身高体重指数；bmr-基础代谢率； bfr-体脂率
     */
    struct Default_BodyIndex {
        static let name = "userBodyIndexInfo"
        static let bmi = "BMI"
        static let bmr = "basic_metabolic_rate"
        static let bfr = "body_fat_rate"
    }
    
    //缓存用户的体测信息
    func saveUserBodyIndex(_ bodyInfo: TXBodyIndexInfo) {
        //需要缓存的体测信息
        let bodyIndexDic = [Default_BodyIndex.bmi: bodyInfo.bmi,
                            Default_BodyIndex.bmr: bodyInfo.bmr,
                            Default_BodyIndex.bfr: bodyInfo.bfr];
        
        //首先从配置文件中读取所有用户的体测信息
        var usersIndexDic = userDefault.object(forKey: Default_BodyIndex.name) as? Dictionary<String, AnyObject>
        
        //如果缓存的体测信息为空，则创建新的体测信息
        if usersIndexDic == nil {
            usersIndexDic = Dictionary <String, AnyObject> ()
        }
        
        usersIndexDic!.updateValue(bodyIndexDic as AnyObject, forKey: self.getCustomerId())
        userDefault.set(usersIndexDic, forKey: Default_BodyIndex.name)
        userDefault.synchronize()
    }

    func getUserBodyIndex() -> TXBodyIndexInfo? {
        let usersIndexDic = userDefault.object(forKey: Default_BodyIndex.name) as? Dictionary<String, AnyObject>
        if usersIndexDic == nil {
            return nil
        }
        
        let bodyIndexDic = usersIndexDic?[self.getCustomerId()] as? Dictionary<String, Double>
        if bodyIndexDic == nil {
            return nil
        }
        
        let bodyInfo = TXBodyIndexInfo()
        bodyInfo.bmi = Float(bodyIndexDic![Default_BodyIndex.bmi]!)
        bodyInfo.bmr = Float(bodyIndexDic![Default_BodyIndex.bmr]!)
        bodyInfo.bfr = Float(bodyIndexDic![Default_BodyIndex.bfr]!)
        
        return bodyInfo
    }

//    struct Default_BodyFigure {
//        static let name  = "userBodyFigureInfo"
//        static let bust  = "bust"   //胸围
//        static let waist = "waist"  //腰围
//        static let hipline = "hipline"//臀围
//        static let type  = "type"   //体型：0-健壮 1-紧致 2-匀称 3-微胖 4-肥胖
//    }
//    
//    func saveUserBodyFigure(figure: TXBodyFigureInfo) {
//        let bodyFigureDic: [String : Int] =
//                            [Default_BodyFigure.bust:   (figure.bust),
//                             Default_BodyFigure.waist:  (figure.waist),
//                             Default_BodyFigure.hipline:(figure.hipline),
//                             Default_BodyFigure.type:   (figure.type)]
//        let userBodyFigure = [self.getCustomerId(): bodyFigureDic]
//        
//        var usersFigureDic = userDefault.objectForKey(Default_BodyFigure.name) as? Dictionary<String, AnyObject>
//        if usersFigureDic == nil {
//            userDefault.setObject(userBodyFigure, forKey: Default_BodyFigure.name)
//        }
//        else {
//            usersFigureDic?.updateValue(bodyFigureDic, forKey: self.getCustomerId())
//            userDefault.setObject(usersFigureDic, forKey: Default_BodyFigure.name)
//        }
//        
//        userDefault.synchronize()
//    }
//    
//    func getUserBodyFigure() -> TXBodyFigureInfo? {
//        let usersFigureDic = userDefault.objectForKey(Default_BodyFigure.name) as? Dictionary<String, AnyObject>
//        if usersFigureDic == nil {
//            return nil
//        }
//        
//        let bodyFigureDic = usersFigureDic?[self.getCustomerId()] as? Dictionary<String, Int>
//        if bodyFigureDic == nil {
//            return nil
//        }
//        
//        let figure = TXBodyFigureInfo()
//        figure.bust = bodyFigureDic![Default_BodyFigure.bust]!
//        figure.waist = bodyFigureDic![Default_BodyFigure.waist]!
//        figure.hipline = bodyFigureDic![Default_BodyFigure.hipline]!
//        figure.type = bodyFigureDic![Default_BodyFigure.type]!
//        
//        return figure
//    }
//    
//    struct TXUserBodyWeightInfo {
//        static let name  = "userBodyWeightInfo"
//        static let device = "device"
//        static let weight  = "weight"   //体重
//        static let height = "height"  //身高
//        static let bodyFat = "bodyFat"//体脂
//        static let muscle  = "muscle"   //
//        static let bmd = "bmd"   //
//        static let water  = "water"   //
//        static let other  = "other"   //
//    }
//    
//    func saveUserWeightInfo(weight: TXWeightInfo) {
//        let bodyWeightDic: [String : String] =
//                            [TXUserBodyWeightInfo.device:     weight.device,
//                             TXUserBodyWeightInfo.weight:     "\(weight.weight)",
//                             TXUserBodyWeightInfo.height:     "\(weight.height)",
//                             TXUserBodyWeightInfo.bodyFat:    "\(weight.bodyFat)",
//                             TXUserBodyWeightInfo.muscle:     "\(weight.muscle)",
//                             TXUserBodyWeightInfo.bmd:        "\(weight.bmd)",
//                             TXUserBodyWeightInfo.water:      "\(weight.water)",
//                             TXUserBodyWeightInfo.other:      weight.other]
//        let userBodyWeight = [self.getCustomerId(): bodyWeightDic]
//        
//        var usersWeightDic = userDefault.objectForKey(TXUserBodyWeightInfo.name) as? Dictionary<String, AnyObject>
//        if usersWeightDic == nil {
//            userDefault.setObject(userBodyWeight, forKey: TXUserBodyWeightInfo.name)
//        }
//        else {
//            usersWeightDic?.updateValue(bodyWeightDic, forKey: self.getCustomerId())
//            userDefault.setObject(usersWeightDic, forKey: TXUserBodyWeightInfo.name)
//        }
//        
//        userDefault.synchronize()
//    }
//    
//    func getUserWeightInfo() -> TXWeightInfo? {
//        let usersWeightDic = userDefault.objectForKey(TXUserBodyWeightInfo.name) as? Dictionary<String, AnyObject>
//        if usersWeightDic == nil {
//            return nil
//        }
//        
//        let bodyWeightDic = usersWeightDic?[self.getCustomerId()] as? Dictionary<String, String>
//        if bodyWeightDic == nil {
//            return nil
//        }
//        
//        let weight = TXWeightInfo()
//        weight.device = bodyWeightDic![TXUserBodyWeightInfo.device]!
//        weight.weight = Float(bodyWeightDic![TXUserBodyWeightInfo.weight]!)!
//        weight.height = Int(bodyWeightDic![TXUserBodyWeightInfo.height]!)!
//        weight.bodyFat = Float(bodyWeightDic![TXUserBodyWeightInfo.bodyFat]!)!
//        weight.muscle = Float(bodyWeightDic![TXUserBodyWeightInfo.muscle]!)!
//        weight.bmd = Float(bodyWeightDic![TXUserBodyWeightInfo.bmd]!)!
//        weight.water = Float(bodyWeightDic![TXUserBodyWeightInfo.water]!)!
//        weight.other = bodyWeightDic![TXUserBodyWeightInfo.other]!
//        
//        return weight
//    }
    
    let userHealthAuthor = "healthAuthor"
    
    func recordHealthAuthor(_ type: TXHealthAuthorType) {
        userDefault.set(type.rawValue, forKey: userHealthAuthor)
        
        userDefault.synchronize()
    }
    
    func getDefaultHealthAuthor() -> TXHealthAuthorType {
        let authorStatus = userDefault.object(forKey: userHealthAuthor) as? String
        if authorStatus == nil {
            return .Undetermined
        }
        
        var status : TXHealthAuthorType!

        switch authorStatus! {
        case TXHealthAuthorType.Approved.rawValue:
            status = .Approved
            
        case TXHealthAuthorType.Undetermined.rawValue:
            status = .Undetermined
            
        case TXHealthAuthorType.Denied.rawValue:
            status = .Denied
            
        default:
            break
        }
        
        return status
    }
    
    /*******    读取用户搜索记录      *******/
    func saveUserResearchHistory(_ history: String) {
        var historyList = userDefault.object(forKey: Config.researchHistory) as? [String]
        if historyList == nil {
            historyList = [String]()
        }
        if historyList?.count < 10 {
            historyList?.append(history)
        } else {
            historyList?.removeFirst()
            historyList?.append(history)
        }
        userDefault.set(historyList, forKey: Config.researchHistory)
    }
    
    func readUserResearchHistory() ->[String] {
        let historyList = userDefault.object(forKey: Config.researchHistory) as? [String]
        if historyList == nil {
            return []
        }else {
            return historyList!
        }
        
    }
    
    func clearUserResearchHistory(){
        var historyList = userDefault.object(forKey: Config.researchHistory) as? [String]
        if historyList == nil {
            return
        }
        historyList?.removeAll()
        userDefault.set(historyList, forKey: Config.researchHistory)
    }
}
