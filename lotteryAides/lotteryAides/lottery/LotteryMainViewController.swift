//
//  LotteryMainViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import MBProgressHUD

class LotteryMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var descriptView: UIView!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonWidthCS: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomGapCS: NSLayoutConstraint!
    @IBOutlet weak var addLabelWidth: NSLayoutConstraint!
    
    let bigButtonWidth = Constants.screenWidth * 0.4
    let bigButtonBottomGap = Constants.screenHeight * 0.4
    let smallButtonWidth = Constants.screenWidth * 0.15
    let smallButtonBottomGap = CGFloat(16)
    
    let FindingLotteries = "查询记录"
    let NoFreshLotteriesDesc = "没有需要通知的彩票，请录入新彩票吧~"
    let QueryLotteriesError = "查询个人彩票信息失败"
    let FoundValidLotteries = "已经查询到您的彩票记录"
    
    var hud : MBProgressHUD!
    var firstShow = 0
    var startY : CGFloat = 0
    
    var lotteryResponsed = false
    var publishResponsed = false
    
    var lotteryList = [LotteryInfo]()
    var waitingLotteries = [LotteryInfo]()
    var publishLotteries = [LotteryInfo]()
    var publishList = [LotteryPublish]()
    
    var interval_delayQueay :TimeInterval = 0.8     //延迟执行查询彩票列表的时间
    var interval_btnScale   :TimeInterval = 0.2
    fileprivate let sectionHeight: CGFloat = 36
    fileprivate var sectionHeaderDic = Dictionary<Int,UIView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "彩票助手"
        
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_navi_bar"), for: .default)
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: LotteryInOpenCellName, bundle: nil), forCellReuseIdentifier: LotteryInOpenCellId)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstShow == 0 {
            buttonWidthCS.constant = smallButtonWidth
            buttonBottomGapCS.constant = smallButtonBottomGap
            
            firstShow = 1
        }
        
        //获取服务端彩票列表
        //先显示hud，然后延迟执行服务端请求
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = FindingLotteries
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getLotteryList), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLotteryList() {
        GetLotteryListRequest().doRequest { (isOK, response) in
            DispatchQueue.main.async{
                self.hud.hide(animated: true)
                
                if isOK && response.code == "0" {
                    self.lotteryList = response.lotteryList
                    if !self.lotteryList.isEmpty {
                        //缓存
                        UserConfig.updateLotteryList(self.lotteryList)
                        self.waitingLotteries = UserConfig.getWaitingLotteries()
                        self.publishLotteries = UserConfig.getPublishLotteries()
                        
                        //ZC_DEBUG
                        self.waitingLotteries = self.publishLotteries
                    }
                    
                    //没有新彩票
                    if self.waitingLotteries.isEmpty && self.publishLotteries.isEmpty {
                        self.descriptLabel.text = self.NoFreshLotteriesDesc
                        
                        //切换到添加视图
                        self.hideLotteryListTable()
                        
                        return
                    }
                    
                    //有开奖的彩票、等待提醒的彩票
                    if self.tableView.isHidden == true {
                        self.showLotteryListTable()
                    }
                    
                    if !self.publishLotteries.isEmpty {
                        self.getLotteryPublish()
                    }
                    
                    self.tableView.reloadData()
                }
                else {
                    self.view.makeToast("请求服务端数据失败")
                }
            }
            
        }
    }
    
    func getLotteryPublish() {
        for lottery in publishLotteries {
            let request = GetPublishRequest()
            request.type = lottery.lt_type.type
            request.term = lottery.term
            request.doRequest { (isOK, response) in
                if isOK && response.code == "0" {
                    self.publishList.append(response.publishInfo)
                    
                    if self.publishList.count == self.publishLotteries.count {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //隐藏tableView，显示空白面板
    func hideLotteryListTable() {
        //按钮、界面变化
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonWidthCS.constant = self.bigButtonWidth
            self.buttonBottomGapCS.constant = self.bigButtonBottomGap
            self.tableView.alpha = 0
            
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.tableView.isHidden = true
            self.view.sendSubview(toBack: self.tableView)
        }
    }
    
    //显示tableView，隐藏空白面板
    func showLotteryListTable() {
        self.tableView.isHidden = false
        self.view.bringSubview(toFront: self.tableView)
        self.view.bringSubview(toFront: self.addButton)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonWidthCS.constant = self.smallButtonWidth
            self.buttonBottomGapCS.constant = self.smallButtonBottomGap
            self.tableView.alpha = 1
            
            self.view.layoutIfNeeded()
        })
    }
    
    func checkPublishLotteries() {
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    /*
     * tableView
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return publishLotteries.count
        }
        else {
            return waitingLotteries.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: SectionHeaderView!
        if sectionHeaderDic[section] != nil {
            headerView = sectionHeaderDic[section] as! SectionHeaderView
        } else {
            headerView = Bundle.main.loadNibNamed("SectionHeaderView", owner: nil, options: nil)!.first as! SectionHeaderView
            headerView.setFrame(Constants.screenWidth, height: sectionHeight, marginTop: 0)
            headerView.backgroundColor = Constants.subColor
        }
        
        if section == 0 {
            headerView.setTitle("已开奖")
            headerView.setFuncButton(title: "标记为已读", image: "btn_checkAll")
            headerView.addAction(self, action: #selector(checkPublishLotteries), forControlEvents: .touchUpInside)
        }
        else {
            headerView.setTitle("未开奖")
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: LotteryInOpenCellId, for: indexPath) as! LotteryInOpenCell
        
        if section == 0 {   //1. 已开奖的彩票cell
            let lottery = publishLotteries[row]
            
            //1.1 显示号码
            cell.setupViewWith(lottery: lottery)
            //1.2 获取开奖记录完毕，刷新cell中奖信息
            if !publishList.isEmpty && publishList.count == publishLotteries.count {
                let publish = publishList[row]
                
                cell.updateViewWith(publish: publish)
            }
            
            return cell
        }
        else if section == 1 {  //等待开奖的cell
            let lottery = waitingLotteries[row]
            
            cell.setupViewWith(lottery: lottery, status: 1)
            
            return cell
        }
        
        return UITableViewCell()
    }
}


/* 拖动tableView时，按钮的显示隐藏逻辑
 * 1. 向下拖动，隐藏按钮
 * 2. 向上拖动，显示按钮
 */

extension LotteryMainViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentY = scrollView.contentOffset.y
        if currentY > startY { //1. 向下拖动，隐藏按钮
            if !addButton.isHidden {
                hideAddButton()
            }
        }
        else {  //2. 向上拖动，显示按钮
            if addButton.isHidden {
                showAddButton()
            }
        }
    }
    
    func hideAddButton() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.addButton.alpha = 0
        }) { (finished) in
            self.addButton.isHidden = true
        }
    }
    
    func showAddButton() {
        UIView.animate(withDuration: 0.2, animations: {
            self.addButton.alpha = 1
        }) { (finished) in
            self.addButton.isHidden = false
        }
    }
}
