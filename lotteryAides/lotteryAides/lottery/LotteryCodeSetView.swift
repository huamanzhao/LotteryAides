//
//  LotteryCodeSetView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/7.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryCodeSetView: UIView {
    var delegate: LotterySelectDelegate!
    var type: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
