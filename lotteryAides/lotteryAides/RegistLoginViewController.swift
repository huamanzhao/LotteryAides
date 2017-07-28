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
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var subFuncBtn: UIButton!
    @IBOutlet weak var funcBtn: UIButton!
    
    @IBOutlet weak var phoneBgView: UIView!
    @IBOutlet weak var passwordBgView: UIView!
    
    var funcType : FuncType = FuncType.login
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubView()
    }
    
    func setupSubView() {
        maskView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        //bgView的颜色
        let inputBgColor = UIColor(white: 0.2, alpha: 0.8)
        phoneBgView.backgroundColor = inputBgColor
        passwordBgView.backgroundColor = inputBgColor
        
        //输入框前面的图标颜色
        phoneIcon.tintColor = Constants.mainColor
        passwordIcon.tintColor = Constants.mainColor
        showPasswordBtn.tintColor = Constants.mainColor
        
        //底部按钮样式
        funcBtn.layer.masksToBounds = true
        funcBtn.layer.cornerRadius = 4.0
        funcBtn.backgroundColor = Constants.mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func functionButtonPressed(_ sender: Any) {
    }
    
    @IBAction func subButtonPressed(_ sender: Any) {
        if funcType == FuncType.login {
            funcType = FuncType.regist
            displayRegist()
        }
        else if funcType == FuncType.forget {
            displayFindback()
        }
    }
    
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
        funcBtn.setTitle("找回密码", for: .normal)
    }
    
    //用户登录
    func userLogin() {
        
    }
    
    //用户注册
    func userRegist() {
        
    }
    
    //找回密码 
    func findPassword() {
        
    }
}
