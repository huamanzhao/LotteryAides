//
//  LotteryCodeView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/3.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryCodeView: UIView {
    var numberView : LotteryNumberView!
    var numbers = [String]()
    var type: Int = 0   //1-前区号码 2-后区号码 3-未中奖号码
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCodeView(number: String, type: Int, bgColor: UIColor) {
    }
}
