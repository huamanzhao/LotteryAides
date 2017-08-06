//
//  LotteryAddingViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/7.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryAddingViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var multipleView: UIView!
    @IBOutlet weak var multipleText: UITextField!
    
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var costText: UITextField!
    
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var termText: UITextField!
    
    @IBOutlet weak var openDateView: UIView!
    @IBOutlet weak var openDateText: UITextField!
    
    @IBOutlet weak var countTimeView: UIView!
    @IBOutlet weak var countTimeLabel: UILabel!
    @IBOutlet weak var countViewHeightCS: NSLayoutConstraint!
    
    @IBOutlet weak var publishView: UIView!
    @IBOutlet weak var publishCodeView: LotteryCodeView!
    @IBOutlet weak var publishViewHeightCS: NSLayoutConstraint!
    
    @IBOutlet weak var lotteryView: UIView!
    @IBOutlet weak var redBallLabel: UILabel!
    @IBOutlet weak var blueBallLabel: UILabel!
    @IBOutlet weak var lotteryCodeView: LotteryCodeView!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultViewWidthCS: NSLayoutConstraint!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var unluckyLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    var lottery: LotteryInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加彩票"
        setCustomBackButton()
        setupViewLayout()
        
        lottery = LotteryInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupViewLayout() {
        resultViewWidthCS.constant = 0
        countViewHeightCS.constant = 0
        publishViewHeightCS.constant = 0
        
        countTimeView.isHidden = true
        publishView.isHidden = true
        resultView.isHidden  = true
        
        addButton.backgroundColor = UIColor.clear
        addButton.addCorner(radius: 4.0, borderWidth: 1.5, backColor: Constants.subColor, borderColor: UIColor(hex: 0xfff5d0))
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
}
