//
//  ServerResponseBase.swift
//  Heymow
//
//  Created by hgy on 16/4/12.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServerResponseBase: NSObject {
    var code = ""
    var message = ""
    var js : SwiftyJSON.JSON?
    
    func parseResponse(_ json : Alamofire.Result<Any>){
        if let value = json.value {
            js = SwiftyJSON.JSON(value)
            code = js!["code"].stringValue
            message = js!["message"].stringValue
        }else {
            code = "1"
            message = "未知错误"
        }
    }
}
