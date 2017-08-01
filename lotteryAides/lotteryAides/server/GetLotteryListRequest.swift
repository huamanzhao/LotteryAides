//
//  GetLotteryListRequest.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/31.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire

class GetLotteryListRequest: RequestBase {
    
    func getRequest() -> [String : String]{
        let request = [
            "phone" : UserConfig.getInstance().getPhone()
        ]
        
        return request
    }
    
    func doRequest(_ callback : ((_ isOK: Bool, _ response: GetLotteryListResponse) -> Void)?) {
        let res = GetLotteryListResponse()
        let util = ServerBase()
        let request = generateRequest()
        request.responseJSON { (data) in
            util.parseResponse(self, serverResponse: data, response: res){ (isOK, response, responseData) in
                if isOK {
                    res.parseResponse(responseData.result)
                    callback!(true, res)
                }else {
                    res.code = response.code
                    res.message = response.message
                    callback!(false, res)
                }
            }
        }
    }
    
    func generateRequest() -> DataRequest {
        return Alamofire.request(Constants.serverBaseUrl + "cp_getTickets", method: .post, parameters: getRequest())
    }
}
