//
//  LotteryType.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/3.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation

class LotteryType : NSObject {
    private var _type = 0
    private var _name = ""
    private var _results = [Int]()
    
    var level = -1
    var prize = 0
    var time: String = ""
    var type : Int!    //1：大乐透 2：七星彩： 3：双色球 4：七乐彩
    {
        get {
            return _type
        }
        set {
            _type = newValue
            _name = getNameByType(_type)
        }
    }
    
    var name : String! {
        get {
            return _name
        }
        set {
            _name = newValue
            _type = getTypeByName(_name)
        }
    }
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
    }
    
    init(type: Int) {
        super.init()
        
        self.type = type
    }
    
    init(name: String) {
        super.init()
        
        self.name = name
    }
    
    private func getNameByType(_ type: Int) -> String {
        var name = ""
        
        switch type {
        case 1:
            name = "超级大乐透"
            time = "20:30"
        
        case 2:
            name = "七星彩"
            time = "20:30"
            
        case 3:
            name = "双色球"
            time = "21:15"
            
        case 4:
            name = "七乐彩"
            time = "21:15"
            
        default:
            break
        }
        
        return name
    }
    
    private func getTypeByName(_ name: String) -> Int {
        var type = 0
        
        switch name {
        case "超级大乐透":
            type = 1
            time = "20:30"
            
        case "大乐透":
            type = 1
            time = "20:30"
            
        case "七星彩":
            type = 2
            time = "20:30"
            
        case "双色球":
            type = 3
            time = "21:15"
            
        case "七乐彩":
            type = 4
            time = "21:15"
            
        default:
            break
        }
        
        return type
    }
    
    /* ----------------------------------------------------------------------------------------
     * ---------------------------------    计算中奖号码    --------------------------------------
     * -----------------------------------------------------------------------------------------
     */
    
    func getLuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int] {
        switch self.type {
        case 1:
            results = getType1LuckyResult(code: code, publish: publish)
            
        case 2:
            results = getType2LuckyResult(code: code, publish: publish)
            
        case 3:
            results = getType3LuckyResult(code: code, publish: publish)
            
        case 4:
            results = getType4LuckyResult(code: code, publish: publish)
            
        default:
            break
        }
        
        return results
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
    
    /* ----------------------------------------------------------------------------------------
     * ---------------------------------    计算中奖结果    --------------------------------------
     * -----------------------------------------------------------------------------------------
     */
    private func setLuchyProperties() {
        if self.type == 1 {
            getType1LuckyLevel()
        }
        else if self.type == 2 {
            getType2LuckyLevel()
        }
        else if self.type == 3 {
            getType3LuckyLevel()
        }
        else if self.type == 4 {
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
}
