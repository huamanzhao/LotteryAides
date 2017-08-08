//
//  LotteryTypeSelectView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/6.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryTypeSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    let margin : CGFloat = 8
    let cellIdentifier = "typeCell"
    var delegate: LotterySelectDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        
        let length = (frame.width - margin) / 2
        layout.itemSize = CGSize(width: length, height: length)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LotteryTypeCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LotteryTypeCell
        
        let index = indexPath.row
        let image = UIImage(named: "logo_type\(index)")!
        cell.setLogoImage(image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        for index in 0 ... 3 {
            let path = IndexPath(row: index, section: section)
            let cell = collectionView.cellForItem(at: path)
            
            if index == row {
                cell?.backgroundColor = Constants.subColor
            }
            else {
                cell?.backgroundColor = UIColor.white
            }
        }
        
        delegate.lotteryTypeDidSelect(indexPath.row + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class LotteryTypeCell : UICollectionViewCell {
    var typeImage : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageMargin: CGFloat = 2.0
        let imageLength = frame.width - imageMargin * 2
        typeImage = UIImageView(frame: CGRect(x: imageMargin, y: imageMargin, width: imageLength, height: imageLength))
        self.addSubview(typeImage)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLogoImage(image: UIImage) {
        typeImage.image = image
    }
}
