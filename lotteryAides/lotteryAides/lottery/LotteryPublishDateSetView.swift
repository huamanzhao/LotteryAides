//
//  LotteryPublishDateSetView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/7.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryPublishDateSetView: UIView {
    private var picker: UIDatePicker!
    private var publishTime: String = ""
    var type: LotteryType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: frame.width * 1.5, height: frame.height))
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "zh")
        picker.minimumDate = Date()
        picker.setValue(Constants.subColor, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        self.addSubview(picker)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSetPublishDate() -> String {
        let date = picker.date
        
        let dateStr = date.toString(LOTTERY_DATE)
        let timeStr = type.publishTime
        
        return dateStr + " " + timeStr
    }

}
