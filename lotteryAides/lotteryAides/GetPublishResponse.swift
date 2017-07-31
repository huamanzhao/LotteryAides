//
//  GetPublishResponse.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetPublishResponse : ServerResponseBase {
    var publishInfo : LotteryPublish!
    
    override func parseResponse(_ result : Alamofire.Result<Any>) {
        super.parseResponse(result)
        if code == "1" {
            return
        }
        
        publishInfo = LotteryPublish()
        publishInfo.parseJson(json)
    }
}
