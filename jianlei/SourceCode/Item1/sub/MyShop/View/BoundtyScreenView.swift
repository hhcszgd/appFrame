//
//  BoundtyScreenView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/20.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class BoundtyScreenView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    init(frame: CGRect, dataList: [BranchListModel]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.isUserInteractionEnabled = true
        self.dataArr = dataList
        //row
        var row: Int = 0
        if dataList.count % 2 == 0 {
            row = dataList.count / 2
        }else {
            row = (dataList.count + 1) / 2
        }
        var collectionHeight = CGFloat(row * 25 + 20/*topHeight*/ + 20/*bottomHeight*/ + (row - 1) * 10)
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: (SCREENWIDTH - 40) / 2.0, height: 25)
        flowLayout.scrollDirection = .vertical
        if collectionHeight >= frame.height {
            collectionHeight = frame.height - 40 - DDSliderHeight
        }
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: collectionHeight), collectionViewLayout: flowLayout)
        self.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BoundtyScreenViewCell.self, forCellWithReuseIdentifier: "BoundtyScreenViewCell")
        
        let cancleBtn = UIButton.init()
        self.addSubview(cancleBtn)
        cancleBtn.setTitle("清空", for: UIControl.State.normal)
        cancleBtn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.normal)
        cancleBtn.backgroundColor = UIColor.colorWithHexStringSwift("ffecd9")
        cancleBtn.frame = CGRect.init(x: 0, y: collectionView.max_Y, width: frame.width / 2.0, height: 40)
        cancleBtn.addTarget(self, action: #selector(cancleAction(sender:)), for: UIControl.Event.touchUpInside)
        
        let sureBtn = UIButton.init()
        self.addSubview(sureBtn)
        sureBtn.setTitle("确定", for: UIControl.State.normal)
        sureBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        sureBtn.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        sureBtn.frame = CGRect.init(x: cancleBtn.max_X, y: collectionView.max_Y, width: frame.width / 2.0, height: 40)
        sureBtn.addTarget(self, action: #selector(sureAction(sender:)), for: UIControl.Event.touchUpInside)
        
    }
    @objc func cancleAction(sender: UIButton) {
        self.removeFromSuperview()
        self.dataArr.forEach { (model) in
            model.isSelected = false
        }
        self.finishedClick?("cancle")
    }
    @objc func sureAction(sender: UIButton) {
        self.removeFromSuperview()
        let arr = self.dataArr.filter { (model) -> Bool in
            return model.isSelected
        }
        if arr.count == 0 {
            self.finishedClick?("total")
        }else {
            if let id = arr.first?.id {
                self.finishedClick?(id)
                
            }else {
                self.finishedClick?("total")
            }
            
        }
        
        
    }
    var finishedClick:((String) -> ())?
    
    
    var dataArr: [BranchListModel] = [BranchListModel]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoundtyScreenViewCell", for: indexPath) as! BoundtyScreenViewCell
        cell.model = self.dataArr[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 13, bottom: 20, right: 13)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataArr.forEach { (model) in
            model.isSelected = false
        }
        let model = self.dataArr[indexPath.item]
        model.isSelected = true
        collectionView.reloadData()
        
    }
    deinit {
        mylog("xiaohu")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class BoundtyScreenViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.imageView)
        self.contentView.backgroundColor = UIColor.white
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(self.imageView.image?.size.width ?? 0)
            make.height.equalTo(self.imageView.image?.size.height ?? 0)
        }
        self.titleLabel.textAlignment = .center
        
    }
    var model: BranchListModel? {
        didSet{
            if model?.isSelected ?? false {
                self.imageView.isHidden = false
                self.titleLabel.backgroundColor = UIColor.colorWithHexStringSwift("ffecd9")
                self.titleLabel.textColor = UIColor.colorWithHexStringSwift("ff7d09")
            }else {
                self.imageView.isHidden = true
                self.titleLabel.backgroundColor = UIColor.colorWithHexStringSwift("eeeeee")
                self.titleLabel.textColor = UIColor.colorWithHexStringSwift("323232")
            }
            self.titleLabel.text = model?.name
            
        }
    }
    let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    let imageView = UIImageView.init(image: UIImage.init(named: "selectmark"))
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
