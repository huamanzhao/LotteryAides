//
//  GetAdverticeUrlResponse.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetAdverticeUrlResponse : ServerResponseBase {
    var adUrl = ""
    
    override func parseResponse(_ result: Alamofire.Result<Any>) {
        super.parseResponse(result)
        if code == "1" {
            return
        }
        
        if let data = json.dictionary {
            if let statusJS = data["url"] {
                adUrl = statusJS.stringValue
            }
        }
    }
}

