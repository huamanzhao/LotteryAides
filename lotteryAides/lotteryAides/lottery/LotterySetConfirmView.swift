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
        
        let okButton = UIButton(frame: frame)
        okButton.setImage(UIImage(named: "btn_ok"), for: .normal)
        okButton.addTarget(self, action: #selector(confirmConfig), for: .touchUpInside)
        
        self.addSubview(okButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confirmConfig() {
        delegate.lotterySettingDidFinished()
    }

}
