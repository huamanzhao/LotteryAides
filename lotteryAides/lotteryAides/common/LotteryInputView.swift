
//
//  LotteryInputView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/6.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryInputView: UIView, UIScrollViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var verticalMargin : CGFloat = 8
    var viewList = [UIView]()
    var subLength : CGFloat!
    var currPage : Int!

    @IBAction func previButtonPressed(_ sender: Any) {
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
    
    override func layoutSubviews() {
        let centerY = (frame.height - 72) / 2
        let firstX = frame.width / 2
        let scrollWidth = frame.width
        
        for (index, view) in viewList.enumerated() {
            view.frame = CGRect(x: 0, y: verticalMargin, width: subLength, height: subLength)
            view.center = CGPoint(x: firstX + scrollWidth * CGFloat(index), y: centerY)
        }
     }
    
    func setupContentView() {
        viewList.removeAll()
        backgroundColor = Constants.subColor
        scrollView.backgroundColor = Constants.cellColor
        scrollView.delegate = self
        
        subLength = frame.height - 72 - 2 * verticalMargin
        
        let typeView = LotteryTypeSelectView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        self.scrollView.addSubview(typeView)
        viewList.append(typeView)
        
        
        scrollView.contentSize = CGSize(width: frame.width * 5, height: (frame.height - 72))
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currPage = Int(scrollView.contentOffset.x / frame.width)
        print(currPage)
    }
}
