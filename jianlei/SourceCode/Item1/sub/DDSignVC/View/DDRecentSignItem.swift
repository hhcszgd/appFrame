//
//  DDRecentSignItem.swift
//  Project
//
//  Created by WY on 2019/8/11.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit
protocol DDRecentSignItemDelegate : NSObjectProtocol {
    var isNeesDestroy : Bool {get set }
    func recentSignItemClick(collection:UICollectionView,indexPath:IndexPath)
    func reloadAction()
}
class DDRecentSignItem: UICollectionViewCell {
    var blankView : DDBlankView?
    var memberType = "0"
    /// 为nil时表示没有加入团队 , 为空数组是表示有团队没有签到,或者超管身份查看没有签到数据
    var models : [DDFootprintVC.SignDataModel]?{
        didSet{
            self.collectionView.gdLoadControl?.endLoad()
            
            if let unwrapModels = models {
                if unwrapModels.count <= 0 {
                    self.collectionView.isScrollEnabled = false
                    if memberType == "0"{//无团队的普通人
                        if self.blankView == nil {
                            let alert = DDBlankView(message: "not_join_group_yet"|?|, image: UIImage(named: "noteam"))
                            self.blankView = alert
                            alert.isHideWhenWhitespaceClick = false
                            self.alert(alert )
                        }
                    }else{//有团队,或者是超管
                        if self.blankView == nil {
                            let alert = DDBlankView(message: "no_one_sign"|?|, image: UIImage(named: "nosign"))
                            alert.isHideWhenWhitespaceClick = false
                            self.blankView = alert
                            self.alert(alert )
                        }
                    }
                }else{//正常有数据的情况
                    self.blankView?.remove()
                    self.blankView = nil
                    self.collectionView.reloadData()
                    self.collectionView.isScrollEnabled = true
                }
            }else{
                self.collectionView.isScrollEnabled = false
                if memberType == "0"{//无团队的普通人
                    if self.blankView == nil {
                        let alert = DDBlankView(message: "not_join_group_yet"|?|, image: UIImage(named: "noteam"))
                        self.blankView = alert
                        alert.isHideWhenWhitespaceClick = false
                        self.alert(alert )
                    }
                }else{//有团队,或者是超管
                    if self.blankView == nil {
                        let alert = DDBlankView(message: "no_one_sign"|?|, image: UIImage(named: "nosign"))
                        alert.isHideWhenWhitespaceClick = false
                        self.blankView = alert
                        self.alert(alert )
                    }
                }
            }
            
            
            
            
            
            
            
//            self.collectionView.gdLoadControl?.endLoad()
//
//            if let unwrapModels = models {
//                if unwrapModels.count <= 0 {//没有人签到
//                    if teamID == "0"{
//                        if self.blankView == nil {
//                            let alert = DDBlankView(message: "尚未加入任何团队 没有签到数据", image: UIImage(named: "noteam"))
//                            self.blankView = alert
//                            alert.isHideWhenWhitespaceClick = false
//                            self.alert(alert )
//                        }
//                    }else{
//                        if self.blankView == nil {
//                            let alert = DDBlankView(message: "还没有人签到", image: UIImage(named: "nosign"))
//                            alert.isHideWhenWhitespaceClick = false
//                            self.blankView = alert
//                            self.alert(alert )
//                        }
//                    }
//                    self.collectionView.isScrollEnabled = false
//                }else{//正常有数据的情况
//                    self.blankView?.remove()
//                    self.blankView = nil
//                    self.collectionView.reloadData()
//                    self.collectionView.isScrollEnabled = true
//                }
//            }else{ // 未空时 表示没有加入团队
//                self.collectionView.isScrollEnabled = false
//
//                if self.blankView == nil {
//                    let alert = DDBlankView(message: "尚未加入任何团队 没有签到数据", image: UIImage(named: "noteam"))
//                    self.blankView = alert
//                    alert.isHideWhenWhitespaceClick = false
//                    self.alert(alert )
//                }
//            }
        }
    }
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var delegate : DDRecentSignItemDelegate?
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
        collectionView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 144 * DDDevice.scale)
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 2
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    func layoutCollectionView() {
        self.contentView.addSubview(collectionView)
        collectionView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(DDRecentSignPerson.self , forCellWithReuseIdentifier: "DDRecentSignPerson")
        
        collectionView.backgroundColor = UIColor.DDLightGray
        
    }
    @objc func loadMore(){
        self.delegate?.reloadAction()
    }
    
}
extension DDRecentSignItem:UICollectionViewDataSource,UICollectionViewDelegate{
    //collection delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDRecentSignPerson", for: indexPath)
        if let temp = cell as? DDRecentSignPerson{
            temp.model = self.models?[indexPath.item]
        }
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.recentSignItemClick(collection: collectionView, indexPath: indexPath)
    }
}

