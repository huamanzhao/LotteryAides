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
            imageView.image = UIImage(named: name)
            scroll.addSubview(imageView)
        }
        
        scroll.contentSize = CGSize(width: Constants.screenWidth * 4, height: Constants.screenHeight)
    }
    
    func setupStartButton() {
        startButton.backgroundColor = UIColor(colorLiteralRed: 0.97, green: 0.82, blue: 0.28, alpha: 0.8)//UIColor(hex: 0xf9d247)
        startButton.layer.cornerRadius = 4.0
        startButton.layer.masksToBounds = true
        startButton.layer.borderColor = Constants.subColor.cgColor
        startButton.layer.borderWidth = 1.0
        
        startButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 36, bottom: 8, right: 36)
        
        startButton.isHidden = true
    }

    func getUserUpdateType() -> String {
        return SENIOR_TYPE
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showLoginId", sender: self)
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

