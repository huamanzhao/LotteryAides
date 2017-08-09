//
//  GetPublishRequest.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire

class GetPublishRequest: RequestBase {
    var type : Int = 0
    var term : String = ""
    
    func getRequest() -> [String : String]{
        let request = [
            "name" : "\(type)",
            "term" : term
        ]
        
        return request
    }
    
    func doRequest(_ callback : ((_ isOK: Bool, _ response: GetPublishResponse) -> Void)?) {
        let res = GetPublishResponse()
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
        return Alamofire.request(Constants.serverBaseUrl + "/cp_getPublish", method: .get, parameters: getRequest())
    }
}
