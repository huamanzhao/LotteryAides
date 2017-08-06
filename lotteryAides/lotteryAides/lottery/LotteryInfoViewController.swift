//
//  LotteryInfoViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

enum LotteryInfo_Type : String {
    case Adding = "Adding"
    case Waiting = "Waiting"
    case Publish = "Publish"
}

class LotteryInfoViewController: UIViewController {
    
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
    @IBOutlet weak var resultViewWidthCS: NSLayoutConstraint!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var prizeLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加彩票"
        setCustomBackButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }

}
