//
//  TXExtDouble.swift
//  Heymow
//
//  Created by hgy on 16/6/1.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

extension Double {
    func floorToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return floor(self * divisor) / divisor
    }
}
