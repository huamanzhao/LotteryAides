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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var codeView: LotteryCodeView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unLuckyLabel: UILabel!
    var lottery: LotteryInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = Constants.cellColor
        priceLabel.isHidden = true
        unLuckyLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViewWith(lottery: LotteryInfo) {
        self.lottery = lottery
        
        nameLabel.text = lottery.lt_type.name
        termLabel.text = lottery.term + "期"
        dateLabel.text = lottery.publishDate.toString("yyyy/MM/dd")
        timeLabel.text = lottery.lt_type.time
        codeView.setupCodeView(lottery.lt_type.type, (lottery.codes.first)!)
    }
    
    func updateViewWith(publish: LotteryPublish) {
        let results = lottery.lt_type.getLuckyResult(code: lottery.codes.first!, publish: publish)
        if results.count == 0 {
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
