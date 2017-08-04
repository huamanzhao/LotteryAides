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
        queryView.isHidden = false
        priceLabel.isHidden = true
        unLuckyLabel.isHidden = true
        countView.isHidden = true
    }
    
    override func layoutSubviews() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //status = 0: 已经开奖了的    1：待开奖
    func setupViewWith(lottery: LotteryInfo, status: Int = 0) {
        self.lottery = lottery
        
        nameLabel.text = lottery.lt_type.name
        termLabel.text = lottery.term + "期"
        dateLabel.text = lottery.publishDate.toString("yyyy/MM/dd")
        timeLabel.text = lottery.lt_type.time
        codeView.setupCodeView(lottery.lt_type.type, (lottery.codes.first)!)
        
        if status == 1 {
            queryView.isHidden = true
            countView.isHidden = false
            
            var early = Date()
            var late = lottery.publishDate
            //ZC_TEMP
            if early.isLaterThan(late){
                early = lottery.publishDate
                late = Date()
            }
            
            let countDown = Util.getCountdownTime(earlyDate: early, lateDate: late)
            countLabel.text = countDown
        }
    }
    
    func updateViewWith(publish: LotteryPublish) {
        let _ = lottery.lt_type.getLuckyResult(code: lottery.codes.first!, publish: publish)
        
        queryView.isHidden = true
        
        if lottery.lt_type.level == -1 {
            priceLabel.isHidden = true
            unLuckyLabel.isHidden = false
        }
        else {
            priceLabel.isHidden = true
            unLuckyLabel.isHidden = false
            
            priceLabel.text = "￥" + "\(lottery.lt_type.prize)"
        }
    }
}
