//
//  TXExtArray.swift
//  Heymow
//
//  Created by hgy on 16/5/23.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension Array {
    
    ///仅字符串数组
    func toString() -> String {
        var string = ""
        for s in self {
            if s is String {
                string = (string + (s as! String)) + ","
            }
        }
        string = string.substring(to: string.characters.index(string.endIndex, offsetBy: -1))
        return string
    }
}
