//
//  DDOrderDetailVC.swift
//  Project
//
//  Created by WY on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
private let noticeBarH : CGFloat = 40
private let topBarH : CGFloat = 80
private let bottomBarH : CGFloat = 40
private let protocolH : CGFloat = 40
private let scrollViewH : CGFloat = SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight -  bottomBarH
private let bottomTipsH : CGFloat = 64
class DDOrderDetailVC: DDNormalVC {
    /// -1放弃支付0待支付1待补交2预付款已逾期 3 已完成
    enum OrderType:String {
        ///放弃支付 ["联系客服" , "重新购买" ] , [ .lightGray , .orange]
        case type1 = "-1"
        ///待支付 ["放弃支付" , "继续支付" ] , [ .lightGray , .orange]
        case type2 = "0"
        ///待补交 ["售后" , "修改时间" , "补交费用"] , [.black , .lightGray , .orange]
        case type3 = "1"
        ///预付款已逾期 ["联系客服" , "重新购买" ] ,  [ .lightGray , .orange]//自己加的
        case type4 = "2"
        /// 已完成 ["售后" , "修改时间" , "再次购买"] , [.black , .lightGray , .orange]
        case type5 = "3"
    }
     var dayCount: Int = 0
    var noticeBar = UIButton(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: noticeBarH))
    var cover: DDCoverView?
    var apiModel = ApiModel<DDOrderDetailApiData>()
    let topBar = DDOrderProcessView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: topBarH))
    let timeBar = WaitView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: topBarH), title: "0")
    let bottomTips = UILabel()
    let bottomBar = DDActionSelectBar(frame: CGRect(x: 0, y: SCREENHEIGHT - DDSliderHeight - bottomBarH, width: SCREENWIDTH, height: bottomBarH))
