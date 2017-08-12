//
//  AdverticeViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import MBProgressHUD

class AdverticeViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var closeButton: UIButton!
    
    var config: UserConfig!
    let defaultUrl = "https://www.szlexuetang.com/cp_index"
    var phone = ""
    var password = ""
    var needLogin = false
    var userType = USER_TYPE_BASIC
    var countDown = 3
    var timer: Timer!
    var hud: MBProgressHUD!
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.scalesPageToFit = true
        webView.delegate = self
        setupCloseButton()
        
        getUserStatus() //后台获取用户状态
        
        config = UserConfig.getInstance()
        
        status = config.getStatus()
        //1. 用户状态异常（未履约），则走正常彩票流程
        if status == "1" {
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            webView.loadRequest(URLRequest(url: URL(string: config.getADUrl())!))
            return
        }
        
        //2. 用户状态正常（履约），则走客户流程
        getBmAdverticeUrl()
        
//        //2.1 基本用户类型模式
//        if config.getUserType() == USER_TYPE_BASIC {
//            return
//        }
//        
//        //2.2 高级用户类型模式
//        if config.getStatus() == "0" {  //2.1 用户状态正常
//            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//            webView.loadRequest(URLRequest(url: URL(string: config.getADUrl())!))
//            
//            return
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCloseButton() {
        closeButton.addCorner(radius: 15, borderWidth: 2.0, backColor: UIColor(white: 0.2, alpha: 0.5), borderColor: Constants.mainColor)
        
        closeButton.isHidden = true
    }
    
    func startCountDown() {
        countDown -= 1
        
        if countDown == 0 {
            timer.invalidate()
            
            openNextViewController()
            
            return
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
    
    //自动登录
    func autoLogin() {
        let request = LoginRequest()
        request.phone = phone
        request.password = password
        request.doRequest { (isOK, response) in
            if !isOK || response.code != "0" { //登录失败后，需要重新登录
                self.needLogin = true
            }
        }
    }
    
    //获取用户状态
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
    
    func getBmAdverticeUrl() {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = BmobQuery(className: "Config")
        query?.getObjectInBackground(withId: "1e0ce6c209", block: { (object, error) in
            if error != nil || object == nil {
                return
            }
            
            let appid = object!.object(forKey: "appid") as! String
            let show  = object!.object(forKey: "show") as! Bool
            let adUrl = object!.object(forKey: "url") as! String
            
            if appid != Bundle.main.bundleIdentifier {
                return
            }
            
            let config = UserConfig.getInstance()
            let status = config.getStatus()
            
            var type = ""
            if show {
                type = USER_TYPE_SENIOR
            }
            else {
                type = USER_TYPE_BASIC
            }
            
            //当前类型跟上一次类型不一致，重新显示引导页
            if type != config.getUserType() {
                config.setNeedGuide(true)
            }
            
            if (type == USER_TYPE_SENIOR) && (status == "0") {
                self.webView.loadRequest(URLRequest(url: URL(string: adUrl)!))
                config.setUserType(type)
                config.setADUrl(adUrl)
                config.saveUserInfo()
                
                return
            }
            
            self.webView.loadRequest(URLRequest(url: URL(string: self.defaultUrl)!))
            config.setUserType(USER_TYPE_BASIC)
            config.saveUserInfo()
        })
    }

    func openLotteryVC() {
        let lotteryStory = UIStoryboard(name: "lottery", bundle: nil)
        let naviVC = lotteryStory.instantiateViewController(withIdentifier: "lottery")
        self.present(naviVC, animated: true, completion: nil)
    }
    
    func openLoginVC() {
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }
}

extension AdverticeViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hud.hide(animated: true)
        
        if config.getStatus() == "1" || config.getUserType() == USER_TYPE_BASIC {
            closeButton.isHidden = false
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            
            phone = config.getPhone()
            password = config.getPassword()
            if !phone.isEmpty && !password.isEmpty {
                autoLogin()
            }
        }
    }
}
