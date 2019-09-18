//
//  CreateTeamVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class CreateTeamVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "team_create"|?|
        
    }
    var teamName: String = ""
    var teamTypeStr: String = ""
    let textField: UITextField = UITextField.init()
    lazy var createBtn: UIButton = {
        let btn = UIButton.init()
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        btn.layer.addSublayer(gradientLayer)
        btn.setTitle("create"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    let teamType = UIView.init()
    lazy var type1Btn: UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("team_bussiness"|?|, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "team_admin_select_type_no"), for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "team_admin_select_type"), for: UIControl.State.selected)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("323232"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(selectTeamType(btn:)), for: UIControl.Event.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    lazy var type2Btn: UIButton = {
        let btn = UIButton.init()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("team_reapire"|?|, for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "team_admin_select_type_no"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("323232"), for: UIControl.State.normal)
        btn.setImage(UIImage.init(named: "team_admin_select_type"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(selectTeamType(btn:)), for: UIControl.Event.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    
    lazy var mySwitch: UISwitch = {
        let btn = UISwitch.init()
        btn.isOn = false
        btn.transform = .init(scaleX: 0.8, y: 0.8)
        
        return btn
    }()
    @objc func switchAction(sender: UISwitch) {
        sender.isOn ? (self.sign_data_permission = "1"): (self.sign_data_permission = "0")
    }
    var sign_data_permission: String = "0"
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CreateTeamVC {
    
    
    
    
    func configUI() {
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.view.addSubview(self.textField)
        self.textField.frame = CGRect.init(x: 0, y: DDNavigationBarHeight + 20, width: SCREENWIDTH, height: 54)
        self.textField.font = GDFont.systemFont(ofSize: 14)
        self.textField.textColor = UIColor.colorWithHexStringSwift("323232")
        self.view.addSubview(self.createBtn)
        
        self.createBtn.layer.masksToBounds = true
        self.createBtn.layer.cornerRadius = 22
        self.textField.placeholder = "team_name_placeholder"|?|
        self.textField.backgroundColor = UIColor.white
        let leftView = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "team_name"|?|)
        leftView.textAlignment = .center
        leftView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
        self.textField.leftViewMode = .always
        self.textField.leftView = leftView
//        self.textField.setValue(UIColor.colorWithHexStringSwift("999999"), forKeyPath: "_placeholderLabel.textColor")
        let _ = self.textField.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.teamName = title
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.view.addSubview(self.teamType)
        self.teamType.backgroundColor = UIColor.white
        self.teamType.frame = CGRect.init(x: 0, y: self.textField.max_Y + 1, width: SCREENWIDTH, height: 54)
        self.configTeamType()
        
        let permission = ShopInfoCell.init(frame: CGRect.init(x: 0, y: self.teamType.max_Y + 1, width: SCREENWIDTH, height: 54), title: "team_check_permission"|?|)
        permission.addSubview(self.mySwitch)
        self.view.addSubview(permission)
        self.mySwitch.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
        }
        
        
        self.createBtn.frame = CGRect.init(x: 30, y: permission.max_Y + 30, width: SCREENWIDTH - 60, height: 44)
        
        
        
        
        
    }
    
    
    
    
    
    
    @objc func btnClick(btn: UIButton) {
        
        btn.isEnabled = false
        let paramete = ["token": DDAccount.share.token ?? "", "team_name": self.teamName, "team_type": self.teamTypeStr, "sign_data_permission": self.sign_data_permission]
        let router = Router.post("sign/create", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<String>.deserialize(from: dict)
            if model?.status == 200 {
                let alertVC = UIAlertController.init(title: "", message: "team_create_success_alter"|?|, preferredStyle: UIAlertController.Style.alert)
                let cancleBtn = UIAlertAction.init(title: "team_create_success_alter_cancle"|?|, style: UIAlertAction.Style.cancel, handler: { [weak self] (action) in
                    self?.popToPreviousVC()
                })
                alertVC.addAction(cancleBtn)
                let sureBtn = UIAlertAction.init(title: "team_create_success_alter_sure"|?|, style: UIAlertAction.Style.default, handler: { [weak self](action) in
                    let paramete = ["id": model?.data ?? "", "teamName": self?.teamName ?? ""]
                    self?.pushVC(vcIdentifier: "TeamDetailVC", userInfo: paramete)
                })
                alertVC.addAction(sureBtn)
                self.present(alertVC, animated: true, completion: nil)
                
            }else {
                let alertVC = UIAlertController.init(title: "", message: model?.message, preferredStyle: UIAlertController.Style.alert)
                let sureAction = UIAlertAction.init(title: "好的", style: UIAlertAction.Style.default, handler: nil)
                alertVC.addAction(sureAction)
                self.present(alertVC, animated: true, completion: nil)
            }
            btn.isEnabled = true
        }, onError: { (error) in
            btn.isEnabled = true
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    func configTeamType() {
        let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "team_type"|?|)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: 80, height: self.teamType.height)
        self.teamType.addSubview(titleLabel)
        self.teamType.addSubview(self.type1Btn)
        self.teamType.addSubview(self.type2Btn)
        self.type1Btn.frame = CGRect.init(x: titleLabel.max_X, y: 0, width: 60, height: self.teamType.height)
        self.type2Btn.frame = CGRect.init(x: self.type1Btn.max_X + 20, y: 0, width: 60, height: self.teamType.height)
    }
    @objc func selectTeamType(btn: UIButton) {
        btn.isSelected = true
        if btn == self.type1Btn {
            self.teamTypeStr = "1"
            self.type2Btn.isSelected = false
        }else {
            self.teamTypeStr = "2"
            self.type1Btn.isSelected = false
        }
        
        
    }
    
    
}
