//
//  LotteryNumberView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryNumberView: UIView {
    var circleView : UIView!
    var numLabel: UILabel!
    var radius : CGFloat!
    var type: Int = 0   //1-前区号码 2-后区号码 3-未中奖号码

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        radius = frame.size.width / 2
        
        circleView = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        self.addSubview(circleView)
        
        numLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        numLabel.font = UIFont.systemFont(ofSize: 14)
        circleView.addSubview(numLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(number: String, type: Int, bgColor: UIColor) {
        circleView.backgroundColor = bgColor
        
        let subjectColor : UIColor!
        if type == 1 {
            subjectColor = UIColor.red
        }
        else if type == 2 {
            subjectColor = UIColor.blue
        }
        else {
            subjectColor = UIColor.darkText
        }
        
        circleView.addCorner(radius: radius, borderWidth: 2, backColor: bgColor, borderColor: subjectColor)
        numLabel.textColor = subjectColor
        numLabel.text = number
    }
}
