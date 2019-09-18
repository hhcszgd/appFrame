//
//  ShopInfoVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
enum ShopInfoType: String {
    case bussinessHistory = "业务历史"
    case installBusiness = "安装业务"
    case  installHistory = "安装历史"
    
}
class ShopInfoVC: DDInternalVC {
    ///页面的类型，区分是业务历史跳转过来的还是安装历史跳转过来的
    var vcType: ShopInfoType = .installBusiness
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dict = self.userInfo as? [String: String], let id = dict["id"], let type = dict["type"] {
            self.id = id
            self.type = type
        }
        switch self.vcType {
        case .installBusiness:
            if let dict = self.userInfo as? [String: String], let operateType = dict["operateType"] {
                self.operateType = operateType
                self.configTitle()
            }
            
        case .bussinessHistory:
            if let dict = self.userInfo as? [String: String], let shopType = dict["shop_type"] {
                self.shop_type = shopType
                self.configTitle()
            }
        case .installHistory:
            if let dict = self.userInfo as? [String: String], let shopType = dict["shop_type"] {
                self.shop_type = shopType
                var title: String = ""
                switch self.type {
                case "1":
                    title = "installHistoryTitle1"|?|
                case "2":
                    title = "installHistoryTitle2"|?|
                case "3":
                    title = "installHistoryTitle3"|?|
                case "4":
                    title = "installHistoryTitle4"|?|
                default:
                    title = "installHistoryTitle"|?|
                }
                self.naviBar.title = title
            }
        default:
            break
        }
        
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.scrollView.showsVerticalScrollIndicator = false
        
        
        // Do any additional setup after loading the view.
    }

    let maginModel = ResetShopInfoModel.init(key: "", value: "", type: "magin")
    
    func configInstallHistoryData() {
        ///法人代表
        var fanrenModel = ResetShopInfoModel.init(key: "shopInfoapply_name"|?|, value: self.data?.apply_name, type: "normal")
        ///手機號碼
        var farenMobile = ResetShopInfoModel.init(key: "shopInfo_mobile"|?|, value: self.data?.apply_mobile, type: "normal")
        ///公司名稱
        let companyName = ResetShopInfoModel.init(key: "shopInfocompany_name"|?|, value: self.data?.company_name, type: "normal")
        ///店鋪名稱
        let shopName = ResetShopInfoModel.init(key: "shopInfoNameOfShop"|?|, value: self.data?.name, type: "normal")
        ///安裝地址address
        let installAddress = ResetShopInfoModel.init(key: "shopInfo_install_address"|?|, value: self.data?.area_name, type: "normal")
        ///安裝地址detail
        let installAddressDetail = ResetShopInfoModel.init(key: "", value: self.data?.address, type: "normal")
        ///店鋪面積
        let shopInfoacreage = ResetShopInfoModel.init(key: "shopInfoacreage"|?|, value: self.data?.acreage, type: "normal")
        ///安裝數量
        let installCount = ResetShopInfoModel.init(key: "shopInfoscreen_number"|?|, value: self.data?.apply_screen_number, type: "normal")
        ///鏡面數量
        let shopInfomirror_account = ResetShopInfoModel.init(key: "shopInfomirror_account"|?|, value: self.data?.mirror_account, type: "normal")
        
        ///屏幕運行時間
        let screenRunTime = ResetShopInfoModel.init(key: "shopInfo_screen_run_time"|?|, value: self.data?.screen_start_at, type: "normal")
        ///聯繫人/業務對接人
        var bussinessContact = ResetShopInfoModel.init(key: "shop_contact_peopleOfInstallHistory"|?|, value: self.data?.member_name, type: "normal")
        ///聯繫電話
        var bussinessContactMobile = ResetShopInfoModel.init(key: "contact_number"|?|, value: self.data?.member_mobile, type: "normal")
        ///店鋪門臉照片
        let shopInfoshop_image = ResetShopInfoModel.init(key: "shopInfoshop_image"|?|, value: self.data?.shop_image, type: "image")
        ///室內全景照片
        let shopInfopanorama_image = ResetShopInfoModel.init(key: "shopInfopanorama_image"|?|, value: self.data?.panorama_image, type: "image")
        ///拆除設備編號
        let chaichuSheBei = ResetShopInfoModel.init(key: "chaichuBianhao"|?|, value: self.data?.remove_device_number?.first, type: "normal")
        ///問題描述
        let questionDesc = ResetShopInfoModel.init(key: "requestion_desc"|?|, value: self.data?.problem_description, type: "normal")
        
        if self.shop_type == "1" {
            if let name = self.data?.contacts_name, name.count > 0 {
                fanrenModel.value = name
            }else {
                fanrenModel.value = self.data?.apply_name
            }
            if let mobile = self.data?.contacts_mobile, mobile.count > 0 {
                farenMobile.value = mobile
            }else {
                farenMobile.value = self.data?.apply_mobile
            }
            
            
        }else {
            
        }
        switch self.type {
        case "1":
            self.dataArr = [shopName, installAddress, installAddressDetail, fanrenModel, farenMobile,shopInfoacreage,installCount,shopInfomirror_account,screenRunTime, bussinessContact, bussinessContactMobile, shopInfoshop_image, shopInfopanorama_image]
            
            
        case "2":
            mylog("屏幕更換")
            bussinessContact.value = self.data?.member_name
            bussinessContactMobile.value = self.data?.member_mobile
            self.dataArr = [shopName, installAddress, installAddressDetail, fanrenModel, farenMobile, bussinessContact, bussinessContactMobile]
            if let removeArr = self.data?.remove_device_number, removeArr.count > 0 {
                for (index, num) in removeArr.enumerated() {
                    if index == 0 {
                        let model = ResetShopInfoModel.init(key: "genghuanOldNum"|?|, value: num, type: "normal")
                        self.dataArr.append(model)
                    }else {
                        let model = ResetShopInfoModel.init(key: "", value: num, type: "normal")
                        self.dataArr.append(model)
                    }
                }
                
            }
            if let removeArr = self.data?.install_device_number, removeArr.count > 0 {
                for (index, num) in removeArr.enumerated() {
                    if index == 0 {
                        let model = ResetShopInfoModel.init(key: "genghuanNewNum"|?|, value: num, type: "normal")
                        self.dataArr.append(model)
                    }else {
                        let model = ResetShopInfoModel.init(key: "", value: num, type: "normal")
                        self.dataArr.append(model)
                    }
                }
                
            }
            
            
            
            if let reason = self.data?.problem_description, reason.count > 0{
                self.dataArr.append(maginModel)
                self.dataArr.append(questionDesc)
                
            }
            
        case "3":
            mylog("屏幕拆除")
            self.dataArr = [shopName, installAddress, installAddressDetail, fanrenModel, farenMobile, bussinessContact, bussinessContactMobile]
            
            if let removeArr = self.data?.remove_device_number, removeArr.count > 0 {
                for (index, num) in removeArr.enumerated() {
                    if index == 0 {
                        self.dataArr.append(chaichuSheBei)
                    }else {
                        let model = ResetShopInfoModel.init(key: "", value: num, type: "normal")
                        self.dataArr.append(model)
                    }
                }
                
            }
            if let reason = self.data?.problem_description, reason.count > 0{
                self.dataArr.append(maginModel)
                self.dataArr.append(questionDesc)
                
            }
        case "4":
            mylog("店鋪信息")
            self.dataArr = [shopName, installAddress, installAddressDetail, fanrenModel, farenMobile, bussinessContact, bussinessContactMobile]
            
            if let removeArr = self.data?.install_device_number, removeArr.count > 0 {
                for (index, num) in removeArr.enumerated() {
                    if index == 0 {
                        let model = ResetShopInfoModel.init(key: "newShebeinum"|?|, value: num, type: "normal")
                        self.dataArr.append(model)
                    }else {
                        let model = ResetShopInfoModel.init(key: "", value: num, type: "normal")
                        self.dataArr.append(model)
                    }
                }
                
            }
            if let reason = self.data?.problem_description, reason.count > 0{
                self.dataArr.append(maginModel)
                self.dataArr.append(questionDesc)
                
            }
            
            
        default:
            mylog("結束")
        }
        self.configUI()
        
        
        
        
        
        
    }
    
    
    ///1是分店，2是总店
    var shop_type: String = ""
    
    func configTitle() {
        var title: String = ""
        switch self.type {
            
        case "1":
            ///只有在店铺状态下才分总店分店
            switch self.vcType {
            case .installHistory, .bussinessHistory:
                if self.shop_type == "1" {
                    title = "shopInfoType1"|?|
                }else {
                    title = "shopInfoAllshopInfo"|?|
                }
            case .installBusiness:
                if self.operateType == "4" {
                    title = "shopInfoAllshopInfo"|?|
                    
                }else {
                    title = "shopInfoType1"|?|
                }
            default:
                break
            }
            
            
        case "2":
            title = "shopInfoType2"|?|
        case "3":
            title = "shopInfoType3"|?|
            
        default:
            title = "店铺信息"
        }
        self.naviBar.title = title
    }
    
    
    ///1，租赁店，2，自营店, 3,连锁店， 4,总店
    var operateType: String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.request()
    }
    @objc func nextAction(sender: CustomBtn) {
        switch self.vcType {
        case .installBusiness:
            self.installBussinessDisplay()
        case .bussinessHistory:
            //判断是总店还是分店
            self.bussinessHistory()
        case .installHistory:
            mylog("没有下一步按钮")
        default:
            break
        }
        
        
    }
    func bussinessHistory() {
        if self.data?.status == "0" {
            ///待审核
        }else
            if self.data?.status == "1" {
            ///修改申请信息
            let vc = LEDApplicationVC()
            var url: String = ""
            switch (self.data?.shop_place_type ?? "1") {
            case "1":
                switch self.shop_type {
                case "2":
                    url = DomainType.wap.rawValue + "shop/hk-modify-office?token=\(DDAccount.share.token ?? "")&shop_place_type=\(self.data?.shop_place_type ?? "1")&headquarters_id=\(self.id)"
                case "1":
                    url = DomainType.wap.rawValue + "hk-shop/hk-modify?token=\(DDAccount.share.token ?? "")&dev=ios&shop_place_type=\(self.data?.shop_place_type ?? "1")&shop_id=\(self.id)&shop_operate_type=\(operateType)"
                default:
                    mylog("")
                }
            case "2", "3":
                url = DomainType.wap.rawValue + "hk-shop/hk-zhuxielou-modify?token=\(DDAccount.share.token ?? "")&shop_place_type=\(self.data?.shop_place_type ?? "1")&shop_id=\(self.id)"
                
            default:
                mylog("")
            }
            
            
            vc.userInfo = url
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func installBussinessDisplay() {
        if self.data?.status == "0" {
            ///待审核
        }else if self.data?.status == "1" {
            ///修改申请信息
            let vc = LEDApplicationVC()
            var url: String = ""
            switch (self.data?.shop_place_type ?? "1") {
            case "1":
                switch operateType {
                case "4":
                    url = DomainType.wap.rawValue + "shop/hk-modify-office?token=\(DDAccount.share.token ?? "")&shop_place_type=\(self.data?.shop_place_type ?? "1")&headquarters_id=\(self.id)"
                case "1", "2", "3":
                    url = DomainType.wap.rawValue + "hk-shop/hk-modify?token=\(DDAccount.share.token ?? "")&dev=ios&shop_place_type=\(self.data?.shop_place_type ?? "1")&shop_id=\(self.id)&shop_operate_type=\(operateType)"
                default:
                    mylog("")
                }
            case "2", "3":
                url = DomainType.wap.rawValue + "hk-shop/hk-zhuxielou-modify?token=\(DDAccount.share.token ?? "")&shop_place_type=\(self.data?.shop_place_type ?? "1")&shop_id=\(self.id)"
                
            default:
                mylog("")
            }
            
            
            vc.userInfo = url
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    ///楼宇。理发店。写字楼信息,安装历史状态下type表示：1新店安装，2，屏幕更换3，屏幕拆除4店铺信息
    var type: String = ""
    var id: String = ""
    lazy var nextBtn: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - DDSliderHeight - 44, width: SCREENWIDTH, height: 44 + DDSliderHeight))
        btn.titleFont = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(nextAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight))
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var dataArr: [ResetShopInfoModel] = [ResetShopInfoModel]()
    var data: BussinessShopInfoModel?
}
extension ShopInfoVC {
    func configUI() {
        let marginTop: CGFloat = 13
        var totalHeight: CGFloat = marginTop
        for (index, model) in self.dataArr.enumerated() {
            var subView: ShopInfoCell?
            switch model.type {
            case "list":
                subView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 80), title: model.value, subTitle: model.value2)
                
                self.scrollView.addSubview(subView!)
                totalHeight += 80
            case "title":
                subView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 44), title: model.key, rightImage: "", subTitle: "")
                self.scrollView.addSubview(subView!)
                totalHeight += 45
            case "subTitle":
                subView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 44), title: model.key, rightImage: "", subTitle: model.value)
                self.scrollView.addSubview(subView!)
                totalHeight += 45
            case "normal":
                subView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 44), title: model.key)
                subView?.subTitleValue = model.value
                self.scrollView.addSubview(subView!)
                totalHeight += 45
            case "image":
                subView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 98), image: model.value ?? "", title: model.key)
                totalHeight += 99
                subView?.image1Str = model.value ?? ""
                self.scrollView.addSubview(subView!)
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(checkImage(tap:)))
                subView?.addGestureRecognizer(tap)
                subView?.isUserInteractionEnabled = true
                
            case "image2":
                subView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 98), title: model.key, image: model.value ?? "", image2: model.value2 ?? "")
                subView?.image1Str = model.value ?? ""
                subView?.image2Str = model.value2 ?? ""
                self.scrollView.addSubview(subView!)
                totalHeight += 99
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(checkImage(tap:)))
                subView?.addGestureRecognizer(tap)
                subView?.isUserInteractionEnabled = true
            case "images":
                let count = model.images.count
                subView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: count > 2 ? 185:99), title: "shop_qianyue_other"|?|, images: model.images)
                self.scrollView.addSubview(subView!)
                subView?.images = model.images
                totalHeight += subView?.height ?? 0
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(checkImage(tap:)))
                subView?.addGestureRecognizer(tap)
                subView?.isUserInteractionEnabled = true
            case "magin":
                totalHeight += 15
            default:
                break
            }
        }
        self.scrollView.contentSize = CGSize.init(width: SCREENWIDTH, height: totalHeight + 64)
            
            
    }

    
    @objc func checkImage(tap: UITapGestureRecognizer) {
        var dataArr: [GDIBPhoto] = [GDIBPhoto]()
        if let subView = tap.view as? ShopInfoCell {
            if let imageStr1 = subView.image1Str, imageStr1.count > 0 {
                let phone1 = GDIBPhoto.init(dict: nil)
                phone1.imageURL = imageStr1
                dataArr.append(phone1)
            }
            if let imageStr2 = subView.image2Str, imageStr2.count > 0 {
                let phone1 = GDIBPhoto.init(dict: nil)
                phone1.imageURL = imageStr2
                dataArr.append(phone1)
            }
            if subView.images.count > 0 {
                subView.images.forEach { (img) in
                    let phone = GDIBPhoto.init(dict: nil)
                    phone.imageURL = img
                    dataArr.append(phone)
                }
            }
            
            let contentView = GDIBContentView.init(photos: dataArr)
            UIApplication.shared.keyWindow?.addSubview(contentView)
        }
    }
    
    
    func request() {
        var paramete = ["token": DDAccount.share.token ?? ""]
        var router: Router!
        switch self.vcType {
        case .installBusiness:
            paramete["shop_operate_type"] = self.operateType
            router = Router.get("shop/shop-detail/\(self.id)", DomainType.api, paramete)
        case .bussinessHistory:
            paramete["id"] = self.id
            paramete["shop_type"] = self.shop_type
            router = Router.get("install-history/shop-details", DomainType.api, paramete)
        case .installHistory:
            paramete["id"] = self.id
            paramete["shop_type"] = self.shop_type
            router = Router.get("install-history/shop-details", DomainType.api, paramete)
        default:
            break
        }
        if self.id != ""  {
            
            NetWork.manager.requestData(router: router, success: { (response) in
                let model = DDJsonCode.decodeAlamofireResponse(ApiModel<BussinessShopInfoModel>.self, from: response)
                if let data = model?.data {
                    self.data = data
                    if self.vcType == .installHistory {
                        self.configInstallHistoryData()
                    }else {
                        self.configData()
                    }
                    
                    
                    
                }
                
            }) {
                
            }
            
        
        }
        
    }
    ///安装和业务历史
    func configData() {
        
        
        let userInfo = ResetShopInfoModel.init(key: "shop_user_info"|?|, value: "", type: "title")
        let companyInfo = ResetShopInfoModel.init(key: "shop_company_info"|?|, value: "", type: "title")
        let imageInfo = ResetShopInfoModel.init(key: "shop_upload_image"|?|, value: "", type: "title")
        var shopSubInfo = ResetShopInfoModel.init(key: "shop_sub_fendian_info"|?|, value: "", type: "subTitle")
        ///法人代表
        let model1 = ResetShopInfoModel.init(key: "shopInfoapply_name"|?|, value: self.data?.apply_name, type: "normal")
        ///總店中的法人字段
        let model1_1 = ResetShopInfoModel.init(key: "shopInfoapply_name"|?|, value: self.data?.name, type: "normal")
        ///法人身份证
        let model2 = ResetShopInfoModel.init(key: "shopInfoidentity_card_num"|?|, value: self.data?.identity_card_num, type: "normal")
        ///手機號碼
        let model3 = ResetShopInfoModel.init(key: "shopInfoapply_mobile"|?|, value: self.data?.apply_mobile, type: "normal")
        ///店鋪名稱
        let model4 = ResetShopInfoModel.init(key: "shopInfoNameOfShop"|?|, value: self.data?.name, type: "normal")
        ///安裝地址
        let model5 = ResetShopInfoModel.init(key: "shopInfoArea_name"|?|, value: self.data?.area_name, type: "normal")
        ///安裝地址明細
        let model6 = ResetShopInfoModel.init(key: "shopInfoAddress"|?|, value: self.data?.address, type: "normal")
        ///店鋪面積
        let model7 = ResetShopInfoModel.init(key: "shopInfoacreage"|?|, value: self.data?.acreage, type: "normal")
        ///鏡面數量
        let model8 = ResetShopInfoModel.init(key: "shopInfomirror_account"|?|, value: self.data?.mirror_account, type: "normal")
        ///安裝數量
        let model9 = ResetShopInfoModel.init(key: "shopInfoscreen_number"|?|, value: self.data?.apply_screen_number, type: "normal")
        ///運行時間
        let model10 = ResetShopInfoModel.init(key: "shopInfoscreen_start_at"|?|, value: self.data?.screen_start_at, type: "normal")
        
        
        
        
        
        let model11 = ResetShopInfoModel.init(key: "shopInfoapply_name"|?|, value: self.data?.identity_card_front, value2: self.data?.identity_card_back, type: "image2")
        ///商業登記證照片
        let model12 = ResetShopInfoModel.init(key: "shopInfobusiness_licence"|?|, value: self.data?.business_licence, type: "image")
        ///店鋪門臉照片
        let model13 = ResetShopInfoModel.init(key: "shopInfoshop_image"|?|, value: self.data?.shop_image, type: "image")
        ///店鋪全景照片
        let model14 = ResetShopInfoModel.init(key: "shopInfopanorama_image"|?|, value: self.data?.panorama_image, type: "image")
        let failReasonModel = ResetShopInfoModel.init(key: "shopInfofail_reason"|?|, value: self.data?.fail_reason, type: "normal")
        ///物業公司的公司名稱
        let companyNameModel = ResetShopInfoModel.init(key: "shopInfocompany_name"|?|, value: self.data?.company_name, type: "normal")
        let contactName = ResetShopInfoModel.init(key: "shopInfocontacts_name"|?|, value: self.data?.contacts_name, type: "normal")
        let contactMobile = ResetShopInfoModel.init(key: "shopInfocontacts_mobile"|?|, value: self.data?.contacts_mobile, type: "normal")
        let otherImageModel = ResetShopInfoModel.init(key: "other"|?|, values: self.data?.other_image ?? [String] (), type: "images")
        
        let mobile = ResetShopInfoModel.init(key: "shopInfo_mobile"|?|, value: self.data?.mobile, type: "normal")
        ///公司名稱
        let companyName = ResetShopInfoModel.init(key: "shop_company_name"|?|, value: self.data?.company_name, type: "normal")
        let companyAddress = ResetShopInfoModel.init(key: "shop_qianyue_company_address"|?|, value: self.data?.company_area_name, type: "normal")
        let companyDetailAddress = ResetShopInfoModel.init(key: "", value: self.data?.company_address, type: "normal")
        ///登記證號碼
        let dengjiTitle = ResetShopInfoModel.init(key: "shop_qianyue_dengji"|?|, value: self.data?.registration_mark, type: "normal")
        let dengjiImage = ResetShopInfoModel.init(key: "shop_qianyue_dengji_image"|?|, value: self.data?.business_licence, type: "image")
       ///结款方式
        let jiekuanStyle = ResetShopInfoModel.init(key: "shop_jiekuanStyle"|?|, value: ((self.data?.settlement_method ?? "1") == "1") ? "APP結款":"線下結款", type: "normal")
//        let installMemberInfo = ResetShopInfoModel.init(key: "installMemberInfo"|?|, value: <#T##String?#>, type: <#T##String#>)
        
        //先判断总店和分店
        var isHeadOffice: Bool = false
        ///區分安裝業務還是業務歷史
        var isInstallBusiness: Bool = false
        if self.vcType == .installBusiness {
            if self.operateType == "4" {
                isHeadOffice = true
            }else {
                
                isHeadOffice = false
            }
            isInstallBusiness = true
            
        }else {
            if self.shop_type == "2" {
                //总店
                isHeadOffice = true
            }else {
                isHeadOffice = false
                //分店
            }
            isInstallBusiness = false
        }
        
        switch self.data?.shop_place_type ?? "1" {
            
        case "1":

            //理发店
            
            if isHeadOffice {
                ///总店
                if let list = self.data?.list  {
                    let count = list.count
                    shopSubInfo.value = String.init(format: "shopInfoCountList"|?|, count);
                }
                switch self.data?.status ?? "0" {
                case "0":
                    mylog("待审核")
                    self.dataArr = [userInfo, model1_1, model2, mobile, maginModel,companyInfo, companyName, dengjiTitle,companyAddress, companyDetailAddress, maginModel,imageInfo, model11, dengjiImage, otherImageModel, maginModel]
                    if isInstallBusiness {
                        self.dataArr = [userInfo, model1_1, model2, mobile, maginModel,companyInfo, companyName, dengjiTitle,companyAddress, companyDetailAddress,jiekuanStyle, maginModel,imageInfo, model11, dengjiImage, otherImageModel, maginModel]
                        self.nextBtn.myTitle = ("shopInfoauthenticate"|?|, .normal)
                        self.nextBtn.setBackgroundImage(UIImage.init(), for: UIControl.State.normal)
                        self.nextBtn.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                        self.nextBtn.myTitleColor = ("ffffff", .normal)
                    }
                    
                    
                case "1":
                    mylog("审核未通过")
                    self.dataArr = [userInfo, model1_1, model2, mobile, maginModel,companyInfo, companyName,dengjiTitle, companyAddress, companyDetailAddress, maginModel,imageInfo, model11, dengjiImage, otherImageModel, maginModel]
                    
                    if isInstallBusiness {
                         self.dataArr = [userInfo, model1_1, model2, mobile, maginModel,companyInfo, companyName,dengjiTitle, companyAddress, companyDetailAddress,jiekuanStyle, maginModel,imageInfo, model11, dengjiImage, otherImageModel, maginModel]
                        self.nextBtn.myTitle = ("shopInfoAllShopApply"|?|, .normal)
                        self.nextBtn.setBackgroundImage(UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffed34"), UIColor.colorWithHexStringSwift("ffab34")], bound: self.nextBtn.bounds), for: UIControl.State.normal)
                        self.nextBtn.myTitleColor = ("323232", .normal)
                    }
                    
                case "5":
                    self.dataArr = [userInfo, model1_1, model2, mobile, maginModel,companyInfo, companyName,dengjiTitle, companyAddress, companyDetailAddress,jiekuanStyle, maginModel,imageInfo, model11, dengjiImage, otherImageModel, maginModel]
                    mylog("安裝歷史點擊后的頁面")
                case "2", "3", "4":
                    self.dataArr = [userInfo, model1_1, model2, mobile, maginModel,companyInfo, companyName,dengjiTitle, companyAddress, companyDetailAddress, maginModel,imageInfo, model11, dengjiImage, otherImageModel, maginModel]
                    
                    
                    
                    mylog("待安装")
                    if isInstallBusiness {
                        self.dataArr = [userInfo, model1_1, model2, mobile, maginModel,companyInfo, companyName,dengjiTitle, companyAddress, companyDetailAddress,jiekuanStyle, maginModel,imageInfo, model11, dengjiImage, otherImageModel, maginModel]
                        self.nextBtn.myTitle = ("shop_fendian_to_be_install"|?|, .normal)
                        self.nextBtn.setBackgroundImage(UIImage.init(), for: UIControl.State.normal)
                        self.nextBtn.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                        self.nextBtn.myTitleColor = ("ffffff", .normal)
                    }
                    
                default:
                    mylog("")
                }
                if let list = self.data?.list {
                    if list.count > 0 {
                        self.dataArr.append(shopSubInfo)
                    }
                    for shopModel in list {
                        let model = ResetShopInfoModel.init(key: "list", value: shopModel.branch_shop_name, value2: (shopModel.branch_shop_area_name ?? "") + (shopModel.branch_shop_address ?? ""), type: "list")
                        self.dataArr.append(model)
                    }
                    
                }
                
                if let failure = self.data?.fail_reason, failure.count > 0 {
                    let model = ResetShopInfoModel.init(key: "failure_reason"|?|, value: failure, type: "normal")
                    self.dataArr.append(maginModel)
                    self.dataArr.append(model)
                }
                if !((self.data?.other_image?.count ?? 0) > 0) {
                    self.dataArr.removeAll { (model) -> Bool in
                        if model.key == otherImageModel.key {
                            return true
                        }else {
                            return false
                        }
                    }
                }
                
                
                
            }else {
                //分店
                switch self.data?.status ?? "0" {
                case "0":
                    //待審核
                    if isInstallBusiness {
                        if self.operateType == "3" {
                            //連鎖店就是分店有店鋪聯繫人和聯繫人手機號
                            self.dataArr = [model1, model2, model3, contactName, contactMobile,maginModel,model4, model5, model6, jiekuanStyle, model7, model8, model9, model10,maginModel, model11, model12,model13, model14]
                        }else {
                            self.dataArr = [model1, model2, model3,maginModel,model4, model5, model6, jiekuanStyle, model7, model8, model9, model10,maginModel, model11, model12,model13, model14]
                        }
                    }else {
                        
                        self.dataArr = [model1, model2, model3,maginModel,model4, model5, model6, model7, model8, model9, model10,maginModel,model13, model14]
                        if let name = self.data?.contacts_name, name.count > 0, let mobile = self.data?.contacts_mobile, mobile.count > 0{
                            self.dataArr = [model1, model2, model3, contactName, contactMobile,maginModel,model4, model5, model6, model7, model8, model9, model10,maginModel,model13, model14]
                        }
                    }
                    
                    
                    
                    
                    if self.data?.other_image?.count ?? 0 > 0 {
                        self.dataArr.append(otherImageModel)
                    }
                    if isInstallBusiness {
                        self.nextBtn.myTitle = ("shopInfoauthenticate"|?|, .normal)
                        self.nextBtn.setBackgroundImage(UIImage.init(), for: UIControl.State.normal)
                        self.nextBtn.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                        self.nextBtn.myTitleColor = ("ffffff", .normal)
                    }
                case "1":
                    //審核未通過
                    
                    if isInstallBusiness {
                        if operateType == "3"{
                            self.dataArr = [model1, model2, model3, contactName, contactMobile, maginModel, model4, model5, model6, jiekuanStyle,model7, model8, model9, model10, maginModel, model11, model12,model13, model14, maginModel]
                        }else {
                            self.dataArr = [model1, model2, model3, maginModel, model4, model5, model6, jiekuanStyle,model7, model8, model9, model10, maginModel, model11, model12,model13, model14, maginModel]
                        }
                    }else {
                        self.dataArr = [model1, model2, model3, maginModel, model4, model5, model6, model7, model8, model9, model10, maginModel, model11, model12,model13, model14, maginModel]
                        if let name = self.data?.contacts_name, name.count > 0, let mobile = self.data?.contacts_mobile, mobile.count > 0{
                            self.dataArr = [model1, model2, model3, contactName, contactMobile, maginModel, model4, model5, model6, model7, model8, model9, model10, maginModel, model11, model12,model13, model14, maginModel]
                        }
                        
                    }
                    if self.data?.other_image?.count ?? 0 > 0 {
                        self.dataArr.append(otherImageModel)
                    }
                    self.dataArr.append(failReasonModel)
                    if isInstallBusiness {
                        self.nextBtn.myTitle = ("shopInfoChangeApplyInfo"|?|, .normal)
                        self.nextBtn.setBackgroundImage(UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffed34"), UIColor.colorWithHexStringSwift("ffab34")], bound: self.nextBtn.bounds), for: UIControl.State.normal)
                        self.nextBtn.myTitleColor = ("323232", .normal)
                    }
                case "2", "3", "4":
                    if isInstallBusiness {
                        if self.operateType == "3" {
                            self.dataArr = [model1, model2, model3,contactName, contactMobile, maginModel,  model4,model5, model6,jiekuanStyle, model7, model8,model9, model10, model11, model12, model13, model14, otherImageModel]
                        }else {
                            self.dataArr = [model1, model2, model3, maginModel,  model4,model5, model6, jiekuanStyle, model7,model8, model9, model10, model13, model14]
                        }
                        
                    }else {
                        self.dataArr = [model1, model2, model3, maginModel,  model4,model5, model6, model7,model8, model9, model10, model13, model14]
                        if let name = self.data?.contacts_name, name.count > 0, let mobile = self.data?.contacts_mobile, mobile.count > 0{
                            self.dataArr = [model1, model2, model3,contactName, contactMobile, maginModel,  model4,model5, model6, model7,model8, model9, model10, model13, model14]
                        }
                        
                    }
                    
                    
                    if isInstallBusiness {
                        self.nextBtn.myTitle = ("shop_fendian_to_be_install"|?|, .normal)
                        self.nextBtn.setBackgroundImage(UIImage.init(), for: UIControl.State.normal)
                        self.nextBtn.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                        self.nextBtn.myTitleColor = ("ffffff", .normal)
                    }
                    //待安装
                case "5":
                    //安裝歷史點擊后的頁面
                    if isInstallBusiness {
                        if operateType == "3" {
                            self.dataArr = [model1, model2, model3, contactName, contactMobile, maginModel ,model4, model5, model6,jiekuanStyle,model7, model8, model9, model10, model13, model14]
                        }else {
                            self.dataArr = [model1, model2, model3, maginModel ,model4, model5, model6,jiekuanStyle,model7, model8, model9, model10, model13, model14]
                        }
                    }else {
                        self.dataArr = [model1, model2, model3, maginModel ,model4, model5, model6,model7, model8, model9, model10, model13, model14]
                        if let name = self.data?.contacts_name, name.count > 0, let mobile = self.data?.contacts_mobile, mobile.count > 0{
                            self.dataArr = [model1, model2, model3,contactName, contactMobile, maginModel ,model4, model5, model6,model7, model8, model9, model10, model13, model14]
                        }
                        
                    }
                    
                    if self.data?.other_image?.count ?? 0 > 0 {
                        self.dataArr.append(otherImageModel)
                    }
                default:
                    break
                }
                
                
            }
            
            
            

        case "2":
            //樓宇
            let model = ResetShopInfoModel.init(key: "shopInfoNameOfXieZi"|?|, value: self.data?.name, type: "normal")
            switch self.data?.status ?? "0" {
            case "0":
                //待審核
                self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10]
                if self.data?.other_image?.count ?? 0 > 0 {
                    self.dataArr.append(otherImageModel)
                }
                if isInstallBusiness {
                    self.nextBtn.myTitle = ("shopInfoauthenticate"|?|, .normal)
                    self.nextBtn.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                    self.nextBtn.setBackgroundImage(UIImage.init(), for: UIControl.State.normal)
                    self.nextBtn.myTitleColor = ("ffffff", .normal)
                }
            case "1":
                //審核未通過
                
                if isInstallBusiness {
                    self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10, maginModel]
                }else {
                    self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10, maginModel]
                }
                if self.data?.other_image?.count ?? 0 > 0 {
                    self.dataArr.append(otherImageModel)
                }
                if isInstallBusiness {
                    self.dataArr.append(failReasonModel)
                }
                if isInstallBusiness {
                    self.nextBtn.myTitle = ("shopInfoChangeApplyInfo"|?|, .normal)
                    self.nextBtn.setBackgroundImage(UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffed34"), UIColor.colorWithHexStringSwift("ffab34")], bound: self.nextBtn.bounds), for: UIControl.State.normal)
                    self.nextBtn.myTitleColor = ("323232", .normal)
                }
            case "2", "3", "4":
                mylog("")
            case "5":
                //安裝歷史點擊后的頁面
                self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10]
                if self.data?.other_image?.count ?? 0 > 0 {
                    self.dataArr.append(otherImageModel)
                }
                
            default:
                break
            }
            
            
            
            

            
            
            
           
            
        case "3":
            let model = ResetShopInfoModel.init(key: "shopInfoNameOfZhuZhai"|?|, value: self.data?.name, type: "normal")
            switch self.data?.status ?? "0" {
            case "0":
                //待審核
                self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10]
                if self.data?.other_image?.count ?? 0 > 0 {
                    self.dataArr.append(otherImageModel)
                }
                if isInstallBusiness {
                    self.nextBtn.myTitle = ("shopInfoauthenticate"|?|, .normal)
                    self.nextBtn.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                    self.nextBtn.setBackgroundImage(UIImage.init(), for: UIControl.State.normal)
                    self.nextBtn.myTitleColor = ("ffffff", .normal)
                }
            case "1":
                //審核未通過
                if isInstallBusiness {
                    self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10, maginModel, failReasonModel]
                }else {
                    self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10, maginModel, failReasonModel]
                }
                
                if self.data?.other_image?.count ?? 0 > 0 {
                    self.dataArr.append(otherImageModel)
                }
                if isInstallBusiness {
                    self.nextBtn.myTitle = ("shopInfoChangeApplyInfo"|?|, .normal)
                    self.nextBtn.setBackgroundImage(UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffed34"), UIColor.colorWithHexStringSwift("ffab34")], bound: self.nextBtn.bounds), for: UIControl.State.normal)
                    
                    self.nextBtn.myTitleColor = ("323232", .normal)
                }
            case "5":
                //安裝歷史點擊后的頁面
                self.dataArr = [model,model5, model6, companyNameModel, contactName, contactMobile, model9, model10]
                if self.data?.other_image?.count ?? 0 > 0 {
                    self.dataArr.append(otherImageModel)
                }
            default:
                break
            }
            

        default:
            break
        }
        self.configUI()
    }
    
    
    
    
}





