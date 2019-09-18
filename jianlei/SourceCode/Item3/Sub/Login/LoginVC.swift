//
//  LoginVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//
let ZKQUUID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
import UIKit
import RxSwift
import RxCocoa
class LoginVC: DDInternalVC, UITextFieldDelegate,CustomBtnProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gdAddSubViews()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var backScrollView: UIScrollView!
    
    @IBOutlet var logoTop: NSLayoutConstraint!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var forgetPassword: UIButton!
    @IBOutlet var lognBtn: UIButton!
    @IBOutlet var loginName: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var logoImage: UIImageView!
    
    func gdAddSubViews() {
        if #available(iOS 11.0, *) {
            self.backScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        if DDDevice.type == .iPhone4 {
            self.backScrollView.isScrollEnabled = true
        }
        self.naviBar.isHidden = true
        self.logoTop.constant = DDNavigationBarHeight - 10
        self.view.layoutIfNeeded()
        
        let leftImage = UIImageView.init(image: UIImage.init(named: "login_number"))
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 43))
        leftView.addSubview(leftImage)
        leftImage.contentMode = .center
        leftImage.frame = CGRect.init(x: 0, y: 0, width: 20, height: 43)
        self.loginName.adLeftView(leftView: leftView)
        self.backScrollView.addSubview(self.phoneCode)
        self.phoneCode.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.loginName.snp.centerY)
            make.left.equalTo(self.loginName.snp.left).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        self.phoneCode.delegate = self
        let passwordImage = UIImageView.init(image: UIImage.init(named: "login_password"))
        passwordImage.contentMode = UIView.ContentMode.center
        passwordImage.frame = CGRect.init(x: 0, y: 0, width: 20, height: 44)
        self.loginPassword.adLeftView(leftView: passwordImage)
        self.loginPassword.adRightView(rightView: self.showButton)
        self.loginPassword.isSecureTextEntry = true
        let placeColor = UIColor.colorWithHexStringSwift("cccccc")
//        self.loginName.setValue(placeColor, forKeyPath: "_placeholderLabel.textColor")
//        self.loginPassword.setValue(placeColor, forKeyPath: "_placeholderLabel.textColor")
        self.naviBar.backBtn.isHidden = true
        
        
        let _ = self.loginName.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.userName = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        let _ = self.loginPassword.rx.text.orEmpty.subscribe(onNext: { [weak self](text) in
            self?.password = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
//
        self.loginName.delegate = self
        self.loginPassword.delegate = self
        self.loginName.keyboardType = UIKeyboardType.numberPad
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
        self.loginName.addBottomLine(lineView: lineView)
        let passwordLineView = UIView.init()
        passwordLineView.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
        self.loginPassword.addBottomLine(lineView: passwordLineView)
        let loginBackImage = UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffcd34"), UIColor.colorWithHexStringSwift("ffab34")], bound: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 60, height: 45))
        self.lognBtn.setBackgroundImage(loginBackImage, for: UIControl.State.normal)
        self.lognBtn.layer.masksToBounds = true
        self.lognBtn.layer.cornerRadius = 22.5
        
    }
    func sendValue(paramete: AnyObject?) {
        if let code = paramete as? String {
            self.phonoCodeStr = code
            self.phoneCode.myTitle = (code, .normal)
        }
    }
    var phonoCodeStr: String = staticPhoneCode
    
    lazy var phoneCode: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 34), lineColor: "cccccc")
        btn.myTitleColor = ("323232", .normal)
        
        btn.titleFont = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    deinit {
        mylog("销毁")
    }
    
    @IBAction func keyBoardHidden(_ sender: UITapGestureRecognizer) {
        self.loginName.resignFirstResponder()
        self.loginPassword.resignFirstResponder()
    }
    
    
   
    let bag = DisposeBag()
    var userName: String = ""
    var password: String = ""
    lazy var leftView: UIView = {[weak self] in
        let view = UIView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 5, height: 40)
        self?.loginPassword.leftView = view
        
        return view
    }()
    @objc func phoneCodeAction(btn: UIButton) {
        
    }
    
    lazy var showButton: UIButton = {
        let showBtn = UIButton.init(type: UIButton.ButtonType.custom)
        showBtn.setImage(UIImage.init(named: "unshow"), for: .normal)
        showBtn.setImage(UIImage.init(named: "show"), for: .selected)
        showBtn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        showBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        return showBtn
        
    }()
    
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.loginPassword.isSecureTextEntry = !btn.isSelected
    }
    

    class LoginModel : Codable {
        var token: String?
        var id: String?
    }
    @IBAction func loginBtnAction(_ sender: UIButton) {
        //判断电话号码是否正确
        if !self.userName.mobileLawful() {
            GDAlertView.alert("账号格式不正确", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.password.passwordLawful() {
            GDAlertView.alert("密码格式不正确", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.phonoCodeStr.count == 0 {
            GDAlertView.alert("alert_get_phonoCode"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.userName == "17600905015" {
            self.phonoCodeStr = "+86"
        }
        
        
        let jpushID = DDStorgeManager.standard.string(forKey: "JPUSHID") ?? "123456"
        let paramete = ["mobile": self.userName, "password": self.password, "equipment_number": ZKQUUID, "equipment_type": "2", "push_id": jpushID, "country_code": self.phonoCodeStr]
        ZkqAlert.share.activeAlert.startAnimating()
        sender.isEnabled = false
        let router = Router.post("member/login", DomainType.api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<LoginModel>.self, from: response)
            ZkqAlert.share.activeAlert.stopAnimating()
            sender.isEnabled = true
            if model?.status == 200 {
                DDAccount.share.mobile = self.userName
                DDAccount.share.id = model?.data?.id ?? ""
                DDAccount.share.token = model?.data?.token ?? ""
                DDAccount.share.save()
                NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
            }
            GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
        }) {
            sender.isEnabled = true
            GDAlertView.alert("server_connect_failure"|?|, image: nil, time: 1, complateBlock: nil)
            ZkqAlert.share.activeAlert.stopAnimating()
        }
        
        
        
        
        
        
    }
    @IBAction func forgetPasswordAction(_ sender: UIButton) {
        let vc = ForgetPasswordVC()
        vc.vergionType = 2
        vc.viewType = .forgetPass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func registerAction(_ sender: UIButton) {
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
//
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
