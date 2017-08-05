//
//  LotteryNumberView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

let Length_Number = CGFloat(32)

//圆圈数字视图
class LotteryNumberView: UIView {
    var circleView : UIView!
    var numLabel: UILabel!
    var radius : CGFloat!
    var defalutFrame = CGRect(x: 0, y: 0, width: Length_Number, height: Length_Number)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        defalutFrame = frame
        
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSubViews()
    }
    
    func initSubViews() {
        radius = defalutFrame.size.width / 2
        
        circleView = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: defalutFrame.size))
        self.addSubview(circleView)
        
        numLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: defalutFrame.size))
        numLabel.font = UIFont.systemFont(ofSize: 14)
        numLabel.textAlignment = .center
        circleView.addSubview(numLabel)
    }
    
    //region: 1-前区红球  2-后区篮球  3-未中奖灰色
    func setupView(number: String, region: Int, bgColor: UIColor = Constants.cellColor) {
        circleView.backgroundColor = bgColor
        
        let subjectColor : UIColor!
        if region == 1 {
            subjectColor = UIColor.red
        }
        else if region == 2 {
            subjectColor = UIColor.blue
        }
        else {
            subjectColor = UIColor.darkText
        }
        
        circleView.addCorner(radius: radius, borderWidth: 1.5, backColor: UIColor.white, borderColor: subjectColor)
        numLabel.textColor = subjectColor
        numLabel.text = number
    }
}
