//
//  AboutUsViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/6.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "关于我们"
        
        setCustomBackButton()
        
        versionLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
