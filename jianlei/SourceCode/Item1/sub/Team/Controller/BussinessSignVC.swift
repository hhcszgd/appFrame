//
//  BussinessSignVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/16.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
class BussinessSignVC: DDInternalVC {
    var signTime: String = ""
    var signTime2: String = ""
    
    var province = "" //省/直辖市
    var city = "" //城市
    var qu = "" //区
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.teamAddress.title.text = dict["shop_address"]
            self.teamID = dict["team_id"] ?? ""
            self.latitude = dict["latitude"] ?? ""
            self.longitude = dict["longitude"] ?? ""
            
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
        
        
        
        self.configUI()
        self.interaction()
        
        // Do any additional setup after loading the view.
    }
    var addressDetail: String = ""
    ///团队id
    var teamID: String = ""
    ///经度
    var latitude: String = ""
    ///纬度
    var longitude: String = ""
    var upLoadPictureTitleLabel: UILabel?
    
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "repair_sign"|?|
        
    }
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight))
    
    let timeView = ShopInfoCell.init(frame: CGRect.zero, leftImage: "time")
    let team = ShopInfoCell.init(frame: CGRect.zero, leftImage: "team")
    let teamAddress = ShopInfoCell.init(frame: CGRect.zero, leftImage: "sign")
    let shopName = ShopInfoCell.init(frame: CGRect.zero, title: "baifangShop"|?|, image: "circular", subTitle: "", placeholder: "enter_shop_name"|?|)
    let shopArea = ShopInfoCell.init(frame: CGRect.zero, title: "shopInfoacreage"|?|, image: "circular", subTitle: "shopInfoacreageOfUnit"|?|, placeholder: "enter_shop_acreage"|?|)
    let screenNumber = ShopInfoCell.init(frame: CGRect.zero, title: "shopInfomirror_account"|?|, image: "circular", subTitle: "unit_of_mirror"|?|, placeholder: "enter_shop_mirror_count"|?|)
    let lowconsumption = ShopInfoCell.init(frame: CGRect.zero, title: "minimum_consumption"|?|, image: "circular", subTitle: "minimum_consumption_unit"|?|, placeholder: "enter_minimum_consumption"|?|)
    let contectMobile = ShopInfoCell.init(frame: CGRect.zero, title: "shopInfocontacts_mobile"|?|, image: "", subTitle: "", placeholder: "enter_contact_mobile"|?|)
    let repairContent4 = ShopInfoCell.init(frame: CGRect.zero, title: "", image: "", subTitle: "", placeholder: "enter_screen_brand"|?|)
    let repairContent5 = ShopInfoCell.init(frame: CGRect.zero, title: "", image: "", subTitle: "screen_brand_unit"|?|, placeholder: "enter_have_screen_num"|?|)
   
    
    lazy var remarks: UITextView = {
        let text = UITextView.init()
        text.placeholderLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("cccccc"), text: "enter_ohter_info"|?|)
        text.placeholder(placeholder: "enter_ohter_info"|?|)
        text.backgroundColor = UIColor.white
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
        btn.addTarget(self, action: #selector(addPicture(btn:)), for: UIControl.Event.touchUpInside)
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
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    let shopType = UIView.init()
    lazy var type1Btn: UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("self_run"|?|, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "radiobutton_normal"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        btn.setImage(UIImage.init(named: "radiobutton_select"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(selectShopType(btn:)), for: UIControl.Event.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    lazy var type2Btn: UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("leasing"|?|, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "radiobutton_normal"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        btn.setImage(UIImage.init(named: "radiobutton_select"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(selectShopType(btn:)), for: UIControl.Event.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    lazy var type3Btn: UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("chain"|?|, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "radiobutton_normal"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        btn.setImage(UIImage.init(named: "radiobutton_select"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(selectShopType(btn:)), for: UIControl.Event.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    lazy var type4Btn: UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("no_have"|?|, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "radiobutton_normal"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        btn.setImage(UIImage.init(named: "radiobutton_select"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(selectShopType(btn:)), for: UIControl.Event.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    lazy var type5Btn: UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("have"|?|, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "radiobutton_normal"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        btn.setImage(UIImage.init(named: "radiobutton_select"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(selectShopType(btn:)), for: UIControl.Event.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    ///照片数组
    var images: [String] = [String]()
    var imageArr = [UIImage]()
    ///店铺类型
    var shopTypeValue: String = ""
    ///有无屏幕
    var isExistScreen: String = ""
    ///店铺名字
    var shopNameValue: String = ""
    ///店铺面积
    var shopAreaValue: String = ""
    ///镜面数量
    var screenNumberValue: String = ""
    ///最低消费
    var lowPayValue: String = ""
    ///联系人电话
    var contectMoblieValue: String = ""
    ///屏幕品牌
    var screenTypeValue: String = ""
    ///已有屏幕的数量
    var haveScreenNumber: String = ""
    ///备注
    var beizhu: String = ""
    let screenIsExist: UIView = UIView.init()
    ///店铺类型和有无屏幕的点击方法
    @objc func selectShopType(btn: UIButton) {
        btn.isSelected = true
        switch btn {
        case self.type1Btn:
            self.type2Btn.isSelected = false
            self.type3Btn.isSelected = false
            self.shopTypeValue = "1"
        case self.type2Btn:
            self.shopTypeValue = "2"
            self.type1Btn.isSelected = false
            self.type3Btn.isSelected = false
        case self.type3Btn:
            self.shopTypeValue = "3"
            self.type1Btn.isSelected = false
            self.type2Btn.isSelected = false
        case self.type4Btn:
            self.isExistScreen = "1"
            self.type5Btn.isSelected = false
            self.repairContent4.textfield.isEnabled = false
            self.repairContent5.textfield.isEnabled = false
        case self.type5Btn:
            self.isExistScreen = "2"
            self.type4Btn.isSelected = false
            self.repairContent5.textfield.isEnabled = true
            self.repairContent4.textfield.isEnabled = true
        default:
            mylog("结束")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension BussinessSignVC: UITextFieldDelegate {
func configUI()  {
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(self.timeView)
        self.scrollView.addSubview(self.team)
        self.scrollView.addSubview(self.teamAddress)
        self.timeView.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44)
        self.scrollView.addSubview(self.team)
        self.team.frame = CGRect.init(x: 0, y: self.timeView.max_Y, width: SCREENWIDTH, height: 44)
        self.scrollView.addSubview(self.teamAddress)
        self.teamAddress.frame = CGRect.init(x: 0, y: self.team.max_Y, width: SCREENWIDTH, height: 44)
        
        self.scrollView.addSubview(self.shopName)
        self.scrollView.addSubview(self.shopArea)
        
        self.shopName.frame = CGRect.init(x: 0, y: self.teamAddress.max_Y + 10, width: SCREENWIDTH, height: 50)
        self.shopArea.frame = CGRect.init(x: 0, y: self.shopName.max_Y + 1, width: SCREENWIDTH, height: 50)
        
        self.scrollView.addSubview(self.screenNumber)
        self.screenNumber.frame = CGRect.init(x: 0, y: self.shopArea.max_Y + 1, width: SCREENWIDTH, height: 40)
        self.scrollView.addSubview(self.lowconsumption)
        self.scrollView.addSubview(self.contectMobile)
        self.configShopType()
        self.configScreenIsExist()
        self.scrollView.addSubview(self.repairContent4)
        self.scrollView.addSubview(self.repairContent5)
        self.lowconsumption.frame = CGRect.init(x: 0, y: self.screenNumber.max_Y + 1, width: SCREENWIDTH, height: 40)
        self.contectMobile.frame = CGRect.init(x: 0, y: self.lowconsumption.max_Y + 1, width: SCREENWIDTH, height: 40)
        self.shopType.frame = CGRect.init(x: 0, y: self.contectMobile.max_Y + 1, width: SCREENWIDTH, height: 40)
        self.screenIsExist.frame = CGRect.init(x: 0, y: self.shopType.max_Y + 1, width: SCREENWIDTH, height: 40)
        self.repairContent4.frame = CGRect.init(x: 0, y: self.screenIsExist.max_Y + 1, width: SCREENWIDTH, height: 40)
        self.repairContent5.frame = CGRect.init(x: 0, y: self.repairContent4.max_Y + 1, width: SCREENWIDTH, height: 40)
    
        //初始化的时候有无屏幕显示无
        self.selectShopType(btn: self.type4Btn)
        
        self.scrollView.addSubview(self.remarks)
        self.remarks.frame = CGRect.init(x: 0, y: self.repairContent5.max_Y + 1, width: SCREENWIDTH, height: 100)
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
    
        ///设置键盘类型
        self.contectMobile.textfield.keyboardType = .numberPad
        self.lowconsumption.textfield.keyboardType = .numberPad
        self.screenNumber.textfield.keyboardType = .numberPad
        self.shopArea.textfield.keyboardType = .numberPad
        self.repairContent5.textfield.keyboardType = .numberPad
    
    
    
    
        
    }
    ///交互
    func interaction() {
        self.shopName.textfield.delegate = self
        self.shopName.textfield.returnKeyType = .done
        let _ = self.shopName.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self] (title) in
            self?.shopNameValue = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.shopArea.textfield.delegate = self
        self.shopArea.textfield.returnKeyType = .done
        let _ = self.shopArea.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self] (title) in
            self?.shopAreaValue = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.screenNumber.textfield.delegate = self
        self.screenNumber.textfield.returnKeyType = .done
        let _ = self.screenNumber.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.screenNumberValue = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.lowconsumption.textfield.delegate = self
        self.lowconsumption.textfield.returnKeyType = .done
        let _ = self.lowconsumption.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.lowPayValue = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.contectMobile.textfield.delegate = self
        self.contectMobile.textfield.returnKeyType = .done
        let _ = self.contectMobile.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.contectMoblieValue = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.repairContent4.textfield.delegate = self
        self.repairContent4.textfield.returnKeyType = .done
        let _ = self.repairContent4.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.screenTypeValue = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.repairContent5.textfield.delegate = self
        self.repairContent5.textfield.returnKeyType = .done
        let _ = self.repairContent5.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.haveScreenNumber = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.remarks.delegate = self
        self.remarks.returnKeyType = .done
        let _ = self.remarks.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.beizhu = title
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
    }
    ///设置contentView
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
                    imageView.addTarget(self, action: #selector(showBigImaeg(target:)), for: UIControl.Event.touchUpInside)
                    imageView.cancleBtn.tag = index + 10000
                    imageView.cancleBtn.addTarget(self, action: #selector(cancleImage(sender:)), for: UIControl.Event.touchUpInside)
                    self.contentView.addSubview(imageView)
                }
                
                
            }
            self.contentView.frame = CGRect.init(x: 0, y: self.remarks.max_Y + 15, width: SCREENWIDTH, height: self.pictureBtn.max_Y + 20)
            
        
            
        }
        self.scrollView.contentSize = CGSize.init(width: SCREENWIDTH, height: self.contentView.max_Y + DDSliderHeight + self.sureBtn.height + 15)
        
        
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
    
    
    @objc func addPicture(btn: UIButton) {
        if self.shopNameValue.count == 0 {
            GDAlertView.alert("enter_shop_name"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        SystemMediaPicker.share.selectImageOnlyCamarm().pickImageCompletedHandler = { [weak self] (image) in
            if let img = image {
                let showImage = ZkqShowImageView.init(backImage: img, shopName: self?.shopNameValue ?? "", name: DDAccount.share.name ?? "", mysuperView: (UIApplication.shared.keyWindow)!, time1: self?.signTime ?? "", time2: self?.signTime2 ?? "")

                showImage.finishedAction = { [weak self] (finishedImage) in
                    if finishedImage != nil {
                        TencentYunUploader.uploadMediaToTencentYun(image: finishedImage!, progressHandler: { (a, b, c) in

                        }, compateHandler: { [weak self](imageStr) in
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
        
        
//        SystemMediaPicker.share.selectImage().pickImageCompletedHandler = { [weak self] (image) in
//            if let img = image {
//                let showImage = ZkqShowImageView.init(backImage: img, shopName: self?.shopNameValue ?? "", name: DDAccount.share.name ?? "", mysuperView: (UIApplication.shared.keyWindow)!, time1: self?.signTime ?? "", time2: self?.signTime2 ?? "")
//
//                showImage.finishedAction = { [weak self] (finishedImage) in
//                    if finishedImage != nil {
//                        TencentYunUploader.uploadMediaToTencentYun(image: finishedImage!, progressHandler: { (a, b, c) in
//
//                        }, compateHandler: { [weak self](imageStr) in
//                            if let imgStr = imageStr, imgStr.count > 0 {
//                                self?.images.append(imgStr)
//                                self?.imageArr.append(finishedImage!
//                                )
//                            }
//
//                            self?.configContentView()
//                        })
//
//                    }else {
//
//                    }
//                }
//
//            }
//
//        }
        
    }
    
    
    
    ///设置店铺类型
    func configShopType() {
        self.shopType.backgroundColor = UIColor.white
        self.scrollView.addSubview(self.shopType)
        let imageView = UIImageView.init(image: UIImage.init(named: "circular"))
        self.shopType.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            make.width.equalTo(imageView.image?.size.width ?? 0)
            make.height.equalTo(imageView.image?.size.height ?? 0)
        }
        
        let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "shop_type"|?|)
        self.shopType.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(6)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
        
        self.shopType.addSubview(self.type1Btn)
        self.shopType.addSubview(self.type2Btn)
        self.shopType.addSubview(self.type3Btn)
        self.type1Btn.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(self.type2Btn.snp.width)
        }
        self.type2Btn.snp.makeConstraints { (make) in
            make.left.equalTo(self.type1Btn.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(self.type3Btn.snp.width)
        }
        self.type3Btn.snp.makeConstraints { (make) in
            make.left.equalTo(self.type2Btn.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
    }
    ///判断屏幕是否存在
    func configScreenIsExist() {
        self.screenIsExist.backgroundColor = UIColor.white
        self.scrollView.addSubview(self.screenIsExist)
        let imageView = UIImageView.init(image: UIImage.init(named: "circular"))
        self.screenIsExist.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            make.width.equalTo(imageView.image?.size.width ?? 0)
            make.height.equalTo(imageView.image?.size.height ?? 0)
        }
        
        let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "shop_isHave_screen"|?|)
        self.screenIsExist.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(6)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
        
        self.screenIsExist.addSubview(self.type4Btn)
        self.screenIsExist.addSubview(self.type5Btn)
        self.type4Btn.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(self.type1Btn.snp.width)
        }
        self.type5Btn.snp.makeConstraints { (make) in
            make.left.equalTo(self.type4Btn.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(self.type1Btn.snp.width)
        }
        
    }
    func showAlertView(title: String = "repari_*_alter"|?|) {
        let width = (280 / 375.0) * SCREENWIDTH
        let height = 0.5 * width
        let alertView = ShopAlertViewType1.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        alertView.center = CGPoint.init(x: SCREENWIDTH / 2.0, y: SCREENHEIGHT / 2.0)
        alertView.myTitleLabel?.text = title
        alertView.sureBtn.setTitle("好", for: UIControl.State.normal)
        let cover = DDCoverView.init(superView: self.view)
        alertView.clickBlock = {
            cover.remove()
        }
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cover.addSubview(alertView)
    }
    ///点击提交信息
    @objc func btnClick(btn: UIButton) {
        
        
        if self.shopNameValue.count == 0 || self.screenNumberValue.count == 0 || self.shopAreaValue.count == 0 || self.lowPayValue.count == 0 || self.shopTypeValue.count == 0 || self.isExistScreen.count == 0 || self.images.count == 0 {
            
            self.showAlertView()
           
            return
        }
        if !self.contectMoblieValue.isEmpty && !self.contectMoblieValue.mobileLawful() {
            GDAlertView.alert("alert_register_phone_error"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }

        var paramete: [String: String] = ["token": DDAccount.share.token ?? "", "team_id": self.teamID, "shop_name": self.shopNameValue, "shop_acreage": self.shopAreaValue, "shop_mirror_number": self.screenNumberValue, "shop_address": self.teamAddress.title.text ?? "", "longitude": self.longitude, "latitude": self.latitude, "minimum_charge": self.lowPayValue, "contacts_mobile": self.contectMoblieValue, "shop_type": self.shopTypeValue, "description": self.remarks.text ?? "", "country_name":DDLocationManager.share.userLocateCountry.countryName,"country_code":DDLocationManager.share.userLocateCountry.countryCode, "screen_type": "2"]

        paramete["address_search"] = self.addressDetail
        
        if self.isExistScreen == "2" {
            if self.screenTypeValue.count == 0 || self.haveScreenNumber.count == 0 {
                
                
                self.showAlertView(title: "enter_screen_brandAndnum"|?|)
                
                return
                
            }
            paramete["screen_brand_name"] = self.screenTypeValue
            paramete["screen_number"] = self.haveScreenNumber
            
        }
        
        if self.images.count == 0 {
            return
        }
        var imageStr: String = ""
        self.images.forEach { (title) in
            imageStr += title + ","
        }
        imageStr.removeLast()
      
        paramete["image_url"] = imageStr
        btn.isEnabled = false
        let router = Router.post("sign", .api, paramete)
        
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                GDAlertView.alert("repari_sign_success"|?|, image: nil, time: 2 , complateBlock: {
                    self.popToPreviousVC()
                })
//                self.popToPreviousVC()
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
            
            btn.isEnabled = true
        }, onError: { (error) in
            btn.isEnabled = true
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
 
    }
}


extension BussinessSignVC: UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.configScrollViewContentOffSet(containerView: textField, keyboardFrame: CGRect.init(x: 0, y: SCREENHEIGHT - keyboardHeight, width: SCREENWIDTH, height: keyboardHeight), duration: 0.25)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollView.configScrollViewContentOffSet(containerView: textView, keyboardFrame: CGRect.init(x: 0, y: SCREENHEIGHT - keyboardHeight, width: SCREENWIDTH, height: keyboardHeight), duration: 0.25)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}



class SingShopImage: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.cancleBtn)
        self.backgroundColor = UIColor.white
        self.imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
        self.cancleBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.imageView.snp.top)
            make.centerX.equalTo(self.imageView.snp.right)
            make.width.equalTo(33)
            make.height.equalTo(33)
            
        }
        self.cancleBtn.setImage(UIImage.init(named: "textfieldCancle"), for: UIControl.State.normal)
    }
    
    let cancleBtn = UIButton.init()
    let imageView = UIImageView.init()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
