//
//  main.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/9.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import UIKit

let applicationID = "8d504db92e9c4b4c7f499062f731ac2e"
Bmob.register(withAppKey: applicationID)

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    nil,
    NSStringFromClass(AppDelegate.self)
)
