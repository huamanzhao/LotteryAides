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

    var publishTime: String = ""
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
            publishTime = "20:30"
        
        case 2:
            name = "七星彩"
            publishTime = "20:30"
            
        case 3:
            name = "双色球"
            publishTime = "21:15"
            
        case 4:
            name = "七乐彩"
            publishTime = "21:15"
            
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
            publishTime = "20:30"
            
        case "大乐透":
            type = 1
            publishTime = "20:30"
            
        case "七星彩":
            type = 2
            publishTime = "20:30"
            
        case "双色球":
            type = 3
            publishTime = "21:15"
            
        case "七乐彩":
            type = 4
            publishTime = "21:15"
            
        default:
            break
        }
        
        return type
    }
    
    
    
}
