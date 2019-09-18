//
//  TeamDetailFooter.swift
//  Project
//
//  Created by 张凯强 on 2019/8/30.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class TeamDetailFooter: UICollectionReusableView {

    @IBOutlet weak var mySwitch: MYSwitch!
    var containerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("TeamDetailFooter", owner: self, options: nil)?.first as? UIView {
            self.backgroundColor = UIColor.white
            self.containerView = subView
                self.addSubview(self.containerView)
            self.mySwitch.transform = .init(scaleX: 0.8, y: 0.8)
            self.mySwitch.addTarget(self, action: #selector(switchAction(_:)), for: UIControl.Event.touchUpInside)
        }
        
    }
    var teamID: String?
    var switchBlick: (() -> ())?
    var isOn: Bool = false {
        didSet {
            self.mySwitch.setOn(isOn, animated: true)
        }
    }
    @objc func switchAction(_ sender: UISwitch) {
        sender.setOn(self.isOn, animated: false)
        sender.isEnabled = false
        let cancle = ZKAlertAction.init(title: "cancel"|?|, style: UIAlertAction.Style.cancel) { (action) in
            sender.isEnabled = true
            
        }
        let sure = ZKAlertAction.init(title: "sure"|?|, style: UIAlertAction.Style.default) { [weak self](action) in
            ZkqAlert.share.activeAlert.startAnimating()
            
            var sign_data_permission: String = "0"
            if !sender.isOn {
                sign_data_permission = "1"
            }else {
                sign_data_permission = "0"
            }
            let paramete = ["token": DDAccount.share.token ?? "", "id": self?.teamID ?? "", "sign_data_permission": sign_data_permission]
            let router = Router.post("sign/on-off", .api, paramete)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                let model = BaseModel<String>.deserialize(from: dict)
                if model?.status == 200 {
                    self?.switchBlick?()
                }else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
                sender.isEnabled = true
                ZkqAlert.share.activeAlert.stopAnimating()
            }, onError: { (error) in
                sender.isEnabled = true
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
        }
        let message = self.isOn ? "team_close_sign_permission_alter"|?| : "team_on_sign_permission_alter"|?|
        let alert = MyAlertView.init(frame: CGRect.zero, title: "", message: message, actions: [cancle, sure])
        
        UIApplication.shared.keyWindow?.alertZkq(alert)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
    
}
class MYSwitch: UISwitch {
    override func setOn(_ on: Bool, animated: Bool) {
        super.setOn(on, animated: animated)
        mylog("点击了这个")
    }
}
