//
//  AddLotteryRequest.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire

class AddLotteryRequest: RequestBase {
    var lottery: LotteryInfo!
    
    func getRequest() -> [String : String]{
        let request = [
            "phone" : UserConfig.getInstance().getPhone(),
            "name" : lottery.lt_type.name!,
            "term" : lottery.term,
            "publishDate" : lottery.getPublishDateString(),
            "multiple" : "\(lottery.multiple)",
            "cost" : "\(lottery.cost)",
            "codes" : getCodesString()
        ]
        
        return request
    }
    
    func doRequest(_ callback : ((_ isOK: Bool, _ response: ServerResponseBase) -> Void)?){
        let res = ServerResponseBase()
        let util = ServerBase()
        let request = generateRequest()
        request.responseJSON { (data) in
            util.parseResponse(self, serverResponse: data, response: res){ (isOK, response, responseData) in
                if isOK {
                    res.parseResponse(data.result)
                    callback!(true, res)
                }else {
                    callback!(false, response)
                }
            }
        }
    }
    
    func generateRequest() -> DataRequest {
        return Alamofire.request(Constants.serverBaseUrl + "cp_user_order", method: .post, parameters: getRequest())
    }
    
    func getCodesString() -> String {
        let codes = lottery.codes!
        
        var result = ""
        if codes.isEmpty {
            return "[]"
        }
        
        result = codes.first!.getJSONString()
        
        for (index, code) in codes.enumerated() {
            if index == 0 {
                continue
            }
            
            result = result + "," + code.getJSONString()
        }
        
        return "[" + result + "]"
    }
}
