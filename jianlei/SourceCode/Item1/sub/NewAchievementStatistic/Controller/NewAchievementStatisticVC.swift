//
//  NewAchievementStatisticVC.swift
//  Project
//
//  Created by WY on 2019/8/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage

class NewAchievementStatisticVC: DDInternalVC {
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
    let propmtLabel: UILabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: "getCashNoticeTitle"|?|)
    let propmtLabel2: UILabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: "getCashNoticeContent"|?|)
    let propmtLabel3: UILabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    var apiModel = ApiModel<NewAchienementDataModel>()
    let container0 = UIView()
    let backImgView = UIImageView()
    let balanceTitle = UILabel()
    let balanceNum = UILabel()
    let tiXian = NewAchieveBtn()
    let mingXi = NewAchieveBtn()
    let bankCard = NewAchieveBtn()
    
    let container2 = UIView()
    let dynamicTitle = UILabel()
//    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    let noMsgNoticeLabel = UILabel()
    
    let container3 = UIView()
    let container3Line = UIView()
    let businessLabel = UILabel()
    let installLabel = UILabel()
    let chooseTime = DDTimeSelectButton()
    let timeLabel = UILabel()
    var cover  : GDCoverView?
    var selectedDate : String = "totally2"|?|
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.selectedDate == "totally1"|?| || self.selectedDate == "totally2"|?| {
            self.newRequestApi(requestType: DDLoadType.initialize)
        }else {
            self.newRequestApi(requestType: DDLoadType.refresh, create_at: self.selectedDate )
        }
    }
