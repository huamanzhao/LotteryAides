//
//  PersonalMainViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class PersonalMainViewController: UIViewController, VTMagicViewDataSource, VTMagicViewDelegate {
    var baseController: VTMagicController!
    var titles = [String]()
    var currentPage: UInt = 0
    

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
