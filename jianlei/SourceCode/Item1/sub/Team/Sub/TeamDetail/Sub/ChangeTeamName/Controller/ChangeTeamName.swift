//
//  ChangeTeamName.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ChangeTeamName: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        
        // Do any additional setup after loading the view.
    }
    let textField: UITextField = UITextField.init()
    lazy var saveBtn: UIButton = {
        let btn = UIButton.init()
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        btn.layer.addSublayer(gradientLayer)
        btn.setTitle("team_save"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "team_change_name"|?|
    }
    
    var teamName: String = ""
    var teamId: String = ""
    var teamIdRx: Variable<String> = Variable<String>.init("")
    deinit {
        mylog("xiaohui")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChangeTeamName{
    func configUI() {
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.view.addSubview(self.textField)
        self.textField.frame = CGRect.init(x: 0, y: DDNavigationBarHeight + 20, width: SCREENWIDTH, height: 54)
        self.textField.font = GDFont.systemFont(ofSize: 14)
        self.textField.textColor = UIColor.colorWithHexStringSwift("323232")
        self.view.addSubview(self.saveBtn)
        self.saveBtn.frame = CGRect.init(x: 30, y: self.textField.max_Y + 60, width: SCREENWIDTH - 60, height: 44)
        self.saveBtn.layer.masksToBounds = true
        self.saveBtn.layer.cornerRadius = 25
        if let dict = self.userInfo as? [String: String], let teamName = dict["teamName"], let id = dict["id"] {
            self.textField.text = teamName
            self.teamId = id
        }
        self.textField.backgroundColor = UIColor.white
        let leftView = UIView.init()
        leftView.frame = CGRect.init(x: 0, y: 0, width: 15, height: 40)
        self.textField.leftViewMode = .always
        self.textField.leftView = leftView
//        self.textField.setValue(UIColor.colorWithHexStringSwift("999999"), forKeyPath: "_placeholderLabel.textColor")
        let _ = self.textField.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.teamName = title
            self?.teamIdRx.value = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        let _ = self.teamIdRx.asObservable().subscribe(onNext: { (_) in
//            if title.count > 0 {
//                self?.saveBtn.isEnabled = true
//            }else {
//                self?.saveBtn.isEnabled = false
//            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
    }
    @objc func btnClick(btn: UIButton) {
        if self.teamName.count == 0 {
            GDAlertView.alert("team_enter_team_name"|?|, image: nil, time: 1) {
                
            }
            return
        }
        
        
        btn.isEnabled = false
        let paramete = ["token": DDAccount.share.token ?? "", "id": self.teamId, "team_name": self.teamName]
        let router = Router.post("sign/update-team-name", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                
                GDAlertView.alert("  \("team_change_success"|?|)  ", image: UIImage.init(named: "team_admin_success"), time: 1, complateBlock: {
                    self.popToPreviousVC()
                })
            }else {
                let alertVC = UIAlertController.init(title: "", message: model?.message, preferredStyle: UIAlertController.Style.alert)
                let sureAction = UIAlertAction.init(title: "sure"|?|, style: UIAlertAction.Style.default, handler: nil)
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
}
