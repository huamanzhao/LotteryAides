//
//  LotteryInfo.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import SwiftyJSON

class LotteryInfo: NSObject {
    var id = ""
    var lt_type : LotteryType!
    var term = ""
    var publishDate = Date()
    var mutiple = 0
    var cost = 0
    var addDate: Date!
    var isRead = false
    var isLucky = false
    var codes: [LotteryCode]!
    
    override init() {
        super.init()
        
        codes = [LotteryCode]()
    }
    
    init(_ js: SwiftyJSON.JSON) {
        super.init()
        
        codes = [LotteryCode]()
        parseJson(js)
    }
    
    func parseJson(_ js: SwiftyJSON.JSON) {
        let data = js.dictionary
        if data != nil {
            if let idJS = data!["id"] {
                id = idJS.stringValue
            }
            if let nameJS = data!["name"] {
                lt_type = LotteryType(type: nameJS.intValue)
            }
            if let termJS = data!["term"] {
                term = termJS.stringValue
            }
            if let publishJS = data!["publishDate"] {
                if let date = publishJS.stringValue.toDate(format: FORMAT_DATE_TIME) {
                    publishDate = date
                }
                else if let date = publishJS.stringValue.toDate(format: "yyyy/MM/dd") {
                    publishDate = date
                }
            }
            if let mutipleJS = data!["mutiple"] {
                mutiple = mutipleJS.intValue
            }
            if let costJS = data!["cost"] {
                cost = costJS.intValue
            }
            if let addDateJS = data!["addDate"] {
                addDate = addDateJS.stringValue.toDate(format: FORMAT_DATE_TIME)
            }
            if let isReadJS = data!["isRead"] {
                isRead = isReadJS.boolValue
            }
            if let isLuckyJS = data!["isLucky"] {
                isLucky = isLuckyJS.boolValue
            }
            if let codesJS = data!["codes"] {
                let array = codesJS.arrayValue
                for codeJS in array {
                    let code = LotteryCode(codeJS)
                    if code.numbers.count == 7 {
                        codes.append(code)
                    }
                }
            }
            
        }
    }
}
