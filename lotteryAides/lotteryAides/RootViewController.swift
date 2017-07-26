//
//  RootViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/25.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var type = ""
    var imageNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let type = getUserUpdateType()
        
        for index in 0 ... 3 {
            let name = type + "_guide_" + "\(index)"
            let image = UIImage(named: name)
//            let 
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getUserUpdateType() -> String {
        return "senior"
    }
    
    

}