//    let arr = ["售后","修改时间","补交费用"]
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: DDNavigationBarHeight , width: SCREENWIDTH, height: scrollViewH))
    let contentView = DDOrderContentView()
    let protocolView = DDProtocolView(frame:  CGRect(x: 0, y: SCREENHEIGHT - DDSliderHeight - bottomBarH - protocolH, width: SCREENWIDTH, height: protocolH))
    var protocolIsAgreed = false{
        didSet{
            protocolView.selectStatus = protocolIsAgreed
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeSelectTime(notification:)), name: NSNotification.Name.init("changeSelectTime"), object: nil)
        self.title = "订单详情"
        self.configBottomBar()
        self.configScrollView()
        configTopBar()
        self.configContenView()
        self.timeBar.isHidden = true
        self.topBar.isHidden = false
        self.timeBar.finished = { [weak self] in
            self?.requestApi()
            
        }
        requestApi()
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#e9e9e9")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.whenShowFromDDItem4VC()
        }
        
    }
    @objc func changeSelectTime(notification: Notification) {
        if let dict = notification.userInfo as? [String: String], let start = dict["start"], let end = dict["end"] {
            if let is_update = self.apiModel.data?.order?.is_update, let count = Int(is_update) {
                if count > 1 {
                    self.apiModel.data?.order?.is_update = String.init(format: "%d", count - 1)
                }
            }
            self.contentView.sentTime.valueLabel.text = start + "到" + end
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.timeBar.timer?.invalidate()
        self.timeBar.timer = nil
    }
    func whenShowFromDDItem4VC() {
        if let _ = self.navigationController?.childViewControllers.first as? DDItem4VC{
            self.navigationController?.viewControllers.forEach({ (tempVC ) in
                if !((tempVC is DDItem4VC)  || (tempVC is DDOrderDetailVC) || (tempVC is DDOrderListVC)){
                    
                    if let tempIndex = self.navigationController?.viewControllers.index(of: tempVC ){
                        self.navigationController?.viewControllers.remove(at: tempIndex)
                    }
                    tempVC.willMove(toParentViewController: nil)
                    tempVC.view.removeFromSuperview()
                    tempVC.removeFromParentViewController()
                }
            })
        }
        if let _ = self.navigationController?.childViewControllers.first as? DDItem3VC{

                    self.navigationController?.viewControllers.forEach({ (tempVC ) in
                        if !((tempVC is DDItem3VC)  || (tempVC is DDOrderDetailVC) || (tempVC is DDOrderListVC)){
                            
                            if let tempIndex = self.navigationController?.viewControllers.index(of: tempVC ){
                                self.navigationController?.viewControllers.remove(at: tempIndex)
                            }
                            tempVC.willMove(toParentViewController: nil)
                            tempVC.view.removeFromSuperview()
                            tempVC.removeFromParentViewController()
                        }
                    })
            
        }
    }
    func configTopBar()  {
        self.scrollView.addSubview(topBar)
        topBar.backgroundColor = UIColor.DDLightGray1
        self.scrollView.addSubview(self.timeBar)
        self.scrollView.addSubview(noticeBar)
        noticeBar.isHidden = true
        noticeBar.backgroundColor = UIColor.orange
        noticeBar.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    @objc func setDetailPage() {
        mylog("print some thing ")
        let alert =  DealPriceChangedAlert(superView: self.view)
        if let orderPrice = self.apiModel.data?.order?.order_price , let dealPrice = self.apiModel.data?.order?.deal_price {
            alert.money = (orderPrice : orderPrice , dealPrice : dealPrice)
        }
       alert.actionHandle = {[weak self ] para in
            self?.connectCustomerService()
        }
    }
//    func jugeHowToShowNoticeBar() {
//        if let orderPrice = self.apiModel.data?.order?.order_price , let dealPrice = self.apiModel.data?.order?.deal_price , orderPrice == dealPrice{
//
//        }else{
//
//        }
//    }
    func layoutNoticeBarAfterRequestApi(status:Bool?) {
        if let statusValue = status {
            let atachment = UIImage(named:"exclamatorymark")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3, width: 15, height: 15)) ?? NSAttributedString(string: "")
            
            let mutableAttribute = NSMutableAttributedString(attributedString: atachment)
            noticeBar.isHidden = false
            if statusValue{ // 可点击状态
                let title = [" 付款期间,选择档期部分被他人抢先购买, ","点击查看详情"].setColor(colors: [UIColor.white , UIColor.blue])
                mutableAttribute.append(title)
                self.noticeBar.addTarget(self , action:#selector(setDetailPage), for: UIControlEvents.touchUpInside)
            }else{//不可点击状态
                self.noticeBar.removeTarget(self , action: #selector(setDetailPage), for: UIControlEvents.touchUpInside)
                let title = [" 请尽快付款, 以免选择广告档期被他人抢先购买"].setColor(colors: [UIColor.white])
                mutableAttribute.append(title)
            }
            noticeBar.setAttributedTitle(mutableAttribute, for: UIControlState.normal)
        }else{ // nil 时 不显示
            noticeBar.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func configBottomBar()  {
        self.view.addSubview(bottomBar)
        protocolView.protocolAction = { [weak self ](status) in
            mylog("action")
            var listID = ""
            
            if let temp = self?.userInfo as? String{listID = temp}
            if status == 0 {
                self?.protocolIsAgreed = true
                
                DDRequestManager.share.setOrderAgreedStatus(type: ApiModel<String>.self, orderID: listID, buy_agreed: "2", success: { (result ) in
                    
                }, failure: { (error ) in
                    
                })
            }else if status == 1 {
                self?.protocolIsAgreed = false
                DDRequestManager.share.setOrderAgreedStatus(type: ApiModel<String>.self, orderID: listID, buy_agreed: "1", success: { (result ) in
                    
                }, failure: { (error ) in
                    
                })
            }else if status == 2{
                if let url = self?.apiModel.data?.order?.buy_url{
                        self?.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: url)
                }else{
                    GDAlertView.alert("协议获取失败,请稍后重试", image: nil, time: 2 , complateBlock: nil)
                }
                
            }
        }
        bottomBar.action = {[unowned  self] index in
            self.configTopAndBottomView( clickIndex : index )
        }
    }
    func configScrollView() {
        self.view.addSubview(scrollView)
        
        self.view.addSubview(protocolView)
        protocolView.isHidden = true
//        scrollView.backgroundColor = .orange
        self.scrollView.addSubview(bottomTips)
        bottomTips.textAlignment = .center
        bottomTips.numberOfLines = 2
        bottomTips.textColor = .lightGray
        bottomTips.font = GDFont.systemFont(ofSize: 13)
        
    }
    func configContenView()  {
        self.scrollView.addSubview(contentView)
        contentView.frame = CGRect(x: 10, y: topBar.bounds.height + 10, width: self.scrollView.bounds.width - 10 * 2 , height: self.scrollView.bounds.height)

        contentView.action = {[weak self ] tag in
            switch tag {
            case 1: // 查看地区
                self?.seeSelectedArea()
            case 2: // 评价业务合作人
                self?.commentYeWu()
                
            case 3: // 评价广告对接人
                self?.commentDuiJie()
                
            case 4: // 素材提交
                self?.suCaiTips()
            default:
                break
            }
//            mylog(tag)
        }
    }
    
    
    func requestApi() {
        
        var orderID = ""
        if let temp = self.userInfo as? String{orderID = temp}
        DDRequestManager.share.orderDetail(order_id: orderID, true)?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<DDOrderDetailApiData>.self , from: response){
                self.apiModel = apiModel
                
                
                mylog(apiModel)
                self.configTopAndBottomView()
//                self.layoutNoticeBarAfterRequestApi(status: nil    )
                self.contentView.apiModel = apiModel
                let contentViewH = self.contentView.bounds.height
                if self.noticeBar.isHidden{
                    self.topBar.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: topBarH)
                    self.contentView.frame = CGRect(x: 10, y: self.topBar.bounds.height + 10, width: self.scrollView.bounds.width - 10 * 2 , height: contentViewH)
                    self.scrollView.contentSize = CGSize(width: SCREENWIDTH, height: self.contentView.frame.height + topBarH + 10 + bottomTipsH)
                }else{
                    
                    self.topBar.frame = CGRect(x: 0, y: self.noticeBar.frame.maxY, width: SCREENWIDTH, height: topBarH)
                    self.timeBar.frame = CGRect(x: 0, y: self.noticeBar.frame.maxY, width: SCREENWIDTH, height: topBarH)
                    self.contentView.frame = CGRect(x: 10, y:self.topBar.frame.maxY  + 10, width: self.scrollView.bounds.width - 10 * 2 , height: contentViewH)
//                    self.scrollView.contentSize = CGSize(width: SCREENWIDTH, height: self.contentView.frame.height + topBarH + 10 + bottomTipsH + noticeBarH)
                    self.scrollView.contentSize = CGSize(width: SCREENWIDTH, height: self.contentView.frame.maxY +  10 + bottomTipsH)
                }
                
                if self.apiModel.data?.order?.payment_status ?? "" == OrderType.type2.rawValue{
                    let size = self.scrollView.contentSize
                    self.scrollView.contentSize = CGSize(width: size.width, height: size.height + protocolH)
                    self.protocolView.isHidden = false
                    if self.apiModel.data?.order?.buy_agreed ?? "" != "2"{// 未同意
                            self.protocolIsAgreed = false
                    }else{self.protocolIsAgreed = true}
                }else{
                    
                    self.protocolView.isHidden = true
                }
                mylog(self.contentView.frame)
                mylog(self.contentView.frame.maxY)
                mylog(self.contentView.frame.height)
                self.bottomTips.frame = CGRect(x: 0, y: self.contentView.frame.maxY, width: SCREENWIDTH, height: bottomTipsH)
                mylog(self.bottomTips.frame)
                
            }
        })
    }
