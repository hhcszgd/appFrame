//
//  RepairSignVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/13.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
class RepairSignVC: DDInternalVC, UITextViewDelegate {
    var signTime: String = ""
    var signTime2: String = ""
    var maintainItems : [String:String] = [String : String]()
    
    var province = "" //省/直辖市
    var city = "" //城市
    var qu = "" //区
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        NetWork.manager.getTime(word: "1", hour: "1") { [weak self](time) in
            
            if time.contains(" ") {
                let arr = time.components(separatedBy: " ")
                self?.signTime = arr.first ?? "时间没获取到"
                self?.timeView.title.text = time
                self?.signTime2 = arr.last ?? "时间没有获取到"
            }
        }
        
       
        if let dict = self.userInfo as? [String: String] {
            mylog(dict)
            self.team.title.text = dict["teamName"]
            self.shopAddress.title.text = dict["shop_address"]
            self.shopAddressStr = dict["shop_address"] ?? ""
            self.teamID = dict["team_id"] ?? ""
            self.latitude = dict["latitude"] ?? ""
            self.longitude = dict["longitude"] ?? ""
            self.shopID = dict["shopId"] ?? ""
            
            self.province = dict["province"] ?? ""
            self.city = dict["city"] ?? ""
            self.qu = dict["qu"] ?? ""
            if self.province.count > 0 {
                self.addressDetail = self.province + ","
            }else if self.city.count > 0 {
                self.addressDetail = self.city + ","
            }
            
            if self.city.count > 0 {
                self.addressDetail += self.city + ","
            }
            self.addressDetail += self.qu
           
        }
 
