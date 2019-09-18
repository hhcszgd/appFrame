//
//  RegisterVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class RegisterVC: DDInternalVC, UITextFieldDelegate,CustomBtnProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gdAddSubViews()
        if DDDevice.type == .iPhone4 {
            self.backScrollView.isScrollEnabled = true
        }
//        self.verificationBtn.phoneCode = self.phoneCodeStr
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var top: NSLayoutConstraint!
    
    func gdAddSubViews() {
        if #available(iOS 11.0, *) {
            self.backScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.naviBar.backgroundColor = UIColor.white
        self.naviBar.title = "profile_register_title"|?|
        
        self.top.constant = DDNavigationBarHeight + 10
        self.registerPasswordRightBtn.backgroundColor = UIColor.clear
        
        self.registerName.adLeftView(leftView: UIView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44)))
        self.backScrollView.addSubview(self.phoneCode)
        self.phoneCode.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.registerName.snp.centerY)
            make.left.equalTo(self.registerName.snp.left)
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
        //MARK:选择完成手机区号码
        self.phoneCode.delegate = self
        
        
        self.registerVergion.adLeftView(leftView: self.createView())
        self.password.adLeftView(leftView: self.createView())
//        self.registerVergion.addSubview(self.verificationBtn)
        self.backScrollView.addSubview(self.verificationBtn)
        self.verificationBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.registerVergion.snp.right).offset(-20)
            make.top.equalTo(self.registerVergion.snp.top).offset(5)
            make.bottom.equalTo(self.registerVergion.snp.bottom).offset(-5)
            make.width.equalTo(90)
        }
        self.password.adRightView(rightView: self.registerPasswordRightBtn)
//        self.verificationBtn.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-13)
//            make.height.equalTo(30)
//            make.width.equalTo(90)
//
//        }

        let _ = self.registerName.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.phone = text
            self?.verificationBtn.phone = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        let _ = self.registerVergion.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.vergion = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        self.registerVergion.delegate = self
        
        
        let _ = self.password.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.passwordStr = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
        self.registerName.keyboardType = .numberPad
        self.registerVergion.keyboardType = .numberPad
        self.registerName.delegate = self
        self.registerVergion.delegate = self
        self.password.delegate = self
        let registerBtnBackImage = UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffcd34"), UIColor.colorWithHexStringSwift("ffab34")], bound: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 60, height: 45))
        self.registerBtn.setBackgroundImage(registerBtnBackImage, for: UIControl.State.normal)
        self.registerBtn.layer.masksToBounds = true
        self.registerBtn.layer.cornerRadius = 22.5
        self.view.layoutIfNeeded()

    }
    //MARK:选择手机区号码
    func sendValue(paramete: AnyObject?) {
        if let code = paramete as? String {
//            self.phoneCodeStr = code
            self.phoneCode.myTitle = (code, .normal)
            self.verificationBtn.phoneCode = code
        }
    }
    
    var phone: String = ""
    var vergion: String = ""
    var passwordStr: String = ""

    let bag = DisposeBag()
    lazy var phoneCode: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 45), lineColor: "cccccc")
        btn.myTitleColor = ("323232", .normal)
        btn.titleFont = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    @IBAction func keyboardHidden(_ sender: UITapGestureRecognizer) {
        self.registerName.resignFirstResponder()
        self.registerVergion.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyBoardY: CGFloat = SCREENHEIGHT - (self.keyBoardHeight)
       
        
  
        
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

    
    func createView() -> UIView {
        let view = UIView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 5, height: 20)
        return view
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.verificationBtn.isEnabled = true
    }
    
    func lineView(textField: UITextField) {
        let view = UIView.init()
        view.backgroundColor = lineColor
        textField.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
  
    lazy var verificationBtn: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: 0, width: 122, height: 34), customBtnType: CustomBtnType.verficationBtn, type: 1)
        btn.myTitle = ("profile_register_verification"|?|, .normal)
        btn.titleFont = UIFont.systemFont(ofSize: 13)
        btn.myTitleColor = ("ffffff", .normal)
        
        return btn
    }()


    
    
    lazy var registerPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "unshow"), for: .normal)
        btn.setImage(UIImage.init(named: "show"), for: .selected)
        btn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.password.isSecureTextEntry = !btn.isSelected
    }
    @IBOutlet var backScrollView: UIScrollView!
    
    @IBOutlet var registerName: UITextField!
    
    @IBOutlet var registerVergion: UITextField!
    
    @IBOutlet var password: UITextField!
    

    
//    @IBAction func jianzhi(_ sender: UIButton) {
//        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: DomainType.wap.rawValue + "agreement/concurrent_post_agreement")
//
//    }
//
//    @IBAction func protocolAction(_ sender: UIButton) {
//
//        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: DomainType.wap.rawValue + "agreement/member_agreement")
//
//    }
//
//    @IBAction func privateAction(_ sender: Any) {
//        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: DomainType.wap.rawValue + "agreement/privacy_policy")
//
//
//    }
    //TODO:這裡寫用戶服務協議跳轉頁面
    @IBAction func yongHuFuWuAction(_ sender: UIButton) {
        self.pushVC(vcIdentifier: "BaseWebVC", userInfo: DomainType.wap.rawValue + "agreement/member_agreement")
    }
    @IBOutlet var registerBtn: UIButton!
    @IBAction func selectBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    class PrivateModel: Codable {
        var token: String?
        var id: Int?
    }
    @IBOutlet weak var selectBtn: UIButton!
    @IBAction func regitsterAction(_ sender: UIButton) {
        
        if !self.selectBtn.isSelected {
            GDAlertView.alert("alert_select_protocal"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
//        if self.phoneCodeStr.count == 0 {
//            GDAlertView.alert("alert_get_phonoCode"|?|, image: nil, time: 1, complateBlock: nil)
//            return
//        }
        
        let onebool = (self.passwordStr.count >= 6) && (self.passwordStr.count <= 12)
        
        if !onebool {
            GDAlertView.alert("alert_password"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
         let jpushID = DDStorgeManager.standard.string(forKey: "JPUSHID") ?? "123456"
        
        let paramete = ["mobile": self.phone, "verify": self.vergion, "password": self.passwordStr, "equipment_number": ZKQUUID, "equipment_type": "2", "push_id": jpushID]
        sender.isEnabled = false
        NetWork.manager.requestData(router: Router.post("v1/member/register", .api, paramete), success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<PrivateModel>.self, from: response)
            sender.isEnabled = true
            if model?.status == 200 {
                if let id = model?.data?.id {
                    DDAccount.share.id = String(id)
                }
                
                DDAccount.share.token = model?.data?.token
                DDAccount.share.save()
                NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
                
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }) {
            GDAlertView.alert("alert_networrk_error"|?|, image: nil, time: 1, complateBlock: nil)
        }
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func uploadPushid() {
//        if let jpushID = DDStorgeManager.standard.string(forKey: "JPUSHID"), jpushID != "upload" {
//            let id = DDAccount.share.id ?? ""
//            let token = DDAccount.share.token ?? ""
//            let parameter = ["token": token, "push_id": jpushID]
//            let _ = NetWork.manager.requestData(router: Router.put("member/\(id)", .api,parameter )).subscribe(onNext: { (dict) in
//                let model = BaseModel<GDModel>.deserialize(from: dict)
//                if model?.status == 200 {
//                    DDStorgeManager.standard.setValue("upload", forKey: "JPUSHID")
//                }
//            }, onError: { (error) in
//
//            }, onCompleted: {
//
//            }, onDisposed: {
//
//            })
//        }
//
//    }
    deinit {
        mylog("销毁")
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
