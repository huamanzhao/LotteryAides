//
//  SettingsViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        
        setCustomBackButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let request = LogoutRequest()
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        request.doRequest { (isOK, response) in
            DispatchQueue.main.async {
                self.hud.hide(animated: true)
            }
            if isOK && response.code == "0" {
                UserConfig.getInstance().clearData()
                self.view.makeToast("退出登录成功")
                
                Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.showParentViewController), userInfo: nil, repeats: false)
            }
        }
    }
    
    func showParentViewController() {
        self.navigationController!.dismiss(animated: true, completion: nil)
    }

}