//    -1放弃支付0待支付1待补交2预付款已逾期 3 已完成
    func configTopAndBottomView( clickIndex : Int? = nil)  {
        var bottomText = ""
        switch (self.apiModel.data?.order?.payment_status ?? "") {
        case OrderType.type1.rawValue:
            if let index = clickIndex {
                if index == 1 {
                    self.connectCustomer()
                }else if index == 2{
                    self.buyAgain()
                }
                return
            }
//            bottomBar.actionTitleArr = ["联系客服" , "重新购买" ]
//            bottomBar.colors = [ .lightGray , .orange]
//            bottomBar.actionTitleArr = ["联系客服"  ]
//            bottomBar.colors = [ .orange]
            topBar.process = .type6
            bottomText = "  "
            self.topBar.isHidden = false
        case OrderType.type2.rawValue:
            if let countDown = self.apiModel.data?.order?.count_down, countDown > 0 {
                self.timeBar.time = countDown
                self.timeBar.start()
                self.timeBar.isHidden = false
            }
            if (self.apiModel.data?.order?.remittance ?? "") == "1"{
                if let index = clickIndex {
                    if index == 1{
                        self.payCancle()
                    }else if index == 2{
                        self.seeRemitInfo()
                    }else if index == 3 {
                        self.payContinue(payType: "2")
                    }
                    return
                }
                
                bottomBar.actionTitleArr = ["放弃支付" , "查看汇款信息" , "线上支付" ]
                bottomText = "请尽快进行线下汇款操作，保证广告按时投放"
                 bottomBar.colors =  [.black , .lightGray , .orange ]
            }else{
                if let index = clickIndex {
                    if index == 1{
                        self.payCancle()
                    }else if index == 2{
                        self.payContinue()
                    }
                    return
                }
                bottomText = "    "
                bottomBar.actionTitleArr = ["放弃支付" , "继续支付" ]
                bottomBar.colors =  [ .lightGray , .orange]
            }
            
            self.layoutNoticeBarAfterRequestApi(status: false  )
        case OrderType.type3.rawValue:
            self.topBar.isHidden = false
            if (self.apiModel.data?.order?.remittance ?? "") == "1"{
                if let index = clickIndex {
                    if index == 1{
                        self.shouHou()
                    }else if index == 2 {
//                        self.seeRemitInfo()
                        self.buJiao()
                    }
                    return
                }
                
                bottomBar.actionTitleArr = ["售后"  , "补交费用" /*, "查看汇款信息"*/ ]
                bottomBar.colors =  [ .lightGray , .orange]
                bottomText  = "请尽快登录网站，提交广告素材\nhttp://www.bjyltf.com"
                
            }else{
                if let index = clickIndex {
                    if index == 1{
                        self.shouHou()
                    }else if index == 2{
                        self.modifyTime()
                    }else if index == 3{
                        self.buJiao()
                    }
//                    if index == 1{
//                        self.shouHou()
//                    }else if index == 2{
//                        self.buJiao()
//                    }
                    return
                }
                if let orderPrice = self.apiModel.data?.order?.order_price , let dealPrice = self.apiModel.data?.order?.deal_price , orderPrice != dealPrice{
                    self.layoutNoticeBarAfterRequestApi(status: true)
                }else{
                    self.layoutNoticeBarAfterRequestApi(status: nil)
                }
//                self.layoutNoticeBarAfterRequestApi(status: false )
                bottomBar.actionTitleArr = ["售后" , "修改时间", "补交费用"]
                bottomBar.colors =  [.black ,.lightGray , .orange]
            }
        case OrderType.type4.rawValue:
            self.topBar.isHidden = false
            if let index = clickIndex {
                if index == 1{
                    self.shouHou()
                }else if index == 2{
                    self.buyAgain()
                }
                return
            }
            
            bottomText = "尾款已逾期,请联系客服"
//            bottomBar.actionTitleArr = ["联系客服" , "重新购买" ]
//            bottomBar.colors =   [ .lightGray , .orange]
            bottomBar.actionTitleArr = ["联系客服"  ]
            bottomBar.colors =   [ .orange]
        case OrderType.type5.rawValue:
            self.topBar.isHidden = false
            
            let suCaiStatus = (self.apiModel.data?.order?.examine_status ?? "")
            if suCaiStatus == "4" || suCaiStatus == "5"{
                if let index = clickIndex {
                    if index == 1{
                        self.shouHou()
                    }else if index == 2{
                        self.buyAgain()
                    }
                    return
                }
                
                bottomText  = "请尽快登录网站，提交广告素材\nhttp://www.bjyltf.com"
                
                
//                bottomBar.actionTitleArr = ["售后"  , "再次购买"]
//                bottomBar.colors =  [.lightGray , .orange]
                bottomBar.actionTitleArr = ["售后"  ]
                bottomBar.colors =  [ .orange]
            }else{
                
                if let index = clickIndex {
//                    if index == 1{
//                        self.shouHou()
//                    }else if index == 2{
//                        self.buyAgain()
//                    }
                    if index == 1{
                        self.shouHou()
                    }else if index == 2{
                        self.modifyTime()
                    }else if index == 3{
                        self.buyAgain()
                    }
                    return
                }
                
//                bottomBar.actionTitleArr = ["售后" , "修改时间" , "再次购买"]
//                bottomBar.colors =  [.black , .lightGray, .orange]
                bottomBar.actionTitleArr = ["售后" , "修改时间" ]
                bottomBar.colors =  [.black , .lightGray]
                if let orderPrice = self.apiModel.data?.order?.order_price , let dealPrice = self.apiModel.data?.order?.deal_price , orderPrice != dealPrice{
                    self.layoutNoticeBarAfterRequestApi(status: true)
                }else{
                    self.layoutNoticeBarAfterRequestApi(status: nil)
                }
            }
//            bottomTips.text = ""
        default:
            break
        }
        
        ///素材审核状态0待提交1待审核2被驳回3待投放4已投放5投放完成
        switch (self.apiModel.data?.order?.examine_status ?? "") {
        case "0":
            topBar.process = .type2
            
            bottomTips.text = self.configStatu()
        case "1":
            topBar.process = .type3
            bottomTips.text = bottomText.count > 0 ? bottomText :  "素材成功提交，请等待审核"
        case "2":
            topBar.process = .type3
            bottomTips.text = self.apiModel.data?.order?.examine_desc
        case "3":
            bottomTips.text = "素材审核通过,等待投放"
            topBar.process = .type4
        case "4" , "5":
            topBar.process = .type5
            bottomTips.text = "广告投放成功"
            break
//        case OrderType.type5.rawValue:
//            topBar.process = .type5
//            bottomTips.text = "订单已完成"
        default:
            break
        }
        
    }
    func configStatu() -> String {
        
        var bottomText = ""
        switch (self.apiModel.data?.order?.payment_status ?? "") {
        case OrderType.type1.rawValue:
            bottomText = "  "
        case OrderType.type2.rawValue:
            if (self.apiModel.data?.order?.remittance ?? "") == "1"{
                bottomText = "请尽快进行线下汇款操作，保证广告按时投放"
            }else{
                bottomText = "    "

            }
        case OrderType.type3.rawValue:
            bottomText  = "请尽快登录网站，提交广告素材\nhttp://www.bjyltf.com"
        case OrderType.type4.rawValue:
            bottomText = "尾款已逾期,请联系客服"
        case OrderType.type5.rawValue:
            bottomText  = "请尽快登录网站，提交广告素材\nhttp://www.bjyltf.com"
          
        default:
            break
        }
        return bottomText
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension DDOrderDetailVC {
    func commentYeWu(){//评价业务合作人
        mylog("评价业务合作人")
        self.pushVC(vcIdentifier: "DDCommentPersonVC", userInfo: ["key1":DDCommentPersonVC.PersonType.hezuo,"key2": (apiModel.data?.order?.salesman_name ?? "") , "key3": (apiModel.data?.order?.id ?? "")])
    }
    func commentDuiJie(){//评价广告对接人
        mylog("评价广告对接人")
        self.pushVC(vcIdentifier: "DDCommentPersonVC", userInfo: ["key1":DDCommentPersonVC.PersonType.duijie,"key2": (apiModel.data?.order?.custom_service_name ?? ""), "key3": (apiModel.data?.order?.id ?? "")])
    }
    func suCaiTips(){//素材提示
        mylog("关于素材的提示")
        let alert = DDSuCaiTipsAlert(superView: self.view )
        alert.tips = (apiModel.data?.order?.format,apiModel.data?.order?.spec,apiModel.data?.order?.size)
    }
    ///看看已选地区
    func seeSelectedArea(){
        let vc = DDSelectedAreaVC()
        vc.userInfo = self.apiModel.data?.order?.id ?? "0"
        vc.type = "1"
        self.navigationController?.pushViewController(vc, animated: true)
//        self.pushVC(vcIdentifier: "DDSelectedAreaVC", userInfo: self.apiModel.data?.order?.id ?? "0")
    }
    ///售后
    func shouHou() {
        mylog("售后")
        UIApplication.shared.openURL(URL(string: "telprompt:4000736688")!)
    }
   
    ///修改时间
    func modifyTime() {
        mylog("改时间")
        if apiModel.data?.order?.is_update ?? "0" == "0"{
            GDAlertView.alert("修改投放时间失败\n您的修改次数已用完", image: nil, time: 2, complateBlock: nil)
            return
        }
        guard let day = self.apiModel.data?.order?.total_day, let dayNum = Int(day) else {
            return
        }
        guard let start = self.apiModel.data?.order?.start_at else {
            return
        }
        //日历
        let calander = Calendar.current
        self.dayCount = dayNum
        let startYear = calander.getTargetYearWithStr(time: start)
        let startMonth = calander.getTargetMonthWithStr(time: start)
        let startDay = calander.getTargetDayWithStr(time: start)
        let pickerContailerH: CGFloat = SCREENHEIGHT * 0.7
        let pickerContainer = SelectStartAndEndTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH), dayCount: dayNum)
        pickerContainer.titleLabel.text = String.init(format: "您只有%@次修改时间机会\n是否确认修改", apiModel.data?.order?.is_update ?? "0")
        let dayModel = DayModel.init()
        dayModel.year = startYear
        dayModel.month = startMonth
        dayModel.day = startDay
        pickerContainer.startModel = dayModel
        
        
        
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = { [weak self] in
            self?.cover?.removeFromSuperview()
            self?.cover = nil
        }
        _ = pickerContainer.finished.subscribe(onNext: { [weak self](result) in
            if let days = result as? [DayModel] {
                let firstModel = days.first!
                let lastModel = days.last!
                let vc = ChangeTimeVC()
                vc.startDay = self?.apiModel.data?.order?.start_at
                vc.endDay = self?.apiModel.data?.order?.end_at
                vc.is_update = self?.apiModel.data?.order?.is_update
                vc.orderID = self?.apiModel.data?.order?.id
                vc.dayCount = (self?.dayCount)!
                vc.finished = { [weak self] (srart, end) in
                    self?.contentView.sentTime.valueLabel.text = srart + "到" + end
                    if let is_update = self?.apiModel.data?.order?.is_update, let count = Int(is_update) {
                        if count > 1 {
                            self?.apiModel.data?.order?.is_update = String.init(format: "%d", count - 1)
                        }
                    }
                }
                
                
                vc.startDay = String.init(format: "%d-%02d-%02d", firstModel.year ?? 2018, firstModel.month ?? 1, firstModel.day ?? 1)
                vc.endDay = String.init(format: "%d-%02d-%02d", lastModel.year ??  2018, lastModel.month ?? 1, lastModel.day ?? 1)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }, onError: nil, onCompleted: {[weak self] in
            self?.cover?.removeFromSuperview()
            self?.cover = nil
            
        }, onDisposed: nil)
//        pickerContainer.finished.subscribe(onNext: { [weak self](result) in
//            if let days = result as? [DayModel] {
//                let firstModel = days.first!
//                let lastModel = days.last!
//                self?.startTimeValue = String.init(format: "%ld-%02ld-%02ld", firstModel.year ?? 2018, firstModel.month ?? 4, firstModel.day ?? 21)
//                self?.startMonthAndday = String.init(format: "%ld-%02ld", firstModel.month ?? 4, firstModel.day ?? 21)
//                self?.endTimeValue = String.init(format: "%ld-%02ld-%02ld", lastModel.year ?? 2018, lastModel.month ?? 4, lastModel.day ?? 3)
//                self?.endMonthAndday = String.init(format: "%ld-%02ld", lastModel.month ?? 4, lastModel.day ?? 3)
//                self?.beginLabel.text = self?.startTimeValue
//                self?.endLabel.text = self?.endTimeValue
//                self?.day = (self?.calander.getDifferenceByDate(oldTime: (self?.startTimeValue)!, newTime: (self?.endTimeValue)!))! + 1
//
//                self?.timeLengthLabel.text = "共" + String(describing: (self?.day)!) + "天"
//                self?.startDay = firstModel
//                self?.endDay = lastModel
                
                
                
//            }
//        }, onError: nil, onCompleted: { [weak self] in
//            self?.conerClick()
//        }, onDisposed: nil)
        
        self.cover?.addSubview(pickerContainer)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContailerH - TabBarHeight - 49, width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
            
        })
        
        
        
