
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

protocol LotterySelectDelegate {
    func lotteryTypeDidSelect(_ type: Int)
    func lotteryMutltipleDidSet(_ multiple: Int)
    func lotteryTermDidSet(_ term: String)
    func lotteryCodeDidSet(_ numbers: String)
    func lotterySettingDidFinished ()
}

class LotteryInputView: UIView, UIScrollViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var multipleView: LotteryMultipleSetView!
    var termView: LotteryTermSetView!
    var publishView: LotteryPublishDateSetView!
    var codeView: LotteryCodeSetView!
    var confirmView: LotterySetConfirmView!
    
    var verticalMargin : CGFloat = 8
    var viewList = [UIView]()
    var subLength : CGFloat!
    var currPage : Int = 0
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
            if currPage == 3 {
                let dateStr = publishView.getSetPublishDate()
                lottery.getPublishDate(dateStr)
                delegate.updateLotteryInfo(lottery)
            }
            return
        }
        
        delegate.lotterySettingFinished()
    }
    
    override func layoutSubviews() {
        let centerY = (frame.height - 76) / 2
        let firstX = frame.width / 2
        let scrollWidth = frame.width
        
        for (index, view) in viewList.enumerated() {
            view.frame = CGRect(x: 0, y: verticalMargin, width: subLength, height: subLength)
            if index == 3 {
                view.frame = CGRect(x: 0, y: verticalMargin, width: subLength * 1.5, height: subLength)
            }
            
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
        scrollHeight = frame.height - 76
        subLength = scrollHeight - 2 * verticalMargin
        viewList.removeAll()
        
        let image = UIImage(named: "bg_gray")
        for index in 0 ... 5 {
            let imageView = UIImageView(frame: CGRect(x: scrollWidth * CGFloat(index), y: 0, width: scrollWidth, height: scrollHeight))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.tintColor = UIColor.white
            scrollView.addSubview(imageView)
        }
        
        //1. 类型
        let typeView = LotteryTypeSelectView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        typeView.delegate = self
        self.scrollView.addSubview(typeView)
        viewList.append(typeView)
        
        //2. 倍数
        multipleView = LotteryMultipleSetView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        multipleView.delegate = self
        self.scrollView.addSubview(multipleView)
        viewList.append(multipleView)
        
        //3. 期次
        termView = LotteryTermSetView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        termView.delegate = self
        self.scrollView.addSubview(termView)
        viewList.append(termView)
        
        //4. 开奖日期
        publishView = LotteryPublishDateSetView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        self.scrollView.addSubview(publishView)
        viewList.append(publishView)
        
        //5. 号码选择
        codeView = LotteryCodeSetView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        codeView.delegate = self
        self.scrollView.addSubview(codeView)
        viewList.append(codeView)
        
        //6. 确认配置正确
        confirmView = LotterySetConfirmView(frame: CGRect(x: 0, y: 0, width: subLength, height: subLength))
        confirmView.delegate = self
        self.scrollView.addSubview(confirmView)
        viewList.append(confirmView)
        
        scrollView.contentSize = CGSize(width: scrollWidth * 6, height: (frame.height - 76))
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

extension LotteryInputView : LotterySelectDelegate {
    func lotteryTypeDidSelect(_ type: Int) {
        let ltType = LotteryType(type: type)
        lottery.lt_type = ltType
        termView.type = ltType.type
        publishView.type = ltType
        codeView.type = ltType.type
        delegate.updateLotteryInfo(lottery)
    }
    
    func lotteryMutltipleDidSet(_ multiple: Int) {
        lottery.multiple = multiple
        delegate.updateLotteryInfo(lottery)
    }
    
    func lotteryTermDidSet(_ term: String) {
        lottery.term = term
        delegate.updateLotteryInfo(lottery)
    }
    
    func lotteryCodeDidSet(_ numbers: String) {
        let code = LotteryCode(numbers)
        lottery.codes.append(code)
        lottery.cost = lottery.multiple * 2
        delegate.updateLotteryInfo(lottery)
    }
    
    func lotterySettingDidFinished () {
        delegate.lotterySettingFinished()
    }
}