class DDRecentSignPerson: UICollectionViewCell {
    var model : DDFootprintVC.SignDataModel?{
        didSet{
//            timeLabel.text = model.
//            shopName.text = model.na
            shopLocation.text = model?.shop_address
            if let lateSign = model?.late_sign , lateSign == "1"{
                    status.text = "sign_overtime"|?|
                status.isHidden = false
            }else{
                status.isHidden = true
            }
            
            imageView.setImageUrl(url: model?.member_avatar)
            
            timeLabel.text = model?.create_at
            nameLabel.text = model?.member_name
            
            let shopIcon = UIImage(named: "shopLogoInFootprint")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale , width: 16 * DDDevice.scale , height: 16 * DDDevice.scale ))  ?? NSAttributedString()
            let shopAttributeString = NSMutableAttributedString(attributedString: shopIcon)
            shopAttributeString.append(NSAttributedString(string:" \(self.model?.shop_name ?? "")"))
            shopName.attributedText = shopAttributeString
            
            
            let locationIcon = UIImage(named: "sign")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale , width: 16 * DDDevice.scale , height: 16 * DDDevice.scale ))  ?? NSAttributedString()
            let locationAttributeString = NSMutableAttributedString(attributedString: locationIcon)
            locationAttributeString.append(NSAttributedString(string:" \(self.model?.shop_address ?? "")"))
            shopLocation.attributedText = locationAttributeString
            
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let shopName = UILabel()
    let shopLocation = UILabel()
    let arrowImageView = UIImageView()
    let status = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(shopName)
        self.contentView.addSubview(shopLocation)
        self.contentView.addSubview(arrowImageView)
        self.contentView.addSubview(status)
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = UIImage(named:"enterthearrow")
        imageView.backgroundColor = UIColor.lightGray
//        nameLabel.backgroundColor = UIColor.yellow
//        timeLabel.backgroundColor = UIColor.green
//        shopName.backgroundColor = UIColor.yellow
//        shopLocation.backgroundColor = UIColor.blue
        nameLabel.font = GDFont.systemFont(ofSize: 18)
        shopName.font = GDFont.systemFont(ofSize: 15)
        shopLocation.font = GDFont.systemFont(ofSize: 15)
        nameLabel.textColor = UIColor.darkGray
        status.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        status.textColor = UIColor.orange
        timeLabel.text = ""
        status.text = ""
        status.isHidden = true
        status.textAlignment = .center
        timeLabel.textColor = UIColor.lightGray
        shopName.textColor = UIColor.lightGray
        shopLocation.textColor = UIColor.lightGray
        timeLabel.font = GDFont.systemFont(ofSize: 14)
        status.font = GDFont.systemFont(ofSize: 14)
        nameLabel.text = ""
        
        let shopIcon = UIImage(named: "shopLogoInFootprint")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale , width: 16 * DDDevice.scale , height: 16 * DDDevice.scale ))  ?? NSAttributedString()
        let shopAttributeString = NSMutableAttributedString(attributedString: shopIcon)
        shopAttributeString.append(NSAttributedString(string:" "))
        shopName.attributedText = shopAttributeString
        
        
        let locationIcon = UIImage(named: "sign")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale , width: 16 * DDDevice.scale , height: 16 * DDDevice.scale ))  ?? NSAttributedString()
        let locationAttributeString = NSMutableAttributedString(attributedString: locationIcon)
        locationAttributeString.append(NSAttributedString(string:" "))
        shopLocation.attributedText = locationAttributeString
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 13 * DDDevice.scale
        timeLabel.sizeToFit()
        status.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        imageView.frame = CGRect(x: margin, y: margin, width: self.bounds.height * 0.4, height: self.bounds.height * 0.4)
        nameLabel.frame = CGRect(x:imageView.frame.maxX + margin , y: imageView.frame.minY, width: 200, height: imageView.frame.height * 0.5)
        timeLabel.frame = CGRect(x:imageView.frame.maxX + margin , y: nameLabel.frame.maxY, width: timeLabel.bounds.width, height: imageView.frame.height * 0.39)
        shopName.frame =  CGRect(x:imageView.frame.minX , y: imageView.frame.maxY + margin, width: self.bounds.width - margin, height: (self.bounds.height - imageView.frame.maxY - margin * 2)/2 )
        shopLocation.frame =  CGRect(x:imageView.frame.minX , y: shopName.frame.maxY, width: self.bounds.width - margin, height:  (self.bounds.height - imageView.frame.maxY - margin * 2)/2 )
        let arrowImageViewW : CGFloat = 14
        let arrowImageViewH : CGFloat = 20
        arrowImageView.frame = CGRect(x: self.bounds.width - 40, y: imageView.frame.midY - arrowImageViewH/2, width: arrowImageViewW, height: arrowImageViewH)
        status.frame = CGRect(x: timeLabel.frame.maxX + 10, y: timeLabel.frame.minY, width: status.bounds.width, height: timeLabel.bounds.height)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width/2
        
        status.layer.masksToBounds = true
        status.layer.cornerRadius = status.bounds.height/2
        status.layer.borderColor = UIColor.orange.cgColor
        status.layer.borderWidth = 1
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
