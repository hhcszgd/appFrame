//
//  MyAlertView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
 
class ShopAlertViewType1: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.myTitleLabel?.sizeToFit()
        self.myTitleLabel?.numberOfLines = 0
        self.addSubview(self.myTitleLabel!)
        self.myTitleLabel?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        
        
//        let gradientLayer = CAGradientLayer.init()
//        gradientLayer.frame = CGRect.init(x: 0, y: frame.height - 44, width: frame.width, height: 44)
//        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
//        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
//        self.layer.addSublayer(gradientLayer)
        
        self.sureBtn.setTitleColor(UIColor.colorWithHexStringSwift("ffffff"), for: UIControl.State.normal)
        self.sureBtn.setTitle("", for: UIControl.State.normal)
        self.sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.sureBtn)
        self.sureBtn.frame = CGRect.init(x: 0, y: frame.height - 44, width: frame.width, height: 44)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white
        self.sureBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        
    }
    
    
    
    
    var myTitleLabel: UILabel? = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "您还未签订补充协议，暂不能上传图片\n请联系客服：400-073-6688")
    var clickBlock: (() -> ())?
    @objc func btnClick(btn: UIButton) {
        self.clickBlock?()
        
        
        
    }
    deinit {
        mylog("xiaohui")
    }
    let sureBtn: UIButton = UIButton.init()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class MyAlertView: ShopAlertViewType1, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    init(frame: CGRect, title: String?, message: String?, actions: [ZKAlertAction]?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.addSubview(self.containerView)
        self.containerView.backgroundColor = UIColor.white
        self.containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(140)
        }
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 15
  
        if title != nil && title?.count != 0 {
            self.titleLabel.sizeToFit()
            self.containerView.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(30)
            }
            self.titleLabel.text = title
            if message != nil && message?.count != 0 {
                self.messsageLabel.sizeToFit()
                self.containerView.addSubview(self.messsageLabel)
                self.messsageLabel.textAlignment = .center
                self.messsageLabel.numberOfLines = 0
                self.messsageLabel.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                    make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                }
                self.messsageLabel.text = message
            }
            
            
        }else {
            if message != nil && message?.count != 0 {
                self.messsageLabel.sizeToFit()
                self.containerView.addSubview(self.messsageLabel)
                self.messsageLabel.textAlignment = .center
                self.messsageLabel.numberOfLines = 0
                self.messsageLabel.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                    make.centerY.equalToSuperview().offset(-20)
                }
                self.messsageLabel.text = message
                
            }
        }
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 100, width: SCREENWIDTH, height: 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        self.containerView.layer.addSublayer(gradientLayer)
        if let arr = actions {
            self.actions = arr
        }
        
        
        self.defaultBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.cancleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.defaultBtn.addTarget(self, action: #selector(btnClick(sender:)), for: UIControl.Event.touchUpInside)
        self.cancleBtn.addTarget(self, action: #selector(btnClick(sender:)), for: UIControl.Event.touchUpInside)
        if let actionArr = actions {
            if actionArr.count == 1 {
                let action1 = actionArr.first
                self.containerView.addSubview(self.defaultBtn)
                self.defaultBtn.setTitle(action1?._title, for: UIControl.State.normal)
                self.defaultBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self.defaultBtn.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(40)
                }
                
            }else if actionArr.count == 2 {
                
                let action1 = actionArr.first
                self.containerView.addSubview(self.cancleBtn)
                self.cancleBtn.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(40)
                }
                self.cancleBtn.setTitleColor(UIColor.colorWithHexStringSwift("cccccc"), for: UIControl.State.normal)
                self.cancleBtn.setTitle(action1?._title, for: UIControl.State.normal)
                let lineView: UIView  = UIView.init()
                lineView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
                
                
                
                let action2 = actionArr.last
                self.defaultBtn.setTitle(action2?._title, for: UIControl.State.normal)
                self.defaultBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self.containerView.addSubview(self.defaultBtn)
                self.defaultBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(self.cancleBtn.snp.right)
                    make.right.bottom.equalToSuperview()
                    make.height.equalTo(40)
                    make.width.equalTo(self.cancleBtn.snp.width)
                }
                
                self.containerView.addSubview(lineView)
                lineView.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.centerY.equalTo(self.defaultBtn.snp.centerY)
                    make.width.equalTo(1)
                    make.height.equalTo(20)
                }
                
            }
        }
        
        
        
        
        
    }
    ///手機號碼區號選擇
    init(frame: CGRect, actions: [ZKAlertAction]?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.addSubview(self.containerView)
        self.containerView.backgroundColor = UIColor.white
        self.containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(90)
        }
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 15
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH * 0.85, height: 90), style: UITableView.Style.plain)
        self.containerView.addSubview(table)
        table.dataSource = self
        table.delegate = self
        table.register(PhoneCodeCell.self, forCellReuseIdentifier: "PhoneCodeCell")
        self.tableView = table
        self.sureBtn.isHidden = true
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phoneCodeArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCodeCell", for: indexPath) as! PhoneCodeCell
    
        cell.model = self.phoneCodeArr[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.phoneCodeArr[indexPath.row]
        if let code = model.code, code.count > 0 {
            self.selectPhoneCodeFinished?(code)
            self.remove()
        }
    }
    var selectPhoneCodeFinished:((String) ->())?
    var tableView: UITableView?
    var phoneCodeArr: [PhoneCodeModel] = [PhoneCodeModel]() {
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    
    
    let textField = UITextField.init()
    
    
    init(frame: CGRect,title: String,  textFieldStr: String?, message: String?, actions: [ZKAlertAction]?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.addSubview(self.containerView)
        self.containerView.backgroundColor = UIColor.white
        self.containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(120)
        }
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 15
        self.containerView.addSubview(self.textField)
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.textColor = UIColor.colorWithHexStringSwift("cccccc")
        self.titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(13)
        }
        
        self.titleLabel.text = title
        self.textField.returnKeyType = .done
        self.textField.delegate = self
        self.textField.textColor = UIColor.colorWithHexStringSwift("323232")
        self.textField.font = UIFont.systemFont(ofSize: 12)
        self.textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(13)
            make.height.equalTo(30)
        }
        self.textField.placeholder = message
        self.textField.text = textFieldStr
        self.textField.tintColor = UIColor.colorWithHexStringSwift("323232")
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 120 - 44, width: SCREENWIDTH, height: 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        self.containerView.layer.addSublayer(gradientLayer)
        if let arr = actions {
            self.actions = arr
        }
        
        
        self.defaultBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.cancleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.defaultBtn.addTarget(self, action: #selector(btnClick(sender:)), for: UIControl.Event.touchUpInside)
        self.cancleBtn.addTarget(self, action: #selector(btnClick(sender:)), for: UIControl.Event.touchUpInside)
        
        
        if let actionArr = actions {
            if actionArr.count == 1 {
                let action1 = actionArr.first
                self.containerView.addSubview(self.defaultBtn)
                self.defaultBtn.setTitle(action1?._title, for: UIControl.State.normal)
                self.defaultBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self.defaultBtn.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(40)
                }
                
                
            }else if actionArr.count == 2 {
                
                let action1 = actionArr.first
                self.containerView.addSubview(self.cancleBtn)
                self.cancleBtn.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(40)
                }
                self.cancleBtn.setTitleColor(UIColor.colorWithHexStringSwift("cccccc"), for: UIControl.State.normal)
                self.cancleBtn.setTitle(action1?._title, for: UIControl.State.normal)
                let lineView: UIView  = UIView.init()
                lineView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
                
                
                
                let action2 = actionArr.last
                self.defaultBtn.setTitle(action2?._title, for: UIControl.State.normal)
                self.defaultBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self.containerView.addSubview(self.defaultBtn)
                self.defaultBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(self.cancleBtn.snp.right)
                    make.right.bottom.equalToSuperview()
                    make.height.equalTo(40)
                    make.width.equalTo(self.cancleBtn.snp.width)
                }
              
                self.containerView.addSubview(lineView)
                lineView.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.centerY.equalTo(self.defaultBtn.snp.centerY)
                    make.width.equalTo(1)
                    make.height.equalTo(20)
                }
                
            }
        }
        
        
        
        
        
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    var actions: [ZKAlertAction] = [ZKAlertAction]()
    @objc func btnClick(sender: UIButton) {
        
        if actions.count == 1 {
            let action = self.actions.first
            if self.subviews.contains(self.textField) {
                if self.textField.text?.count == 0 {
                    GDAlertView.alert("昵称不能为空", image: nil, time: 1, complateBlock: nil)
                    return
                }
            }
            
            action?.paramete = self.textField.text as AnyObject
            action?.handler?(action!)
            self.remove()
        }else if actions.count == 2 {
            if sender == self.defaultBtn {
                let action = self.actions.last
                if self.subviews.contains(self.textField) {
                    if self.textField.text?.count == 0 {
                        GDAlertView.alert("昵称不能为空", image: nil, time: 1, complateBlock: nil)
                        return
                    }
                }
                action?.paramete = self.textField.text as AnyObject
                action?.handler?(action!)
                self.remove()
            }
            if sender == self.cancleBtn {
                let action = self.actions.first
                action?.paramete = self.textField.text as AnyObject
                action?.handler?(action!)
                self.remove()
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    let defaultBtn = UIButton.init()
    let cancleBtn = UIButton.init()
    let containerView = UIView.init()
    
    
    let titleLabel = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 16), textColor: UIColor.colorWithHexStringSwift("ff7d09"), text: "")
    let messsageLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    var isHideWhenWhitespaceClick = true
    var deinitHandle : (()-> ())?
    var backgroundColorAlpha : CGFloat = 0.3
    
    ///animate返回值为自定义动画执行时间
    @objc func remove(animate:((MyAlertView) -> TimeInterval)? = nil ) {
        if animate != nil {
            let time = animate!(self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.subviews.forEach({ (subview) in
                    subview.removeFromSuperview()
                })
                self.removeFromSuperview()
                self.deinitHandle?()
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (bool ) in
                self.subviews.forEach({ (subview) in
                    subview.removeFromSuperview()
                })
                self.removeFromSuperview()
                self.deinitHandle?()
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchBegainAction(touches, with: event)
        if let _ = self.subviews.first{
            if let point = touches.first?.location(in: self){
                for subview in self.subviews{
                    if subview.frame.contains(point){
                        return
                    }
                }
                //                if firstView.frame.contains(point){
                //                    return
                //                }
            }
        }
        
        self.corverViewPart()
        if isHideWhenWhitespaceClick {self.remove()}
    }
    /// to be override
    func corverViewPart() {
        mylog("corver view part touch")
    }
    /// to be override
    func touchBegainAction(_ touches: Set<UITouch>, with event: UIEvent?) {
        mylog("touch begain")
    }
    deinit {
        self.deinitHandle?()
        print("cover destroyed销毁销毁销毁")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ZKAlertAction : NSObject {
    var _title  : String?{
        didSet{
            
        }
    }
    var paramete: AnyObject?
    open var isAutomaticDisappear = true
    
    //    open var title: String? { return _title }
    
    open var _style: UIAlertAction.Style = .default {
        didSet{
            
        }
    }
    
    open var isEnabled: Bool = true {
        didSet{
            
        }
    }
    @objc var handler : ((ZKAlertAction) -> Swift.Void)?
    //    override init() {}
    
    public convenience init(title: String?, style: UIAlertAction.Style = .default, handler: ((ZKAlertAction) -> Swift.Void)? = nil){
        self.init()
        self.handler = handler
        self._title = title
    }
}

class PhoneCodeCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.myTitleLabl)
        self.contentView.backgroundColor = UIColor.white
        self.myTitleLabl.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            
        }
    }
    var model: PhoneCodeModel? {
        didSet{
            self.myTitleLabl.text = (model?.area ?? "") + (model?.code ?? "")
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let myTitleLabl = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    
}
class PhoneCodeModel: Codable {
    var area: String?
    var code: String?
}
