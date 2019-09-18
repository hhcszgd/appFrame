//
//  MyShopInfoVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class MyShopInfoVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dict = self.userInfo as? [String: String], let id = dict["id"], let type = dict["type"] {
            self.id = id
            self.type = type
        }
        var title: String = ""
        switch self.type {
        case "1":
            title = "新店安装"
        case "2":
            title = "屏幕更换"
        case "3":
            title = "屏幕拆除"
        case "4":
            title = "新增屏幕"
        default:
            title = "店铺信息"
        }
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.scrollView.showsVerticalScrollIndicator = false
        self.naviBar.title = title
        self.request()
        // Do any additional setup after loading the view.
    }
    var type: String = ""
    var id: String = ""
    
    
    
    let orderId: ShopInfoCell = ShopInfoCell.init(frame: CGRect.init(x: 0, y: 13, width: SCREENWIDTH, height: 44), title: "订单号")
    let shopContact: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "店铺联系人")
    let phoneNumber: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "手机号码")
    let companyName: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "公司名称")
    let shopName: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "店铺名称")
    let installAddress: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "安装地址")
    let installAddressDetail: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "")
    let shopMianJi: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "店铺面积")
    let installCount: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "安装数量")
    let jingMianCount: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "镜面数量")
    let screenRunTime: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "屏幕运行时间")
    let contact: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "联系人/业务合作人")
    let contactPhone: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, title: "联系电话")
    let shopImage: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, image: "", title: "店铺门脸照片")
    let shopInImage: ShopInfoCell = ShopInfoCell.init(frame: CGRect.zero, image: "", title: "室内全景照片")
    
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight))
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    ///店铺类型(1、店铺 2、总部)
    var shopType: String = "1"
    var dataArr: [NewHistoryShopInfoModel] = [NewHistoryShopInfoModel]()

}
extension MyShopInfoVC {
    func configUI() {
        let marginTop: CGFloat = 13
        var totalHeight: CGFloat = marginTop
        for (index, model) in self.dataArr.enumerated() {
            var containerView: ShopInfoCell?
            switch model.remark ?? "" {
                case "string":
                    containerView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 44), title: model.name ?? "")
                    containerView?.subTitleValue = model.value
                    totalHeight += 45
                    if (self.type == "1") {
                        if model.name == "" {
                            totalHeight += 12
                        }
                        if model.name == "联系电话" {
                            totalHeight += 12
                        }
                    }
                
                case "text":
                    containerView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 98), titleValue: model.name ?? "", subTitleValue: model.value ?? "")
                    totalHeight += 98

                case "image":
                    containerView = ShopInfoCell.init(frame: CGRect.init(x: 0, y: totalHeight, width: SCREENWIDTH, height: 98), image: model.value ?? "", title: model.name ?? "")
                    totalHeight += 99
                    containerView?.image1Str = model.value ?? ""
                case "images":
                    mylog("")
                
                default:
                    break
            }
            
            if let _ = containerView {
                self.scrollView.addSubview(containerView!)
            }
            self.scrollView.contentSize = CGSize.init(width: SCREENWIDTH, height: totalHeight + 64)
            
            
        }
