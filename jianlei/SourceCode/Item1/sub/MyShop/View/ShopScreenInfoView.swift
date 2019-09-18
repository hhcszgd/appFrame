//
//  ShopScreenInfoView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
protocol ShopScreenInfoViewDelegate: NSObjectProtocol {
    ///跳转到评价详情页面
    func evaluateWeihu(info: AnyObject?)
    ///跳转到评价列表页面
    func evaluateListWeihu(info: AnyObject?)
}
class ShopScreenInfoView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            
            // Fallback on earlier versions
        }
        let width: CGFloat = frame.width
        let height: CGFloat = 44
        self.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.weiHuContainerView.addSubview(self.weihuInfo)
        self.weiHuContainerView.addSubview(self.weihuMember)
        self.weiHuContainerView.addSubview(self.weihuTime)
        self.weiHuContainerView.addSubview(self.weihuContent)
        ///维护信息
        self.weihuInfo.frame = CGRect.init(x: 0, y: 0, width: width, height: 50)
        self.weihuMember.frame = CGRect.init(x: 0, y: self.weihuInfo.max_Y + 1, width: width, height: height)
        self.weihuTime.frame = CGRect.init(x: 0, y: self.weihuMember.max_Y + 1, width: width, height: height)
        self.weihuContent.frame = CGRect.init(x: 0, y: self.weihuTime.max_Y + 1, width: width, height: height)
        self.weiHuContainerView.frame = CGRect.init(x: 0, y: 0, width: width, height: 185)
