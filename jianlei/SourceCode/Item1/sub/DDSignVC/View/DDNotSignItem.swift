//
//  DDNotSignItem.swift
//  Project
//
//  Created by WY on 2019/8/11.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

protocol DDNotSignItemDelegate : NSObjectProtocol {
    var isNeesDestroy : Bool {get set }
    func notSignItemClick(collection:UICollectionView,indexPath:IndexPath)
}
class DDNotSignItem: UICollectionViewCell{
    var blankView : DDBlankView?
    var apiModel : ApiModel<[DDFootprintVC.NotSignDataModel]>?{
        didSet{
            
            self.blankView?.remove()
            if let unwrapModels = apiModel?.data , unwrapModels.count > 0  {
                self.collectionView.reloadData()
                self.collectionView.isScrollEnabled = true
            }else{ // 未空时 表示没有加入团队
                let alert = DDBlankView(message: "everyone_working"|?|, image: UIImage(named: "allwork"))
                self.blankView = alert
                alert.isHideWhenWhitespaceClick = false
                self.alert(alert )
                self.collectionView.isScrollEnabled = true 
            }
            
        }
    }
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var delegate:DDNotSignItemDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutCollectionView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil && (self.delegate?.isNeesDestroy ?? false ){
            self.delegate = nil
        }/// in case of memary leaking
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height )
        let minimumInteritemSpacing : CGFloat = 15
        collectionView.contentInset = UIEdgeInsets(top: 0, left: minimumInteritemSpacing , bottom: 0, right: minimumInteritemSpacing )
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            
            let itemW = (self.bounds.width - minimumInteritemSpacing * 4 - collectionView.contentInset.left  - collectionView.contentInset.right)/5
            flowLayout.itemSize = CGSize(width: itemW, height: itemW * 1.5)
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }
    func layoutCollectionView() {
        self.contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(DDNotSignPerson.self , forCellWithReuseIdentifier: "DDNotSignPerson")

        collectionView.backgroundColor = UIColor.white
       
    }
    

}
extension DDNotSignItem:UICollectionViewDataSource,UICollectionViewDelegate{
    //collection delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apiModel?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDNotSignPerson", for: indexPath)
        if let temp = cell as? DDNotSignPerson{
            temp.model = self.apiModel?.data?[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.notSignItemClick(collection: collectionView, indexPath: indexPath)
    }
}

class DDNotSignPerson: UICollectionViewCell {
    let imageView = UIImageView()
    let jobIndicator = UIImageView()
    let nameLabel = UILabel()
    var model : DDFootprintVC.NotSignDataModel?{
        didSet{
            
            nameLabel.text = model?.memberName?.name
            imageView.setImageUrl(url: model?.memberName?.avatar)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(jobIndicator)
        self.contentView.addSubview(nameLabel)
        imageView.backgroundColor = UIColor.lightGray
//        nameLabel.backgroundColor = UIColor.purple
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.gray
        nameLabel.text = "爱新觉罗玄烨"
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        jobIndicator.frame = CGRect(x: self.bounds.width * 0.6, y: self.bounds.width * 0.6, width: self.bounds.width * 0.4, height: self.bounds.width * 0.4)
        let additionalWidth : CGFloat = 8
        nameLabel.frame = CGRect(x: -additionalWidth, y: imageView.frame.maxY, width: self.bounds.width + additionalWidth * 2, height: self.bounds.height - imageView.frame.maxY)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width/2
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
