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
    
    var type: UInt = 0    //0-待开奖 1-已中奖  2-全部
    
    var lotteryList = [LotteryInfo]()
    var waitingLotteries = [LotteryInfo]()
    var publishLotteries = [LotteryInfo]()
    var publishList = [LotteryPublish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 89
        
        tableView.register(UINib(nibName: LotteryInOpenCellName, bundle: nil), forCellReuseIdentifier: LotteryInOpenCellId)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.1))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lotteryList = UserConfig.getLotteryList()
        waitingLotteries = UserConfig.getWaitingLotteries()
        publishLotteries = UserConfig.getPublishLotteries()
        publishList = UserConfig.getPublishList()
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 {  //待开奖
            return waitingLotteries.count
        }
        else if type == 1 { //已中奖
            return publishLotteries.count
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
            cell.setupViewWith(lottery: lottery, status: 1)
        }
        else if type == 1 { //已中奖
            lottery = publishLotteries[row]
            cell.setupViewWith(lottery: lottery)
            
            for publish in publishList {
                if publish.term == lottery.term && publish.type == lottery.lt_type.type {
                    cell.updateViewWith(publish: publish)
                    break
                }
            }
        }
        else {  //全部
            lottery = lotteryList[row]
            if waitingLotteries.contains(lottery) {
                cell.setupViewWith(lottery: lottery, status: 1)
            }
            else if publishLotteries.contains(lottery) {
                cell.setupViewWith(lottery: lottery)
                
                for publish in publishList {
                    if publish.term == lottery.term && publish.type == lottery.lt_type.type {
                        cell.updateViewWith(publish: publish)
                        break
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
