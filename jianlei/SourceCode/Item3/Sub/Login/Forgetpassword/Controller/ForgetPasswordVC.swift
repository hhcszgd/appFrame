//
//  ForgetPasswordVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
enum ForgetPasswordViewType: String {
    ///忘記密碼
    case forgetPass = "忘記密碼"
    ///修改聯繫方式
    case changeContactMobile = "修改聯繫方式"
    ///修改密碼
    case changePassword = "修改密碼"
    ///设置提现密码
    case setWithDraw = "提现密码"
    
}
class ForgetPasswordVC: DDInternalVC, UITextFieldDelegate, CustomBtnProtocol {

    ///修改聯繫方式之後的回調
    var finishChangeContactMobile: ((String) -> ())?
    ///修改聯繫方式的提示
    @IBOutlet weak var changePhonePrompt: UILabel!
    ///发送验证码的类型。1.注册，2找回密码 3, 其他(修改聯繫方式)。
    var vergionType: Int = 0
    var viewType: ForgetPasswordViewType = .forgetPass
    override func viewDidLoad() {
        super.viewDidLoad()
        if DDDevice.type == .iPhone4 {
            self.backScrollView.isScrollEnabled = true
        }
        switch self.viewType {
        case .forgetPass:
            self.changePhonePrompt.isHidden = true
             self.naviBar.title = "profile_resetPassword_title"|?|
            self.vergionType = 2
        case .changePassword:
            self.changePhonePrompt.isHidden = true
             self.naviBar.title = "profile_resetPassword_title"|?|
            self.vergionType = 3
            self.phoneCode.isEnabled = false
        case .changeContactMobile:
            self.changePhonePrompt.isHidden = false
             self.naviBar.title = "changeContactMobileTilte"|?|
            self.password.placeholder = "enterOriginPassword"|?|
            self.resetBtn.setTitle("shopInfoSureChange"|?|, for: UIControl.State.normal)
            self.vergionType = 3
        case .setWithDraw:
            self.changePhonePrompt.isHidden = true
            self.naviBar.title = "profile_setWithPassword"|?|
            self.vergionType = 3
            self.phoneCode.isEnabled = false
            self.phone = DDAccount.share.mobile ?? ""
        }
        self.gdAddSubViews()
        self.verificationBtn.phoneCode = self.phonoCodeStr
        // Do any additional setup after loading the view.
    }
    lazy var phoneCode: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 34), lineColor: "cccccc")
        
        btn.myTitleColor = ("323232", .normal)
        btn.titleFont = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    @IBOutlet var registerName: UITextField!
    
    @IBOutlet var registerVergion: UITextField!
    
    @IBOutlet var password: UITextField!

    let bag = DisposeBag()
    var phone: String = "" {
        didSet{
            self.registerName.text = phone
        }
    }
    var mobile: String = ""
    var vergion: String = ""
    var passwordStr : String = ""
    func gdAddSubViews() {
        
       
        self.Top.constant = DDNavigationBarHeight + 10

        self.view.layoutIfNeeded()
        self.leftView(textField: self.registerVergion)
        self.leftView(textField: self.password)
        self.registerName.adLeftView(leftView: UIView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44)))
        self.backScrollView.addSubview(self.phoneCode)
        self.phoneCode.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.registerName.snp.centerY)
            make.left.equalTo(self.registerName.snp.left)
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
        self.phoneCode.delegate = self
        if self.viewType == .changePassword {
            self.registerName.isEnabled = false
            self.registerName.text = DDAccount.share.mobile
            self.phone = DDAccount.share.mobile ?? ""
            self.verificationBtn.phone = self.phone
        }else {
            let _ = self.registerName.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
                self?.phone = text
                self?.verificationBtn.phone = text
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        }
        
        
        let _ = self.registerVergion.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.vergion = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)

        let _ = self.password.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.passwordStr = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
       
        self.registerVergion.delegate = self
        self.registerName.delegate = self
        self.password.delegate = self
        
        
        
        let resetBtnBackImage = UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffcd34"), UIColor.colorWithHexStringSwift("ffab34")], bound: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 60, height: 45))
        self.resetBtn.setBackgroundImage(resetBtnBackImage, for: UIControl.State.normal)
        self.resetBtn.layer.masksToBounds = true
        self.resetBtn.layer.cornerRadius = 22.5
        
