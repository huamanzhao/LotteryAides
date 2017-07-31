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
    var name : String = ""
    var term : String = ""
    var publishDate = ""
    var multiple: Int = 0
    var cost : Int = 0
    var codes : [LotteryCode]!
    
    func getRequest() -> [String : String]{
        let request = [
            "phone" : "15076128501",    //ZC_DEBUG
            "name" : name,
            "term" : term,
            "publishDate" : publishDate,
            "multiple" : "\(multiple)",
            "cost" : "\(cost)",
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
        if codes == nil {
            return ""
        }
        
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
