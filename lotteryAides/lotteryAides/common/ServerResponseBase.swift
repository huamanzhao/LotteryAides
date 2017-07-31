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
    var code = "0"
    var message = ""
    var js : SwiftyJSON.JSON?
    var resultDic : [String : SwiftyJSON.JSON]!
    
    func parseResponse(_ json : Alamofire.Result<Any>){
        if json.value == nil {
            code = "1"
            message = "未知错误"
            return
        }
        
        
        let value = json.value!
        resultDic = SwiftyJSON.JSON(value).dictionaryValue
    }
}