//    @objc func actionJudgeVC() {
//        let vc = JudgeVC()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    @objc func noPayPasswordAlertWhileGetCash() {
//        self.pushVC(vcIdentifier: "SetWithDrawalVC")
//    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
//        NotificationCenter.default.addObserver(self, selector: #selector(actionJudgeVC), name: NSNotification.Name.init("JudgeVC"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(noPayPasswordAlertWhileGetCash), name: NSNotification.Name.init("noPayPasswordAlertWhileGetCash"), object: nil)
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.naviBar.backgroundColor = .clear
        self.naviBar.attributeTitle = NSAttributedString(string: "achievementAndGettingCash"|?|, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        configSubview()
        // Do any additional setup after loading the view.
        
        newRequestApi(requestType:.initialize)
        NotificationCenter.default.addObserver(self , selector: #selector(getCashSuccess), name: NSNotification.Name.init("GetCashSuccess"), object: nil)
    }
    @objc func getCashSuccess() {
        selectedDate = "totally2"|?|
        self.chooseTime.label.text = "totally2"|?|
        newRequestApi(requestType:.initialize)
        self.adjustChooseTimeTitle()
    }
    func configSubview() {
        self.addSubviews()
        configSubviewsFrameBeforeRqeuest()
        _layoutSubviews()
    }
    func newRequestApi(requestType:DDLoadType, create_at: String? = nil )  {
        
        DDRequestManager.share.achievementStatistic(type: ApiModel<NewAchienementDataModel>.self, create_at: create_at, success: { (apiModel ) in
            if requestType == .initialize{

                    self.apiModel = apiModel
                    self.setValueToUIAfterRequest()
                    mylog(apiModel)
                
            }else{
                    if apiModel.status == 200{
                        if let screenNumber = apiModel.data?.screen_number , screenNumber.count > 0{
                                self.apiModel.data?.screen_number = screenNumber
                        }else{
//                                self.apiModel.data?.screen_number = "0"
                        }
                        if let shop_number = apiModel.data?.shop_number , shop_number.count > 0{
                            self.apiModel.data?.shop_number = shop_number
                        }else{
//                            self.apiModel.data?.shop_number = "0"
                        }
                        if let id_card = apiModel.data?.id_card {self.apiModel.data?.id_card = id_card}
                        if let order_number = apiModel.data?.order_number , order_number.count > 0 {self.apiModel.data?.order_number = order_number}

                        if let payment_password = apiModel.data?.payment_password{self.apiModel.data?.payment_password = payment_password}
                        self.setValueToUIAfterRequest()
                        
                    }else{
                            GDAlertView.alert(apiModel.message , image: nil , time: 2, complateBlock: nil )
                    }
                
                
            }
        }, failure: { (error ) in
            
        })
        /*
        DDRequestManager.share.achievementStatistic(create_at: create_at , true )?.responseJSON(completionHandler: { (response ) in
            
            if requestType == .initialize{
                if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<NewAchienementDataModel>.self , from: response){
                    self.apiModel = apiModel
                    self.setValueToUIAfterRequest()
                    mylog(apiModel)
                }
            }else{
                if let dict = response.value as? [String:Any]{
                    if let status = dict["status"] as? Int , status == 200{
                        if let dataDict  = dict["data"] as? [String:Any] {
                            if let screenNumber = dataDict["screen_number"] as? String{self.apiModel.data?.screen_number = screenNumber}else if let screen_number = dataDict["screen_number"] as? Int{
                                self.apiModel.data?.screen_number = "\(screen_number)"
                            }else{
                                self.apiModel.data?.screen_number = "0"
                            }
                            
//                             self.apiModel.data?.screen_number = dataDict["screen_number"]
                            if let shop_number = dataDict["shop_number"] as? String{
                                self.apiModel.data?.shop_number = shop_number
                            }else if let shop_number = dataDict["shop_number"] as? Int{
                                self.apiModel.data?.shop_number = "\(shop_number)"
                            }else{
                                self.apiModel.data?.shop_number = "0"
                            }
//                              self.apiModel.data?.shop_number = dataDict["shop_number"]
                            if let id_card = dataDict["id_card"] as? String{self.apiModel.data?.id_card = id_card}else if let id_card = dataDict["id_card"] as? Int{
                                self.apiModel.data?.id_card = "\(id_card)"
                            }
//                            self.apiModel.data?.id_card = dataDict["id_card"]
                            if let order_number = dataDict["order_number"] as? String{self.apiModel.data?.order_number = order_number}else if let order_number = dataDict["order_number"] as? Int{
                                self.apiModel.data?.order_number = "\(order_number)"
                            }
//                            self.apiModel.data?.order_number = dataDict["order_number"]
                            if let payment_password = dataDict["payment_password"] as? String{self.apiModel.data?.payment_password = payment_password}else if let payment_password = dataDict["payment_password"] as? Int{
                                self.apiModel.data?.payment_password = "\(payment_password)"
                            }
//                            self.apiModel.data?.payment_password = dataDict["payment_password"]
                            self.setValueToUIAfterRequest()
                        }
                    }else{
                        if let msg  = dict["message"] as? String {
                            GDAlertView.alert(msg , image: nil , time: 2, complateBlock: nil )
                        }
                    }
                }

            }
            
        })*/
    }
    @objc func toWebView() {
        self.pushVC(vcIdentifier: "GDBaseWebVC" , userInfo : DomainType.wap.rawValue + "reward_rule")
//        let model = DDActionModel.init()
//        model.keyParameter = DomainType.wap.rawValue + "reward_rule"
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    let installShop = DDCircleButton()
    let installScreen = DDCircleButton()
    let advertBussiness = DDCircleButton()
//    let installShop = BussInessView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44), title: "联系店铺", image: "installtheshop", count: "", des: "家")
//    let installScreen = BussInessView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44), title: "安装屏幕", image: "installationscreen", count: "", des: "台")
//    let guanggao = BussInessView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44), title: "广告业务", image: "advertisingbusiness", count: "", des: "单")
    func setValueToUIAfterRequest() {
        balanceNum.text = self.apiModel.data?.balance == nil ? "0" : "\(self.apiModel.data!.balance!)"
        let shops = self.apiModel.data?.shop_number ?? "0"
        installShop.numberLable.text = shops
        let screens = self.apiModel.data?.screen_number ?? "0"
        self.installScreen.numberLable.text = screens
        self.advertBussiness.numberLable.text = self.apiModel.data?.order_number ?? "0"
//        guanggao.countLabel.text = self.apiModel.data?.order_number ?? "0"
        
        
        //消息的container显示的高度。
        let msgMaxH: CGFloat = CGFloat((self.apiModel.data?.message?.count ?? 0) > 4 ? 200 : (self.apiModel.data?.message?.count ?? 0) * 40 + 40)
   
        if self.apiModel.data?.message != nil && self.apiModel.data!.message!.count > 0 {
            let container2H = msgMaxH
            tableView?.isHidden = false
            container2.frame = CGRect(x: 0, y: container3.max_Y + 10, width: SCREENWIDTH, height: container2H)
            tableView?.frame = CGRect.init(x: 0, y: 45, width: container2.width, height: container2.height - 45)
            tableView?.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.tableView!.isScrollEnabled = self.tableView!.contentSize.height > self.tableView!.bounds.height ? true : false
                mylog("contentSizeHeight : \(self.tableView!.contentSize.height) . boundsHeight:\(self.tableView!.bounds.height)")
            })
        }else{
            tableView?.isHidden = true
            let container2H =  msgMaxH
//            let container2OldFrame = container2.frame
            container2.frame = CGRect(x: 0, y: container3.max_Y + 10, width: SCREENWIDTH, height: container2H)
            noMsgNoticeLabel.frame = container2.bounds
            tableView?.frame = container2.bounds
            
            
            
//            container2.isHidden = true
//            container3.center = CGPoint(x:self.view.bounds.width/2 ,y : container1.frame.maxY + 44 + container3.bounds.height/2)
        }
        let propmtHieht: CGFloat = self.propmtLabel.getSize(width: 100).height
        self.propmtLabel.frame = CGRect.init(x: 15, y: container2.max_Y + 9, width: 100, height: propmtHieht)
        let propmt2Height: CGFloat = self.propmtLabel2.getSize(width: SCREENWIDTH - 60).height
        self.propmtLabel2.frame = CGRect.init(x: 30, y: self.propmtLabel.max_Y + 9, width: SCREENWIDTH - 60, height: propmt2Height)
        let propmt3Height: CGFloat = self.propmtLabel3.getSize(width: SCREENWIDTH - 60).height
        self.propmtLabel3.frame = CGRect.init(x: 30, y: self.propmtLabel2.max_Y + 9, width: SCREENWIDTH - 60, height: propmt3Height)
        self.scrollView.contentSize = CGSize.init(width: 0, height: self.propmtLabel3.max_Y + 40)
        
    }
    func testMessageModel() -> [NewAchienementMsgModel] {
        var models = [NewAchienementMsgModel]()
        for index  in 0...9 {
            let model = NewAchienementMsgModel.init()
            model.title = "title\(index)"
            model.create_at = "create_at\(index)"
            models.append(model)
        }
        return models
    }
    func _layoutSubviews()  {

        
//        chooseTime.sizeToFit()
//        let chooseTimeW = chooseTime.title.sizeSingleLine(font: chooseTime.label.font).width + 20
//        chooseTime.frame = CGRect(x:container2.bounds.width - chooseTimeW - container2Margin, y: container2Margin, width: chooseTimeW, height: 40)
//
//        timeLabel.frame = CGRect(x:chooseTime.frame.minX - 99 - container2Margin, y: container2Margin, width: 99, height: 40)
      
    }
    func addSubviews()  {
        self.view.addSubview(self.scrollView)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(container0)
        container0.addSubview(backImgView)
       container0.addSubview(balanceTitle)
        container0.addSubview(balanceNum)
        

        container0.addSubview(tiXian)
        container0.addSubview(mingXi)
        container0.addSubview(bankCard)
        tiXian.addTarget(self , action: #selector(aboutMoneyButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        mingXi.addTarget(self , action: #selector(aboutMoneyButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        bankCard.addTarget(self , action: #selector(aboutMoneyButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        
        self.scrollView.addSubview(container2)
        container2.addSubview(dynamicTitle)
        container2.addSubview(installLabel)
        container2.addSubview(noMsgNoticeLabel)
        container2.addSubview(tableView!)
        
        
        self.scrollView.addSubview(container3)
        container3.addSubview(container3Line)
        container3.addSubview(installShop)
        container3.addSubview(installScreen)
        container3.addSubview(advertBussiness)
//        container3.addSubview(guanggao)
        container3.addSubview(installLabel)
        container3.addSubview(timeLabel)
        container3.addSubview(chooseTime)
        container3.backgroundColor = UIColor.white
        container3Line.backgroundColor = UIColor.DDLightGray
        
        installShop.titleLable.attributedText = "connectionShopCount"|?|.setColor(color: UIColor.lightGray, keyWord: "achievement_jia"|?|)
        
        installScreen.titleLable.attributedText = "installScreenCount"|?|.setColor(color: UIColor.lightGray, keyWord: "achievement_tai"|?|)
        advertBussiness.titleLable.attributedText = "advertOrderCount"|?|.setColor(color: UIColor.lightGray, keyWord: "achievement_dan"|?|)
        
//        installShop.titleLable.text = "connectionShopCount"|?|
//        installScreen.titleLable.text = "installScreenCount"|?|
//        advertBussiness.titleLable.text = "advertOrderCount"|?|
        
        
        backImgView.image = UIImage(named:"money_bg")

        timeLabel.textColor = UIColor.DDSubTitleColor
        chooseTime.addTarget(self , action: #selector(chooseTimeClick(sender:)), for: .touchUpInside)
        self.balanceTitle.text = "\("balanceTitle"|?|) (\("moneyIndicater"|?|)) "
        tiXian.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        mingXi.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        bankCard.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        tiXian.setTitleColor(UIColor.colorWithHexStringSwift("9e8a61"), for: .normal)
        mingXi.setTitleColor(UIColor.colorWithHexStringSwift("9e8a61"), for: .normal)
        bankCard.setTitleColor(UIColor.colorWithHexStringSwift("9e8a61"), for: .normal)
        
       
        
        
        
//        dynamicTitle.text = "   最新动态"
        let attributeImage = UIImage(named: "money_dynamic")?.imageConvertToAttributedString(bounds: CGRect(x: 10, y: -4, width: dynamicTitle.font.lineHeight, height: dynamicTitle.font.lineHeight)) ?? NSAttributedString()
        let titAttribute = NSAttributedString(string: "     \("recentDynamic"|?|)")
        let dynamictitle = NSMutableAttributedString(attributedString: attributeImage)
            dynamictitle.append(titAttribute)
        
        dynamicTitle.attributedText = dynamictitle
        dynamicTitle.backgroundColor = UIColor.white
        businessLabel.text = "bussinessDetail"|?|
        
//        installLabel.text = "业务统计"
        let tongjiAttributeImage = UIImage(named: "money_business")?.imageConvertToAttributedString(bounds: CGRect(x: 10, y: -4, width: dynamicTitle.font.lineHeight, height: dynamicTitle.font.lineHeight)) ?? NSAttributedString()
        let tongjititAttribute = NSAttributedString(string: "     \("bussinessStatistic"|?|)")
        let tongjititle = NSMutableAttributedString(attributedString: tongjiAttributeImage)
        tongjititle.append(tongjititAttribute)
        
        installLabel.attributedText = tongjititle
        
        
        
        
        timeLabel.text = ""

        chooseTime.label.text = "totally2"|?|
        balanceNum.textAlignment = .center
        balanceTitle.textAlignment = .center
        balanceNum.textColor = UIColor.colorWithHexStringSwift("9e8a61")
        balanceTitle.textColor = UIColor.colorWithHexStringSwift("cdb27b")
        balanceNum.font = GDFont.boldSystemFont(ofSize: 33)
//        chooseTime.backgroundColor = UIColor.DDLightGray

        installLabel.textColor = UIColor.colorWithHexStringSwift("333333")
        businessLabel.textColor = UIColor.DDTitleColor
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorStyle = .none
        noMsgNoticeLabel.text = "noDynamicYetRecently"|?|
        noMsgNoticeLabel.textAlignment = .center
        noMsgNoticeLabel.textColor = UIColor.DDSubTitleColor
        tableView?.showsVerticalScrollIndicator = false
        
        self.scrollView.addSubview(self.propmtLabel)
        self.scrollView.addSubview(self.propmtLabel2)
        self.scrollView.addSubview(self.propmtLabel3)
        self.propmtLabel2.numberOfLines = 0
        self.propmtLabel3.numberOfLines = 0
        
        
    }
    func configSubviewsFrameBeforeRqeuest()  {
        self.automaticallyAdjustsScrollViewInsets = false
        container0.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 8 / 10 * SCREENWIDTH)
        backImgView.frame = container0.bounds
        balanceTitle.frame = CGRect(x: 0, y: 111 * SCALE, width: container0.bounds.width, height: 20)
        balanceNum.frame = CGRect(x: 0, y: balanceTitle.frame.maxY, width: container0.bounds.width, height: 60)
        


        let firstBtnX : CGFloat = 0
        let btnW = container0.frame.width / 3
        let btnH: CGFloat = 78
//        let btnY : CGFloat  = container0.height - btnH 
        let btnY : CGFloat  = container0.height - btnH
        bankCard.frame  = CGRect(x: firstBtnX, y: btnY, width: btnW, height: btnH)
        mingXi.frame  = CGRect(x: bankCard.frame.maxX + firstBtnX, y: btnY, width: btnW, height: btnH)
        tiXian.frame  = CGRect(x:  mingXi.frame.maxX + firstBtnX, y: btnY, width: btnW, height: btnH)
        tiXian.setImage(UIImage(named:"money_cash"), for: .normal)
        mingXi.setImage(UIImage(named:"money_detail"), for: .normal)
        bankCard.setImage(UIImage(named:"money_bankcard"), for: .normal)
        tiXian.setTitle("getCashTitle"|?|, for: .normal)
        mingXi.setTitle("detailTitle"|?|, for: .normal)
        bankCard.setTitle("bankCardTitle"|?|, for: .normal)
        
//
        

        
//        container3.frame = CGRect(x: 0, y: container0.frame.maxY, width: SCREENWIDTH, height: 173)
        let subCompnentsW = SCREENWIDTH/3
        let subCompnentsY : CGFloat = 46
        let subCompnentsH = subCompnentsW * 1.3
        container3.frame = CGRect(x: 0, y: container0.frame.maxY, width: SCREENWIDTH, height: subCompnentsH + 46)
        
        self.configChooseTimeFrame()
        installLabel.frame = CGRect(x: 10, y: 0, width: container3.bounds.width/3, height: 44)
        container3Line.frame = CGRect(x: 0, y: installLabel.frame.maxY, width: container3.bounds.width, height: 2)
        installShop.frame = CGRect.init(x: 0, y: subCompnentsY, width: subCompnentsW, height: subCompnentsH)
        installScreen.frame = CGRect.init(x: installShop.frame.maxX, y: subCompnentsY, width: subCompnentsW, height: subCompnentsH)
        advertBussiness.frame = CGRect.init(x: installScreen.frame.maxX, y: subCompnentsY, width: subCompnentsW, height: subCompnentsH)
//        guanggao.frame = CGRect.init(x: 0, y: installScreen.max_Y, width: container3.width, height: 43)
        
        
        
        
        container2.frame = CGRect(x: 0, y: container3.frame.maxY + 10, width: SCREENWIDTH, height: 100)
        tableView?.frame = container2.bounds
        dynamicTitle.frame = CGRect(x: 0, y: 0, width: container2.bounds.width, height: 44)
        let lineView = UIView.init()
        lineView.frame = CGRect.init(x: 0, y: dynamicTitle.max_Y, width: SCREENWIDTH, height: 1)
        container2.addSubview(lineView)
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        

        
    }

}


