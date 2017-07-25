
//
//  TXServerBase.swift
//  Heymow
//
//  Created by hgy on 16/4/12.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TXServerBase: NSObject {    
    func parseResponse(_ serverRequest: TXRequestBase, serverResponse: Alamofire.DataResponse<Any>, response: TXServerResponseBase, call: ((_ isOK: Bool, _ response: TXServerResponseBase, _ responseData: Alamofire.DataResponse<Any>) -> Void)?){
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
//                call!(isOK: false, response: response, responseData: serverResponse)
//                let info = TXUserConfig.getInstance().getAccountInfo()
//                
//                if !info.userName.isEmpty {
//                    let loginRequest = TXLoginRequest()
//                    loginRequest.phoneNumber = info.userName
//                    loginRequest.password = info.password
//                    loginRequest.login{(isOK, response) -> Void in
//                        if(isOK) {
//                            //登录成功后重新调用接口
//                            if serverRequest is TXUpdateSelfRequest || serverRequest is TXSendMomentRequest || serverRequest is TXUpdateHealthGroupRequest || serverRequest is TXCreateHealthGroupRequest {
//                                response.code = "1"
//                                response.message = "请重新发送"
//                                call!(false, response, serverResponse)
//                            }else {
//                                serverRequest.generateRequest().responseJSON{ res in
//                                    self.parseResponse(serverRequest, serverResponse: res, response: response){ (isOK, res2, data) in
//                                        call!(true, res2, data)
//                                    }
//                                }
//                            }
//                        } else {
//                            print("登录失败！")
//                            response.code = "1"
//                            response.message = "登录失败"
//                            call!(false, response, serverResponse)
//                        }
//                    }
//                } else if (!info.unionId.isEmpty) {
//                    let request = TXWXLoginRequest()
//                    let info = TXUserConfig.getInstance().getAccountInfo()
//                    request.accessToken = info.wxPassword
//                    request.unionId = info.unionId
//                    request.requestLogin { (isOK, response) -> Void in
//                        if (isOK) {
//                            //登录成功后重新调用接口
//                            if serverRequest is TXUpdateSelfRequest || serverRequest is TXSendMomentRequest || serverRequest is TXUpdateHealthGroupRequest || serverRequest is TXCreateHealthGroupRequest {
//                                response.code = "1"
//                                response.message = "请重新发送"
//                                call!(false, response, serverResponse)
//                            }else {
//                                serverRequest.generateRequest().responseJSON{ res in
//                                    self.parseResponse(serverRequest, serverResponse: res, response: response){ (isOK, res2, data) in
//                                        call!(true, res2, data)
//                                    }
//                                }
//                            }
//                        } else {
//                            print("登录失败！")
//                            response.code = "1"
//                            response.message = "登录失败"
//                            call!(false, response, serverResponse)
//                            //self.view.makeToast("登录失败：授权错误，请稍候再试")
//                        }
//                    }
//                }
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
