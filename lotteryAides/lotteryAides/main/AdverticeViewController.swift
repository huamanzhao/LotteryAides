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
    var userType = BASIC_TYPE
    var countDown = 3
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.scalesPageToFit = true
        getUserStatus()
        setupCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        countDown = 3
        
        config = UserConfig.getInstance()
        userType = config.getUserType()
        
        let urlStr = getAdverticeUrl()
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
        
        if userType == BASIC_TYPE {
            phone = config.getPhone()
            password = config.getPassword()
            if !phone.isEmpty && !password.isEmpty {
                autoLogin()
            }
            else {
                //TODO 上线后，正常情况怎么处理，而且得考虑服务端已经停了，不能再进行登录操作了
                
                openLoginVC()
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCloseButton() {
        closeButton.addCorner(radius: 15, borderWidth: 2.0, backColor: UIColor(white: 0.2, alpha: 0.5), borderColor: Constants.mainColor)
    }
    
    func startCountDown() {
        countDown -= 1
        
        if countDown == 0 {
            timer.invalidate()
            
            openNextViewController()
        }
        
        closeButton.setTitle("跳过 \(countDown)", for: .normal)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        timer.invalidate()
        openNextViewController()
    }
    
    func openNextViewController() {
        if !phone.isEmpty && !password.isEmpty && !needLogin {
            openLotteryVC()
        }
        else {
            openLoginVC()
        }
    }

    func getAdverticeUrl() -> String {
        var urlStr = defaultUrl
        if config.getStatus() == "0" {
            urlStr = config.getADUrl()
            if urlStr.isEmpty {
                urlStr = defaultUrl
            }
        }
        
        if userType == BASIC_TYPE {
            getServerAdverticeUrl()
        }
        else {
            //TODO  获取BOOM上URL
            urlStr = config.getADUrl()
        }
        
        
        return urlStr
    }
    
    func getServerAdverticeUrl() {
        let request = GetAdverticeUrlRequest()
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                self.config.setADUrl(response.adUrl)
                self.config.saveUserInfo()
                
                if self.config.getStatus() == "0" {
                    self.webView.loadRequest(URLRequest(url: URL(string: response.adUrl)!))
                }
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
    
    func openLoginVC() {
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    func getUserStatus() {
        let request = GetUserStatusRequest()
        request.doRequest { (isOK, response) in
            var status = ""
            if isOK && response.code == "0" {
                status = response.status
            }
            else {
                status = "0"
            }
            
            self.config.setPromptStatus(status)
            self.config.saveUserInfo()
        }
    }
}