//        self.weiHuContainerView.isHidden = true
        
        self.weihuInfo.shopInfoBtnClick = { [weak self] (bo) in
            mylog("最新维护信息")
            self?.mydelegate?.evaluateListWeihu(info: nil)
        }
        self.weihuMember.shopInfoBtnClick = { [weak self] (bo) in
            mylog("旺财")
            self?.mydelegate?.evaluateWeihu(info: nil)
        }
        
        
        //个人信息
    
        
        
        let userInfo = ShopInfoCell.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 50), title: "shop_admit_title"|?|, rightImage: "")
        self.aduitTime.frame = CGRect.init(x: 0, y: userInfo.max_Y + 1, width: width, height: height)
        self.editInstallCount.frame = CGRect.init(x: 0, y: self.aduitTime.max_Y + 1, width: width, height: height)
        self.admitContainerView.addSubview(userInfo)
        self.admitContainerView.addSubview(self.aduitTime)
        self.admitContainerView.addSubview(self.editInstallCount)
        self.admitContainerView.frame = CGRect.init(x: 0, y: self.weiHuContainerView.max_Y + 15, width: width, height: 140)
        
        self.admitContainerView.isHidden = true
        //公司信息
        
        let companyInfo = ShopInfoCell.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 50), title: "shopManagerInfo"|?|, rightImage: "")
        self.name.frame = CGRect.init(x: 0, y: companyInfo.max_Y + 1, width: width, height: height)
        self.phone.frame = CGRect.init(x: 0, y: name.max_Y + 1, width: width, height: height)
        self.managerContainerView.addSubview(companyInfo)
        self.managerContainerView.addSubview(self.phone)
        self.managerContainerView.addSubview(self.name)
        self.managerContainerView.frame = CGRect.init(x: 0, y: self.admitContainerView.max_Y + 15, width: width, height: 140)
        
        //图片信息
        
        self.addSubview(self.pingMuTitleView)
        self.pingMuTitleView.frame = CGRect.init(x: 0, y: self.managerContainerView.max_Y + 15, width: width, height: 50)
        
        self.addSubview(self.screenView)
        self.screenView.frame = CGRect.init(x: 0, y: self.pingMuTitleView.max_Y + 1, width: width, height: 40)
        
        
        
        

    }
    weak var mydelegate: ShopScreenInfoViewDelegate?
  
    var pingMuTitleView = ShopInfoCell.init(frame: CGRect.zero, title: "shop_screenStatusInfo_title"|?|, rightImage: "")
    
    let weihuInfo = ShopInfoCell.init(frame: CGRect.zero, title: "shop_weihu_info_title"|?|, rightImage: "smallarrow")
    let weihuMember = ShopInfoCell.init(frame: CGRect.zero, title: "shop_weihu_member"|?|, subTitle: "旺财", btnImage: "evaluate", btnSelectImage: "evaluate")
    let weihuTime = ShopInfoCell.init(frame: CGRect.zero, title: "shop_weihu_time"|?|)
    let weihuContent = ShopInfoCell.init(frame: CGRect.zero, title: "shop_weihu_content"|?|)
    
    
    let aduitTime: ShopInfoCell = ShopInfoCell.init(frame: CGRect.init(x: 0, y: 13, width: SCREENWIDTH, height: 44), title: "shop_admit_time"|?|)
    let editInstallCount: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_admit_changeInsatall"|?|)
    let name: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_manager_name"|?|)
    let phone: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "shop_manager_mobile"|?|)

    let screenView: ShopScreenStatusView = ShopScreenStatusView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44))
    
    
    
    
   
    
    func configScreensHeight(count: Int) -> CGFloat {
        let top: Float = 13
        let bottom: Float = 13
        let margin: Float = 6
        var line: Int = 0
        if count % 2 == 0 {
            line = count / 2
        }else {
            line = (count + 1) / 2
        }
        let height = top + bottom + Float(line - 1) * margin + Float(line) * Float(40)
        return CGFloat(height)
    }
    lazy var weiHuContainerView: UIView = {
        let view = UIView.init()
        self.addSubview(view)
        view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0f")
        return view
    }()
    lazy var admitContainerView: UIView = {
        let view = UIView.init()
        self.addSubview(view)
        view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0f")
        return view
    }()
    lazy var managerContainerView: UIView = {
        let view = UIView.init()
        self.addSubview(view)
        view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0f")
        return view
    }()
    

    func configSection() {
        
        if self.model?.shop?.status == "6" {
            self.weihuMember.rightBtn.isEnabled = false
        }else {
            self.weihuMember.rightBtn.isEnabled = true
        }
        if let screens = self.model?.shop?.screens, screens.count > 0 {
            if let maintain = self.model?.shop?.maintain {
                self.weiHuContainerView.isHidden = false
                self.weihuMember.subTitle.text = maintain.member_name
                self.weihuTime.subTitle.text = maintain.create_at
                self.weihuContent.subTitle.text = maintain.content
                self.weiHuContainerView.frame = CGRect.init(x: 0, y: 0, width: self.weiHuContainerView.width, height: self.weiHuContainerView.height)
                self.managerContainerView.isHidden = false
                self.managerContainerView.frame = CGRect.init(x: 0, y: self.weiHuContainerView.max_Y + 5, width: self.weiHuContainerView.width, height: self.managerContainerView.height)
            }else {
                self.weiHuContainerView.isHidden = true
                self.weiHuContainerView.frame = CGRect.init(x: 0, y: 0, width: self.weiHuContainerView.width, height: self.weiHuContainerView.height)
                self.managerContainerView.isHidden = false
                self.managerContainerView.frame = CGRect.init(x: 0, y: 0, width: self.managerContainerView.width, height: self.managerContainerView.height)
                
            }
            
            self.pingMuTitleView.frame = CGRect.init(x: 0, y: self.managerContainerView.max_Y + 5, width: self.pingMuTitleView.width, height: self.pingMuTitleView.height)
            self.pingMuTitleView.isHidden = false
            self.screenView.frame = CGRect.init(x: 0, y: self.pingMuTitleView.max_Y + 1, width: self.width, height: self.configScreensHeight(count: screens.count))
            self.screenView.screens = screens
            self.screenView.isHidden = false
            

        }else {
            if let maintain = self.model?.shop?.maintain {
                self.weiHuContainerView.isHidden = false
                self.weihuMember.subTitle.text = maintain.member_name
                self.weihuTime.subTitle.text = maintain.create_at
                self.weihuContent.subTitle.text = maintain.content
                self.weiHuContainerView.frame = CGRect.init(x: 0, y: 0, width: self.weiHuContainerView.width, height: self.weiHuContainerView.height)
                self.managerContainerView.isHidden = false
                self.managerContainerView.frame = CGRect.init(x: 0, y: self.weiHuContainerView.max_Y + 5, width: self.managerContainerView.width, height: self.managerContainerView.height)
            }else {
                self.weiHuContainerView.isHidden = true
                self.weiHuContainerView.frame = CGRect.init(x: 0, y: 0, width: self.weiHuContainerView.width, height: self.weiHuContainerView.height)
                self.managerContainerView.isHidden = false
                self.managerContainerView.frame = CGRect.init(x: 0, y: 0, width: self.managerContainerView.width, height: self.managerContainerView.height)
                
                
            }
            
            self.pingMuTitleView.isHidden = true
            self.screenView.isHidden = true 
        }
        self.weihuTime.subTitle.text = model?.shop?.maintain?.create_at
        self.name.subTitleValue = model?.shop?.memberName
        self.phone.subTitleValue = model?.shop?.mobile
        self.pingMuTitleView.subTitle.text = model?.shop?.screen_start_at
        
    }
    var model: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>? {
        didSet{
            
            self.configSection()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    



    func judgeMemberInfo() -> Bool {

        if let name = self.model?.shop?.memberName, name.count > 0 {
            return true
        }else if let mobile = self.model?.shop?.mobile, mobile.count > 0 {
            return true
        }else {
            return false
        }
    }
    func judgeAuditInfo() -> Bool {
        if let name = self.model?.shop?.auditingTime, name.count > 0 {
            return true
        }else {
            return false
        }
    }


}
class ShopScreenStatusView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    var screens: [ScreensModel] = [ScreensModel]() {
        didSet{
            self.subviews.forEach { (subView) in
                subView.removeFromSuperview()
            }
            
            let top: CGFloat = 6
            let leftMargin: CGFloat = 13
            var line: Int = 0
            let count = screens.count
            let margin = 6
            if count % 2 == 0 {
                line = count / 2
            }else {
                line = (count + 1) / 2
            }
            for i in 0...(count - 1) {
                //取余，列
                let lienCount = i % 2
                let privateX: CGFloat = CGFloat(lienCount + 1) * leftMargin + CGFloat(lienCount) * (self.width - 39) / 2.0
                let hangIndex = i / 2
                let privateY: CGFloat = top + CGFloat(hangIndex * 40) + CGFloat(hangIndex * 6)
                let contentView = StatusCell.init(frame: CGRect.init(x: privateX, y: privateY, width: (self.width - 39) / 2.0, height: 40))
                contentView.model = screens[i]
                self.addSubview(contentView)
                
            }
            
            
        }
    }
    class StatusCell: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            let leftImageView = UIImageView.init()
            leftImageView.image = UIImage.init(named: "screen")
            self.addSubview(leftImageView)
            leftImageView.snp.makeConstraints { (make) in
                make.width.equalTo(16)
                make.height.equalTo(14)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(10)
            }
            self.addSubview(titleLabel)
            self.titleLabel.sizeToFit()
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(leftImageView.snp.right).offset(6)
                make.centerY.equalToSuperview()
            }
            self.backgroundColor = UIColor.colorWithHexStringSwift("fcecd5")
            self.statusLabel = UILabel.init()
            self.statusLabel.textAlignment = .center
            self.statusLabel.textColor = UIColor.white
            self.statusLabel.font = UIFont.systemFont(ofSize: 10)
            self.addSubview(statusLabel)
          
            self.statusLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-8)
                make.width.equalTo(60 * SCALE)
                make.height.equalTo(25)
            }
            self.statusLabel.layer.masksToBounds = true
            self.statusLabel.layer.cornerRadius = 12.5
            self.statusLabel.textAlignment = .center

        }
        let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
        var statusLabel: UILabel!
        var model: ScreensModel? {
            didSet{
                self.titleLabel.text = model?.name ?? ""
                if let status = model?.status {
                    if status == "1" {
                        self.statusLabel.text = "screenStatusNormal"|?|
                        self.statusLabel.backgroundColor = UIColor.colorWithHexStringSwift("cdb179")
                    }else {
                        self.statusLabel.backgroundColor = UIColor.colorWithHexStringSwift("f06968")
                        self.statusLabel.text = "screenStatusUnNormal"|?|
                    }
                }
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




