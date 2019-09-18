//
//  ShopQianYueView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ShopQianYueView: UIScrollView {

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
        let height: CGFloat = 44 * SCALE
        let userInfo = self.configTuPianGuiFan(title: "shop_user_info"|?|, isHidden: true)
        userInfo.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: 50)
        self.addSubview(self.faRen)
        self.faRen.frame = CGRect.init(x: 0, y: userInfo.max_Y + 1, width: width, height: height)
        self.addSubview(self.ICCard)
        self.ICCard.frame = CGRect.init(x: 0, y: self.faRen.max_Y + 1, width: width, height: height)
        self.addSubview(self.phoneNumber)
        self.phoneNumber.frame = CGRect.init(x: 0, y: self.ICCard.max_Y + 1, width: width, height: height)
        //公司信息
        let companyInfo = self.configTuPianGuiFan(title: "shop_company_info"|?|, isHidden: true)
        companyInfo.frame = CGRect.init(x: 0, y: self.phoneNumber.max_Y + 13, width: width, height: 50)
        self.addSubview(self.companyName)
        self.companyName.frame = CGRect.init(x: 0, y: companyInfo.max_Y + 1, width: width, height: height)
        self.addSubview(self.xinYongDaiMa)
        self.xinYongDaiMa.frame = CGRect.init(x: 0, y: self.companyName.max_Y + 1, width: width, height: height)
        self.addSubview(self.companyAddress)
        self.companyAddress.frame = CGRect.init(x: 0, y: self.xinYongDaiMa.max_Y + 1, width: width, height: height)
        self.addSubview(self.addressDetail)
        self.addressDetail.frame = CGRect.init(x: 0, y: self.companyAddress.max_Y + 1, width: width, height: height)
        //图片信息
        let imageInfo = self.configTuPianGuiFan(title: "shop_image_info"|?|, isHidden: true)
        imageInfo.frame = CGRect.init(x: 0, y: self.addressDetail.max_Y + 13, width: width, height: height)
        self.addSubview(self.faRenDaiBiao)
        self.faRenDaiBiao.frame = CGRect.init(x: 0, y: imageInfo.max_Y + 1, width: width, height: 98)
        self.addSubview(self.zhiZhao)
        self.zhiZhao.frame = CGRect.init(x: 0, y: self.faRenDaiBiao.max_Y + 1, width: width, height: 98)
        self.addSubview(self.other)
        self.other.frame = CGRect.init(x: 0, y: self.zhiZhao.max_Y + 1, width: width, height: 98)
        
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentSize = CGSize.init(width: width, height: self.other.max_Y + DDSliderHeight + 30)
    }
    
    let faRen: ShopInfoCell = ShopInfoCell.init(frame: CGRect.init(x: 0, y: 13, width: SCREENWIDTH, height: 44), title: "shop_qianyue_faren"|?|)
    let ICCard: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_qianyue_id"|?|)
    let phoneNumber: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_qianyue_phone"|?|)
    let companyName: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_company_name"|?|)
    let xinYongDaiMa: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_qianyue_dengji"|?|)
    let companyAddress: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_qianyue_company_address"|?|)
    let addressDetail: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "")
    let faRenDaiBiao: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_qianyue_faren"|?|, image: "", image2: "")
    let zhiZhao: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, image: "", title: "shopInfobusiness_licence"|?|)
    let other: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_qianyue_other"|?|, image: "", image2: "")
    
    
    var zongDianData: ShopZongDianInfo<ShopInfoModel, FendianList>? {
        didSet{
            self.faRen.subTitleValue = zongDianData?.shop_info?.name
            self.ICCard.subTitleValue = zongDianData?.shop_info?.identity_card_num
            self.phoneNumber.subTitleValue = zongDianData?.shop_info?.mobile
            self.companyName.subTitleValue = zongDianData?.shop_info?.company_name
            self.xinYongDaiMa.subTitleValue = zongDianData?.shop_info?.registration_mark
            self.companyAddress.subTitleValue = zongDianData?.shop_info?.company_area_name
            self.addressDetail.subTitleValue = zongDianData?.shop_info?.company_address
            self.faRenDaiBiao.image1Str = zongDianData?.shop_info?.identity_card_front
            self.faRenDaiBiao.image2Str = zongDianData?.shop_info?.identity_card_back
            self.zhiZhao.image1Str = zongDianData?.shop_info?.business_licence
            if zongDianData?.shop_info?.other_image?.count ?? 0 > 0 {
                self.other.image1Str = zongDianData?.shop_info?.other_image?.first
                self.other.image2Str = zongDianData?.shop_info?.other_image?.last
                self.other.isHidden = false
            }else {
                self.contentSize = CGSize.init(width: 0, height: self.zhiZhao.max_Y + DDSliderHeight + 30)
                self.other.isHidden = true
            }
            
            
            
        }
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
