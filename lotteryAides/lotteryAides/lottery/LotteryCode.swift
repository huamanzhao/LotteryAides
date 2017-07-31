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
    var codes : [String]!
    
    override init() {
        super.init()
        
        codes = [String]()
    }
    
    
    
    func getJSONString() -> String {
        let codeStr = codes.joined(separator: ",")
        
        return "[" + codeStr + "]"
    }
    
    func parseJson(_ js: SwiftyJSON.JSON) {
        let dataArr = js.arrayValue
        
        for valueJS in dataArr {
            let value = valueJS.stringValue
            codes.append(value)
        }
    }
    
    init(_ js: SwiftyJSON.JSON) {
        super.init()
        
        codes = [String]()
        parseJson(js)
    }
    
    init(_ codesStr: String) {
        super.init()
        
        codes = codesStr.components(separatedBy: ",")
    }
}
