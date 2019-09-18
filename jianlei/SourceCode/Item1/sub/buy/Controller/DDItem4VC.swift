//
//  DDItem4VC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import RxSwift

class DDItem4VC: DDNormalVC, BannerAutoScrollViewActionDelegate, DDBankChooseDelegate {
   
    
    @IBOutlet var countryBtn: UIButton!
    @IBOutlet var cityBtn: UIButton!
    @IBOutlet var provinceBtn: UIButton!
    
    @IBOutlet var countryBtnheight: NSLayoutConstraint!
    
    @IBOutlet var cityBtnHeight: NSLayoutConstraint!
    
    @IBOutlet var provinceBtnHeight: NSLayoutConstraint!
    @IBAction func countryBtnAction(_ sender: UIButton) {
        self.configAreaBtn(sender: sender)
        self.countryBtnheight.constant = 50
        self.cityBtnHeight.constant = 40
        self.provinceBtnHeight.constant = 40
        self.view.layoutIfNeeded()
        self.areaType = .area
        self.area = ""
        self.areaName = ""
        self.toufangAddressBtn.setTitle("请选择区域", for: .normal)
    }
    @IBAction func cityBtnAction(_ sender: UIButton) {
        self.configAreaBtn(sender: sender)
        self.countryBtnheight.constant = 40
        self.cityBtnHeight.constant = 50
        self.provinceBtnHeight.constant = 40
        self.view.layoutIfNeeded()
        self.areaType = .city
        self.area = ""
        self.areaName = ""
        self.toufangAddressBtn.setTitle("请选择区域", for: .normal)
    }
    @IBAction func provinceBtnAction(_ sender: UIButton) {
        self.configAreaBtn(sender: sender)
        self.countryBtnheight.constant = 40
        self.cityBtnHeight.constant = 40
        self.provinceBtnHeight.constant = 50
        self.view.layoutIfNeeded()
        self.areaType = .province
        self.area = ""
        self.areaName = ""
        self.toufangAddressBtn.setTitle("请选择区域", for: .normal)
    }
    func configAreaBtn(sender: UIButton) {
        let btnArr = [self.countryBtn, self.cityBtn, self.provinceBtn]
        btnArr.forEach { (btn) in
            if btn == sender {
                sender.isSelected = true
                sender.backgroundColor = UIColor.white
            }else {
                btn?.isSelected = false
                btn?.backgroundColor = UIColor.colorWithHexStringSwift("660000").withAlphaComponent(0.3)
            }
        }
        

        
        
    }
    
    
    
    @IBAction func protocalAction(_ sender: UIButton) {
        let web = HomeWebVC()
        
        web.userInfo = DomainType.wap.rawValue + "agreement/throw_agreement"
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    var areaType: AreaType = AreaType.area
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottom: NSLayoutConstraint!
    @IBOutlet var top: NSLayoutConstraint!
    let calander = Calendar.current
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "广告余量查询"
        self.countryBtnAction(self.countryBtn)
        self.bottom.constant = 0
        self.top.constant = DDStateBarHeight
        self.view.layoutIfNeeded()
        self.request()
        self.configBannerView()
        let yearGlobal = self.calander.getyear()
        let globalMonth = self.calander.getMonth()
        let globalDay = self.calander.getDay()
        let date = self.calander.getDate(year: yearGlobal, month: globalMonth, day: globalDay, h: 0, m: 0, s: 15)
        let targetDate = Date.init(timeInterval: 60 * 60 * 24 * 15, since: date)
        let targetDay = self.calander.getDay(date: targetDate)
        let targetMonth = self.calander.getMonth(date: targetDate)
        let targetYear = self.calander.getyear(date: targetDate)
        self.beginLabel.text = String.init(format: "%d-%02d-%02d", targetYear, targetMonth, targetDay)
        self.endLabel.text = String.init(format: "%d-%02d-%02d", targetYear, targetMonth, targetDay)
        self.timeLengthLabel.text = "1天"
        self.startTimeValue = String.init(format: "%d-%02d-%02d", targetYear, targetMonth, targetDay)
        self.endTimeValue = String.init(format: "%d-%02d-%02d", targetYear, targetMonth, targetDay)
        self.startMonthAndday = String.init(format: "%02d-%02d", targetMonth, targetDay)
        self.endMonthAndday = String.init(format: "%02d-%02d", targetMonth, targetDay)
        self.day = 1
        
        
        mylog(self.view.height)
        
        
    }
    
