//
//  GetLotteryListResponse.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/31.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetLotteryListResponse : ServerResponseBase {
    var lotteryList : [LotteryInfo]!
    
    override func parseResponse(_ result : Alamofire.Result<Any>) {
        super.parseResponse(result)
        if code == "1" {
            return
        }
        
        lotteryList = [LotteryInfo]()
        
        let datas = json["codes"].arrayValue
        for data in datas {
            let lottery = LotteryInfo(data)
            if lottery.codes.count != 0 {
                lotteryList.append(lottery)
            }
        }
    }
}
