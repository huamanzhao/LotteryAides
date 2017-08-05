//
//  LotteryListViewController.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryListViewController: UIViewController {
    var type: UInt = 0    //0-待开奖 1-已中奖  2-全部

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        if type == 0 {
            self.view.backgroundColor = UIColor.red
        }
        else if type == 1 {
            self.view.backgroundColor = UIColor.yellow
        }
        else {
            self.view.backgroundColor = UIColor.green
        }
    }

}
