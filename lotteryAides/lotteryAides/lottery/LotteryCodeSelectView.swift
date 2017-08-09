//
//  LotteryCodeSelectView.swift
//  lotteryAides
//
//  Created by zhccc on 2017/8/8.
//  Copyright © 2017年 zhccc. All rights reserved.
//

import UIKit

class LotteryCodeSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var ltType : LotteryType!
    var collectionView: UICollectionView!
    
    private var topView: UIView!
    private var frontLabel: UILabel!
    private var rearLabel: UILabel!
    
    private let cellIdentifier = "codeNumberId"
    private var topHeight: CGFloat = 0
    private var width: CGFloat = 0
    private var cellLen: CGFloat = 0
    private var margin : CGFloat = 0
    
    private var frontList = [Int]()
    private var rearList = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topHeight = 40
        width = frame.width
        margin = 4
        cellLen = (width - margin * 4) / 5
        
        //TopView
        topView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: topHeight))
        topView.layer.borderWidth = 1.0
        topView.layer.borderColor = Constants.subColor.cgColor
        
        frontLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width * 0.6, height: topHeight))
        frontLabel.textColor = UIColor.red
        frontLabel.textAlignment = .left
        frontLabel.backgroundColor = UIColor.white
        frontLabel.backgroundColor = UIColor(hex: 0xfff6f6)
        
        rearLabel  = UILabel(frame: CGRect(x: width * 0.6, y: 0, width: width * 0.4, height: topHeight))
        rearLabel.textColor = UIColor.blue
        rearLabel.textAlignment = .left
        rearLabel.backgroundColor = UIColor.white
        rearLabel.backgroundColor = UIColor(hex: 0xf6f6ff)
        
        topView.addSubview(frontLabel)
        topView.addSubview(rearLabel)
        
        //CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellLen, height: cellLen)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        
        
        let collectionFrame = CGRect(x: 0, y: topHeight, width: width, height: frame.height - topHeight)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LotteryNumCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        self.addSubview(topView)
        self.addSubview(collectionView)
        
        
        collectionView.register(LotteryNumCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        ltType = LotteryType(type: 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if ltType.type % 2 == 0 {
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? ltType.frontMax : ltType.rearMax
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let section = indexPath.section
        var region = 0  //默认前区
        var select = false
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LotteryNumCell
        
        if section == 0 {
            select = frontList.contains(row)
            region = 0
        }
        else {
            select = rearList.contains(row)
            region = 1
        }
        
        cell.setNumber(row + 1, region: region)
        cell.isSelect = select
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LotteryNumCell
        let newSelectStatus = !cell.isSelect!   //点击之后的状态，为原选中状态的反转
        
        let row = indexPath.row
        let section = indexPath.section
        let number = row + 1
        
        if section == 0 {
            if !newSelectStatus {
                frontListRemove(number)
            }
            else {
                if !frontListAppend(number) {
                    self.makeToast("最多选择\(ltType.frontCount)个红球")
                    return
                }
            }
        }
        else {
            if !newSelectStatus {
                rearListRemove(number)
            }
            else {
                if !rearListAppend(number) {
                    self.makeToast("最多选择\(ltType.rearCount)个蓝球")
                }
            }
        }
        
        cell.isSelect = newSelectStatus
    }
    
    func frontListAppend(_ row: Int) -> Bool {
        if frontList.count == ltType.frontCount {
            return false
        }
        
        if !frontList.contains(row) {
            frontList.append(row)
        }
        
        updateFrontLabel()
        
        return true
    }
    
    func frontListRemove(_ row: Int) {
        if frontList.contains(row) {
            let index = frontList.index(of: row)!
            frontList.remove(at: index)
        }
        
        updateFrontLabel()
    }
    
    func rearListAppend(_ row: Int) -> Bool {
        if rearList.count == ltType.rearCount {
            return false
        }
        
        if !rearList.contains(row) {
            rearList.append(row)
        }
        
        updateRearLabel()
        
        return true
    }
    
    func rearListRemove(_ row: Int) {
        if rearList.contains(row) {
            let index = rearList.index(of: row)!
            rearList.remove(at: index)
        }
        
        updateRearLabel()
    }
    
    func onSort(num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    func updateFrontLabel() {
        if frontList.isEmpty {
            frontLabel.text = ""
            return
        }
        
        frontList.sort(by: onSort(num1:num2:))
        
        var front = ""
        let count = frontList.count
        for index in 0 ..< count {
            front = front + " " + "\(frontList[index])"
        }
        
        frontLabel.text = front
    }
    
    func updateRearLabel() {
        let count = rearList.count
        
        var rear = ""
        switch count {
        case 0:
            break
            
        case 1:
            rear = " \(rearList.first!)"
            
        case 2:
            rearList.sort(by: onSort(num1:num2:))
            rear = " \(rearList.first!)" + " \(rearList.last!)"
            
        default:
            break
        }
        
        rearLabel.text = rear
    }
    
}

class LotteryNumCell : UICollectionViewCell {
    private var _select = false
    
    private var numView: LotteryNumSelectView!
    private var region : Int = 1    //2: 前区红球 2： 后区蓝球
    var isSelect: Bool! {
        get {
            return _select
        }
        set {
            _select = newValue
            updateNumberSelect()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        numView = LotteryNumSelectView(frame: CGRect(x: 0, y: 0, width: Length_Number, height: Length_Number))
        numView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        self.addSubview(numView)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNumber(_ num: Int, region: Int = 0) {
        self.region = region
        
        numView.setNumber(num, region: region)
    }
    
    func setCellSelect(_ status : Bool) {
        isSelect = status
    }
    
    private func updateNumberSelect() {
        numView.setSelectStatus(isSelect)
    }
}
