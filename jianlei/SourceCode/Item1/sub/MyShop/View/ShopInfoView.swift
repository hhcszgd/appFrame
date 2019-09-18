//
//  ShopInfoView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ShopInfoView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            
            // Fallback on earlier versions
        }
        
        self.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        //个人信息
        let width: CGFloat = frame.width
        let height: CGFloat = 44
        let userInfo = self.configTuPianGuiFan(title: "shop_info_income"|?|, isHidden: true)
        userInfo.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: 50)
        self.addSubview(self.dianPuFeiYongCell)
        self.dianPuFeiYongCell.frame = CGRect.init(x: 0, y: userInfo.max_Y + 1, width: width, height: height)
        self.addSubview(self.sheBeiWeiHuCell)
        self.sheBeiWeiHuCell.frame = CGRect.init(x: 0, y: self.dianPuFeiYongCell.max_Y + 1, width: width, height: height)
     
        //公司信息
        let companyInfo = self.configTuPianGuiFan(title: "installHistoryTitle"|?|, isHidden: true)
        companyInfo.frame = CGRect.init(x: 0, y: self.sheBeiWeiHuCell.max_Y + 13, width: width, height: 50)
        self.addSubview(self.shopName)
        self.shopName.frame = CGRect.init(x: 0, y: companyInfo.max_Y + 1, width: width, height: height)
        
        
        self.addSubview(self.shopAddress)
        self.shopAddress.frame = CGRect.init(x: 0, y: shopName.max_Y + 1, width: width, height: height)
        self.addSubview(self.installCount)
        self.installCount.frame = CGRect.init(x: 0, y: self.shopAddress.max_Y + 1, width: width, height: height)
        self.addSubview(self.shopContact)
        self.shopContact.frame = CGRect.init(x: 0, y: self.installCount.max_Y + 1, width: width, height: height)
        self.addSubview(self.contact)
        self.contact.frame = CGRect.init(x: 0, y: self.shopContact.max_Y + 1, width: width, height: height)
        //图片信息
        let imageInfo = self.configTuPianGuiFan(title: "shop_info_shopImage"|?|, isHidden: true)
        imageInfo.frame = CGRect.init(x: 0, y: self.contact.max_Y + 13, width: width, height: height)
        self.addSubview(shopImageCell)
        
        self.shopImageCell.frame = CGRect.init(x: 0, y: imageInfo.max_Y + 1, width: width, height: 92)
        self.contentSize = CGSize.init(width: width, height: self.shopImageCell.max_Y + DDSliderHeight + 30)
        
        self.dianPuFeiYongCell.subTitleValue = ""
        self.sheBeiWeiHuCell.subTitleValue = ""
        
        self.sheBeiWeiHuCell.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        self.sheBeiWeiHuCell.addGestureRecognizer(tap)
    }
    @objc func tapAction(tap: UITapGestureRecognizer) {
        
//        let alertView = MyShopAlertView.init(frame: CGRect.init(x: 0, y: 0, width: (280.0 / 375.0) * SCREENWIDTH, height: 0.547 * (280.0 / 375.0) * SCREENWIDTH), title: "费用说明", detail: "一个月内累计开机时间:每天少于10小时,累计天数达到5天时,开始扣钱，以5天为起扣时间,超过5天时,按累计天数扣钱，每天每块屏扣钱金额为0.2元。")
//        alertView.center = CGPoint.init(x: SCREENWIDTH / 2.0, y: SCREENHEIGHT / 2.0)
//        if let window = self.window {
//            let cover = DDCoverView.init(superView: window)
//            cover.addSubview(alertView)
//            cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//
//        }
        
    }
    
    let dianPuFeiYongCell: ShopInfoCell = ShopInfoCell.init(frame: CGRect.init(x: 0, y: 13, width: SCREENWIDTH, height: 44), title: "shop_info_cost"|?|)
    let sheBeiWeiHuCell: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, rightImage: "explain", title: "shop_info_tariff_subsidy"|?|)
    let shopName: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_info_name"|?|)
    let shopAddress: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_info_address"|?|)
    let installCount: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_info_install_count"|?|)
    let shopContact: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_info_shop_contactName"|?|)
    let contact: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_info_shop_contact_mobile"|?|)
    let shopImageCell: ShopImageView = ShopImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 92))
    
    
   
    
    func configTuPianGuiFan(title: String, isHidden: Bool = true) -> UIView {
        let contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        
        let imageView = UIView.init()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
        imageView.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: title)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.sizeToFit()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        
        
        
        return contentView
        
    }

    var model: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>? {
        didSet{
            self.shopName.subTitleValue = model?.shop?.name
            self.shopAddress.subTitleValue = (model?.shop?.areaName ?? "") + (model?.shop?.address ?? "")
            self.installCount.subTitleValue = model?.shop?.screenNumber
            self.shopContact.subTitleValue = model?.shop?.applyName
            self.contact.subTitleValue = model?.shop?.applyMobile
            self.shopImageCell.dataArr = model?.imageArr ?? []
            if let apply_brokerage = model?.shop?.apply_brokerage, apply_brokerage.count > 2  {
                let money = String(apply_brokerage.prefix(apply_brokerage.count - 2))
                   
                
                
                self.dianPuFeiYongCell.subTitleValue = String.init(format: "shop_info_shopCostValue"|?|, money)
                
            }else {
                self.dianPuFeiYongCell.subTitleValue = String.init(format: "shop_info_shopCostValue"|?|, "0")
            }
            if let monthPay = model?.shop?.electric_charge, monthPay.count > 2 {
                let month = String(monthPay.prefix(monthPay.count - 2))
                self.sheBeiWeiHuCell.subTitleValue = String.init(format: "shop_info_dianfei_butie"|?|, month)
            }else {
                self.sheBeiWeiHuCell.subTitleValue = String.init(format: "shop_info_dianfei_butie"|?|, "0")
            }
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
class ShopImageView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var dataArr: [ShopImagesModel] = []{
        didSet{
            self.collectionView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.flowLayout = UICollectionViewFlowLayout.init()
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 13, width: frame.width, height: frame.height - 26), collectionViewLayout: self.flowLayout)
        self.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ShopImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ShopImageCell")
        self.flowLayout.minimumLineSpacing = 20
        self.flowLayout.minimumInteritemSpacing = 20
        self.flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        self.flowLayout.itemSize = CGSize.init(width: frame.height - 26, height: frame.height - 26)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.isPagingEnabled = true
        self.collectionView.bounces = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return
            self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShopImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopImageCell", for: indexPath) as! ShopImageCell
        cell.backgroundColor = UIColor.white
        cell.model = self.dataArr[indexPath.item]
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var arr: [GDIBPhoto] = []
        for model in self.dataArr {
            let photo: GDIBPhoto = GDIBPhoto(dict: nil)
            photo.imageURL = model.image
            arr.append(photo)
            
        }
        let _ = GDIBContentView.init(photos: arr, showingPage: indexPath.item)
    }
    
   
}
class MyShopAlertView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect, title: String, detail: String) {
        super.init(frame: frame)
        let titleView = self.configTuPianGuiFan(title: "shop_info_feiyong_desc"|?|, isHidden: true)
        self.addSubview(titleView)
        titleView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: 46 * SCALE)
        self.addSubview(self.detailLabel)
        let lineView = UIView.init()
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
            make.height.equalTo(1)
        }
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")

        self.detailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        self.detailLabel.numberOfLines = 0
        self.detailLabel.text = detail
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white
    
        
        
    }
    let detailLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("666666"), text: "")
    func configTuPianGuiFan(title: String, isHidden: Bool = true) -> UIView {
        let contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        
        let imageView = UIView.init()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
        imageView.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: title)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.sizeToFit()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        return contentView
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







