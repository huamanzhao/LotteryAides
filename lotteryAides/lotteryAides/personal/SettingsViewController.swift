//
//  SettingsViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    var notifySwitch: UISwitch!
    
    var hud: MBProgressHUD!
    var config: UserConfig!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        
        setCustomBackButton()
        
        bgImage.tintColor = UIColor(hex: 0xf2f2f2)
        logoutButton.backgroundColor = Constants.subColor
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        
        tableView.rowHeight = 44
        
        config = UserConfig.getInstance()
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
    
    func showAboutUsViewController() {
        
    }
    
    func showParentViewController() {
        self.navigationController!.dismiss(animated: true, completion: nil)
    }
    
    func notifyConfigChanged() {
        let status = notifySwitch.isOn
        config.setNotifyOn(status)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "notification")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "notification")
            }
            
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.text = "开奖提醒"
            
            let originX = Constants.screenWidth - 56 - 8
            notifySwitch = UISwitch(frame: CGRect(x: originX , y: 6, width: 56, height: 32))
            notifySwitch.onTintColor = Constants.subColor
            notifySwitch.isOn = config.getNotifyOn()
            notifySwitch.addTarget(self, action: #selector(notifyConfigChanged), for: .valueChanged)
            cell?.addSubview(notifySwitch)
            
            return cell!
        }
        
        else if row == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "aboutus")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "aboutus")
            }
            
            cell!.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.text = "关于我们"
            
            return cell!
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        if row == 1 {
            self.performSegue(withIdentifier: "showAbout", sender: self)
        }
    }

}
