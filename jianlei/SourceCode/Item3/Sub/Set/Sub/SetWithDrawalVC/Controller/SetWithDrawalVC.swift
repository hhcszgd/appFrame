//
//  SetWithDrawalVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/26.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class SetWithDrawalVC: DDInternalVC, UITextFieldDelegate {
    let bag = DisposeBag()
    var phone: String = ""
    var vergion: String = ""
    var passwordStr : String = ""
    var againpasswordStr: String = ""
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        DDAccount.share.refreshAccountInfo()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jobNumber.keyboardType = .numberPad
        self.password.keyboardType = .numberPad
        self.gdAddSubViews()
        
    }
    func gdAddSubViews() {
        if DDDevice.type == .iPhone4 {
            self.backScrollView.isScrollEnabled = true
        }
        
        self.verificationBtn.backgroundColor = UIColor.clear
        
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
        let _ = self.registerName.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.phone = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
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
        
        self.registerName.text = DDAccount.share.mobile ?? ""
        self.registerName.isEnabled = false
        self.phone = DDAccount.share.mobile ?? ""
        
        
        
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
    @objc func keyboardWillShow(notification: Notification) {
        
//        if let keyBoardFrameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? AnyObject, let keyBoardFrame = keyBoardFrameValue.cgRectValue {
//            let keyboardHeight: CGFloat = keyBoardFrame.height
//            self.keyBoardHeight = keyboardHeight
//
//
//        }
    }
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
    
    
    @objc func verficationActin(btn: UIButton) {
        if !self.phone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        btn.isEnabled = false
        
        self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        //请求二维码的接口
//        let paramete = ["mobile": self.phone, "type": 2] as [String : Any]
//        let _ = NetWork.manager.requestData(router: Router.get("verify", .api, paramete)).subscribe(onNext: { (dict) in
//            let model = BaseModel<GDModel>.deserialize(from: dict)
//            if model?.status == 200 {
//                //获取成功
//                if let timer = self.timer {
//                    RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
//                }
//
//            }else {
//                self.timer?.invalidate()
//                self.leftTime = 60
//                self.verificationBtn.isEnabled = true
//                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
//                DDRequestManager.share.getPublickKey(force: true , publicKey: { (publicKey) in
//                     print("xxxxxxxxxxxxxxxx:\(String.init(format: "%@", publicKey ?? ""))")
//                })
//            }
//        }, onError: { (error) in
//            GDAlertView.alert("网络问题，稍后重试", image: nil, time: 1, complateBlock: nil)
//        }, onCompleted: {
//            mylog("结束")
//        }) {
//            mylog("回收")
//        }
        
    }
    var timer: Timer?
    var leftTime: Int = 60
    @objc func countDown() {
        
        if self.leftTime >= 1 {
            leftTime -= 1
        }
        if self.leftTime < 1 {
            self.leftTime = 60
            self.verificationBtn.isEnabled = true
            self.timer?.invalidate()
        }
        
        let count = String(self.leftTime) + "秒后重新发送"
        
        self.verificationBtn.setTitle(count, for: .disabled)
        //请求二维码的接口
        
        
    }
    
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
    lazy var verificationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 122, height: 38))
        btn.setTitle("发送验证码", for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .normal)
        let lineview = UIView.init(frame: CGRect.init(x: 0, y: 4, width: 1, height: 30))
        lineview.backgroundColor = UIColor.colorWithRGB(red: 203, green: 203, blue: 203)
        btn.addTarget(self, action: #selector(verficationActin(btn:)), for: .touchUpInside)
        btn.addSubview(lineview)
        
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
        let onebool = self.passwordStr.authoCodeLawful()
        let twoBool = self.againpasswordStr.authoCodeLawful()
        
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
        
//        let id = DDAccount.share.id ?? ""
//        let token = DDAccount.share.token ?? ""
//        let paramete = ["mobile": self.phone, "verify": self.vergion, "password": self.passwordStr, "repeat_password": self.againpasswordStr, "token": token]
//        let _ = NetWork.manager.requestData(router: Router.post("member/\(id)/payment_password", .api, paramete)).subscribe(onNext: { (dict) in
//            let model = BaseModel<GDModel>.deserialize(from: dict)
//            if model?.status == 200 {
//                self.navigationController?.popViewController(animated: true)
//            }else {
//                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
//                
//            }
//        }, onError: { (error) in
//            GDAlertView.alert("网络错误，请稍后重试", image: nil, time: 1, complateBlock: nil)
//        }, onCompleted: {
//            mylog("结束")
//        }) {
//            mylog("回收")
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