//        DDChangeTimeLimitAlert(superView: self.view )
//        let alert = DDChangeTimeAlert(superView: self.view )
//        alert.times = apiModel.data?.order?.is_update ?? "0"
//        alert.action = {[weak self ] startTime , endTime in
//            mylog(startTime)
//            mylog(endTime)
//            DDRequestManager.share.changeSentTime(order_id: self?.apiModel.data?.order?.id ?? "", start_at: startTime, end_at: endTime, true)?.responseJSON(completionHandler: { (response ) in
//                if let dict = response.value as? [String:Any]{
//                    if let status = dict["status"] as? Int , status == 200 {
//                        GDAlertView.alert("成功修改广告投放时间", image: nil, time: 2, complateBlock: {
//                            self?.viewDidLoad()
//                        })
//                    }else{
//                        if let message = dict["message"] as? String  {
//                            GDAlertView.alert(message, image: nil, time: 2, complateBlock: {
//                            })
//                        }
//                            GDAlertView.alert("修改失败,请重试", image: nil, time: 2, complateBlock: nil )
//                    }
//                }else{
//                    GDAlertView.alert("修改失败,请重试", image: nil, time: 2, complateBlock: nil )
//                }
//            })
//
//        }
//
//        if let start = apiModel.data?.order?.start_at,let end = apiModel.data?.order?.end_at{
//            alert.timeRange = (start , end)
////            let startt = "2018-04-01"
////            let endd = "2018-06-30"
////            alert.timeRange = (startt , endd )
//        }else{
//            mylog("广告投放起始时间为空")
//            let startt = "2018-04-01"
//            let endd = "2018-06-30"
//            alert.timeRange = (startt , endd )
//        }
    }
    ///再次购买
    func buyAgain() {
        mylog("再次购买")
        rootNaviVC?.selectChildViewControllerIndex(index: 2)
    }
    ///放弃支付
    func payCancle() {
        mylog("放弃支付")
        DDCanclePayAlertView.init(superView: self.view ).action = {[weak self ] reason in
            mylog(reason)
            var reasonStr = ""
            switch reason  {
            case 1:
                reasonStr = "信息错误,重新购买"
            case 2:
                reasonStr = "放弃购买"
            case 3:
                reasonStr = "其他"
            default:
                break
            }
            DDRequestManager.share.canclePay(order_id: self?.apiModel.data?.order?.id ?? "", cancleRease: reasonStr, true)?.responseJSON(completionHandler: { (response ) in
                self?.viewDidLoad()
            })
        }
    }
    ///继续支付
    func payContinue(payType: String = "1") {
        mylog("继续支付")
        if !protocolIsAgreed {
            GDAlertView.alert("请同意支付协议", image: nil, time: 2 , complateBlock: nil)
            return
        }
        self.pushVC(vcIdentifier: "PayVC",userInfo:   ["orderCode":self.apiModel.data?.order?.order_code ?? "" , "orderID" : self.apiModel.data?.order?.id ?? "", "payType": payType , "dealPrice":self.apiModel.data?.order?.deal_price , "orderPrice" : self.apiModel.data?.order?.order_price])
    }
    func buJiao() {
        mylog("补交费用")
        self.pushVC(vcIdentifier: "PayVC",userInfo:  ["orderCode":self.apiModel.data?.order?.order_code ?? "" , "orderID" : self.apiModel.data?.order?.id ?? "", "dealPrice":self.apiModel.data?.order?.deal_price , "orderPrice" : self.apiModel.data?.order?.order_price])
    }
    ///联系客服
    func connectCustomerService() {
        mylog("联系客服")
        UIApplication.shared.openURL(URL(string: "telprompt:4000736688")!)
    }
    ///联系客户
    func connectCustomer() {
        mylog("联系客户")
        UIApplication.shared.openURL(URL(string: "telprompt:4000736688")!)
    }
    ///查看汇款信息
    func seeRemitInfo() {
        mylog("查看汇款信息")
        self.pushVC(vcIdentifier: "UnderPayVC" , userInfo: ["orderCode": self.apiModel.data?.order?.order_code, "orderID": self.apiModel.data?.order?.id])
    }
    ///投诉
    func tousu() {
        mylog("投诉")
    }
    func captureScreen()  {
        if let window = UIApplication.shared.keyWindow{
            UIGraphicsBeginImageContext(CGSize(width: SCREENWIDTH, height: SCREENHEIGHT))
            window.layer.render(in: UIGraphicsGetCurrentContext()!)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIImageWriteToSavedPhotosAlbum(img! , nil , nil, nil )
            UIGraphicsEndImageContext();
        }
    }
}

