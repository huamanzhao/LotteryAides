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
        funcType = FuncType.regist
        
        phoneTF.text = ""
        passwordTF.text = ""
        
        displayCorrectLayer(phoneBgView)
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
        
        //TODO
        self.performSegue(withIdentifier: "showAdvertice", sender: self)
    }
    
    //用户注册
    func userRegist() {
        if !checkPhoneInput() || !checkPasswordInput() {
            return
        }
        
        //TODO
    }
    
    //找回密码 
    func findPassword() {
        if !checkPhoneInput() || !checkPasswordInput() {
            return
        }
        
        
        //TODO
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
}

extension RegistLoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //验证手机号码
        if textField.tag == 0 {
            checkPhoneInput()
        }
        else {        //验证密码
            checkPasswordInput()
        }
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