//        self.registerVergion.addSubview(self.verificationBtn)
        self.backScrollView.addSubview(self.verificationBtn)
        self.verificationBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.registerVergion.snp.right).offset(-20)
            make.top.equalTo(self.registerVergion.snp.top).offset(10)
            make.bottom.equalTo(self.registerVergion.snp.bottom).offset(-10)
            make.width.equalTo(90)
        }
        self.verificationBtn.type = self.vergionType
        self.password.adRightView(rightView: self.subnewPasswordRightBtn)
//        self.verificationBtn.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-13)
//            make.height.equalTo(30)
//            make.width.equalTo(90)
//            
//        }
        
    }
    func sendValue(paramete: AnyObject?) {
        if let code = paramete as? String {
            self.phonoCodeStr = code
            self.phoneCode.myTitle = (code, .normal)
            self.verificationBtn.phoneCode = code
        }
    }
    var phonoCodeStr: String = staticPhoneCode
    @IBAction func keyboardHidden(_ sender: UITapGestureRecognizer) {
        self.registerName.resignFirstResponder()
        self.registerVergion.resignFirstResponder()
        self.password.resignFirstResponder()
    }
   
    var keyBoardHeight: CGFloat = 280

    @IBOutlet var backScrollView: UIScrollView!

    
    
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
    


 
    lazy var subnewPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "unshow"), for: .normal)
        btn.setImage(UIImage.init(named: "show"), for: .selected)
        btn.addTarget(self, action: #selector(subNewPasswordShowAction(btn:)), for: .touchUpInside)
       
        return btn
    }()
    @objc func subNewPasswordShowAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.password.isSecureTextEntry = !btn.isSelected
        
    }
    
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
    }


    @IBOutlet var Top: NSLayoutConstraint!
    
    



    @IBOutlet var resetBtn: UIButton!


    @IBAction func resetAction(_ sender: UIButton) {
        let onebool = (self.passwordStr.count >= 6) && (self.passwordStr.count <= 12)
        if !onebool {
            GDAlertView.alert("alert_password"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.phonoCodeStr.count == 0 {
            GDAlertView.alert("alert_get_phonoCode"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
      
        var paramete = ["mobile": self.phone, "verify": self.vergion, "password": self.passwordStr, "repeat_password": self.passwordStr, "country_code": self.phonoCodeStr]
//        13269226148
        let id = DDAccount.share.id ?? ""
        var router: Router!
        switch self.viewType {
        case .forgetPass, .changePassword:
            paramete["equipment_number"] = ZKQUUID
            paramete["equipment_type"] = "2"
            router = Router.post("member/password", .api, paramete)
        case .changeContactMobile:
            paramete["token"] = DDAccount.share.token ?? ""
            
            router = Router.put("member/\(id)/mobile", DomainType.api, paramete)
        case .setWithDraw:
            paramete["token"] = DDAccount.share.token ?? ""
            router = Router.post("member/\(id)/payment_password", .api, paramete)
        }
        
        sender.isEnabled = false
        let _ = NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<DDAccount>.self, from: response)
            sender.isEnabled = true
            if model?.status == 200 {
                
                switch self.viewType {
                case .changeContactMobile:
                    self.finishChangeContactMobile?(self.phone)
                    DDAccount.share.mobile = self.phone
                    DDAccount.share.save()
                    self.popToPreviousVC()
                case .changePassword:
                    DDAccount.share.deleteAccountFromDisk()
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                        appDelegate.configRootVC()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
                    self.uploadPushid()
                case .forgetPass:
                    if let account = model?.data {
                        DDAccount.share.setPropertisOfShareBy(otherAccount: account)
                    }
                    self.popToPreviousVC()
                case .setWithDraw:
                    self.popToPreviousVC()
                }
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }) {
            
        }
        
    }
    func uploadPushid() {
        if let jpushID = DDStorgeManager.standard.string(forKey: "JPUSHID"), jpushID != "upload" {
            let id = DDAccount.share.id ?? "0"
            let token = DDAccount.share.token ?? ""
            let parameter = ["token": token, "push_id": jpushID]
            
            let _ = NetWork.manager.requestData(router: Router.put("member/\(id)", .api,parameter ), success: { (response) in
                let model = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response)
                if model?.status == 200 {
                    DDStorgeManager.standard.setValue("upload", forKey: "JPUSHID")
                }
            }) {
                
            }
           
        }

    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
