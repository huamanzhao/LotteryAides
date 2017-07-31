//
//  LogoutRequest.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire

class LogoutRequest: RequestBase {
    var phone : String = ""
    
    func getRequest() -> [String : String]{
        let request = [
            "phone" : phone
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
        return Alamofire.request(Constants.serverBaseUrl + "cp_logout", method: .post, parameters: getRequest())
    }
}
