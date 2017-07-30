
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
                if let value = serverResponse.result.value {
                    let errMsgDic = SwiftyJSON.JSON(value).dictionaryValue
                    if let messageJSON = errMsgDic["errorMessage"] {
                        let errorMessage = messageJSON.stringValue
                        if errorMessage.isEmpty {
                            call!(true, response, serverResponse)
                            return
                        }
                        
                        response.message = errorMessage
                        response.code = "1"
                    }
                }
                call!(false, response, serverResponse)
            } else if statusCode == 100 {
                response.code = "1"
                response.message = "参数错误"
                call!(false, response, serverResponse)
            } else if statusCode == 403 {
                response.code = "1"
                response.message = "权限错误"
                call!(false, response, serverResponse)
            }else {//TODO: 调试时的返回404，走这里，记得去掉
                response.code = "1"
                response.message = "错误：statusCode=\(statusCode)"
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
