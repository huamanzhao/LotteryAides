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
    
    @IBOutlet weak var lotteryView: UIView!
    @IBOutlet weak var redBallLabel: UILabel!
    @IBOutlet weak var blueBallLabel: UILabel!
    @IBOutlet weak var lotteryCodeView: LotteryCodeView!
    
    @IBOutlet weak var addButton: UIButton!
    
    var configView: LotteryInputView!
    
    var lottery: LotteryInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加彩票"
        setCustomBackButton()
        setupViewLayout()
        
        lottery = LotteryInfo()
        addButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if configView != nil {
            configView.removeFromSuperview()
        }
        
        configView = Bundle.main.loadNibNamed("LotteryInputView", owner: nil, options: nil)?.first as! LotteryInputView
        configView.frame = CGRect(x: 0, y: Constants.screenHeight * 0.6, width: Constants.screenWidth, height: Constants.screenHeight * 0.4)
        configView.delegate = self
        configView.setupContentView()
        self.view.addSubview(configView)
    }

    func setupViewLayout() {
        setViewBorder(titleView)
        setViewBorder(multipleView)
        setViewBorder(costView)
        setViewBorder(termView)
        setViewBorder(openDateView)
        setViewBorderWide(countTimeView)
        setViewBorderWide(lotteryView)
        
        lotteryCodeView.backgroundColor = UIColor.white
        titleLabel.textColor = Constants.subColor
        multipleText.textColor = Constants.subColor
        costText.textColor = Constants.subColor
        termText.textColor = Constants.subColor
        openDateText.textColor = Constants.subColor
        
        countViewHeightCS.constant = 0
        
        countTimeView.isHidden = true
        
        addButton.backgroundColor = UIColor.clear
        addButton.addCorner(radius: 4.0, borderWidth: 1.5, backColor: Constants.subColor, borderColor: UIColor(hex: 0xfff5d0))
    }
    
    func setViewBorder(_ view: UIView) {
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Constants.textColor.cgColor
    }
    
    func setViewBorderWide(_ view: UIView) {
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Constants.textColor.cgColor
    }
    
    func setupViewData() {
        titleLabel.text = "<" + lottery.lt_type.name + ">"
        multipleText.text = "\(lottery.mutiple)"
        costText.text = "\(lottery.cost)"
        if !lottery.term.isEmpty {
            termText.text = lottery.term
        }
        if lottery.publishDate.isLaterThan(Date().toLocalDate()) {
            openDateText.text = lottery.publishDate.toString(LOTTERY_DATE) + " " + lottery.lt_type.publishTime
        }
        if !lottery.codes.isEmpty {
            lotteryCodeView.setupCodeView(lottery: self.lottery, status: 2, white: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
}

extension LotteryAddingViewController : LotteryInputDelegate {
    func updateLotteryInfo(_ lottery: LotteryInfo) {
        self.lottery = lottery
        setupViewData()
    }
    
    func lotterySettingFinished() {
        
    }
}
