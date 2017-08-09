//
//  LotterySetConfirmView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/7.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotterySetConfirmView: UIView {
    var delegate: LotterySelectDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let confirmButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        confirmButton.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        confirmButton.backgroundColor = UIColor(white: 1, alpha: 0.65)
        confirmButton.layer.cornerRadius = 64
        confirmButton.setImage(UIImage(named: "btn_confirm"), for: .normal)
        confirmButton.tintColor = Constants.subColor
        confirmButton.addTarget(self, action: #selector(confirmConfig), for: .touchUpInside)
        
        self.addSubview(confirmButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confirmConfig() {
        delegate.lotterySettingDidFinished()
    }

}
