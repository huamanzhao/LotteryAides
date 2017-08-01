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
}


extension AdverticeViewController {
    
    
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
}