    var model: DDItem4Model<AdvertisModel, AdvertiseBannerModel>?
    func request() {
        let paramete = ["token": DDAccount.share.token ?? ""]
        let _ = NetWork.manager.requestData(router: Router.get("advert", .api, paramete)).subscribe(onNext: { (dict) in
            if let model = BaseModel<DDItem4Model<AdvertisModel, AdvertiseBannerModel>>.deserialize(from: dict), let data = model.data {
                self.model = data
                self.reloadBannerView()
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
    }
    
    var screenItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                arr.forEach({ (model) in
                    let resultModel = AdvertisePickModel.init()
                    resultModel.id = model.id
                    resultModel.name = model.name
                    items.append(resultModel)
                    
                })
                return items
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    var advertiseTimeItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                if self.selectAddressModel == nil {
                    
                    return [AdvertisePickModel]()
                }else {
                    var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                    arr.forEach({ (model) in
                        if model.id == self.selectAddressModel?.id {
                            model.time_list?.forEach({ (time) in
                                let resultModel = AdvertisePickModel.init()
                                resultModel.name = time
                                items.append(resultModel)
                            })
                            
                        }
                        
                        
                    })
                    return items
                }
                
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    
    var frequencyChildrenItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                if self.selectAddressModel == nil {
                    
                    return [AdvertisePickModel]()
                }else {
                    var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                    arr.forEach({ (model) in
                        if model.id == self.selectAddressModel?.id {
                            model.rate_list?.forEach({ (time) in
                                let resultModel = AdvertisePickModel.init()
                                resultModel.name = time
                                items.append(resultModel)
                            })
                            
                        }
                        
                        
                    })
                    return items
                }
                
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    var frequencyItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                if self.selectAddressModel == nil {
                    
                    return [AdvertisePickModel]()
                }else {
                    var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                    arr.forEach({ (model) in
                        if model.id == self.selectAddressModel?.id {
                            model.rate_list?.forEach({ (time) in
                                let resultModel = AdvertisePickModel.init()
                                resultModel.name = time + "次/天"
                                items.append(resultModel)
                            })
                            
                        }
                        
                        
                    })
                    return items
                }
                
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    
    
    
    ///布局bannerview
    func configBannerView() {
        let height: CGFloat = (250.0 / 375.0) * SCREENWIDTH
        let bannerView = DDLeftRightAutoScroll.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: height))
        
        self.bannerView.addSubview(bannerView)
        
        self.banner = bannerView
        
        bannerView.delegate = self
    }
    ///刷新banner的数据
    func reloadBannerView() {
        self.banner?.models = self.bannerDataArr
    }
    var banner: DDLeftRightAutoScroll?
    var bannerDataArr: [DDHomeBannerModel] {
        get {
            var dataArr = [DDHomeBannerModel]()
            if let arr = self.model?.banner {
                
                arr.forEach({ (model) in
                    let otherModel = DDHomeBannerModel.init()
                    otherModel.link_url = model.link_url
                    otherModel.image_url = model.image_url
                    dataArr.append(otherModel)
                })
                
            }
            return dataArr
        }
    }
    
    func performBannerAction(indexPath: IndexPath) {
        //点击banner图到的操作
        let model = self.bannerDataArr[indexPath.item]
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: model.link_url)
        
    }
    
    @IBOutlet var bannerView: UIView!
//    var timePickView: AdvertisePickView?

    @IBOutlet var timeLengthLabel: UILabel!

