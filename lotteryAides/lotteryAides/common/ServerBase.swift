
//
//  ServerBase.swift
//  Heymow
//
//  Created by hgy on 16/4/12.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServerBase: NSObject {    
    func parseResponse(_ serverRequest: RequestBase, serverResponse: Alamofire.DataResponse<Any>, response: ServerResponseBase, call: ((_ isOK: Bool, _ response: ServerResponseBase, _ responseData: Alamofire.DataResponse<Any>) -> Void)?){
        if serverResponse.response != nil{
            let statusCode = serverResponse.response!.statusCode
            if statusCode == 200 {
                if serverResponse.result.isFailure{
                    response.code = "1"
                    response.message = serverResponse.result.error.debugDescription
                    call!(false, response, serverResponse)
                }else {
                    call!(true, response, serverResponse)
                }
            } else if statusCode == 401 {
                response.code = "1"
                response.message = "登录失败"
                call!(false, response, serverResponse)
            } else if statusCode == 400 {
                response.code = "1"
                response.message = "参数错误"
                call!(false, response, serverResponse)
            } else if statusCode == 302 || statusCode == 405  {
                response.code = "1"
                response.message = "操作失败：未登录"
                call!(false, response, serverResponse)
            }else {//TODO: 调试时的返回404，走这里，记得去掉
                response.code = "1"
                response.message = "未知错误"
                call!(false, response, serverResponse)
            }
        }else {
            response.code = "1"
            if let error = serverResponse.result.error {
                response.message = error.localizedDescription
            }else {
                response.message = "未知错误"
            }
            call!(false, response, serverResponse)
        }
    }
}
