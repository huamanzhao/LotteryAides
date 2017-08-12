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
    @IBOutlet weak var startButton: UIButton!
    
    var type = ""
    var imageNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupStartButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScrollView() {
        let type = getUserUpdateType()
        
        for index in 0 ... 3 {
            let originPoint = CGPoint(x: CGFloat(index) * Constants.screenWidth, y: 0)
            let imageView = UIImageView(frame: CGRect(origin: originPoint, size: Constants.screenSize))
            
            let name = type + "_guide_" + "\(index)"
            let image = UIImage(named: name)
            imageView.image = image
            scroll.addSubview(imageView)
        }
        
        scroll.contentSize = CGSize(width: Constants.screenWidth * 4, height: Constants.screenHeight)
    }
    
    func setupStartButton() {
        startButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        startButton.setTitleColor(UIColor.white, for: .normal)
        
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 5.0
        startButton.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        startButton.layer.borderWidth = 1.5
        
        startButton.isHidden = true
    }

    func getUserUpdateType() -> String {
        let config = UserConfig.getInstance()
        return config.getUserType()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let config = UserConfig.getInstance()
        config.setNeedGuide(false)
        config.saveUserInfo()
        
        self.performSegue(withIdentifier: "showAdvertice", sender: self)
    }
    
}

extension RootViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let count = offset.x / Constants.screenWidth
        
        pageControl.currentPage = Int(count)
        
        if count == 3 {
            startButton.isHidden = false
        }
        else {
            startButton.isHidden = true
        }
    }
}

