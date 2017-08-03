//
//  LotteryType.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/3.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation

class LotteryType : NSObject {
    var type : Int!    //1：大乐透 2：七星彩： 3：双色球 4：七乐彩
    {
        get {
            return self.type
        }
        set {
            self.type = newValue
            self.name = getNameByType(newValue)
        }
    }
    
    var name : String! {
        get {
            return self.name
        }
        set {
            self.name = newValue
            self.type = getTypeByName(newValue)
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
    
    func getNameByType(_ type: Int) -> String {
        var name = ""
        
        switch type {
        case 1:
            name = "超级大乐透"
        
        case 2:
            name = "七星彩"
            
        case 3:
            name = "双色球"
            
        case 4:
            name = "七乐彩"
            
        default:
            break
        }
        
        return name
    }
    
    func getTypeByName(_ name: String) -> Int {
        var type = 0
        
        switch name {
        case "超级大乐透":
            type = 1
            
        case "大乐透":
            type = 1
            
        case "七星彩":
            type = 2
            
        case "双色球":
            type = 3
            
        case "七乐彩":
            type = 4
            
        default:
            break
        }
        
        return type
    }
    
    func getLuckyResult(code: LotteryCode, publish: LotteryPublish) -> [String] {
        switch self.type {
        case 1:
            name = "超级大乐透"
            
        case 2:
            name = "七星彩"
            
        case 3:
            name = "双色球"
            
        case 4:
            name = "七乐彩"
            
        default:
            break
        }
        
        return [String]()
    }
    
    //查询类型1的彩票中奖结果 超级大乐透 5个红球+2个蓝球
    func getType1LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let ltNumbers = code.codes!
        let pbNumbers = publish.code.codes!
        
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
    func getType2LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let max_len = 7
        
        let ltNumbers = code.codes!
        let pbNumbers = publish.code.codes!
        
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
    func getType3LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let ltNumbers = code.codes!
        let pbNumbers = publish.code.codes!
        
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
    func getType4LuckyResult(code: LotteryCode, publish: LotteryPublish) -> [Int]  {
        let ltNumbers = code.codes!
        let pbNumbers = publish.code.codes!
        
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
}
