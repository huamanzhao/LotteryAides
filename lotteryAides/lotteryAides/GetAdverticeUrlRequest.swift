//
//  GetAdverticeUrlRequest.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/30.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import Foundation
import Alamofire

class GetAdverticeUrlRequest: RequestBase {
    func doRequest(_ callback : ((_ isOK: Bool, _ response: GetAdverticeUrlResponse) -> Void)?){
        let res = GetAdverticeUrlResponse()
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
        return Alamofire.request(Constants.serverBaseUrl + "/cp_index_json", method: .post, parameters: nil)//getRequest())
    }
}
