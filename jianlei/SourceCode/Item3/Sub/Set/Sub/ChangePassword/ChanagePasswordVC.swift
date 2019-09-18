//
//  ChanagePasswordVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/19.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ChanagePasswordVC: DDInternalVC, UITextFieldDelegate {

    let bag = DisposeBag()
    var phone: String = ""
    var vergion: String = ""
    var passwordStr : String = ""
    var againpasswordStr: String = ""
    func gdAddSubViews() {
        if DDDevice.type == .iPhone4 {
            self.backScrollView.isScrollEnabled = true
        }
        
        
//        self.Top.constant = (DDDevice.type == .iphoneX) ? 108 : 84
        self.Top.constant = DDDevice.isFullScreen ? 108 : 84
        self.lineView(textField: self.registerName)
        self.lineView(textField: self.registerVergion)
        self.lineView(textField: self.jobNumber)
        self.lineView(textField: self.password)
        self.view.layoutIfNeeded()
        self.registerName.leftViewMode = .always
        self.registerName.leftView = self.phoneCode
        
        self.leftView(textField: self.registerVergion)
        self.leftView(textField: self.jobNumber)
        self.leftView(textField: self.password)
        self.resetBtn.setTitle("确定修改", for: .normal)
        
        self.registerVergion.rightView = self.verificationBtn
        self.registerVergion.rightViewMode = .always
        self.registerName.isEnabled = false
        self.verificationBtn.type = 3
//        let _ = self.registerName.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
//            self?.phone = text
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        let _ = self.registerVergion.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.vergion = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        let _ = self.jobNumber.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.passwordStr = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        let _ = self.password.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.againpasswordStr = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)

        self.registerName.delegate = self
        self.registerName.delegate = self
        self.jobNumber.delegate = self
        self.password.delegate = self
        self.registerName.isEnabled = false
        if let mobile = DDAccount.share.mobile {
            self.phone = mobile
            self.registerName.text = mobile.prefixphone()
        }
        
        
        
        
        
        
        
        
        
    }
    @IBOutlet var backScrollView: UIScrollView!
    
    
    @IBAction func keyboardHidden(_ sender: UITapGestureRecognizer) {
        self.registerName.resignFirstResponder()
        self.registerVergion.resignFirstResponder()
        self.jobNumber.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyBoardY: CGFloat = SCREENHEIGHT - (self.keyBoardHeight)
        if self.registerVergion.isFirstResponder {
            let Y: CGFloat = self.jobNumber.convert(self.jobNumber.bounds, to: self.view).origin.y + self.jobNumber.bounds.size.height
            if Y > keyBoardY {
                let move = Y - keyBoardY
                mylog(move)
                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
            }
            
            
        }
        
        if self.jobNumber.isFirstResponder {
            let Y: CGFloat = self.password.convert(self.password.bounds, to: self.view).origin.y + self.password.bounds.size.height
            if Y > keyBoardY {
                let move = Y - self.keyBoardHeight
                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
            }
        }
        
        if self.password.isFirstResponder {
            let Y: CGFloat = self.password.convert(self.password.bounds, to: self.view).origin.y + self.password.bounds.size.height
            if Y > keyBoardY {
                let move = Y - self.keyBoardHeight
                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
            }
        }
        
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    var keyBoardHeight: CGFloat = 280
    
    @objc func keyboardWillHidden(notification: Notification) {
        
        self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
    }
    
    @objc func phoneCodeAction(btn: UIButton) {
        
    }
    ///获取手机区号
    lazy var phoneCode: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("+86", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        let rightlineView = UIView.init()
        rightlineView.backgroundColor = lineColor
        btn.addSubview(rightlineView)
        rightlineView.frame = CGRect.init(x: 45, y: 10, width: 1, height: 30)
        
        btn.addTarget(self, action: #selector(phoneCodeAction(btn:)), for: .touchUpInside)
        return btn
    }()
    
    func lineView(textField: UITextField) {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithRGB(red: 203, green: 203, blue: 203)
        textField.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    func leftView(textField: UITextField) {
        textField.leftViewMode = .always
        let view = UIView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 5, height: 5)
        textField.leftView = view
    }
    lazy var verificationBtn: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: 0, width: 122, height: 34), customBtnType: CustomBtnType.verficationBtn, type: 1)
        btn.myTitle = ("profile_register_verification"|?|, .normal)
        btn.titleFont = UIFont.systemFont(ofSize: 13)
        btn.myTitleColor = ("ffffff", .normal)
        return btn
    }()
    
    lazy var newPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        btn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        btn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        
        return btn
    }()
    lazy var subnewPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        btn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        btn.addTarget(self, action: #selector(subNewPasswordShowAction(btn:)), for: .touchUpInside)
        
        return btn
    }()
    @objc func subNewPasswordShowAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
    }
    
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
    }
    
    
    @IBOutlet var Top: NSLayoutConstraint!
    @IBOutlet var registerName: UITextField!
    
    @IBOutlet var registerVergion: UITextField!
    
    @IBOutlet var jobNumber: UITextField!
    @IBOutlet var password: UITextField!
    
    
    
    @IBOutlet var resetBtn: UIButton!
    
    
    @IBAction func resetAction(_ sender: UIButton) {
        let onebool = self.passwordStr.passwordLawful()
        let twoBool = self.againpasswordStr.passwordLawful()
        if !onebool {
            GDAlertView.alert("密码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !twoBool {
            GDAlertView.alert("确认密码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !(self.passwordStr == self.againpasswordStr) {
            GDAlertView.alert("两次密码输入不一致", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        let paramete = ["mobile": self.phone, "verify": self.vergion, "password": self.passwordStr, "repeat_password": self.againpasswordStr, "equipment_number": ZKQUUID, "equipment_type": "2"]
//        let _ = NetWork.manager.requestData(router: Router.post("member/password", .api, paramete)).subscribe(onNext: { (dict) in
//            let model = BaseModel<DDAccount>.deserialize(from: dict)
//            if model?.status == 200 {
////                if let account = model?.data {
////                    DDAccount.share.setPropertisOfShareBy(otherAccount: account)
////                }
//                ///修改密码成功后重新登录
//                DDAccount.share.deleteAccountFromDisk()
//                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
//                    appDelegate.configRootVC()
//                }
//                
////                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
////                NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
////                self.uploadPushid()
//            }else {
//                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
//            }
////            let model = BaseModel<GDModel>.deserialize(from: dict)
////            if model?.status == 200 {
////                self.navigationController?.popViewController(animated: true)
////
////            }else {
////                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
////
////            }
//        }, onError: { (error) in
//        }, onCompleted: {
//            mylog("结束")
//        }) {
//            mylog("回收")
//        }
    }

}
