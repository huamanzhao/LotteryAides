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
    
    override func parseResponse(_ json: Alamofire.Result<Any>) {
        super.parseResponse(json)
        
        let value = json.value as! JSON
        if let data = value.dictionary {
            if let statusJS = data["url"] {
                adUrl = statusJS.stringValue
            }
        }
    }
}