class DDTimeSelectButton: UIControl {
    let arrow1 = UIImageView()

    let label = UILabel()
    var title : String = "totally2"|?| {
        didSet{
            self.label.text = title
            layoutIfNeeded()
        }
    }
    override var isSelected: Bool{
        didSet{
            if isSelected {
//                arrow1.image = UIImage(named:"pulldownarrowhead")
//                label.textColor = UIColor.white
                self.backgroundColor = UIColor.white
//                self.backgroundColor = UIColor.colorWithHexStringSwift("ff8302")
            }else{
//                arrow1.image = UIImage(named:"drop_downtriangle")
//                label.textColor = UIColor.colorWithHexStringSwift("c9c9c9")
                self.backgroundColor = UIColor.white
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(arrow1)
        self.addSubview(label)
        self.backgroundColor = .white
        label.text = "totally2"|?|
        label.textColor = UIColor.colorWithRGB(red: 226, green: 198, blue: 135)
        arrow1.bounds = CGRect(x: 0, y: 0, width: 16, height: 10)
//        arrow1.image = UIImage(named:"drop_downtriangle")
        label.font = GDFont.systemFont(ofSize: 12)
        self.backgroundColor = UIColor.white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let arrowW : CGFloat = 0
        let arrowH : CGFloat = 1022
        let margin : CGFloat = 5
        label.sizeToFit()
        let labelCenterX : CGFloat = self.bounds.width/2 - arrowW/2 - margin
        label.center = CGPoint(x: labelCenterX, y: self.bounds.height/2)
        arrow1.frame = CGRect(x: label.frame.maxX + margin  , y: (self.bounds.height - arrowH) / 2, width: arrowW, height: arrowH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        mylog("销毁")
    }
    
}
extension NewAchievementStatisticVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushVC(vcIdentifier: "MingXiVC")
//        let mingXi = MingXiVC()
//        self.navigationController?.pushViewController(mingXi, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.message?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = self.apiModel.data?.message?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell"){
            cell.textLabel?.text = msg?.title
            cell.detailTextLabel?.text = msg?.create_at
            return cell
        }else{
            let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "systemCell")
            cell.imageView?.image = UIImage(named:"achievementDot")
            cell.textLabel?.text = msg?.title
            cell.detailTextLabel?.text = msg?.create_at
            cell.textLabel?.textColor = UIColor.DDSubTitleColor
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension NewAchievementStatisticVC {
    @objc func aboutMoneyButtonClick(sender:UIButton){
        mylog(sender.title(for: UIControl.State.normal))
        switch sender {
        case tiXian:
            if self.apiModel.data?.id_card == "-1" {
//                let vc1 = DDItem1VC()
                self.noAuthorizedAlertWhileGetCash()
                
                
                return
            }else if  self.apiModel.data?.id_card == "0" || self.apiModel.data?.id_card == "2"{//待审核和被驳回
                self.authorizing()
                return
            }
            
            if let payMentPswEnable  = self.apiModel.data?.payment_password , payMentPswEnable == "0"{
//                GDAlertView.alert("请前往个人中心设置支付密码", image: nil , time: 2, complateBlock: nil)
                
//                let vc1 = DDItem1VC()
                self.noPayPasswordAlertWhileGetCash()
                
                
                return
            }
            
            self.pushVC(vcIdentifier: "DDGetCashVC")
//            self.navigationController?.pushViewController(DDGetCashVC(), animated: true)
            break
        case mingXi:
            self.pushVC(vcIdentifier: "MingXiVC")
//            let mingXi = MingXiVC()
//            self.navigationController?.pushViewController(mingXi, animated: true)
            break
        case bankCard:
//            if self.apiModel.data?.id_card == "0" {
////                let vc1 = DDItem1VC()
//                self.noAuthorizedAlertWhileBandCard()
//
//
//                return
//            }
            if self.apiModel.data?.id_card == "-1" {
                //                let vc1 = DDItem1VC()
//                self.noAuthorizedAlertWhileGetCash()
                self.noAuthorizedAlertWhileBandCard()
                
                
                return
            }else if  self.apiModel.data?.id_card == "0" || self.apiModel.data?.id_card == "2"{//待审核和被驳回
                self.authorizing()
                return
            }
            self.pushVC(vcIdentifier: "DDBankCardManageVC")
//            self.navigationController?.pushViewController(DDBankCardManageVC(), animated: true )
            break
            
        default:
            break
        }
    }
}
/// alerts
extension NewAchievementStatisticVC {
    func authorizing() {
        let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//            print(action._title)
        })
        let message1  = "authorNotBePassed"|?|
        let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
        alert.isHideWhenWhitespaceClick = false
        UIApplication.shared.keyWindow?.alert( alert)
    }
    
    
    func noPayPasswordAlertWhileGetCash() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                print(action._title)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                print(action._title)
                let vc = ForgetPasswordVC()
                vc.viewType = .setWithDraw
                self.navigationController?.pushViewController(vc, animated: true)
                
//                NotificationCenter.default.post(name: NSNotification.Name.init("noPayPasswordAlertWhileGetCash"), object: nil)
                
                
            })
            let message1  = "payPasscodeNotBeenSet"|?|
            
            let alert = DDNotice1Alert(message: message1, backgroundImage: nil , image: nil , actions:  [cancel,sure])
            
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
            
        })
    }
    
    func noAuthorizedAlertWhileBandCard() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                print(action._title)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                let vc = DDAuthenticatedVC() // JudgeVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let message1  = "notCertificationedAndCanNotBandBank"|?|
            let alert = DDNotice1Alert(message: message1, backgroundImage: nil , image: nil , actions:  [cancel,sure])
            
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
            
        })
    }
    func noAuthorizedAlertWhileGetCash() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                print(action._title)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                let vc = DDAuthenticatedVC() // JudgeVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let message1  = "notCertificationedAndCanNotGetCash"|?|
            let alert = DDNotice1Alert(message: message1, backgroundImage: nil , image: nil , actions:  [cancel,sure])
            
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
            
        })
    }
    
    
}


