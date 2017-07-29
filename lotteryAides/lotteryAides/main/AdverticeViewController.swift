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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)

        webView.scalesPageToFit = true
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
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }

    func getAdverticeUrl() -> String {
        return "https://wlmq.szlexuetang.com/huodong"
    }

}
