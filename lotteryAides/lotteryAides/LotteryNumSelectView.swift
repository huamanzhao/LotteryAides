//
//  LotteryNumSelectView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/9.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryNumSelectView: UIView {
    var select = false
    var region = 0
    var number = 0
    private var label: UILabel!
    private var borderColor : UIColor!
    private var fillColor: UIColor!
    private var textColor: UIColor!
    
    private let red = UIColor.red
    private let blue = UIColor.blue
    private let white = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        borderColor = region == 0 ? red : blue
        if !select {
            fillColor = white
            textColor = region == 0 ? red : blue
        }
        else if region == 0 {
            fillColor = red
            textColor = white
        }
        else {
            fillColor = blue
            textColor = white
        }
        
        
        //填充色
        fillColor.set()
        let bPath = UIBezierPath.init(ovalIn: rect)
        bPath.fill()
        
        //边框色
        borderColor.set()
        let aPath = UIBezierPath.init(ovalIn: CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2))
        aPath.lineWidth = 2
        aPath.stroke()
        
        //数字
        let numStr = NSString(string: "\(number)")
        
        let font = UIFont.systemFont(ofSize: 14.0)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        numStr.draw(in: CGRect(x: 0, y: rect.height * 0.2, width: rect.width, height: rect.height * 0.6), withAttributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : textColor, NSParagraphStyleAttributeName: style])
    }
    
    func setNumber(_ num: Int, region: Int = 0) {
        self.region = region
        self.number = num
        
//        self.setNeedsDisplay()
    }
    
    func setSelectStatus(_ status: Bool) {
        select = status
        
        self.setNeedsDisplay()
    }

}
