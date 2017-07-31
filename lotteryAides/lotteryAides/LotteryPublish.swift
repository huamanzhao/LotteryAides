//
//  LotteryPublish.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import SwiftyJSON

class LotteryPublish: AnyObject {
    var name = ""
    var term = ""
    var code : LotteryCode!
    
    func parseJson(_ js: SwiftyJSON.JSON) {
        if let data = js.dictionary {
            if let nameJS = data["name"] {
                name = nameJS.stringValue
            }
            
            if let termJS = data["term"] {
                term = termJS.stringValue
            }
            
            if let codeJS = data["codes"] {
                code = LotteryCode(codeJS)
            }
        }
    }
}
