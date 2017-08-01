//
//  LotteryMainViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryMainViewController: UIViewController {
    
    @IBOutlet weak var descriptView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "彩票助手"
        
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_navi_bar"), for: .default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        getLotteryList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLotteryList() {
        GetLotteryListRequest().doRequest { (isOK, response) in
            DispatchQueue.main.async{
                self.indicatorView.stopAnimating()
                
                if isOK && response.code == "0" {
                    
                    
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        tempTest3()
    }
    
    func tempTest2() {
        let request = GetLotteryListRequest()
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                self.view.makeToast("获取订单列表OK")
            }
            else {
                self.view.makeToast("获取订单列表Failed")
            }
            print("tempTest2 isOK:" + "\(isOK)")
            print("code:" + response.code)
            print("message:" + response.message)
        }
    }
    
    func tempTest3() {
        let request = UpdateLotteryRequest()
        request.id = "2"
        request.isLucky = true
        request.isRead = true
        request.level = 1
        request.prize = 20000
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                self.view.makeToast("更新彩票中奖信息OK")
            }
            else {
                self.view.makeToast("更新彩票中奖信息Failed")
            }
            print("tempTest3 isOK:" + "\(isOK)")
            print("code:" + response.code)
            print("message:" + response.message)
        }
    }
}
