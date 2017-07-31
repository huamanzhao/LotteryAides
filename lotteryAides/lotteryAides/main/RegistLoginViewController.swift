//
//  RegistLoginViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/27.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

enum FuncType : String {
    case login = "login"
    case regist = "regist"
    case forget = "forget"
}

class RegistLoginViewController: UIViewController {
    
    let registDscp = "还没有账号吗？点此注册~"
    let forgetDscp = "忘记密码了吗？点此找回~"
    
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var funcBtn: UIButton!
    
    @IBOutlet weak var phoneBgView: UIView!
    @IBOutlet weak var passwordBgView: UIView!
    
    var funcType : FuncType = FuncType.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)

        setupSubView()
        
        //ZC_DEBUG
        phoneTF.text = "15076128501"
        passwordTF.text = "222222"
    }
    
    func setupSubView() {
        //bgView的颜色
        setupViewLayer(phoneBgView)
        setupViewLayer(passwordBgView)
        setupViewLayer(funcBtn)
        
    }
    
    func setupViewLayer(_ view: UIView) {
        view.backgroundColor = UIColor(white: 1, alpha: 0.37)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5.0
        view.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        view.layer.borderWidth = 1.5
    }
    
    func displayErrorLayer(_ view: UIView) {
        view.layer.borderColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 0.8).cgColor
    }
    
    func displayCorrectLayer(_ view: UIView) {
        view.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //底部功能按钮点击后
    @IBAction func functionButtonPressed(_ sender: Any) {
        switch funcType {
        case FuncType.login:
            userLogin()
            
        case FuncType.regist:
            userRegist()
            
        case FuncType.forget:
            findPassword()
        }
    }
    
    //忘记密码按钮
    @IBAction func forgetButtonPressed(_ sender: Any) {
        funcType = FuncType.forget
        
        passwordTF.text = ""
        
        displayCorrectLayer(passwordBgView)
        
        displayAnimationChange("找回密码")
    }
    
    //立即注册按钮
    @IBAction func registButtonPressed(_ sender: Any) {
        //ZC_DEBUG
        tempTest5()
        return
        
        funcType = FuncType.regist
        
        passwordTF.text = ""
        
        displayCorrectLayer(passwordBgView)
        
        displayAnimationChange("注册")
    }
    
    //查看密码按钮
    @IBAction func showPasswordBtnPressedDown(_ sender: Any) {
        passwordTF.isSecureTextEntry = false
    }
    @IBAction func showPasswordBtnPressedUp(_ sender: Any) {
        passwordTF.isSecureTextEntry = true
    }
    
    func displayRegist() {
        funcBtn.setTitle("注册", for: .normal)
    }
    
    func displayFindback() {
        passwordTF.text = ""
        
        displayCorrectLayer(phoneBgView)
        displayCorrectLayer(passwordBgView)
        
        funcBtn.setTitle("重置密码", for: .normal)
    }
    
    func displayAnimationChange(_ title: String) {
        UIView.animate(withDuration: 0.3) { 
            self.funcBtn.setTitle(title, for: .normal)
        }
    }
    
    //用户登录
    func userLogin() {
        if !checkPhoneInput() || !checkPasswordInput() {
            return
        }
        
        let request = LoginRequest()
        request.phone = phoneTF.text!
        request.password    = passwordTF.text!
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                let config = UserConfig.getInstance()
                config.setPhone(self.phoneTF.text!)
                config.saveUserInfo()
                
                self.view.makeToast("登陆成功")
            }
            else {
                
                self.view.makeToast("登陆失败")
            }
        }
        
        
        //TODO
//        self.performSegue(withIdentifier: "showAdvertice", sender: self)
    }
    
    //用户注册
    func userRegist() {
        if !checkPhoneInput() || !checkPasswordInput() {
            return
        }

        let request = RegistRequest()
        request.phone = phoneTF.text!
        request.password = passwordTF.text!
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                //TODO: 自动登录
                
                self.view.makeToast("注册成功")
            }
            else {
                self.view.makeToast("注册失败")
            }
        }
    }
    
    //找回密码 
    func findPassword() {
        if !checkPhoneInput() || !checkPasswordInput() {
            return
        }
        
        let request = ChangePasswordRequest()
        request.phone = phoneTF.text!
        request.newPswd = passwordTF.text!
        request.doRequest { (isOK, response) in
            print("findPassword isOK:" + "\(isOK)")
            print("code:" + response.code)
            self.view.makeToast("重置成功：" + "\(isOK)")
        }
    }
    
    func checkPhoneInput() -> Bool {
        let phone = phoneTF.text!
        if !phone.isPhoneNumber() {
            self.view.makeToast("手机号码格式错误")
            displayErrorLayer(phoneBgView)
            return false
        }
        
        displayCorrectLayer(phoneBgView)
        return true
    }
    
    func checkPasswordInput() -> Bool {
        let password = passwordTF.text!
        if !password.isValidPassword() {
            self.view.makeToast("密码只能由6~8位的数字、字母组成")
            displayErrorLayer(passwordBgView)
            return false
        }
        
        displayCorrectLayer(passwordBgView)
        return true
    }
    
    //ZC_DEBUG
    func tempTest() {
        let code1 = LotteryCode("1,6,17,18,22,26,27")
        let code2 = LotteryCode("3,5,6,10,12,20,22")
        
        let request = AddLotteryRequest()
        request.name = "4"
        request.term = "17084"
        request.publishDate = "2017/07/19"
        request.cost = 20
        request.multiple = 10
        request.codes = [code1, code2]
        request.doRequest { (isOK, response) in
            print("tempTest isOK:" + "\(isOK)")
            print("code:" + response.code)
        }
        
    }
    
    func tempTest1() {
        let request = GetPublishRequest()
        request.name = "1"
        request.term = "17072927"
        request.doRequest { (isOK, response) in
            print("tempTest1 isOK:" + "\(isOK)")
            print("code:" + response.code)
            print("message:" + response.message)
        }
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
        request.id = ""
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
    
    func tempTest5() {
        let request = GetAdverticeUrlRequest()
        request.doRequest { (isOK, response) in
            if isOK && response.code == "0" {
                self.view.makeToast("获取广告URlOK")
            }
            else {
                self.view.makeToast("获取广告URlFailed")
            }
            
            print("GetAdverticeUrl isOK:" + "\(isOK)")
            print("code:" + response.code)
            print("message:" + response.message)
        }
    }
    
}

extension RegistLoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //验证手机号码
        if textField.tag == 0 {
            phoneTF.resignFirstResponder()
            checkPhoneInput()
        }
        else {        //验证密码
            passwordTF.resignFirstResponder()
            checkPasswordInput()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            phoneTF.resignFirstResponder()
            checkPhoneInput()
        }
        else {        //验证密码
            passwordTF.resignFirstResponder()
            checkPasswordInput()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            displayCorrectLayer(phoneBgView)
        }
        else {
            displayCorrectLayer(passwordBgView)
        }
    }
}