    ///开始时间
    var startTimeValue: String = ""
    ///结束时间
    var endTimeValue: String = ""
    ///广告天数
    var day: Int = 0
    var rate: String = ""
    var time: String = ""
    var advertID: String = ""
    var advertIDName: String = ""
    var area: String = ""
    var areaName: String = ""
    var startDay: DayModel?
    var endDay: DayModel?
    var isFirstVC: Bool {
        get{
            if self.navigationController?.viewControllers.count ?? 1 > 1 {
                return false
            }else {
                return true
            }
            
        }
    }
    //投放地区
    @IBOutlet var beginLabel: UILabel!
    var startMonthAndday: String?
    var endMonthAndday: String?
    @IBOutlet var endLabel: UILabel!
    @IBAction func selectAreaTapAction(_ sender: UITapGestureRecognizer) {
        let pickerContailerH: CGFloat = SCREENHEIGHT * 0.7
        let pickerContainer = SelectStartAndEndTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH))
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }

        let _ = pickerContainer.finished.subscribe(onNext: { [weak self](result) in
            if let days = result as? [DayModel] {
                let firstModel = days.first!
                let lastModel = days.last!
                self?.startTimeValue = String.init(format: "%ld-%02ld-%02ld", firstModel.year ?? 2018, firstModel.month ?? 4, firstModel.day ?? 21)
                self?.startMonthAndday = String.init(format: "%ld-%02ld", firstModel.month ?? 4, firstModel.day ?? 21)
                self?.endTimeValue = String.init(format: "%ld-%02ld-%02ld", lastModel.year ?? 2018, lastModel.month ?? 4, lastModel.day ?? 3)
                self?.endMonthAndday = String.init(format: "%ld-%02ld", lastModel.month ?? 4, lastModel.day ?? 3)
                self?.beginLabel.text = self?.startTimeValue
                self?.endLabel.text = self?.endTimeValue
                self?.day = (self?.calander.getDifferenceByDate(oldTime: (self?.startTimeValue)!, newTime: (self?.endTimeValue)!))! + 1

                self?.timeLengthLabel.text = "共" + String(describing: (self?.day)!) + "天"
                self?.startDay = firstModel
                self?.endDay = lastModel



            }
        }, onError: nil, onCompleted: { [weak self] in
            self?.conerClick()
        }, onDisposed: nil)

        self.cover?.addSubview(pickerContainer)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: SCREENHEIGHT - pickerContailerH - TabBarHeight - (self.isFirstVC ? 49:0) , width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in

        })