//        let arr = [self.orderId, self.shopContact, self.phoneNumber, self.companyName, self.shopName, self.installAddress, self.installAddressDetail
//                   ]
//        for (i, subView) in arr.enumerated() {
//            self.scrollView.addSubview(subView)
//            subView.frame = CGRect.init(x: 0, y: 14 + i * 45, width: Int(SCREENWIDTH), height: 44)
//        }
//        for (i, subView) in [self.shopMianJi, self.installCount, self.jingMianCount, self.screenRunTime, self.contact, self.contactPhone].enumerated() {
//            self.scrollView.addSubview(subView)
//            subView.frame = CGRect.init(x: 0, y: (Int(self.installAddressDetail.max_Y) + 14 + i * 45), width: Int(SCREENWIDTH), height: 44)
//        }
//        self.scrollView.addSubview(self.shopImage)
//        self.shopImage.frame = CGRect.init(x: 0, y: self.contactPhone.max_Y + 13, width: SCREENWIDTH, height: 98)
//        self.scrollView.addSubview(self.shopInImage)
//        self.shopInImage.frame = CGRect.init(x: 0, y: self.shopImage.max_Y + 1, width: SCREENWIDTH, height: 98)
//        self.scrollView.contentSize = CGSize.init(width: SCREENWIDTH, height: self.shopInImage.max_Y + 13)
    }
    
    func request() {
        let paramete = ["token": DDAccount.share.token ?? "", "shop_type": self.shopType, "id": self.id]
        if self.id != ""  {
            let router = Router.get("install-history/shop-detail", DomainType.api, paramete)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                let model = BaseModelForArr<NewHistoryShopInfoModel>.deserialize(from: dict)
                if let infoModel = model?.data, model?.status == 200 {
                    self.dataArr = infoModel
                    self.configUI()
                    
                    
//                    self.orderId.subTitleValue = infoModel.apply_code
//                    self.shopName.subTitleValue = infoModel.name
//                    self.shopImage.imageView.sd_setImage(with: imgStrConvertToUrl(infoModel.shop_image ?? ""), placeholderImage: UIImage.init(), options: SDWebImageOptions.cacheMemoryOnly)
//                    self.shopInImage.imageView.sd_setImage(with: imgStrConvertToUrl(infoModel.panorama_image ?? ""), placeholderImage: UIImage.init(), options: SDWebImageOptions.cacheMemoryOnly)
//                    self.installAddress.subTitleValue = infoModel.area_name
//                    self.installAddressDetail.subTitleValue = infoModel.address
//                    self.installCount.subTitleValue = (infoModel.screen_number ?? "") + "台"
//                    self.jingMianCount.subTitleValue = (infoModel.mirror_account ?? "") + "面"
//                    self.shopMianJi.subTitleValue = (infoModel.acreage ?? "") + "平米"
//                    self.shopContact.subTitleValue = infoModel.contacts_name
//                    self.contact.subTitleValue = infoModel.member_name
//                    self.contactPhone.subTitleValue = infoModel.member_mobile
//                    self.screenRunTime.subTitleValue = infoModel.screen_start_at
//                    self.companyName.subTitleValue = infoModel.company_name
//                    self.phoneNumber.subTitleValue = infoModel.contacts_mobile
                    
                    
                }
                
                
            }, onError: { (error) in
                mylog(error)
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
        }
        
    }
}


class PrivateBtnInShopCell: UIButton {
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let title = self.currentTitle else {
            return CGRect.zero
        }
        
        let size = title.sizeSingleLine(font: GDFont.systemFont(ofSize: 14))
        let width = size.width + 3
        let height = contentRect.height
        let x: CGFloat = 0
        let y: CGFloat = 0
        
        
        
        return CGRect.init(x: x, y: y, width: width, height: height)
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let image = self.currentImage else {
            return CGRect.zero
        }
        let x: CGFloat = contentRect.width - image.size.width - 5
        let y: CGFloat = (contentRect.size.height - image.size.height) / 2.0
        
        
        return CGRect.init(x: x, y: y, width: image.size.width, height: image.size.height)
    }
}


class HistoryShopInfoModel: GDModel {
    var shop_image: String?
    var panorama_image: String?
    var name: String?
    var area_name: String?
    var address: String?
    var screen_number: String?
    var mirror_account: String?
    var acreage: String?
    var member_name: String?
    var member_mobile: String?
    var contacts_name: String?
    var contacts_mobile: String?
    var apply_code: String?
    var screen_start_at: String?
    var company_name: String?
}
class NewHistoryShopInfoModel: GDModel {
    var name: String?
    var value: String?
    var remark: String?
}



