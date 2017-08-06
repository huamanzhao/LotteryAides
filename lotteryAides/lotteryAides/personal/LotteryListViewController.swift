//
//  LotteryListViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var type: UInt = 0    //0-待开奖 1-已中奖  2-全部
    
    var lotteryList = [LotteryInfo]()
    var waitingLotteries = [LotteryInfo]()
    var publishLotteries = [LotteryInfo]()
    var luckyLotteries = [LotteryInfo]()
    var publishList = [LotteryPublish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyImage.tintColor = Constants.subColor
        emptyLabel.textColor = Constants.subColor
        
        tableView.register(UINib(nibName: LotteryInOpenCellName, bundle: nil), forCellReuseIdentifier: LotteryInOpenCellId)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.1))
        
        tableView.rowHeight = 89
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lotteryList = UserConfig.getLotteryList()
        waitingLotteries = UserConfig.getWaitingLotteries()
        publishLotteries = UserConfig.getPublishLotteries()
        luckyLotteries = UserConfig.getLuckyLotteries()
        publishList = UserConfig.getPublishList()
        
        if type == 0 && waitingLotteries.isEmpty {  //待开奖
            self.view.sendSubview(toBack: tableView)
        }
        else if type == 1 && luckyLotteries.isEmpty { //已中奖
            self.view.sendSubview(toBack: tableView)
        }
        else if type == 2 && lotteryList.isEmpty {  //全部
            self.view.sendSubview(toBack: tableView)
        }
        else {
            self.view.bringSubview(toFront: tableView)
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 {  //待开奖
            return waitingLotteries.count
        }
        else if type == 1 { //已中奖
            return luckyLotteries.count
        }
        else {  //全部
            return lotteryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: LotteryInOpenCellId, for: indexPath) as! LotteryInOpenCell
        
        var lottery: LotteryInfo!
        if type == 0 {  //待开奖
            lottery = waitingLotteries[row]
            cell.setupViewWith(lottery: lottery, status: 3)
        }
        else if type == 1 { //已中奖
            lottery = luckyLotteries[row]
            cell.setupViewWith(lottery: lottery, status: 1)
        }
        else {  //全部
            lottery = lotteryList[row]
            cell.setupViewWith(lottery: lottery, status: 2)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let lotteryInfoVC = UIStoryboard(name: "lottery", bundle: nil).instantiateViewController(withIdentifier: "lotteryInfo") as! LotteryInfoViewController
        
        self.navigationController!.pushViewController(lotteryInfoVC, animated: true)
    }

}
