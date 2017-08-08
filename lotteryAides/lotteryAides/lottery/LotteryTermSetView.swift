//
//  LotteryTermSetView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/7.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryTermSetView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    var delegate: LotterySelectDelegate!
    private var picker: UIPickerView!
    private var startNumber: Int = 0
    private var _type : Int = 0
    var type: Int! {
        get {
            return _type
        }
        set {
            _type = newValue
            getDefaultStartNum()
        }
    }
    
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
    
    func getDefaultStartNum() {
        if _type == 1 {
            startNumber = 17090
        }
        else if _type == 2 {
            startNumber = 17090
        }
        else if _type == 3 {
            startNumber = 2017090
        }
        else if _type == 4 {
            startNumber = 2017090
        }
        
        picker.reloadAllComponents()
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
        return "\(row + startNumber)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let term = "\(row + startNumber)"
        delegate.lotteryTermDidSet(term)
    }
    
}
