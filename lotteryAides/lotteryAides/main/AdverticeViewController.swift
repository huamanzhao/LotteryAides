//
//  AdverticeViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class AdverticeViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var closeButton: UIButton!
    var config: UserConfig!
    let defaultUrl = "https://www.szlexuetang.com/cp_index"
    var phone = ""
    var password = ""
    var needLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)

        webView.scalesPageToFit = true
        
        config = UserConfig.getInstance()
        phone = config.getPhone()
        password = config.getPassword()
        if !phone.isEmpty && !password.isEmpty {
            autoLogin()
        }
        
        getServerAdverticeUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let urlStr = getAdverticeUrl()
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        openNextViewController()
    }
    
    func openNextViewController() {
        if !phone.isEmpty && !password.isEmpty && !needLogin {
            openLotteryVC()
        }
        else {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
    }

    func getAdverticeUrl() -> String {
        var urlStr = config.getADUrl()
        if urlStr.isEmpty {
            urlStr = defaultUrl
        }
        
        return urlStr
    }
    
    func getServerAdverticeUrl() {
        let request = GetAdverticeUrlRequest()
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                self.config.setADUrl(response.adUrl)
                self.config.saveUserInfo()
            }
        }
    }
    
    func autoLogin() {
        let request = LoginRequest()
        request.phone = phone
        request.password = password
        request.doRequest { (isOK, response) in
            if !isOK || response.code != "0" {
                self.needLogin = true
            }
        }
    }
    
    func openLotteryVC() {
        let lotteryStory = UIStoryboard(name: "lottery", bundle: nil)
        let naviVC = lotteryStory.instantiateViewController(withIdentifier: "lottery")
        self.present(naviVC, animated: true, completion: nil)
    }
    
    func tempTest4() {
        let request = GetUserStatusRequest()
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                self.view.makeToast("获取用户状态OK")
            }
            else {
                self.view.makeToast("获取用户状态Failed")
            }
            print("tempTest4 isOK:" + "\(isOK)")
            print("code:" + response.code)
            print("message:" + response.message)
        }
    }
    
    
    func getLuckyResult(ltNumbers: [Int], pbNumbers: [Int]) -> [Int]  {
        let max_len = 7
        
        if ltNumbers.count != max_len || pbNumbers.count != max_len {
            return [Int]()
        }
        
        var results = [Int]()   //保存最终结果
        var tempResults = [Int]()   //保存中间结果
        
        for (index, number) in ltNumbers.enumerated() {
            //1. 当前位置两个数组的数字不同
            if number != pbNumbers[index] {
                if tempResults.isEmpty {    //1.1 temp为空
                    continue
                }
                
                //1.2 temp不为空
                if results.isEmpty {    //1.2.1 result为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
                
                if results.count < tempResults.count {  //1.2.2 result不为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
                
                tempResults = [Int]()   //置为空
                continue
            }
            
            //2. 此位置两数字相同
            //-- 如果前一个位置或者后一个位置数字相同，则此数位置入temp列
            if index == 0 { //2.1 第一个
                if ltNumbers[index+1] == pbNumbers[index+1] {
                    tempResults.append(index)
                }
            }
            else if index == max_len - 1 {  //2.2 最后一个
                if ltNumbers[index-1] == pbNumbers[index-1] {
                    tempResults.append(index)
                }
                
                if results.isEmpty {    //2.2.1 result为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
                
                if results.count < tempResults.count {  //2.2.2 result不为空
                    results = tempResults
                    tempResults = [Int]()   //置为空
                    continue
                }
            }
            else {  //2.3 中间的
                if (ltNumbers[index-1] == pbNumbers[index-1]) || (ltNumbers[index+1] == pbNumbers[index+1]) {
                    tempResults.append(index)
                }
            }
            
        }
        
        return results
    }
}