        self.getInfo()
        
        
        // Do any additional setup after loading the view.
    }
    var addressDetail: String = ""
    var shopAddressStr: String = ""
    var teamID: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var shopNameStr: String = ""
    var shopID: String = "1"
    var openTimeStr: String = ""
    var closeTimeStr: String = ""
    var contactName: String = ""
    var contactMobile: String = ""
    var upLoadPictureTitleLabel: UILabel?
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "repair_sign"|?|
        
    }
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight))
    let timeView = ShopInfoCell.init(frame: CGRect.zero, leftImage: "time")
    let team = ShopInfoCell.init(frame: CGRect.zero, leftImage: "team")
    let shopName = ShopInfoCell.init(frame: CGRect.zero, leftImage: "shopLogoInFootprint")
    let shopAddress = ShopInfoCell.init(frame: CGRect.zero, leftImage: "sign")
    let shopContect = ShopInfoCell.init(frame: CGRect.zero, title: "repari_shop_contact"|?|)
    let shopContectMobile = ShopInfoCell.init(frame: CGRect.zero, title: "repari_contact_mobile"|?|)
    
    var images: [String] = [String]()
    var imageArr = [UIImage]()
    let repairContent = ShopInfoCell.init(leftImage: "circular", title: "repari_content"|?|, subTitle: "repari_normal_check"|?|, btnTitle: "", btnImage: "normal", btnSelectImage: "select")
    
    
      var modifyTimeView = ShopInfoCell(frame: CGRect.zero, title: "")
    
    let openTime = ShopInfoCell.init(title: "repari_open_time"|?|, rightImage: "return")
    
    let closeTime = ShopInfoCell.init(title: "repari_close_time"|?|, rightImage: "return")
    
    lazy var remarks: UITextView = {
        let text = UITextView.init()
        text.placeholderLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("cccccc"), text: "repari_other_enter"|?|)
        text.placeholder(placeholder: "repari_other_enter"|?|)
        text.backgroundColor = UIColor.white
        text.delegate = self
        return text
    }()
    lazy var contentView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var pictureBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "addpicture"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(addPicture(bn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var sureBtn: UIButton = {
        let btn = UIButton.init()
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: DDSliderHeight + 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        btn.layer.addSublayer(gradientLayer)
        btn.setTitle("repari_sure_sign"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(uploadInfo(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    
    
    ///判断开机时间是否超过是十小时
    func judgeOpenTimedistence() -> Bool {
        let openTime = self.openTimeStr
        let endTime = self.closeTimeStr
        let openTimeArr = openTime.components(separatedBy: ":")
        let closeTimeArr = endTime.components(separatedBy: ":")
        if let prefixOpenTime = openTimeArr.first, let prefixCloseTime = closeTimeArr.first, let prefixOpenTimeInt = Int(prefixOpenTime), let prefixEndTimeInt = Int(prefixCloseTime) {
            let prefixResult = prefixEndTimeInt - prefixOpenTimeInt
            if prefixResult < 8 {
                //小于10小时的话就不用比较
                return false
            }else if prefixResult > 8 {
                return true
            }else {
                if let suffixOpenTime = openTimeArr.last, let suffixCloseTime = closeTimeArr.last, let suffixOpenTimeInt = Int(suffixOpenTime), let suffixCloseTimeInt = Int(suffixCloseTime) {
                    let suffixResult = suffixCloseTimeInt - suffixOpenTimeInt
                    if suffixResult >= 0{
                        return true
                    }else {
                        return false
                    }
                    
                }else {
                    return false
                }
            }
        }else {
            return false
        }
    }
    
    @objc func uploadInfo(sender: UIButton) {
        let bo1 = self.fuwu.count == 0 || self.images.count == 0
        
        if self.openTimeStr.count == 0 {
            GDAlertView.alert("repari_select_open_time_alter"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.closeTimeStr.count == 0 {
            GDAlertView.alert("repari_select_close_time_alter"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        
        
        if !self.judgeOpenTimedistence() {
            GDAlertView.alert("repari_time_limit_alter"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        if bo1 {
            self.showAlertView()
            return
        }
        
        if self.shopAddressStr.count == 0 {
            GDAlertView.alert("repari_back"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        
        

        var paramete: [String: String] = [ "country_name":DDLocationManager.share.userLocateCountry.countryName,"country_code":DDLocationManager.share.userLocateCountry.countryCode , "screen_type":"2"]
        paramete["token"] = DDAccount.share.token ?? ""
        paramete["team_id"] = self.teamID
        paramete["shop_id"] = self.shopID
        paramete["shop_name"] = self.shopNameStr
        paramete["shop_address"] = self.shopAddressStr
        paramete["longitude"] = self.longitude
        paramete["latitude"] = self.latitude
        paramete["contacts_name"] = self.contactName
        paramete["contacts_mobile"] = self.contactMobile
        paramete["maintain_content"] = self.fuwu
        paramete["screen_start_at"] = self.openTimeStr
        paramete["screen_end_at"] = self.closeTimeStr
        paramete["address_search"] = self.addressDetail
        var imageStr: String = ""
        self.images.forEach { (title) in
            imageStr += title + ","
        }
        imageStr.removeLast()
        
        paramete["image_url"] = imageStr
        paramete["description"] = self.remarks.text
        sender.isEnabled = false
        let router = Router.post("sign", .api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                GDAlertView.alert("repari_sign_success"|?|, image: nil, time: 2 , complateBlock: {
                    self.popToPreviousVC()
                })
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
            
            sender.isEnabled = true
        }, onError: { (error) in
            sender.isEnabled = true
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    ///服务内容的id
    var fuwu: String = ""
    var cover: DDCoverView?
    
    deinit {
        mylog("**************************销毁")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RepairSignVC {
    func getInfo() {
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("sign/maintain-sign/\(self.teamID)/\(self.shopID)", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<ReparinSignModel<RepairSignShopInfoModel>>.deserialize(from: dict)
            if model?.status == 200, let data = model?.data {
                self.timeView.title.text = data.now_time
                self.team.title.text = data.team_name
                self.shopContect.subTitleValue = data.shopInfo?.contacts_name
                self.shopContectMobile.subTitleValue = data.shopInfo?.contacts_mobile
                self.shopName.title.text = data.shopInfo?.name
                self.shopNameStr = data.shopInfo?.name ?? ""
                self.contactName = data.shopInfo?.contacts_name ?? ""
                self.contactMobile = data.shopInfo?.contacts_mobile ?? ""
                self.openTimeStr = data.shopInfo?.screen_start_at ?? "8:00"
                self.closeTimeStr = data.shopInfo?.screen_end_at ?? "18:00"
                self.openTime.subTitleValue = self.openTimeStr
                self.closeTime.subTitleValue = self.closeTimeStr
            }else {
                ///没有获取数据
                
            }
        }, onError: { (error) in
            self.configUI(dataCount: 0)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
        
        let rrouter = Router.get("sign/maintain-content", .api, ["token": DDAccount.share.token ?? ""])
        let _ = NetWork.manager.requestData(router: rrouter).subscribe(onNext: { (dict) in
            self.configWithInfo(dict: dict)
        }, onError: { (error) in
            self.configUI(dataCount: 0)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
        
    }
    
    func configWithInfo(dict: [String: AnyObject]) {
            let baseModel = BaseModelForArr<RepairModel>.deserialize(from: dict)
            if let data = baseModel?.data {
                self.configUI(dataCount: data.count)
                
                for (index, model) in data.enumerated() {
                    if index == 0 {
                        let containerView = ShopInfoCell.init(leftImage: "circular", title: "维护内容", subTitle: model.content ?? "", btnTitle: "", btnImage: "normal", btnSelectImage: "select")
                        containerView.frame = CGRect.init(x: 0, y: self.shopContectMobile.max_Y + 15, width: SCREENWIDTH, height: 40)
                        self.scrollView.addSubview(containerView)
                        containerView.rightBtn.tag = index
                        self.configContainerView(containerView: containerView, data: data)
                    }else {
                        let containerView = ShopInfoCell.init(frame: CGRect.zero, title: "", subTitle: model.content ?? "", btnTitle: "", btnImage: "normal", btnSelectImage: "select")
                        if model.content ?? "" == "调整设备开关机时间"{
                                modifyTimeView = containerView
                        }
                        containerView.frame = CGRect.init(x: 0, y: self.shopContectMobile.max_Y + 15 + CGFloat(index * 40), width: SCREENWIDTH, height: 40)
                        self.scrollView.addSubview(containerView)
                        containerView.rightBtn.tag = index
                        self.configContainerView(containerView: containerView, data: data)
                    }
                    
                   
                }


            }else {
                //没有返回数据的时候
                self.configUI(dataCount: 0)
                
        }
    }
    
 
    

    
    func configContainerView(containerView: ShopInfoCell, data: [RepairModel]) {
        containerView.rightshopInfoBtnClick = { [weak self] (sender) in
            let model = data[sender.tag]
            if let id = model.id {
                if sender.isSelected {
                    self?.maintainItems[id] = id
                }else {
                    if self?.maintainItems[id] != nil {
                        self?.maintainItems.removeValue(forKey: id)
                    }
                }
            }
            let arr = self?.maintainItems.values.sorted()
            var str = ""
            for (index , value ) in (arr ?? []).enumerated() {
                if index == (arr?.count ?? 0) - 1{
                    str.append(contentsOf: value)
                }else{
                        str.append(contentsOf: (value + ","))
                }
            }
            self?.fuwu = str
        }
    }
    
    func configUI(dataCount: Int)  {
        
        self.scrollView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(self.timeView)
        self.scrollView.addSubview(self.team)
        self.scrollView.addSubview(shopName)
        self.scrollView.addSubview(self.shopAddress)
        self.timeView.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44)
        self.scrollView.addSubview(self.team)
        self.team.frame = CGRect.init(x: 0, y: self.timeView.max_Y, width: SCREENWIDTH, height: 44)
        self.scrollView.addSubview(self.shopName)
        self.shopName.frame = CGRect.init(x: 0, y: self.team.max_Y, width: SCREENWIDTH, height: 44)
        self.scrollView.addSubview(self.shopAddress)
        self.shopAddress.frame = CGRect.init(x: 0, y: self.shopName.max_Y, width: SCREENWIDTH, height: 44)
        
        self.scrollView.addSubview(self.shopContect)
        self.scrollView.addSubview(self.shopContectMobile)
        self.shopContect.frame = CGRect.init(x: 0, y: self.shopAddress.max_Y + 15, width: SCREENWIDTH, height: 50)
        self.shopContectMobile.frame = CGRect.init(x: 0, y: self.shopContect.max_Y + 1, width: SCREENWIDTH, height: 50)
        
        self.scrollView.addSubview(self.openTime)
        self.scrollView.addSubview(self.closeTime)
        self.openTime.frame = CGRect.init(x: 0, y:self.shopContectMobile.max_Y + CGFloat(dataCount * 40 +  15), width: SCREENWIDTH, height: 50)
        self.closeTime.frame = CGRect.init(x: 0, y: self.openTime.max_Y, width: SCREENWIDTH, height: 50)
        
        self.scrollView.addSubview(self.remarks)
        self.remarks.frame = CGRect.init(x: 0, y: self.closeTime.max_Y + 1, width: SCREENWIDTH, height: 100)
        self.remarks.delegate = self
        self.remarks.returnKeyType = .done
        let rxRemark = self.remarks.rx.text.orEmpty
        let _ = rxRemark.subscribe(onNext: { [weak self](title) in
            if title.count > 0 {
                self?.remarks.placeholderLabel?.isHidden = true
            }else {
                self?.remarks.placeholderLabel?.isHidden = false
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.view.addSubview(self.sureBtn)
        self.sureBtn.frame = CGRect.init(x: 0, y: SCREENHEIGHT - DDSliderHeight - 44, width: SCREENWIDTH, height: DDSliderHeight + 44)
        self.configContentView()
        self.interaction()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    func interaction() {
      
        self.openTime.shopInfoBtnClick = { [weak self] (bo) in
            self?.alertTimeView(superView: self?.openTime)
        }
        self.closeTime.shopInfoBtnClick = { [weak self] (bo) in
            self?.alertTimeView(superView: self?.closeTime)
            
        }
    }
    
    func alertTimeView(superView: ShopInfoCell?) {
        var alert: HourView!
        if self.openTime == superView {
            alert = HourView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 200, width: SCREENWIDTH, height: 200), type: "open", limitTime: self.closeTimeStr)
        }else {
            alert = HourView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 200, width: SCREENWIDTH, height: 200), type: "close", limitTime: self.openTimeStr)
        }
        
        let _ = alert.sender.asObserver().subscribe(onNext: { [weak self](time) in
            if self?.openTime == superView {
                if self?.openTimeStr ?? "8:00" != time && !(self?.modifyTimeView.rightBtn.isSelected ?? false ){
                    self!.modifyTimeView.btnAction(sender: self!.modifyTimeView.rightBtn)
                }
                self?.openTimeStr = time
            }else {
                self?.closeTimeStr = time
            }
            superView?.subTitleValue = time
            self?.cover?.removeFromSuperview()
            self?.cover = nil
        }, onError: nil, onCompleted: {
            self.cover?.removeFromSuperview()
            self.cover = nil
        }, onDisposed: nil)
    
        self.cover = DDCoverView.init(superView: self.view)
        self.cover?.addSubview(alert)
        self.cover?.deinitHandle = { [weak self] in
            self?.cover?.removeFromSuperview()
            self?.cover = nil
        }
    }
    
    
    
    
    
    
    
    
    @objc func addPicture(bn: UIButton) {

//
        SystemMediaPicker.share.selectImageOnlyCamarm().pickImageCompletedHandler = { [weak self] (image) in
            if let img = image {
                let showImage = ZkqShowImageView.init(backImage: img, shopName: self?.shopAddressStr ?? "", name: DDAccount.share.name ?? "", mysuperView: (UIApplication.shared.keyWindow)!, time1: self?.signTime ?? "", time2: self?.signTime2 ?? "")
                
                showImage.finishedAction = { [weak self] (finishedImage) in
                    if finishedImage != nil {
                        TencentYunUploader.uploadMediaToTencentYun(image: finishedImage!, progressHandler: { (a, b, c) in
                            
                        }, compateHandler: { (imageStr) in
                            if imageStr.count > 0 {
                                self?.images.append(imageStr)
                                self?.imageArr.append(finishedImage!
                                )
                            }
                            
                            self?.configContentView()
                        })
                        
                        
                    }else {
                        
                    }
                }
                
                
                
                
            }
            
        }
       
       
    }
    
    
    func configContentView() {
        
        if !self.scrollView.subviews.contains(self.contentView) {
            self.scrollView.addSubview(self.contentView)
        }
        if !self.contentView.subviews.contains(self.upLoadPictureTitleLabel ?? UIView.init()) {
            
            let circularImage = UIImageView.init(image: UIImage.init(named: "circular"))
            self.contentView.addSubview(circularImage)
            circularImage.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(12)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(circularImage.image?.size.width ?? 0)
                make.height.equalTo(circularImage.image?.size.height ?? 0)
            }
            
            self.upLoadPictureTitleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "repari_upLoadPicture"|?|)
            self.contentView.addSubview(self.upLoadPictureTitleLabel!)
            self.upLoadPictureTitleLabel?.snp.makeConstraints { (make) in
                make.left.equalTo(circularImage.snp.right).offset(12)
                make.centerY.equalTo(circularImage.snp.centerY)
                make.right.equalToSuperview().offset(-8)
            }
            self.upLoadPictureTitleLabel?.numberOfLines = 0
            
            

        }
        if !self.contentView.subviews.contains(self.pictureBtn) {
            self.contentView.addSubview(self.pictureBtn)
        }
        
        
        let imageW: CGFloat = (SCREENWIDTH - 50) / 4.0
        let count = self.images.count
        let margin: CGFloat = 10
        self.contentView.subviews.forEach { (subView) in
            if subView.isKind(of: SingShopImage.self) {
                subView.removeFromSuperview()
            }
        }
        if self.images.count == 0 {
            self.pictureBtn.frame = CGRect.init(x: margin, y: 40, width: imageW, height: imageW)
            self.contentView.frame = CGRect.init(x: 0, y: self.remarks.max_Y + 15, width: SCREENWIDTH, height: 130)
            
            
        }else {
            
            for index in 0..<(count + 1) {
                let i = index % 4
                let j = index / 4
                if index == count {
                    self.pictureBtn.frame = CGRect.init(x: margin * CGFloat(i + 1) + CGFloat(i) * imageW, y: 40 + (margin + imageW) * CGFloat(j), width: imageW, height: imageW)
                }else {
                    let imageView = SingShopImage.init(frame: CGRect.zero)
                    imageView.imageView.image = self.imageArr[index]
                    imageView.frame = CGRect.init(x: margin * CGFloat(i + 1) + CGFloat(i) * imageW, y: 40 + (margin + imageW) * CGFloat(j), width: imageW, height: imageW)
                    imageView.cancleBtn.tag = 10000 + index
                    imageView.cancleBtn.addTarget(self, action: #selector(cancleImage(sender:)), for: UIControl.Event.touchUpInside)
                    imageView.addTarget(self, action: #selector(showBigImaeg(target:)), for: UIControl.Event.touchUpInside)
                    self.contentView.addSubview(imageView)
                }
                
                
            }
            self.contentView.frame = CGRect.init(x: 0, y: self.remarks.max_Y + 15, width: SCREENWIDTH, height: self.pictureBtn.max_Y + 20)

        }

        self.scrollView.contentSize = CGSize.init(width: SCREENWIDTH, height: self.contentView.max_Y + DDSliderHeight + self.sureBtn.height + 40)
        
        
    }
    @objc func showBigImaeg(target: SingShopImage) {
        var arr: [GDIBPhoto] = []
        for image in self.imageArr {
            let photo: GDIBPhoto = GDIBPhoto(dict: nil)
            photo.image = image
            arr.append(photo)
            
        }
        let _ = GDIBContentView.init(photos: arr, showingPage: target.cancleBtn.tag - 10000)
    }
    @objc func cancleImage(sender: UIButton) {
        let tag = sender.tag - 10000
        self.imageArr.remove(at: tag)
        self.images.remove(at: tag)
        self.configContentView()
    }
    
    func showAlertView() {
        let width = (280 / 375.0) * SCREENWIDTH
        let height = 0.5 * width
        let alertView = ShopAlertViewType1.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        alertView.center = CGPoint.init(x: SCREENWIDTH / 2.0, y: SCREENHEIGHT / 2.0)
        alertView.myTitleLabel?.text = "repari_*_alter"|?|
        alertView.sureBtn.setTitle("好", for: UIControl.State.normal)
        let cover = DDCoverView.init(superView: self.view)
        alertView.clickBlock = {
            cover.remove()
        }
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cover.addSubview(alertView)
    }
    
    
}
import HandyJSON
class ReparinSignModel<T: HandyJSON>: GDModel {
    var now_time: String?
    var team_name: String?
    var shopInfo: T?
    
}
class RepairSignShopInfoModel: GDModel {
    var contacts_mobile: String?
    var contacts_name: String?
    var name: String?
    var screen_end_at: String?
    var screen_start_at: String?
    
}
class RepairModel: GDModel {
    var id: String?
    var content: String?
}