//        let containerView = CalenderSelectTime.init(superView: UIApplication.shared.keyWindow!, isFirstVC: self.isFirstVC)
//        containerView.finished.subscribe(onNext: { [weak self](value) in
//            let firstModel = value.0
//            let lastModel = value.1
//            self?.startTimeValue = String.init(format: "%ld-%02ld-%02ld", firstModel.year ?? 2018, firstModel.month ?? 4, firstModel.day ?? 21)
//            self?.startMonthAndday = String.init(format: "%ld-%02ld", firstModel.month ?? 4, firstModel.day ?? 21)
//            self?.endTimeValue = String.init(format: "%ld-%02ld-%02ld", lastModel.year ?? 2018, lastModel.month ?? 4, lastModel.day ?? 3)
//            self?.endMonthAndday = String.init(format: "%ld-%02ld", lastModel.month ?? 4, lastModel.day ?? 3)
//            self?.beginLabel.text = self?.startTimeValue
//            self?.endLabel.text = self?.endTimeValue
//            self?.day = (self?.calander.getDifferenceByDate(oldTime: (self?.startTimeValue)!, newTime: (self?.endTimeValue)!))! + 1
//            
//            self?.timeLengthLabel.text = "共" + String(describing: (self?.day)!) + "天"
//            self?.startDay = firstModel
//            self?.endDay = lastModel
//        }, onError: nil, onCompleted: {
//         
//        }, onDisposed: nil)
        
        
        
        
        
    }
    
    
    @IBOutlet var toufangAddressBtn: UIButton!
    
    @IBAction func toufangAddressAction(_ sender: UIButton) {
        if self.areaType == .area {
            let vc = ToufangAreaVC.init(nibName: "ToufangAreaVC", bundle: Bundle.main)
            vc.type = self.areaType
            self.navigationController?.pushViewController(vc, animated: true)
            let _ = vc.selectArea.subscribe(onNext: { (dict) in
                self.area = dict["area"]!
                self.areaName = dict["areaName"]!
                self.toufangAddressBtn.setTitle(self.areaName, for: .normal)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        }else if self.areaType == .city {
            let containerView = ToufangCity.init(superView: self.view, isFirst: self.isFirstVC)
            containerView.selectFinished = {[weak self](value) in
                self?.area = value.0
                self?.areaName = value.1
                self?.toufangAddressBtn.setTitle(self?.areaName, for: .normal)
                
                
                
            }
            
        }
        
    }
    //查看已经选择的地区
    @IBAction func chakanTouFangAddressAction(_ sender: UIButton) {
        if self.areaName.count <= 0 {
            GDAlertView.alert("请先选择投放地区", image: nil, time: 2, complateBlock: nil)
            return
        }
        
        self.pushVC(vcIdentifier: "DDSelectedAreaVC", userInfo: "0")
    }
    
    @IBOutlet var guanggaoweiBtn: UIButton!
    
    @IBAction func guanggaoweiAction(_ sender: UIButton) {
        //广告位
        self.advertiseAddress()
        
    }
    
    @IBAction func guanggaoweiyulanAction(_ sender: UIButton) {
        //广告位预览
        let promptVC = ScreenPromptVC()
        if let items = self.model?.advert_position {
            promptVC.items = items
        }
        
        self.navigationController?.pushViewController(promptVC, animated: true)
    }
    
    @IBOutlet var guanggaotimeLengthBtn: UIButton!
    var cover: DDCoverView?
    
    @IBAction func guanggaoTimelengthAction(_ sender: UIButton) {
        //选择广告的时长
        self.advertiseTime()
    }
    
    var vertiseTime: AdvertisementTime?
    var vertiseAddress: AdvertisementTime?
    var vertiseRate: AdvertisementTime?
    var selectAddressModel: AdvertisePickModel?
    var selectTimeModel: AdvertisePickModel?
    var selectScreenModel: AdvertisModel?
    
    
    func didSelectRowAt(indexPath: IndexPath, target: UIView?) {
        if target == self.vertiseAddress {
            let model = self.screenItems[indexPath.row]
            self.selectAddressModel = model
            if let arr = self.model?.advert_position {
                self.selectScreenModel = arr[indexPath.row]
            }
            
            self.guanggaoweiBtn.setTitle(model.name, for: .normal)
            self.advertID = model.id ?? ""
            self.advertIDName = model.name ?? ""
            self.conerClick()
            self.vertiseAddress = nil
            if self.time.count <= 0 {
                
            }else {
                self.time = ""
                self.guanggaotimeLengthBtn.setTitle("请选择投放内容的时长", for: .normal)
            }
            if self.rate.count <= 0 {
                
            }else {
                self.rate = ""
                self.pinciBtn.setTitle("请选择播放内容的频次", for: .normal)
            }
            
            
            
            
        }else if self.vertiseTime == target{
            let model = self.advertiseTimeItems[indexPath.row]
            self.guanggaotimeLengthBtn.setTitle(model.name, for: .normal)
            self.time = model.name ?? ""
            self.conerClick()
            self.vertiseTime = nil
        }else {
            let model = self.frequencyItems[indexPath.row]
            self.pinciBtn.setTitle(model.name!, for: .normal)
            let childrenModel = self.frequencyChildrenItems[indexPath.row]
            self.rate = childrenModel.name ?? ""
            self.conerClick()
            self.vertiseRate = nil
        }
    }
    
    @IBAction func tishiTimeLength(_ sender: UIButton) {
        //查看播放内容时长的提示
        
        GDAlertView.alert("广告时长即为您选择提交广告素材的时间长度，本系统默认按照最小单位5s的倍数进行销售。", image: nil, time: 3, complateBlock: nil)
        
    }
    
    @IBOutlet var pinciBtn: UIButton!
    
    @IBAction func pinciAction(_ sender: UIButton) {
        self.advertiseRate()
    }
    @IBAction func pinciChankanAction(_ sender: UIButton) {
        //查看频次的提示
        GDAlertView.alert("广告播放频次即为广告每天播放的次数，本系统默认按照最小单位12次/天的倍数进行销售。", image: nil, time: 3
            , complateBlock: nil)
    }
    
    
    @IBAction func chanxunAction(_ sender: UIButton) {
        self.chaxunResultView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        //        if self.area.count == 0 {
        //            self.toufangAddressBtn.setTitle("请选择区域", for: .normal)
        //        }else {
        //            self.toufangAddressBtn.setTitle(self.areaName, for: .normal)
        //        }
        
        //        self.navigationController?.navigationBar.isHidden = true
    }
    
    
}
extension DDItem4VC {
    ///弹出框消失
    @objc func conerClick()  {
        self.cover?.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        self.cover?.removeFromSuperview()
        self.cover = nil
        //        self.levelSelectButton.isSelected = false
        //        if let corverView = self.cover{
        //            for (_ ,view) in corverView.subviews.enumerated(){
        //                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
        //                    view.frame = CGRect(x: 0 , y: self.view.bounds.height, width: self.view.bounds.width , height: 250)
        //                    corverView.alpha = 0
        //                }, completion: { (bool ) in
        //                    corverView.remove()
        //                    self.cover = nil
        //                })
        //            }
        //        }
    }
    func advertiseTime() {
        
        
        
        if self.selectAddressModel == nil {
            GDAlertView.alert("请先选择屏幕板块", image: nil, time: 1, complateBlock: nil)
            return
        }
        let pickerTitle = UILabel(frame: CGRect(x:0 , y: 0, width: SCREENWIDTH, height: 50))
        let attribute = NSMutableAttributedString.init(string: "  请选择时长:\n  时长为所要提交广告素材内容的时长")
        attribute.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithHexStringSwift("b3b3b3")], range: NSRange.init(location: 8, length: 19))
        pickerTitle.numberOfLines = 0
        pickerTitle.attributedText = attribute
        let pickerContailerH: CGFloat = 7 * 40
        let pickerContainer = AdvertisementTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH))
        pickerContainer.delegate = self
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
            self.vertiseTime = nil
        }
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.pickerTitleView = pickerTitle
        pickerContainer.addSubview(pickerTitle)
        pickerContainer.models = self.advertiseTimeItems
        self.vertiseTime = pickerContainer
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: SCREENHEIGHT - pickerContailerH - TabBarHeight - (self.isFirstVC ? 49:0) , width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
        })
    }
    func advertiseAddress() {
        let pickerView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 225.5 + 30))
        pickerView.image = UIImage.init(named: "screen0129")
        pickerView.contentMode = .scaleAspectFit
        let pickerContailerH: CGFloat = CGFloat(self.screenItems.count) * 40 + 225.5 + 30
        let pickerContainer = AdvertisementTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH))
        pickerContainer.delegate = self
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = { [weak self] in
            self?.conerClick()
            self?.vertiseAddress = nil
        }
        self.vertiseAddress = pickerContainer
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.pickerTitleView = pickerView
        pickerContainer.addSubview(pickerView)
        pickerContainer.models = self.screenItems
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: SCREENHEIGHT - pickerContailerH - TabBarHeight - (self.isFirstVC ? 49:0) , width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
        })
    }
    
    func advertiseRate() {
        if self.selectAddressModel == nil {
            GDAlertView.alert("请先选择屏幕板块", image: nil, time: 1, complateBlock: nil)
            return
        }
        let pickerTitle = UILabel(frame: CGRect(x:0 , y: 0, width: SCREENWIDTH, height: 60))
        pickerTitle.font = GDFont.systemFont(ofSize: 12)
        let attribute = NSMutableAttributedString.init(string: "  请选择广告播放频次:频次为一天内广告播放总次数，每小时播放1次为基础频次，每天至少播放10小时")
        attribute.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithHexStringSwift("b3b3b3")], range: NSRange.init(location: 12, length: attribute.length - 12))
        pickerTitle.attributedText = attribute
        pickerTitle.numberOfLines = 0
        let pickerContailerH: CGFloat = 7 * 40
        let pickerContainer = AdvertisementTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH))
        pickerContainer.delegate = self
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = { [weak self] in
            self?.conerClick()
            self?.vertiseRate = nil
        }
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.pickerTitleView = pickerTitle
        pickerContainer.addSubview(pickerTitle)
        self.vertiseRate = pickerContainer
        pickerContainer.models = self.frequencyItems
        self.vertiseRate = pickerContainer
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: SCREENHEIGHT - pickerContailerH - TabBarHeight - (self.isFirstVC ? 49:0), width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
        })
    }
    
    //    func advetiseStartTime(pickerTitleText: String, isStart: Bool, startTime: String) {
    //        let pickerTitleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44))
    //
    //
    //
    //        let pickerTitle = UILabel(frame: CGRect(x:0 , y: 0, width: SCREENWIDTH - 80, height: 44))
    //        pickerTitle.text = pickerTitleText
    //        pickerTitleView.addSubview(pickerTitle)
    //
    //
    //
    //        let rightBtn: UIButton = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 80, y: 0, width: 80, height: pickerTitleView.height))
    //        rightBtn.setTitle("确定", for: .normal)
    //        rightBtn.setTitleColor(UIColor.colorWithHexStringSwift("ed8102"), for: .normal)
    //        rightBtn.titleLabel?.font = GDFont.systemFont(ofSize: 15)
    //        rightBtn.addTarget(self, action: #selector(rightBtnAction(btn:)), for: .touchUpInside)
