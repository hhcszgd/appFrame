//
//  SignBussinessCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
enum SignDataType: String {
    ///超时签到人数
    case action1 = "1"
    ///未达标人数
    case action2 = "2"
    ///未签到人数
    case action3 = "3"
    ///重复店铺数
    case action4 = "重复店铺数"
    ///中评数
    case action5 = "4"
    ///差评数
    case action6 = "5"
    ///差评率
    case action7 = "差评率"
    ///早退人数
    case leave_early_number = "6"
    
}
class SignBussinessCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createAt = self.lastTime
        self.teamName = "allBussiness"|?|
        self.request(team_id: self.teamID, create_at: self.lastTime)
        self.createTime = self.lastTimeType2
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.contentView.addSubview(self.bussiness)
        self.contentView.addSubview(self.time)
        self.time.frame = CGRect.init(x: 0, y: 15, width: frame.width, height: 44)
        
        self.bussiness.frame = CGRect.init(x: 0, y: self.time.max_Y, width: frame.width, height: 44)
        self.time.title.text = self.lastTimeType2
        self.bussiness.title.text = "allBussiness"|?|
        
        
        let memberView = self.configTuPianGuiFan(title: "member_sign_data"|?|)
        self.contentView.addSubview(memberView)
        memberView.frame = CGRect.init(x: 0, y: self.bussiness.max_Y + 10, width: frame.width, height: 44)
        let subHeight = (frame.height - 198 - 30) / 2.0
        let subView1Frame = CGRect.init(x: 0, y: memberView.max_Y + 1, width: frame.width, height: subHeight > 150 ? 150:subHeight)
        self.subView1 = SignSubView.init(frame: subView1Frame, subTitle1: "chaoshiSign"|?|, subTitle2: "weidabiao"|?|, subTitle3: "weiqiandao"|?|, subTitle4: "zaotui"|?|)
        self.contentView.addSubview(self.subView1)
        let memberView2 = self.configTuPianGuiFan(title: "shop_sign_data"|?|)
        self.addSubview(memberView2)
        memberView2.frame = CGRect.init(x: 0, y: self.subView1.max_Y + 10, width: frame.width, height: 44)
        let subView2Frame = CGRect.init(x: 0, y: memberView2.max_Y + 1, width: frame.width, height: subHeight > 150 ? 150: subHeight)
        self.subView2 = SignSubView.init(frame: subView2Frame, subTitle1: "shop_repeat_sign"|?|, subTitle2: "sign_repeat_propert"|?|, subTitle3: "repeat_shop_num"|?|, subTitle4: nil)
        self.contentView.addSubview(self.subView2)
        
        self.subView1.btn1.defaultHidden = false
        self.subView1.btn2.defaultHidden = false
        self.subView1.btn3.defaultHidden = false
        self.subView1.btn4.defaultHidden = false
        
        self.subView2.btn3.defaultHidden = false
        
        self.subView1.countStr = "0"
        self.subView1.signStr = "all_sign_member"|?|
        
        self.subView2.countStr = "0"
        self.subView2.signStr = "shop_sign_num"|?|
        self.subView2.btn1Hidden = true
        self.subView2.btn2Hidden = true
        self.subView2.btn3Hidden = false
        
        self.subView1.btn1.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView1.btn2.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView1.btn3.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView1.btn4.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView2.btn3.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        
        
        self.time.shopInfoBtnClick = { [weak self] (_) in
            self?.timeAction()
        }
        self.bussiness.shopInfoBtnClick = { [weak self] (_) in
            self?.bussinessAction()
        }
    }
    
    var lastTime: String {
        get {
            let date = Date.init(timeInterval: -24 * 3600, since: Date.init())
            mylog(date)
            return self.calendar.getYearAndMonthAndDayWithDate(date: date)
            
        }
    }
    var lastTimeType2: String {
        get{
            let date = Date.init(timeInterval: -24 * 3600, since: Date.init())
            let year = self.calendar.getyear(date: date)
            let month = self.calendar.getMonth(date: date)
            let day = self.calendar.getDay(date: date)
            let str = String(year) + "year"|?| + String(month) + "month"|?| + String(day) + "day"|?|
            return str
        }
    }
    
    
    var calendar: Calendar {
        get{
            if #available(iOS 9.0, *) {
                return Calendar.init(identifier: Calendar.Identifier.gregorian)
            } else {
                return Calendar.current
                // Fallback on earlier versions
            }
        }
    }
    ///类型团队id和时间,团队姓名，时间不同样式, 总人数
    var detailClick: (((SignDataType, String, String, String, String, String)) -> ())?
    var model: SignDataModel?
    ///带有年月日的日期
    var createTime: String = ""
    func request(team_id: String, create_at: String) {
        let paramete = ["token": DDAccount.share.token ?? "", "team_id": team_id, "create_at": create_at]
        let router = Router.get("sign/sign-datas", .api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<SignDataModel>.deserialize(from: dict)
            if let data = model?.data {
                self.subView1.count.text = data.total_sign_member_number ?? "0"
                self.subView1.btn1Title = data.overtime_sign_member_number ?? "0"
                self.subView1.btn2Title = data.unqualified_member_number ?? "0"
                self.subView1.btn3Title = data.no_sign_member_number ?? "0"
                self.subView1.btn4Title = data.leave_early_number ?? "0"
                self.subView2.count.text = data.total_sign_shop_number ?? "0"
                self.subView2.btn1Title = data.repeat_sign_number ?? "0"
                self.subView2.btn2Title = (data.repeat_sign_rate ?? "0") + "%"
                self.subView2.btn3Title = data.repeat_shop_number ?? "0"
                self.bussiness.title.text = data.team_name
                self.teamName = data.team_name ?? ""
                self.model = data
                
            }else {
                self.cleanData()
            }
        }, onError: { (error) in
            self.cleanData()
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    func cleanData() {
        self.subView1.count.text = "0"
        self.subView1.btn1Title = "0"
        self.subView1.btn2Title = "0"
        self.subView1.btn3Title = "0"
        self.subView1.btn4Title = "0"
        self.subView2.count.text = "0"
        self.subView2.btn1Title = "0"
        self.subView2.btn2Title = "0"
        self.subView2.btn3Title = "0"
        self.subView2.btn4Title = "0"
    }
    var selectTeam: (() -> ())?
    @objc func timeAction() {
        let selectTime = SignSelectTimeView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 200, width: SCREENWIDTH, height: 200))
        self.cover = DDCoverView.init(superView: self.window!)
        self.cover?.addSubview(selectTime)
        self.cover?.deinitHandle = {[weak self] in
            self?.cover?.removeFromSuperview()
            self?.cover = nil
        }
        let _ = selectTime.sender.subscribe(onNext: {[weak self](dict) in
            self?.time.title.text = dict["time2"] ?? ""
            self?.createTime = dict["time2"] ?? ""
            self?.createAt = dict["time"] ?? ""
            self?.request(team_id: self?.teamID ?? "", create_at: self?.createAt ?? "")
            
            }, onError: nil, onCompleted: {[weak self] in
                self?.cover?.removeFromSuperview()
                self?.cover = nil
            }, onDisposed: nil)
        
    }
    var teamName: String = "" {
        didSet{
            self.bussiness.title.text = teamName
        }
    }
    var teamID: String = "business" {
        didSet {
            self.request(team_id: self.teamID, create_at: self.createAt)
        }
    }
    var createAt: String = ""
    var cover: DDCoverView?
    
    @objc func controlClick(sender: UIControl) {
        switch sender {
        case self.subView1.btn1:
            self.detailClick?((SignDataType.action1, self.teamID, self.createAt, self.teamName, self.createTime, self.model?.overtime_sign_member_number ?? ""))
        case self.subView1.btn2:
            self.detailClick?((SignDataType.action2, self.teamID, self.createAt, self.teamName, self.createTime, self.model?.unqualified_member_number ?? ""))
        case self.subView1.btn3:
            self.detailClick?((SignDataType.action3, self.teamID, self.createAt, self.teamName, self.createTime, self.model?.no_sign_member_number ?? ""))
        case self.subView1.btn4:
            self.detailClick?((SignDataType.leave_early_number, self.teamID, self.createAt, self.teamName, self.createTime, self.model?.leave_early_number ?? ""))
        case self.subView2.btn3:
            self.detailClick?((SignDataType.action4, self.teamID, self.createAt, self.teamName, self.createTime,self.model?.repeat_shop_number ?? ""))
        default:
            mylog("结束")
        }
        
    }

    
    
    var subView1: SignSubView!
    var subView2: SignSubView!
    let time = ShopInfoCell.init(leftImage: "time", title: "", rightImage: "enterthearrow", isUserinteractionEnable: true)
    let bussiness = ShopInfoCell.init(leftImage: "team", title: "", rightImage: "enterthearrow", isUserinteractionEnable: true)
   
    @objc func bussinessAction() {
        self.selectTeam?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configTuPianGuiFan(title: String) -> UIView {
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
    deinit {
        mylog("销毁")
    }
    
}
class SignSubView: UIView {
    init(frame: CGRect, subTitle1: String?, subTitle2: String?, subTitle3: String?, subTitle4: String?) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
    
        self.imageView.frame = CGRect.init(x: 10, y: 20, width: frame.height - 40, height: frame.height - 40)
        self.addSubview(self.count)
        self.addSubview(self.signLabel)
        self.count.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.imageView.snp.centerX)
            make.width.equalTo(self.imageView.snp.width).multipliedBy(0.8)
            make.centerY.equalTo(self.imageView.snp.centerY).offset(-20)
        }
        self.count.textAlignment = .center
        self.backgroundColor = UIColor.white
        self.signLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.imageView.snp.centerX)
            make.width.equalTo(self.imageView.snp.width).multipliedBy(0.8)
            make.top.equalTo(self.count.snp.bottom).offset(6)
        }
        self.signLabel.textAlignment = .center
        let width = (frame.width - (self.imageView.max_X + 10) - 20) / 2.0
        let height = (frame.height - 30) / 2.0
        self.btn1.frame = CGRect.init(x: self.imageView.max_X + 10, y: 10, width: width, height: height)
        self.btn2.frame = CGRect.init(x: self.btn1.max_X + 15, y: 10, width: width, height: height)
        self.btn3.frame = CGRect.init(x: self.imageView.max_X + 10, y: self.btn1.max_Y + 10, width: width, height: height)
        self.btn4.frame = CGRect.init(x: self.btn1.max_X + 15, y: self.btn1.max_Y + 10, width: width, height: height)
        self.addSubview(self.btn1)
        self.addSubview(self.btn2)
        self.addSubview(self.btn3)
        self.addSubview(self.btn4)
        
        
        if subTitle1 != nil {
            self.btn1.isHidden = false
            self.btn1.subTitleLabel.text = subTitle1
        }
        if subTitle2 != nil {
            self.btn2.isHidden = false
            self.btn2.subTitleLabel.text = subTitle2
        }
        if subTitle3 != nil {
            self.btn3.isHidden = false
            self.btn3.subTitleLabel.text = subTitle3
        }
        if subTitle4 != nil {
            self.btn4.isHidden = false
            self.btn4.subTitleLabel.text = subTitle4
        }
        
    }
    let count = UILabel.configlabel(font: GDFont.systemFont(ofSize: 25), textColor: UIColor.colorWithHexStringSwift("ff7d09"), text: "72")
    let signLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("323232"), text: "shop_sign_num"|?|)
    let imageView = UIImageView.init(image: UIImage.init(named: "circularBig"))
    let btn1 = CustomSignBtn.init(frame: CGRect.zero, title: "2", subTitle: "chaoshiSign"|?|, isCanClick: false)
    let btn2 = CustomSignBtn.init(frame: CGRect.zero, title: "2", subTitle: "chaoshiSign"|?|, isCanClick: false)
    let btn3 = CustomSignBtn.init(frame: CGRect.zero, title: "2", subTitle: "chaoshiSign"|?|, isCanClick: false)
    let btn4 = CustomSignBtn.init(frame: CGRect.zero, title: "2", subTitle: "chaoshiSign"|?|, isCanClick: false)
    
    var btn1Hidden: Bool = false {
        didSet {
            self.btn1.imageView.isHidden = btn1Hidden
            self.btn1.isUserInteractionEnabled = !btn1Hidden
        }
    }
    var btn2Hidden: Bool = false {
        didSet {
            self.btn2.imageView.isHidden = btn2Hidden
            self.btn2.isUserInteractionEnabled = !btn2Hidden
        }
    }
    var btn4Hidden: Bool = false {
        didSet {
            self.btn4.imageView.isHidden = btn4Hidden
            self.btn4.isUserInteractionEnabled = !btn4Hidden
        }
    }
    var btn3Hidden: Bool = false {
        didSet {
            self.btn3.imageView.isHidden = btn3Hidden
            self.btn3.isUserInteractionEnabled = !btn3Hidden
        }
    }
    
    
    var countStr: String? {
        didSet{
            self.count.text = countStr
        }
    }
    var signStr: String? {
        didSet{
            self.signLabel.text = signStr
        }
    }
    
    
    var btn1Title: String? {
        didSet{
            self.btn1.titleLabel.text = btn1Title
            if btn1Title == "0" {
                self.btn1.imageView.isHidden = true
                self.btn1.isUserInteractionEnabled = false
            }
            else {
                if btn1.defaultHidden {
                    self.btn1.isUserInteractionEnabled = false
                    self.btn1.imageView.isHidden = true
                }else {
                    self.btn1.isUserInteractionEnabled = true
                    self.btn1.imageView.isHidden = false
                }
                
            }
        }
    }
    var btn1SubTitle: String? {
        didSet{
            self.btn1.subTitleLabel.text = btn1SubTitle
        }
    }
    var btn2Title: String? {
        didSet{
            self.btn2.titleLabel.text = btn2Title
            if btn2Title == "0" {
                self.btn2.imageView.isHidden = true
                self.btn2.isUserInteractionEnabled = false
            }
            else {
                if btn2.defaultHidden {
                    self.btn2.isUserInteractionEnabled = false
                    self.btn2.imageView.isHidden = true
                }else {
                    self.btn2.isUserInteractionEnabled = true
                    self.btn2.imageView.isHidden = false
                }
                
            }
        }
    }
    var btn2SubTitle: String? {
        didSet{
            self.btn2.subTitleLabel.text = btn2SubTitle
        }
    }
    
    var btn3Title: String? {
        didSet{
            self.btn3.titleLabel.text = btn3Title
            
            if btn3Title == "0" {
                self.btn3.imageView.isHidden = true
                self.btn3.isUserInteractionEnabled = false
            }
            else {
                if btn3.defaultHidden {
                    self.btn3.isUserInteractionEnabled = false
                    self.btn3.imageView.isHidden = true
                }else {
                    self.btn3.isUserInteractionEnabled = true
                    self.btn3.imageView.isHidden = false
                }
                
            }
        }
    }
    var btn3SubTitle: String? {
        didSet{
            self.btn3.subTitleLabel.text = btn3SubTitle
        }
    }
    var btn4Title: String? {
        didSet{
            self.btn4.titleLabel.text = btn4Title
            if btn4Title == "0" {
                self.btn4.imageView.isHidden = true
                self.btn4.isUserInteractionEnabled = false
            }
            else {
                if btn4.defaultHidden {
                    self.btn4.isUserInteractionEnabled = false
                    self.btn4.imageView.isHidden = true
                }else {
                    self.btn4.isUserInteractionEnabled = true
                    self.btn4.imageView.isHidden = false
                }
                
            }
        }
    }
    var btn4SubTitle: String? {
        didSet{
            self.btn4.subTitleLabel.text = btn4SubTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
class CustomSignBtn: UIControl {
    var defaultHidden: Bool = true {
        didSet {
            self.imageView.isHidden = defaultHidden
        }
    }
    init(frame: CGRect, title: String, subTitle: String, isCanClick: Bool) {
        super.init(frame: frame)
        self.isHidden = true
        self.backgroundColor = UIColor.white
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.imageView)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(3)
        }
        self.titleLabel.textAlignment = .center
        self.subTitleLabel.textAlignment = .center
        self.subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            
        }
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.subTitleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-5)
        }
        self.isUserInteractionEnabled = !isCanClick
        self.imageView.isHidden = isCanClick
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
    let titleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 18), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    let subTitleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    let imageView = UIImageView.init(image: UIImage.init(named: "returnhsk"))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




