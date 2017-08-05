//
//  AppDelegate.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/25.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let refreshConsumeEvent = "refreshConsumeEvent"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var config: UserConfig!
    var lotteryList: [LotteryInfo]!
    var waitingLotteries: [LotteryInfo]!
    var publishLotteries: [LotteryInfo]!
    var publishList: [LotteryPublish]!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        
        //极光推送
        JPUSHService.register(forRemoteNotificationTypes: UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.badge.rawValue, categories: nil)
        JPUSHService.setup(withOption: launchOptions, appKey: "3f83347939ed7375e64e48b8", channel: "APPLESTORE", apsForProduction: false)
        JPUSHService.resetBadge()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        config = getUserConfig()
        if !config.getNeedGuide() {
            window = UIWindow(frame: UIScreen.main.bounds)
            let main = UIStoryboard(name: "Main", bundle: nil)
            let adverticeVC = main.instantiateViewController(withIdentifier: "advertice")
            
            window?.rootViewController = adverticeVC
            window?.makeKeyAndVisible()
        }
        
        lotteryList = [LotteryInfo]()
        waitingLotteries = [LotteryInfo]()
        publishLotteries = [LotteryInfo]()
        publishList = [LotteryPublish]()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        /* 当程序在前台收到推送或者在后台点击推送通知后进入程序走这个方法，获得的通知内容在userINfo中 */
        JPUSHService.handleRemoteNotification(userInfo)
        let notification = Notification(name: Notification.Name(rawValue: refreshConsumeEvent), object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print(notificationSettings.types.rawValue)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let localNotification = Notification(name: Notification.Name(rawValue: "localNotification"), object: nil, userInfo: notification.userInfo)
        NotificationCenter.default.post(localNotification)
    }
    
    func getUserConfig() -> UserConfig {
        if config == nil {
            config = UserConfig()
            config.getLocalUserInfo()
        }
        
        return config
    }
    
    func updateLotteryList(_ list: [LotteryInfo]) {
        lotteryList = list
        waitingLotteries.removeAll()
        publishLotteries.removeAll()
        
        let currTime = Date.localDate()
        for lottery in list {
            if lottery.publishDate.isLaterThan(currTime) {
                waitingLotteries.append(lottery)
            }
            else {
                if !lottery.isRead {
                    publishLotteries.append(lottery)
                }
            }
        }
    }
    
    func appendPublish(_ publish: LotteryPublish) {
        for item in publishList {
            if item.type == publish.type && item.term == publish.term {
                return
            }
        }
        
        publishList.append(publish)
    }
}