//        pickerTitleView.addSubview(rightBtn)
//
//
//
//
//
//        let pickerContailerH: CGFloat = 44 * 4
//        var pickerContainer: AdvertisePickView!
//        if isStart {
//            let view = AdvertisePickView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH), isStart: isStart)
//            pickerContainer = view
//        }else {
//            pickerContainer = AdvertisePickView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH), isStart: false, startTime: startTime)
//        }
//
//        cover = DDCoverView.init(superView: self.view)
//        cover?.deinitHandle = {
//            self.conerClick()
//        }
//        self.timePickView = pickerContainer
//        self.cover?.addSubview(pickerContainer)
//        pickerContainer.backgroundColor = UIColor.white
//        pickerContainer.pickerTitleView = pickerTitleView
//        pickerContainer.addSubview(pickerTitleView)
//
//
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContailerH - TabBarHeight , width: self.view.bounds.width, height: pickerContailerH)
//        }, completion: { (bool ) in
//        })
//    }
//
//    @objc func rightBtnAction(btn: UIButton) {
//        
//        self.timePickView?.sure()
//        self.conerClick()
//        self.timePickView = nil
//        
//    }
    
    
    

    func chaxunResultView() {
        if self.area.count <= 0 {
            GDAlertView.alert("请选择投放地区", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        
        if self.advertID.count <= 0 {
            GDAlertView.alert("请选择广告位", image: nil, time: 1, complateBlock: nil)
            return

        }
        if self.time.count <= 0 {
            GDAlertView.alert("请选择播放时长", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        if self.rate.count <= 0 {
            GDAlertView.alert("请选择播放频次", image: nil, time: 1, complateBlock: nil)
            return
        }

        let token: String = DDAccount.share.token ?? ""
        let param = ["advert_time": self.time, "rate": self.rate, "start_at": self.startTimeValue, "end_at": self.endTimeValue, "advert_id": self.advertID, "token": token, "total_day": String(self.day), "time": self.time]

        let resultVC = ChaXunResultVC()
        resultVC.userInfo = param
        resultVC.startDay = self.startDay
        resultVC.endDay = self.endDay
        resultVC.model = self.model
        resultVC.areaid = self.area
        resultVC.areaName = self.areaName
        resultVC.areaType = self.areaType
        resultVC.startMonthAndDay = self.startMonthAndday
        resultVC.endMonthAndDay = self.endMonthAndday
        self.navigationController?.pushViewController(resultVC, animated: true)
        resultVC.back = {[weak self] (value) in
            self?.areaName = ""
            self?.area = ""
            self?.toufangAddressBtn.setTitle("请选择区域", for: UIControlState.normal)

        }
     

    }
    
    
    
    
    
}
class AdvertisePickModel: GDModel {
    var id: String?
    var name: String?
}

//class AdvertisePickView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
//
//    let pickerView: UIPickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 40))
//    var leftMonthArrs: [String] = Calendar.current.shortMonthSymbols
//    var delegate: DDBankChooseDelegate?
//    var rightDaysArrs: [String] {
//        get {
//            if isStart {
//                return ["1日", "16日"]
//            }else {
//
//                return ["15日", "月底"]
//            }
//        }
//    }
//    var isStart: Bool = true
//    var pickerTitleView: UIView?
//    init(frame: CGRect, isStart: Bool) {
//        super.init(frame: frame)
//        self.isStart = isStart
//        self.addSubview(self.pickerView)
//        self.pickerView.delegate = self
//        self.pickerView.dataSource = self
//
//        if isStart {
//            self.configStart()
//
//        }else {
//
//
//        }
//
//
//
//    }
//    init(frame: CGRect, isStart: Bool, startTime: String) {
//        super.init(frame: frame)
//        self.isStart = isStart
//        self.addSubview(self.pickerView)
//        self.pickerView.delegate = self
//        self.pickerView.dataSource = self
//
//        if isStart {
//            self.configStart()
//
//        }else {
//            self.configEnd(startTime: startTime)
//
//        }
//    }
//
//
//
//    func sure() {
//        let month: String = String.init(format: "%02d", self.selectMonth)
//        let day: String = String.init(format: "%02d", self.selectDay)
//        let result = String(startYear) + "-" + month + "-" + day
//        finishedSelect.onNext(result)
//        finishedSelect.onCompleted()
//
//    }
//    let finishedSelect: PublishSubject<String> = PublishSubject<String>.init()
//
//
//    var startMonth: Int = 1
//    var startDay: Int = 1
//    var startYear: Int = Calendar.current.getyear()
//    var selectMonth: Int = 1
//    var selectDay: Int = 1
//
//

//    func configStart() {
//        let currentMonth = calander.getMonth()
//        ///首先看看从现在开始推迟7天后有没有超过16号
//        let zhidingDate = calander.getZhiDingTime(month: currentMonth, day: 16)
//        ///退职七天之后的日期
//        let targetDate = calander.getTargetTimeWith(day: "", num: 7)
//        self.startMonth = currentMonth
//        self.selectMonth = currentMonth
//        let result = calander.comparDate(date1: zhidingDate, date2: targetDate)
//        if (result == -1) || (result == 0) {
//            //开始时间移动到下一个月
//            let targetMonth = currentMonth + 1
//            self.startMonth = targetMonth
//            self.selectMonth = targetMonth
//            self.pickerView.selectRow(targetMonth - 1, inComponent: 0, animated: false)
//            self.pickerView.selectRow(0, inComponent: 1, animated: false)
//            self.startDay = 1
//            self.selectDay = 1
//        }else {
//            self.pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: false)
//            self.pickerView.selectRow(1, inComponent: 1, animated: false)
//            self.startDay = 16
//            self.selectDay = 16
//
//        }
//    }
    
//    func configEnd(startTime: String) {
//        let date = calander.theTargetStringConversionDate(str: startTime)
//        self.startMonth = calander.getMonth(date: date)
//        self.startDay = calander.getDay(date: date)
//
//        if self.startDay == 1 {
//            //是从该月的第一天开始的。
//            self.selectMonth = self.startMonth
//            self.selectDay = 15
//            self.pickerView.selectRow(self.selectMonth - 1, inComponent: 0, animated: false)
//            self.pickerView.selectRow((self.selectDay == 15) ? 0:1, inComponent: 1, animated: false)
//        }else {
//            self.selectMonth = self.startMonth
//            self.selectDay = calander.getTargetMonthCountDay(time: startTime)
//            self.pickerView.selectRow(self.selectMonth - 1, inComponent: 0, animated: false)
//            self.pickerView.selectRow((self.selectDay == 15) ? 0:1, inComponent: 1, animated: false)
//
//        }
//
//
//
//    }
    
    
    
    
//    let calander = Calendar.current
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if self.pickerTitleView != nil {
//            self.pickerView.frame = CGRect.init(x: 0, y: self.pickerTitleView?.height ?? 40, width: SCREENWIDTH, height: self.height - (self.pickerTitleView?.height ?? 40))
//        }
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 {
//            return self.leftMonthArrs.count
//        }else {
//            return self.rightDaysArrs.count
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//
//        if let  cell = view as? PickerCell {
//            if component == 0 {
//                cell.label.text = self.leftMonthArrs[row]
//            }else {
//                cell.label.text = self.rightDaysArrs[row]
//            }
//
//            return cell
//        }else {
//            let cell: PickerCell = PickerCell.init(frame: CGRect.init())
//            if component == 0 {
//                cell.label.text = self.leftMonthArrs[row]
//            }else {
//                cell.label.text = self.rightDaysArrs[row]
//            }
//
//            return cell
//        }
//
//    }
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return SCREENWIDTH / 2.0
//    }
//
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 44
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if self.isStart {
//
//
//            if component == 0 {
//                let startIndex: Int = self.startMonth - 1
//                if row <= startIndex {
//                    pickerView.selectRow(startIndex, inComponent: 0, animated: true)
//                    let dayIndex: Int = (self.startDay == 1) ? 0:1
//                    pickerView.selectRow(dayIndex, inComponent: 1, animated: true)
//                }else {
//
//                    self.selectMonth = row + 1
//                }
//
//
//            }else {
//
//
//                if self.selectMonth <= self.startMonth {
//                    pickerView.selectRow(self.startMonth - 1, inComponent: 0, animated: true)
//                    if self.startDay == 1 {
//                        self.selectDay = (row == 0) ? 1:16
//                    }else {
//                        pickerView.selectRow(1, inComponent: 1, animated: true)
//                        self.selectDay = 16
//                    }
//                }else {
//
//                    self.selectDay = (row == 0) ? 1:16
//                }
//
//
//            }
//
//
//
//
//        }else {
//
//            if component == 0 {
//                let startIndex: Int = self.startMonth - 1
//                if row <= startIndex {
//                    pickerView.selectRow(startIndex, inComponent: 0, animated: true)
//                    let dayIndex: Int = (self.startDay == 1) ? 0:1
//                    pickerView.selectRow(dayIndex, inComponent: 1, animated: true)
//                }else {
//
//                    self.selectMonth = row + 1
//                    if self.selectDay != 15 {
//                        let year = calander.getyear()
//                        let month = self.selectMonth
//                        let day = 1
//                        let str = String.init(format: "%d-%2d-%2d", year, month, day)
//                        self.selectDay = calander.getTargetMonthCountDay(time: str)
//                    }
//                }
//
//
//            }else {
//
//
//                if self.selectMonth <= self.startMonth {
//                    pickerView.selectRow(self.startMonth - 1, inComponent: 0, animated: true)
//                    if self.startDay == 1 {
//                        let year = calander.getyear()
//                        let month = self.selectMonth
//                        let day = 1
//                        let str = String.init(format: "%d-%2d-%2d", year, month, day)
//                        self.selectDay = (row == 0) ? 1:calander.getTargetMonthCountDay(time: str)
//                    }else {
//                        pickerView.selectRow(1, inComponent: 1, animated: true)
//                        let year = calander.getyear()
//                        let month = self.selectMonth
//                        let day = 1
//                        let str = String.init(format: "%d-%2d-%2d", year, month, day)
//                        self.selectDay = calander.getTargetMonthCountDay(time: str)
//                    }
//                }else {
//                    let year = calander.getyear()
//                    let month = self.selectMonth
//                    let day = 1
//                    let str = String.init(format: "%d-%2d-%2d", year, month, day)
//                    let count = calander.getTargetMonthCountDay(time: str)
//                    self.selectDay = (row == 0) ? 15: count
//                }
//
//
//            }
//
//
//
//
//        }
//
//
//    }
//
//
//    class PickerCell: UIView {
//        let label = UILabel.init()
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            label.font = GDFont.systemFont(ofSize: 15)
//            label.textColor = UIColor.colorWithHexStringSwift("333333")
//            label.textAlignment = .center
//            label.backgroundColor = UIColor.white
//            self.addSubview(label)
//
//            self.label.snp.makeConstraints { (make) in
//                make.edges.equalToSuperview()
//            }
//
//
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("in；it(coder:) has not been implemented")
//    }
//
//
//
//
//}








class AdvertisementTime: UIView ,UITableViewDelegate , UITableViewDataSource{
    var models : [AdvertisePickModel]?{
        didSet{
            self.tableView.reloadData()
            layoutIfNeeded()
        }
    }
    var currentSelectLevel : Int = 0 {
        didSet{
            mylog(currentSelectLevel)
        }
    }
    
    weak var delegate : DDBankChooseDelegate?
    var pickerTitleView: UIView?
    deinit {
        mylog("**********AdvertisementTime销毁")
    }
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog(indexPath)
        self.delegate?.didSelectRowAt(indexPath: indexPath, target: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  returnCell : DDLevelCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDLevelCell") as? DDLevelCell{
            returnCell = cell
        }else{
            let cell = DDLevelCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDLevelCell")
            returnCell = cell
        }
        if let model = models?[indexPath.row]{
            
            returnCell.titleLabel.text = model.name
        }
        return returnCell
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //            tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.pickerTitleView != nil {
            self.tableView.frame = CGRect(x: 0, y: self.pickerTitleView?.max_Y ?? 40, width: self.bounds.width, height: self.bounds.height - (self.pickerTitleView?.height ?? 40 ))
        }
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




