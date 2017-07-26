//
//  RequestBase.swift
//  Heymow
//
//  Created by hgy on 16/5/27.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit
import Alamofire

protocol RequestBase {
    func generateRequest() -> Alamofire.DataRequest
}
