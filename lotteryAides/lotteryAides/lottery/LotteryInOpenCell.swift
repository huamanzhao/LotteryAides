//
//  LotteryInOpenCell.swift
//  lotteryAides
//
//  Created by zhccc on 2017/7/29.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

let LotteryInOpenCellName = "LotteryInOpenCell"
let LotteryInOpenCellId   = "LotteryInOpenCellId"

class LotteryInOpenCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var codeView: LotteryCodeView!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unLuckyLabel: UILabel!
    @IBOutlet weak var queryView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    var lottery: LotteryInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.backgroundColor = Constants.cellColor
         
        statusView.backgroundColor = Constants.cellColor
        statusView.addCorner(radius: 4, borderWidth: 1, backColor: UIColor(hex: 0xfff5d0), borderColor: UIColor(hex: 0xfffdfe))
    }
    
    override func layoutSubviews() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //status = 0:未中奖  1：已中奖  2: 不关心是否中奖  3: 未开奖
    func setupViewWith(lottery: LotteryInfo, status: Int) {
        self.lottery = lottery
        
        queryView.isHidden = false
        priceLabel.isHidden = true
        unLuckyLabel.isHidden = true
        countView.isHidden = true
        
        nameLabel.text = lottery.lt_type.name
        termLabel.text = lottery.term + "期"
        dateLabel.text = lottery.getPublishDateString()
        timeLabel.text = lottery.lt_type.publishTime
        codeView.setupCodeView(lottery: lottery, status: status)
        
        if status == 0 {
            statusView.isHidden = false
            queryView.isHidden = true
            unLuckyLabel.isHidden = false
            priceLabel.isHidden = true
        }
        else if status == 1 {statusView.isHidden = false
            queryView.isHidden = true
            unLuckyLabel.isHidden = true
            priceLabel.isHidden = false
            
            priceLabel.text = "￥\(lottery.prize)"
        }
        else if status == 2 {
            statusView.isHidden = true
        }
        else if status == 3 {
            statusView.isHidden = false
            queryView.isHidden = true
            unLuckyLabel.isHidden = true
            priceLabel.isHidden = true
            countView.isHidden  = false
            countLabel.isHidden = false
            
            var early = Date()
            var late = lottery.publishDate
            //ZC_TEMP
            if early.isLaterThan(late){
                early = lottery.publishDate
                late = Date()
            }
            
            let countDown = Util.getSimpleCountdownTime(earlyDate: early, lateDate: late)
            countLabel.text = countDown
        }
    }
}
