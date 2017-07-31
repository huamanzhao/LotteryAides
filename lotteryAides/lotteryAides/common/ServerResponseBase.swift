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
    var json : SwiftyJSON.JSON!
    
    func parseResponse(_ result : Alamofire.Result<Any>){
        if result.value == nil {
            code = "1"
            message = "未知错误"
            return
        }
        
        json = SwiftyJSON.JSON(result.value!)
    }
}