class BussinessShopInfoModel: Codable {
    ///结款方式
    var settlement_method: String?
    ///店鋪門臉
    var shop_image: String?
    ///室內全景
    var panorama_image: String?
    ///店鋪名稱，寫字樓或者是住宅樓名稱
    var name: String?
    ///安裝地址
    var area_name: String?
    ///詳細地址
    var address: String?
    ///安裝數量
    var screen_number: String?
    ///鏡面數量
    var mirror_account: String?
    ///店鋪面積
    var acreage: String?
    
    var member_name: String?
    var member_mobile: String?
    ///聯繫人，
    var contacts_name: String?
    ///聯繫手機號
    var contacts_mobile: String?
    ///法人
    var apply_name: String?
    ///法人身份證號
    var identity_card_num: String?
    ///法人手機號
    var apply_mobile: String?
    
    var apply_code: String?
    ///開機時間
    var screen_start_at: String?
    ///物業公司
    var company_name: String?
    ///店鋪類型
    var shop_place_type: String?
    ///法人代表正面照
    var identity_card_front: String?
    ///法人代表反面照
    var identity_card_back: String?
    ///營業執照
    var business_licence: String?
    ///錯誤原因
    var fail_reason: String?
    ///登記證號碼
    var registration_mark: String?
    //0待審核，1審核未通過
    var status: String?
    var other_image: [String]?
    var mobile: String?
    var company_area_id: String?
    var company_area_name: String?
    var company_address: String?
    var agreement_name: String?
    var examine_status: String?
    var create_at: String?
    var list: [ShopInfoFenDianModel]?
    ///問題描述
    var problem_description: String?
    ///減少設備問題編號
    var remove_device_number: [String]?
    ///增加硬件設備編號
    var install_device_number: [String]?
    ///安装数量（不变）
    var apply_screen_number: String?
}
class ShopInfoFenDianModel: Codable {
    var id: String?
    var shop_id: String?
    var headquarters_id: String?
    var branch_shop_name: String?
    var branch_shop_area_id: String?
    var branch_shop_area_name: String?
    var branch_shop_address: String?
    
    
    
    
}

struct ResetShopInfoModel {
    var key: String = ""
    var value: String? = ""
    var type: String = ""
    var value2: String? = ""
    var images: [String] = []
    init(key: String, value: String?, type: String) {
        self.key = key
        self.value = value
        self.type = type
    }
    init(key: String, value: String?, value2: String?, type: String) {
        self.key = key
        self.value = value
        self.value2 = value2
        self.type = type
    }
    init(key: String, values: [String],type: String) {
        self.key = key
        self.images = values
        self.type = type
    }
}







