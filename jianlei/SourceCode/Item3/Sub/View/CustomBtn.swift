//
//  CustomBtn.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/9/10.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
@objc protocol CustomBtnProtocol: NSObjectProtocol {
    @objc optional func sendValue(paramete: AnyObject?)
    
}
enum CustomBtnType: String {
    case verficationBtn = "獲取驗證碼按鈕"
    
}

class CustomBtn: UIButton {
    ///创建区号按钮
    convenience init(frame: CGRect, lineColor: String) {
        self.init(frame: frame)
//        let lineView = UIView.init()
//        self.addSubview(lineView)
//        lineView.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-5)
//            make.centerY.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.7)
//            make.width.equalTo(1)
//        }
       
        self.setImage(UIImage.init(named: "profile_arrow"), for: UIControl.State.normal)
        self.setTitle(staticPhoneCode, for: UIControl.State.normal)
        self.phoneCode = staticPhoneCode
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: -30)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
        
        self.titleFont = UIFont.systemFont(ofSize: 14)
        self.myTitle = (nil, .normal)
        self.myTitleColor = ("323232", .normal)
        self.backgroundColor = UIColor.white
//        lineView.backgroundColor = UIColor.colorWithHexStringSwift(lineColor)
        self.addTarget(self, action: #selector(selectPhoneCode(sender:)), for: UIControl.Event.touchUpInside)
        
        
        
    }
    var alterView: MyAlertView?
    var phoneArr: [PhoneCodeModel] = []
    weak var delegate: CustomBtnProtocol?
    @objc func selectPhoneCode(sender: CustomBtn) {
        if let phoneCodeStr = UserDefaults.standard.object(forKey: "phoneCode") as? String {
            let data = phoneCodeStr.data(using: String.Encoding.utf8)
            do{
                let jsonDecoder = JSONDecoder.init()
                let t = try jsonDecoder.decode(ApiModel<[PhoneCodeModel]>.self, from: data ?? Data.init())
                if let arr = t.data {
                    self.phoneArr = arr
                    
                    
                }
            }catch{
                
            }
            
            
            
            
        }
        if self.alterView == nil {
            self.alterView = MyAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENWIDTH), actions: nil)
            alterView?.phoneCodeArr = self.phoneArr
            alterView?.selectPhoneCodeFinished = { [weak self] (code) in
                self?.finishedSelectCode(code: code)
                staticPhoneCode = code
                self?.phoneCode = code
                self?.alterView = nil
            }
            alterView?.deinitHandle = { [weak self] in
                self?.alterView = nil
            }
            UIApplication.shared.keyWindow?.alertZkq(alterView!)
            
        }
        
        
        
        sender.isEnabled = false
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("system/get-area-code", DomainType.api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            sender.isEnabled = true
            if let phoneCodeStr = UserDefaults.standard.object(forKey: "phoneCode") as? String {
                let newPhoneCodeStr = String.init(data: response.data ?? Data.init(), encoding: String.Encoding.utf8)
                if phoneCodeStr != newPhoneCodeStr {
                    UserDefaults.standard.set(newPhoneCodeStr ?? "", forKey: "phoneCode")
                }else {
                    self.alterView?.phoneCodeArr = self.phoneArr
                    return
                    
                }
            }
            
            
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<[PhoneCodeModel]>.self, from: response)
            let newPhoneCodeStr = String.init(data: response.data ?? Data.init(), encoding: String.Encoding.utf8)
            UserDefaults.standard.set(newPhoneCodeStr ?? "", forKey: "phoneCode")
            if let arr = model?.data {
                self.phoneArr = arr
                self.alterView?.phoneCodeArr = arr
            }
            
        }) {
            sender.isEnabled = true
        }
        
        
    }
    ///选择完手机区号的时候
    func finishedSelectCode(code: String) {
        self.delegate?.sendValue?(paramete: code as AnyObject)
    }
    override init(frame: CGRect) {
        super.init(frame: frame )
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let lineView = UIView.init()
        self.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        self.addSubview(lineView)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        lineView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(1)
        }
        
        self.setImage(UIImage.init(named: "profile_arrow"), for: UIControl.State.normal)
        self.setTitle(staticPhoneCode, for: UIControl.State.normal)
        self.phoneCode = staticPhoneCode
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 33, bottom: 0, right: -33)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
        
        self.titleFont = UIFont.systemFont(ofSize: 14)
        self.myTitle = (nil, .normal)
        self.myTitleColor = ("323232", .normal)
        self.backgroundColor = UIColor.white
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("999999")
        self.addTarget(self, action: #selector(selectPhoneCode(sender:)), for: UIControl.Event.touchUpInside)
        
    }
    //MARK:創建獲取驗證碼接口
    ///type：1，註冊，2，找回密碼， 3其他
    convenience init(frame: CGRect, customBtnType: CustomBtnType, type: Int) {
        self.init(frame: frame)
        switch customBtnType {
        case .verficationBtn:
            self.addTarget(self, action: #selector(verficationActin(btn:)), for: UIControl.Event.touchUpInside)
            self.type = type
            self.backgroundColor = UIColor.colorWithHexStringSwift("ffab34")
            self.layer.cornerRadius = 6
           
            
        }
        
    }
    var type: Int = 0
    ///倒計時剩餘時間
    var leftTime: Int = 60
    ///電話號碼
    var phone: String = ""
    ///計時器類
    var timer: Timer?
    ///國家地區碼
    var phoneCode: String = ""
    @objc func verficationActin(btn: CustomBtn) {
        if self.leftTime != 60 {
            GDAlertView.alert("正在倒計時，請等待", image: nil, time: 1, complateBlock: nil)
            return
        }
        
//        if self.phoneCode.count == 0 {
//            GDAlertView.alert("alert_get_phonoCode"|?|, image: nil, time: 1, complateBlock: nil)
//            return
//        }
        
        if !self.phone.mobileLawful() {
            GDAlertView.alert("alert_register_phone_error"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        
        
        btn.isEnabled = false
        self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        NetWork.manager.getPublicKey { (key) in
            if key.count > 0 {
                self.getVerfication(key: key)
            }else {
                btn.isEnabled = true
            }
            
            
        }
        
        
        
        
        
    }
    ///倒計時方法
    @objc func countDown() {
        
        if self.leftTime >= 1 {
            leftTime -= 1
        }
        if self.leftTime < 1 {
            self.leftTime = 60
            self.isEnabled = true
            self.timer?.invalidate()
        }
        let count = String(self.leftTime) + "s后再發送"
        self.myTitle = (count, .disabled)
        //请求二维码的接口
        
    }
    deinit {
        mylog("XXXXXXXXXXXXXXXXXXXXXXX銷毀")
        self.timer?.invalidate()
        self.timer = nil
    }
    func getVerfication(key: String) {
        
        let paramete = ["mobile": self.phone, "device_number": ZKQUUID, "public_key": key] as [String : Any]
        let router = Router.get("system/verify", .api, paramete)
        let _ = NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response)
            if model?.status == 200 {
                if let timer = self.timer {
                    RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
                }
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                
            }else {
                self.isEnabled = true
                self.leftTime = 60
                self.timer?.invalidate()
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                
            }
        }) {
            self.isEnabled = true
        }
    }
    
    
    
    
    
    
    ///设置标题
    var myTitle:(String?, UIControl.State) = ("", UIControl.State.normal) {
        didSet{
            self.setTitle(myTitle.0, for: myTitle.1)
        }
    }
    ///设置标题颜色
    var myTitleColor:(String, UIControl.State) = ("", UIControl.State.normal) {
        didSet{
            self.setTitleColor(UIColor.colorWithHexStringSwift(myTitleColor.0), for: myTitleColor.1)
        }
    }
    var titleFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet{
            self.titleLabel?.font = titleFont
        }
    }
    
}