extension NewAchievementStatisticVC : UIPickerViewDataSource , UIPickerViewDelegate{
    class DDPickerContainer: UIView {
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            mylog("touch")
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.apiModel.data?.date_list?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if let model  = self.apiModel.data?.date_list?[row] {
            return model.create_at
        }
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if let model  = self.apiModel.data?.date_list?[row] {
            self.selectedDate = model.create_at
        }
    }
    @objc func chooseTimeClick(sender:DDTimeSelectButton)  {
        sender.isSelected = true
        cover = GDCoverView.init(superView: self.view)
        cover?.addTarget(self , action: #selector(conerClick) , for: UIControl.Event.touchUpInside)
        let y = self.chooseTime.convert(self.chooseTime.bounds, to: self.view).maxY
        let choseTime = ChooseTimeView.init(frame: CGRect.init(x: Int(SCREENWIDTH - 109), y: Int(y), width: 109, height: (self.apiModel.data?.date_list?.count ?? 0) * 44 + 6))
        cover?.addSubview(choseTime)
        
        
        choseTime.arr = self.apiModel.data?.date_list ?? []
        choseTime.selectStr = self.selectedDate
        choseTime.finished = { [weak self] (str) in
            self?.selectedDate = str
            self?.conerClick()
            if self?.selectedDate == "totally1"|?| || self?.selectedDate == "totally2"|?| {
                self?.newRequestApi(requestType: DDLoadType.initialize)
            }else {
                self?.newRequestApi(requestType: DDLoadType.refresh, create_at: self?.selectedDate ?? "")
            }            
            self?.configChooseTimeFrame()
            sender.isSelected = false
        }
        
    }
    func configChooseTimeFrame() {
        self.chooseTime.title = self.selectedDate
        chooseTime.sizeToFit()
        let chooseTimeW = chooseTime.title.sizeSingleLine(font: chooseTime.label.font).width + 60
        chooseTime.frame = CGRect(x:container3.bounds.width - chooseTimeW, y: 0, width: chooseTimeW, height: 44)
    }
    
    
    
    @objc func leftButtonClick(sender:UIButton)  {
        conerClick()
    }
    @objc func rightButtonClick(sender:UIButton)  {
        ///do something
        if self.selectedDate == "totally1"|?| || self.selectedDate == "totally2"|?| {
            self.newRequestApi(requestType:.initialize)
            self.chooseTime.title = "totally2"|?|
            
        }else{
            self.newRequestApi(requestType:.refresh,create_at : self.selectedDate)
            self.chooseTime.title = self.selectedDate
        }
        conerClick()
        self.adjustChooseTimeTitle()
//        let container2Margin : CGFloat = 10
//        let chooseTimeW = (chooseTime.label.text ?? "").sizeSingleLine(font: chooseTime.label.font).width + 20
//        chooseTime.frame = CGRect(x:container3.bounds.width - chooseTimeW - container2Margin, y: 0, width: chooseTimeW, height: 44)
//        timeLabel.sizeToFit()
//        timeLabel.frame = CGRect(x:chooseTime.frame.minX - timeLabel.bounds.width - container2Margin, y: 0, width: timeLabel.bounds.width, height: 44)
    }
    
    func adjustChooseTimeTitle(){
        self.configChooseTimeFrame()
    }
    
    @objc func conerClick()  {
        //        self.levelSelectButton.isSelected = false
        if let corverView = self.cover{
            for (_ ,view) in corverView.subviews.enumerated(){
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    view.frame = CGRect(x: 0 , y: self.view.bounds.height, width: self.view.bounds.width , height: 250)
                    corverView.alpha = 0
                }, completion: { (bool ) in
                    corverView.remove()
                    self.cover = nil
                })
            }
        }
    }
}

