//
//  UpdateLotteryRequest.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire

class UpdateLotteryRequest: RequestBase {
    var id = ""
    var isRead = true
    var isLucky = false
    var level = 0
    var prize = 0
    
    func getRequest() -> [String : String]{
        let request = [
            "phone" : UserConfig.getInstance().getPhone(),
            "id" : id,
            "isRead" : isRead ? "1" : "0",
            "isLucky" : isLucky ? "1" : "0",
            "level" : "\(level)",
            "prize" : "\(prize)"
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
        return Alamofire.request(Constants.serverBaseUrl + "/cp_updateTicket", method: .post, parameters: getRequest())
    }
}
