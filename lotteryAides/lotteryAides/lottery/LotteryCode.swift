//
//  LotteryCode.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import SwiftyJSON

class LotteryCode: NSObject {
    var numbers : [String]!
    
    override init() {
        super.init()
        
        numbers = [String]()
    }
    
    
    
    func getJSONString() -> String {
        let codeStr = numbers.joined(separator: ",")
        
        return "[" + codeStr + "]"
    }
    
    func parseJson(_ js: SwiftyJSON.JSON) {
        let dataArr = js.arrayValue
        
        for valueJS in dataArr {
            let value = valueJS.stringValue
            numbers.append(value)
        }
    }
    
    init(_ js: SwiftyJSON.JSON) {
        super.init()
        
        numbers = [String]()
        parseJson(js)
    }
    
    init(_ codesStr: String) {
        super.init()
        
        numbers = codesStr.components(separatedBy: ",")
    }
}
