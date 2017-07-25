//
//  TXExtTableView.swift
//  Heymow
//
//  Created by LibraG on 16/7/26.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit



extension UITableView {
    
    /** 没有数据时 显示一个lable*/
    func tableViewDisplayWithMsg(_ message: String, ifNecessaryForRowCount  rowCount: NSInteger) {
        
        if (rowCount == 0) {
            //Display a message when the table is empty
            //没有数据的时候， UILabel的显示样式--------需要的话 可以改为显示图片等等
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            messageLabel.textColor = UIColor.lightGray
            messageLabel.textAlignment = NSTextAlignment.center
            messageLabel.sizeToFit()
            //设置自动换行
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
            self.backgroundView = messageLabel
            self.separatorStyle = UITableViewCellSeparatorStyle.none
        }else {
            self.backgroundView = nil
            self.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
    }
    
    
}
