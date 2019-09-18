//
//  SignRepairCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class SignRepairCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createAt = self.lastTime
        self.teamName = "allBussiness"|?|
        self.request(team_id: self.teamID, create_at: self.lastTime)
        self.createTime = self.lastTimeType2
        
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.contentView.addSubview(self.bussiness)
        self.contentView.addSubview(self.time)
        self.time.title.text = self.lastTimeType2
        self.bussiness.title.text = "allPari"|?|
        
        self.time.frame = CGRect.init(x: 0, y: 15, width: frame.width, height: 44)
        self.bussiness.frame = CGRect.init(x: 0, y: self.time.max_Y, width: frame.width, height: 44)
        let memberView = self.configTuPianGuiFan(title: "signData"|?|)
        self.contentView.addSubview(memberView)
        memberView.frame = CGRect.init(x: 0, y: self.bussiness.max_Y + 10, width: frame.width, height: 44)
        let subHeight = (frame.height - 198 - 30) / 2.0
        let subView1Frame = CGRect.init(x: 0, y: memberView.max_Y + 1, width: frame.width, height: subHeight > 150 ? 150:subHeight)
        self.subView1 = SignSubView.init(frame: subView1Frame, subTitle1: "chaoshiSign"|?|, subTitle2: "weidabiao"|?|, subTitle3: "weiqiandao"|?|, subTitle4: "zaotui"|?|)
        self.addSubview(self.subView1)
        let memberView2 = self.configTuPianGuiFan(title: "pingfen_qingkuang"|?|)
        self.addSubview(memberView2)
        memberView2.frame = CGRect.init(x: 0, y: self.subView1.max_Y + 10, width: frame.width, height: 44)
        let subView2Frame = CGRect.init(x: 0, y: memberView2.max_Y + 1, width: frame.width, height: subHeight > 150 ? 150: subHeight)
        self.subView2 = SignSubView.init(frame: subView2Frame, subTitle1: "haoping"|?|, subTitle2: "zhongping"|?|, subTitle3: "chaping"|?|, subTitle4: "chapinglv"|?|)
        self.addSubview(self.subView2)
        
        
        self.subView1.countStr = "0"
        self.subView1.signStr = "all_sign_member"|?|
        self.subView1.btn1.defaultHidden = false
        self.subView1.btn2.defaultHidden = false
        self.subView1.btn3.defaultHidden = false
        self.subView1.btn4.defaultHidden = false
        self.subView2.btn2.defaultHidden = false
        self.subView2.btn3.defaultHidden = false
        
        self.subView2.countStr = "0"
        self.subView2.signStr = "zongpingjia"|?|
        self.subView2.btn1Hidden = true
        self.subView2.btn2Hidden = false
        self.subView2.btn3Hidden = false
        self.subView2.btn4Hidden = true
        self.subView1.btn1.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView1.btn2.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView1.btn3.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView1.btn4.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView2.btn2.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView2.btn3.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)
        self.subView2.btn4.addTarget(self, action: #selector(controlClick(sender:)), for: UIControl.Event.touchUpInside)

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
                self.subView2.count.text = data.total_evaluate_number ?? "0"
                self.subView2.btn1Title = data.good_evaluate_number ?? "0"
                self.subView2.btn2Title = (data.middle_evaluate_number ?? "0")
                self.subView2.btn3Title = data.bad_evaluate_number ?? "0"
                self.subView2.btn4Title = (data.bad_evaluate_rate ?? "0") + "%"
                self.model = data
                self.bussiness.title.text = data.team_name
                self.teamName = data.team_name ?? ""
                
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
    var teamID: String = "maintain" {
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
        case self.subView2.btn2:
            self.detailClick?((SignDataType.action5, self.teamID, self.createAt, self.teamName, self.createTime,self.model?.middle_evaluate_number ?? ""))
        case self.subView2.btn3:
            self.detailClick?((SignDataType.action6, self.teamID, self.createAt, self.teamName, self.createTime,self.model?.bad_evaluate_number ?? ""))
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
    
}
