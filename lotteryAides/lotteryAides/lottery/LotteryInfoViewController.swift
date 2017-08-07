//
//  LotteryInfoViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var unluckyLabel: UILabel!
    
    
    var lottery : LotteryInfo!
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "彩票信息"
        setCustomBackButton()
        
        publishCodeView.backgroundColor = UIColor.white
        lotteryCodeView.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewLayout()
        setupViewData()
        
        if checkNeedsPublish() {    //查询最新开奖信息
            getPublisResult()
        }
    
        if checkNeedCountdown() {   //开启倒计时
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(waitingPublishCountDown), userInfo: nil, repeats: true)
        }
    }
    
    func setupViewLayout() {
        displayCountDownOrPublishView()
        
        if lottery.lt_type.type % 2 == 0 {
            blueBallLabel.isHidden = true
        }
        
        multipleText.isUserInteractionEnabled = false
        costText.isUserInteractionEnabled = false
        termText.isUserInteractionEnabled = false
        openDateText.isUserInteractionEnabled = false
        costText.borderStyle = .none
        termText.borderStyle = .none
        openDateText.borderStyle = .none
        multipleText.borderStyle = .none
    }
    
    func setupViewData() {
        
        titleLabel.text = "<" + lottery.lt_type.name + ">"
        multipleText.text = "\(lottery.mutiple)"
        costText.text = "\(lottery.cost)"
        termText.text = lottery.term
        openDateText.text = lottery.publishDate.toString(LOTTERY_DATE) + " " + lottery.lt_type.publishTime

        if checkNeedsPublish() {
            if lottery.isLucky {
                levelLabel.text = "\(lottery.level)等奖"
                prizeLabel.text = "￥\(lottery.prize)"
                unluckyLabel.isHidden = true
            }
            else {
                prizeLabel.isHidden = true
                levelLabel.isHidden = true
                unluckyLabel.isHidden = false
            }
        }
    }
    
    func displayCountDownOrPublishView() {
        //如果还未开奖，则显示倒计时，不显示开奖结果
        if checkNeedCountdown() {
            countTimeView.isHidden = false
            countViewHeightCS.constant = 64
            
            publishView.isHidden = true
            publishViewHeightCS.constant = 0
            resultViewWidthCS.constant = 0
        }
        
        //如果开奖结果已经公布，则不显示倒计时，显示开奖结果
        if checkNeedsPublish() {
            countTimeView.isHidden = true
            countViewHeightCS.constant = 0
            
            publishView.isHidden = false
            publishViewHeightCS.constant = 70
            resultViewWidthCS.constant = Constants.screenWidth * 0.2
        }
    }
    
    //是否要查询开奖信息
    func checkNeedsPublish() -> Bool {
        //当前是显示类型 并且 彩票开奖时间已经早于当前时间了
        return lottery.publishDate.isEarlierThan(Date().toLocalDate())
    }
    
    //是否要显示倒计时
    func checkNeedCountdown() -> Bool {
        //当前是显示类型 并且 彩票开奖时间晚于当前时间
        return lottery.publishDate.isLaterThan(Date().toLocalDate())
    }

    //查询最新开奖信息
    func getPublisResult() {
        let request = GetPublishRequest()
        request.type = lottery.lt_type.type
        request.term = lottery.term
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                let publish = response.publishInfo
                UserConfig.appendPublish(publish)
                self.lottery.getLuckyResult(publish: publish)
                
                self.publishCodeView.setupCodeView(publish: publish, white: true)
                
                let status = self.lottery.isLucky ? 1 : 0
                self.lotteryCodeView.setupCodeView(lottery: self.lottery, status: status, white: true)
            }
        }
    }
    
    func waitingPublishCountDown() {
        if checkNeedCountdown() {
            let currDate = Date().toLocalDate()
            let countdown = Util.getCountdownTime(earlyDate: currDate, lateDate: currDate)
            countTimeLabel.text = countdown
        }
        else {
            timer.invalidate()
            getPublisResult()
            
            displayCountDownOrPublishView()
        }
    }
    
    
}
