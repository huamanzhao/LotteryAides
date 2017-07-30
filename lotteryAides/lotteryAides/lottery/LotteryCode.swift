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
    }
    
    func getJSONString() -> String {
        let codeStr = codes.joined(separator: ",")
        
        return "[" + codeStr + "]"
    }
    
    func parseJson(_ js: SwiftyJSON.JSON) {
        let data = js.dictionary!
        
//        if let codesJS = data["codes"] {
//            let json = codesJS.json
//            
//        }
    }
}
