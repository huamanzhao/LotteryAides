
//
//  LotteryInputView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/6.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

protocol LotteryInputDelegate {
    func updateLotteryInfo(_ lottery: LotteryInfo)
    func lotterySettingFinished()
}

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
    var delegate : LotteryInputDelegate!
    var scrollWidth: CGFloat = 0
    var scrollHeight: CGFloat = 0
    
    var lottery: LotteryInfo!

    @IBAction func previButtonPressed(_ sender: Any) {
        scrollToPrevious()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        scrollToNext()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if currPage != 5 {
            scrollToNext()
            return
        }
        
        delegate.lotterySettingFinished()
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
        lottery = LotteryInfo()
        titleLabel.text = "请选择彩票类型"
        
        backgroundColor = Constants.subColor
        scrollView.backgroundColor = Constants.cellColor
        scrollView.delegate = self
        prevButton.isHidden = true
        
        
        scrollWidth = frame.width
        scrollHeight = frame.height - 72
        subLength = scrollHeight - 2 * verticalMargin
        viewList.removeAll()
        
        var bgImageList = [UIImageView]()
        let image = UIImage(named: "bg_gray")
        for index in 0 ... 5 {
            let imageView = UIImageView(frame: CGRect(x: scrollWidth * CGFloat(index), y: 0, width: scrollWidth, height: scrollHeight))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.tintColor = UIColor.white
            scrollView.addSubview(imageView)
        }
        
        let typeView = LotteryTypeSelectView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        self.scrollView.addSubview(typeView)
        typeView.delegate = self
        viewList.append(typeView)
        
        
        scrollView.contentSize = CGSize(width: scrollWidth * 6, height: (frame.height - 72))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currPage = Int(scrollView.contentOffset.x / scrollWidth)
        if currPage == 0 {
            prevButton.isHidden = true
        }
        else if currPage == 5 {
            nextButton.isHidden = true
        }
        else {
            if prevButton.isHidden {
                prevButton.isHidden = false
            }
            if nextButton.isHidden {
                nextButton.isHidden = false
            }
        }
        
        var title = ""
        switch currPage {
        case 0 :
            title = "请选择彩票类型"
            
        case 1:
            title = "请设置倍数"
            
        case 2:
            title = "请设置期数"
            
        case 3:
            title = "请设置开奖日期"
            
        case 4:
            title = "请设置开奖号码"
            
        case 5:
            title = "确认设置正确吗？"
            
        default:
            break
        }
        
        titleLabel.text = title
    }
    
    func scrollToNext() {
        let offsetX = scrollView.contentOffset.x
        let offsetY = scrollView.contentOffset.y
        
        if offsetX  <= (scrollView.contentSize.width - 2 * scrollWidth) {
            scrollView.setContentOffset(CGPoint(x: offsetX + scrollWidth, y: offsetY), animated: true)
        }
    }
    
    
    func scrollToPrevious() {
        let offsetX = scrollView.contentOffset.x
        let offsetY = scrollView.contentOffset.y
        
        if offsetX  >= scrollWidth {
            scrollView.setContentOffset(CGPoint(x: offsetX - scrollWidth, y: offsetY), animated: true)
        }
    }
}

extension LotteryInputView : LotteryTypeSelectDelegate {
    func lotteryTypeDidSelect(_ type: Int) {
        let ltType = LotteryType(type: type)
        lottery.lt_type = ltType
        delegate.updateLotteryInfo(lottery)
        scrollToNext()
    }
    
    func lotteryMutltipleDidSet(_ multiple: Int) {
        lottery.mutiple = multiple
        delegate.updateLotteryInfo(lottery)
        scrollToNext()
    }
    
    func lotteryTermDidSet(_ term: String) {
        lottery.term = term
        delegate.updateLotteryInfo(lottery)
        scrollToNext()
    }
    
    func lotteryPublishDateDidSet(_ date: Date) {
        lottery.publishDate = date
        delegate.updateLotteryInfo(lottery)
        scrollToNext()
    }
    
    func lotteryCodeDidSet(_ numbers: String) {
        let code = LotteryCode(numbers)
        lottery.codes.append(code)
        delegate.updateLotteryInfo(lottery)
        scrollToNext()
    }
    
    func lotterySettingDidFinished () {
        delegate.updateLotteryInfo(lottery)
        scrollToNext()
    }
}
