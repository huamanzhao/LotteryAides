//
//  SectionHeaderView.swift
//  Heymow
//
//  Created by Icefly on 16/9/20.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    @IBOutlet weak var marginTop: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    func setFrame(_ width: CGFloat, height: CGFloat, marginTop: CGFloat) {
        self.marginTop.constant = marginTop
        self.frame = CGRect(x: 0, y: 0, width: width, height: height + marginTop)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setSubTitle(_ subTitle: String) {
        subTitleLabel.isHidden = false
        subTitleLabel.text = subTitle
    }
    
    func setFuncButton(title: String, image: String, tintColor: UIColor = UIColor.white) {
        actionButton.setTitle(title, for: .normal)
        actionButton.setTitleColor(tintColor, for: .normal)
        actionButton.setImage(UIImage(named: image), for: .normal)
        actionButton.tintColor = tintColor
    }
    
    func addAction(_ target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        actionButton.addTarget(target, action: action, for: controlEvents)
    }
}
