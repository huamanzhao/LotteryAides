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
    
    //region: 1-前区红球  2-后区篮球
    //status: 0-未中奖 1-中奖  2-不关心是否中奖，只显示圆圈+数字（红、蓝）
    func setupView(number: String, region: Int, status: Int, _ white: Bool = false) {
        numLabel.text = number
        
        circleView.backgroundColor = white ? UIColor.white : Constants.cellColor
        
        let regionColor = region == 1 ? UIColor.red : UIColor.blue
        let white = UIColor.white
        
        var textColor : UIColor!
        var backColor: UIColor!
        
        if status == 1 {
            textColor = white
            backColor = regionColor
        }
        else {
            textColor = regionColor
            backColor = white
        }
        
        circleView.addCorner(radius: radius, borderWidth: 1.5, backColor: backColor, borderColor: regionColor)
        numLabel.textColor = textColor
    }
    
    
    /*
     * 添加彩票界面 录入彩票号码界面所用
     */
    
    func setNumber(_ number: Int) {
        numLabel.text = "\(number)"
    }
    
    //region: 1-前区红球  2-后区篮球
    func setupDisplay(region: Int, select: Bool) {
        for subView in self.subviews {
            if subView is UIImageView {
                subView.removeFromSuperview()
            }
        }
        
        let regionColor = region == 1 ? UIColor.red : UIColor.blue
        let white = UIColor.white
        circleView.backgroundColor = white
        
        var textColor : UIColor!
        var backColor: UIColor!
        
        if select {
            textColor = white
            backColor = regionColor
        }
        else {
            textColor = regionColor
            backColor = white
        }
        
        circleView.addCorner(radius: radius, borderWidth: 1.5, backColor: backColor, borderColor: regionColor)
        numLabel.textColor = textColor
    }
}
