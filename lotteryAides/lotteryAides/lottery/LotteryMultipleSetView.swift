//
//  LotteryMultipleSetView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/7.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryMultipleSetView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    fileprivate var picker: UIPickerView!
    var delegate : LotterySelectDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        picker.delegate = self
        picker.dataSource = self
        self.addSubview(picker)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.lotteryMutltipleDidSet(row)
    }
    
    //    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    //        return frame.width
    //    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        return nil
//    }
    
}
