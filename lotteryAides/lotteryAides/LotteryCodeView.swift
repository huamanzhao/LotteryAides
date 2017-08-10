//
//  LotteryCodeView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/3.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

//彩票数字组
class LotteryCodeView: UIView {
    var numberViewList : [LotteryNumberView]!
    var numberSize = CGSize(width: Length_Number, height: Length_Number)
    var code: LotteryCode!
    var type : LotteryType!    //1：大乐透 2：七星彩： 3：双色球 4：七乐彩
    var luckyIndexes : [Int]!
    var white = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberViewList = [LotteryNumberView]()
        luckyIndexes = [Int]()
        
        self.backgroundColor = Constants.cellColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        numberViewList = [LotteryNumberView]()
        luckyIndexes = [Int]()
        
        self.backgroundColor = Constants.cellColor
    }
    
    override func layoutSubviews() {
        let width = frame.width
        var margin : CGFloat = 8
        
        if width < (Length_Number * 7 + margin * 6) {
            margin = (width - Length_Number * 7) / 6
        }
        
        let originY = (self.frame.height - Length_Number) / 2
        let count = numberViewList.count
        for index in (0 ..< count) {
            let originX = CGFloat(index) * (Length_Number + margin)
            numberViewList[index].frame = CGRect(x: originX, y: originY, width: Length_Number, height: Length_Number)
        }
    }
    
    //status: 0-未中奖 1-中奖  2-不关心是否中奖，只显示圆圈+数字（红、蓝）
    func setupCodeView(lottery: LotteryInfo, status: Int, white: Bool = false) {
        let code = lottery.codes.first
        if code == nil {
            return
        }
        
        self.white = white
        setupCodeView(code!, type: lottery.lt_type.type, status: status)
    }
    
    func setupCodeView(publish: LotteryPublish, white: Bool = false) {
        let code = publish.code
        if code == nil {
            return
        }
        
        self.white = white
        setupCodeView(code!, type: publish.type, status: 2)
    }
    
    //status: 0-未中奖 1-中奖  2-不关心是否中奖，只显示圆圈+数字（红、蓝）
    private func setupCodeView(_ code: LotteryCode, type: Int, status: Int) {
//        if code.numbers.count != 7 {
//            return
//        }
        
        for view in numberViewList {
            view.removeFromSuperview()
        }
        numberViewList.removeAll()
        
        self.code = code
        self.type = LotteryType(type: type)
        
        switch type {
        case 1:
            setupType1View(code, status)
            
        case 2:
            setupType2View(code, status)
            
        case 3:
            setupType3View(code, status)
            
        case 4:
            setupType4View(code, status)
            
        default:
            break
        }
    }
    
    
//    func updateCodeView(_ publish: LotteryPublish) {
//        for view in numberViewList {
//            view.removeFromSuperview()
//        }
//        numberViewList.removeAll()
//        
//        luckyIndexes = type.getLuckyResult(code: code, publish: publish)
//        
//        switch type.type {
//        case 1:
//            updateType1View()
//            
//        case 2:
//            updateType2View()
//            
//        case 3:
//            updateType3View()
//            
//        case 4:
//            updateType4View()
//            
//        default:
//            break
//        }
//    }
    
    //大乐透
    private func setupType1View(_ code: LotteryCode, _ status: Int) {
        for index in (0 ... 4) {
            setupBaseNumberView(code.numbers[index], status, region: 1)
        }
        for index in (5 ... 6) {
            setupBaseNumberView(code.numbers[index], status, region: 2)
        }
    }
//    private func updateType1View() {
//        for index in (0 ... 4) {
//            let region = luckyIndexes.contains(index) ? 1 : 3
//            setupBaseNumberView(code.numbers[index], CGFloat(index) * Length_Number, region)
//        }
//        for index in (5 ... 6) {
//            let region = luckyIndexes.contains(index) ? 2 : 3
//            setupBaseNumberView(code.numbers[index], CGFloat(6 * Length_Number), region)
//        }
//    }
    
    //七星彩
    private func setupType2View(_ code: LotteryCode, _ status: Int) {
        for index in (0 ... 6) {
            setupBaseNumberView(code.numbers[index], status, region: 1)
        }
    }
//    private func updateType2View()  {
//        for index in (0 ... 6) {
//            let region = luckyIndexes.contains(index) ? 1 : 3
//            setupBaseNumberView(code.numbers[index], CGFloat(index) * Length_Number, region)
//        }
//    }
    
    //双色球
    private func setupType3View(_ code: LotteryCode, _ status: Int) {
        for index in (0 ... 5) {
            setupBaseNumberView(code.numbers[index], status, region: 1)
        }
        
        setupBaseNumberView(code.numbers[6], status, region: 2)
    }
//    private func updateType3View()  {
//        for index in (0 ... 5) {
//            let region = luckyIndexes.contains(index) ? 1 : 3
//            setupBaseNumberView(code.numbers[index], CGFloat(index) * Length_Number, region)
//        }
//        
//        let region = luckyIndexes.contains(6) ? 1 : 3
//        setupBaseNumberView(code.numbers[6], CGFloat(6 * Length_Number), region)
//    }
    
    //七乐彩
    private func setupType4View(_ code: LotteryCode, _ status: Int) {
        for index in (0 ... 6) {
            setupBaseNumberView(code.numbers[index], status, region: 1)
        }
    }
//    private func updateType4View()  {
//        for index in (0 ... 6) {
//            let region = luckyIndexes.contains(index) ? 1 : 3
//            setupBaseNumberView(code.numbers[index], CGFloat(index) * Length_Number, region)
//        }
    //    }
    
    /*
     *
     //region: 1-前区红球  2-后区篮球
     //status: 0-未中奖 1-中奖  2-不关心是否中奖，只显示圆圈+数字（红、蓝）
     func setupView(number: String, region: Int, status: Int)
     */
    
    private func setupBaseNumberView(_ number: String, _ status: Int, region: Int) {
        let numView = LotteryNumberView(frame: CGRect(x: 0, y: 0, width: Length_Number, height: Length_Number))
        numView.setupView(number: number, region: region, status: status, white)
        numberViewList.append(numView)
        self.addSubview(numView)
    }
}
