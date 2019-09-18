//
//  EnterValueAlterView.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/8/28.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
enum FoundatonType: String {
    case email = "郵箱"
    case school = "學校"
}
class EnterValueAlterView: DDCoverView {

    @objc func cancleAction(btn: UIButton) {
        self.remove()
    }
    var finishEnter: ((String) -> ())?
    var enterValue: String = ""
    @objc func sureAction(btn: UIButton) {
        if self.enterValue.count == 0 {
            GDAlertView.alert("enterNUll"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        var paramete: [String: String] = ["token": token]
        switch self.foundtionType {
        case .school:
            paramete["school"] = self.enterValue
        case .email:
            paramete["email"] = self.enterValue
        
        }
        btn.isEnabled = false
        let router = Router.put("member/\(id)", DomainType.api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            btn.isEnabled = true
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response)
            if model?.status == 200 {
                self.finishEnter?(self.enterValue)
                self.remove()
                
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }) {
            btn.isEnabled = true
            GDAlertView.alert("重新上傳", image: nil, time: 1, complateBlock: nil)
        }
    }
    var foundtionType: FoundatonType = .school
    init(superView: UIView, placeholder: String, action: FoundatonType) {
        super.init(superView: superView)
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(160)
        }
        self.enterText.placeholder = placeholder
        self.containerView.addSubview(self.cancleBtn)
        self.containerView.addSubview(self.sureBtn)
        self.cancleBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(self.sureBtn.snp.width)
            make.right.equalTo(self.sureBtn.snp.left)
            make.height.equalTo(40)
        }
        self.sureBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalTo(self.cancleBtn.snp.right)
            make.height.equalTo(40)
        }
        self.containerView.addSubview(self.enterText)
        self.enterText.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(40)
        }
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
        self.containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.enterText.snp.left)
            make.right.equalTo(self.enterText.snp.right)
            make.top.equalTo(self.enterText.snp.bottom)
            make.height.equalTo(1)
        }
        let rx = self.enterText.rx.text.orEmpty
        let _ = rx.subscribe(onNext: { (title) in
            self.enterValue = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
    }
    lazy var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var enterText: UITextField = {
        let textField = UITextField.init()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.colorWithHexStringSwift("cccccc")
        textField.tintColor = UIColor.orange
        textField.textAlignment = .left
        return textField
    }()
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init()
        btn.setTitle("cancel"|?|, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
        return btn
    }()
    lazy var sureBtn : UIButton = {
        let btn = UIButton.init()
        btn.setTitle("sure"|?|, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(sureAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("ed8202")
        return btn
    }()

}
