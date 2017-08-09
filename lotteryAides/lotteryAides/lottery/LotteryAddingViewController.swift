//
//  LotteryAddingViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/7.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import MBProgressHUD

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
    var configHeight: CGFloat = 0
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加彩票"
        setCustomBackButton()
        setupViewLayout()
        
        lottery = LotteryInfo()
        addButton.alpha = 0
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
        
        configHeight = Constants.screenHeight * 0.45
        
        configView = Bundle.main.loadNibNamed("LotteryInputView", owner: nil, options: nil)?.first as! LotteryInputView
        configView.frame = CGRect(x: 0, y: Constants.screenHeight, width: Constants.screenWidth, height: configHeight) //初始化的时候，让它整个隐藏在屏幕下边
        configView.delegate = self
        configView.setupContentView()
        self.view.addSubview(configView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startConfigViewAnimate(show: true)
    }
    
    func startConfigViewAnimate(show: Bool) {
        UIView.animate(withDuration: 0.5) {
            let transformY = show ? 0 - self.configHeight : self.configHeight
            self.configView.transform = self.configView.transform.translatedBy(x: 0, y: transformY)
            if !show {
                self.addButton.alpha = 1
            }
        }
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
        countTimeLabel.textColor = Constants.subColor
        
        countViewHeightCS.constant = 0
        
        countTimeView.isHidden = true
        
        addButton.backgroundColor = UIColor.clear
        addButton.addCorner(radius: 8.0, borderWidth: 1.5, backColor: Constants.subColor, borderColor: UIColor(hex: 0xfff5d0))
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
        if lottery.lt_type != nil {
            titleLabel.text = lottery.lt_type.name
            let type = lottery.lt_type.type
            if type == 2 || type == 4 {
                redBallLabel.isHidden = true
                blueBallLabel.isHidden = true
            }
        }
        multipleText.text = "\(lottery.multiple)"
        costText.text = "\(lottery.cost)"
        if !lottery.term.isEmpty {
            termText.text = lottery.term
        }
        if lottery.publishDate.isLaterThan(Date()) {
            openDateText.text = lottery.getPublishDateString()
        }
        if !lottery.codes.isEmpty {
            lotteryCodeView.setupCodeView(lottery: self.lottery, status: 2, white: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在上传"
        let request = AddLotteryRequest()
        request.lottery = lottery
        request.doRequest { (isOK, response) in
            DispatchQueue.main.async {
                hud.hide(animated: true)
            }
            
            if isOK && response.code == "0" {
                self.view.makeToast("上传成功")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.view.makeToast("上传失败：\(response.message)")
            }
        }
    }
}

extension LotteryAddingViewController : LotteryInputDelegate {
    func updateLotteryInfo(_ lottery: LotteryInfo) {
        self.lottery = lottery
        setupViewData()
    }
    
    func lotterySettingFinished() {
        startConfigViewAnimate(show: false)
        
        //启动倒计时
        countViewHeightCS.constant = 64
        countTimeView.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(waitingPublishCountDown), userInfo: nil, repeats: true)
    }
    
    func waitingPublishCountDown() {
        let currDate = Date()
        let countdown = Util.getCountdownTime(earlyDate: currDate, lateDate: lottery.publishDate)
        countTimeLabel.text = countdown
        if currDate == lottery.publishDate {
            timer.invalidate()
        }
    }
}
