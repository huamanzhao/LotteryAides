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
    var multiple = 0
    var cost = 0
    var addDate: Date!
    var isRead = false
    var isLucky = false
    var level = -1
    var prize = 0
    var codes: [LotteryCode]!
    var _results = [Int]()
    var results : [Int] {
        get {
            return _results
        }
        set {
            _results = newValue
            setLuchyProperties()
        }
    }
    
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
                getPublishDate(publishJS.stringValue)
            }
            if let mutipleJS = data!["multiple"] {
                multiple = mutipleJS.intValue
            }
            if let costJS = data!["cost"] {
                cost = costJS.intValue
            }
            if let addDateJS = data!["addDate"] {
                addDate = addDateJS.stringValue.toDate(format: LOTTERY_WHOLE_DATE)!
            }
            if let isReadJS = data!["isRead"] {
                isRead = isReadJS.intValue == 1 ? true : false
            }
            if let isLuckyJS = data!["isLucky"] {
                isLucky = isLuckyJS.intValue == 1 ? true : false
            }
            if let levelJS = data!["level"] {
                level = levelJS.intValue
            }
            if let prizeJS = data!["prize"] {
                prize = prizeJS.intValue
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
    
    
    /*
     * ----------------------------------------------------------------------------------------
     * ---------------------------------    计算中奖号码    --------------------------------------
     * -----------------------------------------------------------------------------------------
     */
    func getLuckyResult(publish: LotteryPublish) {
        let code = self.codes.first
        if code == nil {
            return
        }
        
        switch self.lt_type.type {
        case 1:
            results = getType1LuckyResult(code: code!, publish: publish)
            
        case 2:
            results = getType2LuckyResult(code: code!, publish: publish)
            
        case 3:
            results = getType3LuckyResult(code: code!, publish: publish)
            
        case 4:
            results = getType4LuckyResult(code: code!, publish: publish)
            
        default:
            break
        }
    }
    
    //查询类型1的彩票中奖结果 超级大乐透 5个红球+2个蓝球
    private func getType1LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let ltNumbers = code.numbers!
        let pbNumbers = publish.code.numbers!
        
        if ltNumbers.count != 7 || pbNumbers.count != 7 || ltNumbers.count != pbNumbers.count {
            return [Int]()
        }
        
        let preLtNumbers = ltNumbers[0 ... 4]
        let sufLtNumbers = ltNumbers[5 ... 6]
        
        let prePbNumbers = pbNumbers[0 ... 4]
        let sufPbNumbers = pbNumbers[5 ... 6]
        
        var preResults = [Int]()
        var sufResults = [Int]()
        for number in preLtNumbers {
            if prePbNumbers.contains(number) {
                preResults.append(prePbNumbers.index(of: number)!)
            }
        }
        
        for number in sufLtNumbers {
            if sufPbNumbers.contains(number) {
                sufResults.append(sufPbNumbers.index(of: number)!)
            }
        }
        
        for index in sufResults {
            preResults.append(index + 5)
        }
        
        
        return preResults
    }
    
    //查询类型2的彩票中奖结果 七星彩
    private func getType2LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let max_len = 7
        
        let ltNumbers = code.numbers!
        let pbNumbers = publish.code.numbers!
        
        if ltNumbers.count != 7 || pbNumbers.count != 7 {
            return [Int]()
        }
        
        var results = [Int]()
        var tempResults = [Int]()
        
        for (index, number) in ltNumbers.enumerated() {
            //1. 当前位置两个数组的数字不同
            if number != pbNumbers[index] {
                if tempResults.isEmpty {    //1.1 temp为空
                    continue
                }
                
                //1.2 temp不为空
                if results.isEmpty {    //1.2.1 result为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
                
                if results.count < tempResults.count {  //1.2.2 result不为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
                
                tempResults = [Int]()   //置为空
                continue
            }
            
            //2. 此位置两数字相同
            //-- 如果前一个位置或者后一个位置数字相同，则此数位置入temp列
            if index == 0 { //2.1 第一个
                if ltNumbers[index+1] == pbNumbers[index+1] {
                    tempResults.append(index)
                }
            }
            else if index == max_len - 1 {  //2.2 最后一个
                if ltNumbers[index-1] == pbNumbers[index-1] {
                    tempResults.append(index)
                }
                
                if results.isEmpty {    //2.2.1 result为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
                
                if results.count < tempResults.count {  //2.2.2 result不为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
            }
            else {  //2.3 中间的
                if (ltNumbers[index-1] == pbNumbers[index-1]) || (ltNumbers[index+1] == pbNumbers[index+1]) {
                    tempResults.append(index)
                }
            }
            
        }
        
        return results
    }
    
    //查询类型3的彩票中奖结果 双色球
    private func getType3LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let ltNumbers = code.numbers!
        let pbNumbers = publish.code.numbers!
        
        if ltNumbers.count != 7 || pbNumbers.count != 7 {
            return [Int]()
        }
        
        let preLtNumbers = ltNumbers[0 ... 5]
        let prePbNumbers = pbNumbers[0 ... 5]
        
        var preResults = [Int]()
        for number in preLtNumbers {
            if prePbNumbers.contains(number) {
                preResults.append(prePbNumbers.index(of: number)!)
            }
        }
        
        if ltNumbers[6] == pbNumbers[6] {
            preResults.append(6)
        }
        
        
        return preResults
    }
    
    //查询类型4的彩票中奖结果 七乐彩
    private func getType4LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let ltNumbers = code.numbers!
        let pbNumbers = publish.code.numbers!
        
        if ltNumbers.count != 7 || pbNumbers.count != 7 {
            return [Int]()
        }
        
        let preLtNumbers = ltNumbers[0 ... 5]
        let prePbNumbers = pbNumbers[0 ... 5]
        
        var preResults = [Int]()
        for number in preLtNumbers {
            if prePbNumbers.contains(number) {
                preResults.append(prePbNumbers.index(of: number)!)
            }
        }
        
        if ltNumbers[6] == pbNumbers[6] {
            preResults.append(6)
        }
        
        
        return preResults
    }
    
    /*
     * ----------------------------------------------------------------------------------------
     * ---------------------------------    计算中奖结果    --------------------------------------
     * -----------------------------------------------------------------------------------------
     */
    private func setLuchyProperties() {
        if self.lt_type.type == 1 {
            getType1LuckyLevel()
        }
        else if self.lt_type.type == 2 {
            getType2LuckyLevel()
        }
        else if self.lt_type.type == 3 {
            getType3LuckyLevel()
        }
        else if self.lt_type.type == 4 {
            getType2LuckyLevel()
        }
    }
    
    //大乐透中奖结果
    private func getType1LuckyLevel() {
        let count = results.count
        switch count {
        case 1:
            if results.contains(5) || results.contains(6) {
                level = 6
                prize = 5
            }
        case 2, 3:
            if results.contains(5) || results.contains(6) {
                level = 6
                prize = 5
            }
            
        case 4:
            level = 5
            prize = 10
            
        case 5:
            level = 4
            prize = 200
            
        case 6:
            if results.contains(5) || results.contains(6) {
                level = 3
                prize = 5000
            }
            else {
                level = 2
                prize = 100000
            }
            
        case 7:
            level = 1
            prize = 9000000
            
            
        default:
            break
        }
    }
    
    
    //七星彩中奖结果
    //七乐彩中奖结果
    private func getType2LuckyLevel() {
        let count = results.count
        switch count {
        case 2:
            level = 6
            prize = 5
            
        case 3:
            level = 5
            prize = 20
            
        case 4:
            level = 4
            prize = 300
            
        case 5:
            level = 3
            prize = 1800
            
        case 6:
            level = 2
            prize = 20000
            
        case 7:
            level = 1
            prize = 5000000
            
        default:
            break
        }
    }
    
    //双色球中奖结果
    private func getType3LuckyLevel() {
        let count = results.count
        switch count {
        case 1, 2, 3:
            if results.contains(6) {
                level = 6
                prize = 5
            }
            
        case 4:
            level = 5
            prize = 10
            
        case 5:
            level = 4
            prize = 200
            
        case 6:
            if results.contains(6) {
                level = 3
                prize = 3000
            }
            else {
                level = 2
                prize = 50000
            }
            
        case 7:
            level = 1
            prize = 9800000
            
            
        default:
            break
        }
    }
    
    func getPublishDateString1() -> String {
        let dateString = publishDate.toString(FORMAT_DATE_TIME)
        if !dateString.isEmpty
        {
            return dateString
        }
        
        return ""
    }
    
    func getPublishDateString() -> String {
        let dateString = publishDate.toString(LOTTERY_DATE_1)
        if !dateString.isEmpty
        {
            return dateString
        }
        
        let dateString1 = publishDate.toString(LOTTERY_WHOLE_DATE)
        if !dateString1.isEmpty
        {
            return dateString1
        }
        
        let dateString2 = publishDate.toString(LOTTERY_DATE)
        if !dateString2.isEmpty
        {
            return dateString2
        }
        
        return ""
    }
    
    func getPublishDate(_ dateStr: String) {
        if let date = dateStr.toDate(format: LOTTERY_DATE) {
            publishDate = date
        }
        else if let date = dateStr.toDate(format: LOTTERY_WHOLE_DATE) {
            publishDate = date
        }
        else if let date = dateStr.toDate(format: LOTTERY_DATE_1) {
            publishDate = date
        }
        else {
            publishDate = Date()
        }
    }
}
