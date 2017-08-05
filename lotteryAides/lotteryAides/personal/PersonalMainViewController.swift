//
//  PersonalMainViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import MBProgressHUD

class PersonalMainViewController: UIViewController, VTMagicViewDataSource, VTMagicViewDelegate {
    var baseController: VTMagicController!
    var titles = [String]()
    var currentPage: UInt = 0
    var hud: MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人中心"
        setCustomBackButton()
        setNaviRightImage(UIImage(named: "btn_config")!)
        
        //初始化顶部标签栏
        baseController = setBaseViewController(36)
        baseController.magicView.dataSource = self
        baseController.magicView.delegate = self
        self.view.addSubview(baseController.view)
        
        titles = ["待开奖", "已中奖", "全部"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        baseController.magicView.itemSpacing = self.view.frame.width * 0.12
        baseController.magicView.sliderWidth = self.view.frame.width * 0.15
        baseController.magicView.reloadData()
        
        getLotteryList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //获取彩票列表
    func getLotteryList() {
        hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        GetLotteryListRequest().doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                let lotteryList = response.lotteryList
                //更新缓存
                UserConfig.updateLotteryList(lotteryList!)
                
                //获取开奖结果
                self.getLotteryPublish()
            }
            else {
                DispatchQueue.main.async{
                    self.hud.hide(animated: true)
                    self.view.makeToast("请求服务端数据失败")
                }
            }
            
        }
    }
    
    //获取开奖信息（所有已开奖彩票的开奖信息）
    func getLotteryPublish() {
        let publishLotteries = UserConfig.getPublishLotteries()
        for lottery in publishLotteries {
            let request = GetPublishRequest()
            request.type = lottery.lt_type.type
            request.term = lottery.term
            request.doRequest { (isOK, response) in
                DispatchQueue.main.async{
                    self.hud.hide(animated: true)
                }
                if isOK && response.code == "0" {
                    UserConfig.appendPublish(response.publishInfo)
                }
            }
        }
    }
    
    func menuTitles(for magicView: VTMagicView!) -> [String]! {
        return titles
    }
    
    func magicView(_ magicView: VTMagicView!, menuItemAt itemIndex: UInt) -> UIButton! {
        let itemBtnIdentifier = "itemIdentifier"
        var menuBtn = magicView.dequeueReusableItem(withIdentifier: itemBtnIdentifier)
        
        if menuBtn == nil {
            menuBtn = UIButton(type: .custom)
            menuBtn?.setTitleColor(UIColor.darkText, for: UIControlState())
            menuBtn?.setTitleColor(Constants.subColor, for: .selected)
            menuBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        return menuBtn
    }
    
    func magicView(_ magicView: VTMagicView!, viewControllerAtPage pageIndex: UInt) -> UIViewController! {
        let lotteryIdentifier = "lotteryList"
        var lotteryListVC = magicView.dequeueReusablePage(withIdentifier: lotteryIdentifier) as? LotteryListViewController
        
        let storyboard = UIStoryboard(name: "personal", bundle: nil)
        if lotteryListVC == nil {
            lotteryListVC = storyboard.instantiateViewController(withIdentifier: lotteryIdentifier) as? LotteryListViewController
        }
        lotteryListVC!.type = pageIndex
        
        return lotteryListVC
    }
    
    func magicView(_ magicView: VTMagicView!, viewDidAppeare viewController: UIViewController!, atPage pageIndex: UInt) {
        currentPage = pageIndex
    }
}
