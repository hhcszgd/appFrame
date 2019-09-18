//
//  DDAdBankCardVC.swift
//  Project
//
//  Created by WY on 2019/8/23.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAdBankCardVC: DDNormalVC {
    @IBOutlet weak var yueshu: NSLayoutConstraint!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cardNum: UITextField!
    
    @IBOutlet weak var areaCodeButton: CustomBtn!
    @IBOutlet weak var bankName: UITextField!
    
    @IBOutlet weak var bankAccountName: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var authCode: UITextField!
    @IBOutlet weak var noticeBtn: UIButton!
    var doneHandle : (()->())?
    @IBOutlet weak var sendCodeBtn: UIButton!
    var timer : Timer?
    var timeInterval : Int = 60
    var apiModel : ApiModel<[DDBandBrandModel]>?
    var selectedBankBrandModel : DDBandBrandModel?
    var cover  : DDCoverView?
    @IBOutlet weak var bandBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        areaCodeButton.delegate = self
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        getUserRealName()
        self.title = "bandBankCardTitle"|?|
        self.bankName.delegate = self
        self.bankName.adjustsFontSizeToFitWidth = true
        self.bankName.minimumFontSize = 8
        self.name.delegate = self
        self.name.isUserInteractionEnabled = false
        
        
        self.cardNum.delegate = self
        self.mobile.delegate = self
        self.authCode.delegate = self
        self.bankAccountName.delegate = self
        if #available(iOS 10.0, *){
            
        }else{
            yueshu.constant = DDNavigationBarHeight
        }
        
        self.sendCodeBtn.setTitleColor(UIColor.orange, for: UIControl.State.disabled)
        self.sendCodeBtn.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        self.sendCodeBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.disabled)
        self.mobile.keyboardType = .numberPad
        self.authCode.keyboardType = .numberPad
        self.cardNum.keyboardType = .numberPad
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
//            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.requestAPI()
    }
    
    func getUserRealName() {
        let token: String = DDAccount.share.token ?? ""
        let memberID: String = DDAccount.share.id ?? ""
        
        let paramete: [String: Any] = ["token": token]
        let _ = NetWork.manager.requestData(router: Router.get("member/\(memberID)/id", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    DDAccount.share.setPropertisOfShareBy(otherAccount: data)
                    if let name = data.name, name.count > 0 {
                        self.name.text = DDAccount.share.name
                    }
                }
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.view.frame.origin.y = 111
        bandBtn.embellishView(redius: 10)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        mylog(self.view.bounds)
    }
    func requestAPI()  {
       DDRequestManager.share.getBankBrandList(type: ApiModel<[DDBandBrandModel]>.self, success: {apiModel in
            self.apiModel = apiModel
       })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func noticeClick(_ sender: UIButton) {
//        GDAlertView.alert("姓名一经填写,不能修改", image: nil , time: 2, complateBlock: nil )
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                print(action._title)
            })
            let message1  = "bankYourselfBankcardMakeSureSafe"|?|
            let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
        
        self.view.endEditing(true)
    }
    
    @IBAction func sendAuthCodeClick(_ sender: UIButton) {
        self.view.endEditing(true)
        getAutoCode()
    }
    func addTimer() {
        self.sendCodeBtn.isEnabled = false
        self.timeInterval -= 1
        self.sendCodeBtn.setTitle("\(self.timeInterval)\("resendTitle"|?|)", for: UIControl.State.disabled)
        timer = Timer.init(timeInterval: 1, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
        self.sendCodeBtn.isEnabled = true
        self.timeInterval = 60
        self.sendCodeBtn.setTitle("sendCodeTitle"|?|, for: UIControl.State.normal)
    }
    @objc func daojishi() {
        self.timeInterval -= 1
        if self.timeInterval <= 0 {
            self.removeTimer()
        }else{
//            UIView.animate(withDuration: 0.1, animations: {
                self.sendCodeBtn.setTitle("\(self.timeInterval)\("resendTitle"|?|)", for: UIControl.State.disabled)
//            })
        }
    }
    func getAutoCode() {
        if let mobileStr = self.mobile.text , mobileStr.count > 0 {
            
            if !mobile.text!.mobileLawful() {
                GDAlertView.alert("typeinCorrectMobile"|?|, image: nil, time: 2, complateBlock: nil)
                return
            }
            self.addTimer()
            DDRequestManager.share.getAuthCode(type: ApiModel<String>.self, mobile: mobileStr , success : { (apiModel) in
                if apiModel.status == 200 {
                    GDAlertView.alert(apiModel.message, image: nil , time: 2, complateBlock: nil )
                }else {
                    GDAlertView.alert(apiModel.message, image: nil , time: 2, complateBlock: nil )
                    DDRequestManager.share.getPublickKey(force: true , publicKey: { (publicKey) in
                        print("xxxxxxxxxxxxxxxx:\(String(describing: publicKey))")
                    })
                    self.removeTimer()
                }
            } , failure : {error in
                self.removeTimer()
                GDAlertView.alert("server_data_type_error"|?|, image: nil , time: 2, complateBlock: nil )
            })
            
        }else{
            GDAlertView.alert("mobileIsEmpty"|?|, image: nil , time: 2, complateBlock: nil )
        }
    }
    
    @IBAction func bandBtnClick(_ sender: UIButton) {
        if name.text == nil || name.text!.count == 0 {
            GDAlertView.alert("fullnameIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if bankAccountName.text == nil  || bankAccountName.text!.count == 0 {
            GDAlertView.alert("銀行卡開戶名稱為空", image: nil, time: 2, complateBlock: nil)
            return
        }else if cardNum.text == nil  || cardNum.text!.count == 0 {
            GDAlertView.alert("bankNumberIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if bankName.text == nil || bankName.text!.count == 0  {
            GDAlertView.alert("bankIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if mobile.text == nil || mobile.text!.count == 0  {
            GDAlertView.alert("mobileIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if authCode.text == nil || authCode.text!.count == 0  {
            GDAlertView.alert("authorCodeIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        
        if !name.text!.userNameLawful() {
            GDAlertView.alert("typeinCorrectUsername"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
//        if !((cardNum.text ?? "").bankCardCheck())  {
//            GDAlertView.alert("typeinCorrectBankNumber"|?|, image: nil, time: 2, complateBlock: nil)
//            return
//        }
        
        if (cardNum.text ?? "").count <= 6 ||  (cardNum.text ?? "").count >= 26 {
            GDAlertView.alert("typeinCorrectBankNumber"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        
        if !authCode.text!.authoCodeLawful() {
            GDAlertView.alert("typeinAuthorCode"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        if !mobile.text!.mobileLawful() {
            GDAlertView.alert("typeinCorrectMobile"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        let countryCode = self.areaCodeButton.phoneCode
        DDRequestManager.share.bandBankCard(type: ApiModel<String>.self, ownName: self.name.text ?? "",account_name : self.bankAccountName.text ?? "", cardNum: cardNum.text!, mobile: mobile.text!,bankID: "\(selectedBankBrandModel?.id ?? 0)", verify: self.authCode.text ?? "",countryCode:countryCode,  success: { (apiModel) in
            if apiModel.status == 200 {
                self.doneHandle?()
                self.navigationController?.popViewController(animated: true)
            }else {
                GDAlertView.alert(apiModel.message, image: nil , time: 2, complateBlock: nil )
            }
        } , failure : {error in
            GDAlertView.alert("operateFailure"|?|, image: nil , time: 2, complateBlock: nil )
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension DDAdBankCardVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        return true
//        if textField ==  name{
//            if (name.text?.count ?? 0) > 6 {
//                GDAlertView.alert("请输入2到6个汉字的姓名", image: nil, time: 2, complateBlock: nil)
//                return false
//            }else {return true }
//        }else if textField ==  cardNum{
//            //^([1-9]{1})(\d{14}|\d{18})$
//            let regex = "^([1-9]{1})(\\d{14}|\\d{18})$"
//            let regextext = NSPredicate.init(format: "SELF MATCHES %@", regex)
//            let result: Bool = regextext.evaluate(with: cardNum.text ?? "")
//            return true
//        }else if textField == mobile {
//            if (mobile.text?.count ?? 0) > 11{return false }else{return true }
//        }else if textField == authCode {
//            if (authCode.text?.count ?? 0) > 6{return false }else{return true }
//        }else{return true }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == bankName {
            chooseBankClick()
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mylog(textField.placeholder)
        if textField ==  name{
            if (name.text?.count ?? 0) > 6 || (name.text?.count ?? 0) < 2{
                GDAlertView.alert("typeinCorrectUsername"|?|, image: nil, time: 2, complateBlock: nil)
            }
        }else if textField ==   bankAccountName{
            if (bankAccountName.text ?? "").count <= 0  {
                GDAlertView.alert(bankAccountName.placeholder, image: nil, time: 2, complateBlock: nil)
            }
        }
        else if textField ==  cardNum{
//            let result: Bool = (cardNum.text ?? "").bankCardCheck()
            let result: Bool =  (cardNum.text ?? "").count <= 6 ||  (cardNum.text ?? "").count >= 26
            if result  {
                GDAlertView.alert("bankCardNumIncorrect"|?|, image: nil, time: 2, complateBlock: nil)
            }
        }else if textField == mobile {
            if let lawful =  mobile.text?.mobileLawful(),lawful == false {
                GDAlertView.alert("typeinCorrectMobile"|?|, image: nil, time: 2, complateBlock: nil)
            }
        }else if textField == authCode {
            if (authCode.text?.count ?? 0) != 6{GDAlertView.alert("typeinAuthorCode"|?|, image: nil, time: 2, complateBlock: nil) }
        }else{
            
        }
    }
}
extension DDAdBankCardVC {
  
    @objc func chooseBankClick()  {
        let pickerTitle = UILabel(frame:  CGRect(x:(self.view.bounds.width - 100) / 2 , y: 0, width: 100, height: 44))
        pickerTitle.text = "chooseBankTitle"|?|
        pickerTitle.textAlignment = .center
        //        sender.isSelected = !sender.isSelected
//        let leftButton = UIButton(frame: CGRect(x: 20, y: 10, width: 88, height: 44))
//        let rightButton = UIButton(frame: CGRect(x:self.view.bounds.width - 20 - 88 , y: 10, width: 88, height: 44))
        
//        leftButton.addTarget(self , action: #selector(leftButtonClick(sender:)), for: UIControl.Event.touchUpInside)
//        rightButton.addTarget(self, action: #selector(rightButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        cover = DDCoverView.init(superView: self.view)
        cover?.isHideWhenWhitespaceClick = false 
        cover?.deinitHandle = {
            self.conerClick()
        }
        
//        leftButton.setTitle("取消", for: UIControl.State.normal)
//        rightButton.setTitle("确定", for: UIControl.State.normal)
//        leftButton.setTitleColor(UIColor.DDSubTitleColor, for: UIControl.State.normal)
//        rightButton.setTitleColor(UIColor.DDSubTitleColor, for: UIControl.State.normal)
        let pickerContainerH :CGFloat = 500
        let pickerContainer = DDBankContainer(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: pickerContainerH))
        pickerContainer.delegate = self
        pickerContainer.models = self.apiModel?.data
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = .white
//        pickerContainer.addSubview(rightButton)
        pickerContainer.addSubview(pickerTitle)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContainerH, width: self.view.bounds.width, height: pickerContainerH)
        }, completion: { (bool ) in
        })
        
    }
    
    @objc func conerClick()  {
        //        self.levelSelectButton.isSelected = false
        if let corverView = self.cover{
            for (_ ,view) in corverView.subviews.enumerated(){
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    view.frame = CGRect(x: 0 , y: self.view.bounds.height, width: self.view.bounds.width , height: 250)
                    corverView.alpha = 0
                }, completion: { (bool ) in
                    view.removeFromSuperview()
                    corverView.remove()
                    self.cover = nil
                })
            } 
        }
    }
}


///////////

protocol DDBankChooseDelegate : NSObjectProtocol {
    
    func didSelectRowAt(indexPath : IndexPath)
    func didSelectRowAt(indexPath: IndexPath, target: UIView?)
    
    
}
extension DDBankChooseDelegate {
    func didSelectRowAt(indexPath : IndexPath){}
    func didSelectRowAt(indexPath: IndexPath, target: UIView?){}
}

extension DDAdBankCardVC : DDBankChooseDelegate {
    
    func didSelectRowAt(indexPath : IndexPath){
        mylog(indexPath)
        if let selectedBankBrandModel = self.apiModel?.data?[indexPath.row]{
            self.selectedBankBrandModel = selectedBankBrandModel
            self.bankName.text = selectedBankBrandModel.name
        }
        self.cover?.remove()
        self.cover = nil
    }
    class DDBankContainer: UIView ,UITableViewDelegate , UITableViewDataSource{
        var models : [DDBandBrandModel]?{
            didSet{
                self.tableView.reloadData()
                layoutIfNeeded()
            }
        }
        var currentSelectLevel : Int = 0 {
            didSet{
                mylog(currentSelectLevel)
            }
        }
        
        weak var delegate : DDBankChooseDelegate?
        let titleLabel = UILabel()
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                        mylog(indexPath)
            self.delegate?.didSelectRowAt(indexPath: indexPath)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return models?.count ?? 0
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var  returnCell : DDLevelCell!
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DDLevelCell") as? DDLevelCell{
                returnCell = cell
            }else{
                let cell = DDLevelCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDLevelCell")
                returnCell = cell
            }
            if let model = models?[indexPath.row]{
                returnCell.titleLabel.text = model.name
            }
            return returnCell
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(titleLabel)
            self.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
//            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
            self.tableView.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: self.bounds.width, height: self.bounds.height - titleLabel.frame.maxY - 44 )
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}

class DDLevelCell: UITableViewCell {
    let titleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        titleLabel.adjustsFontSizeToFitWidth = true
//        titleLabel.minimumFontSize = 11
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.DDSubTitleColor
        self.contentView.addSubview(self.lineView)
        self.lineView.backgroundColor = UIColor.colorWithRGB(red: 233, green: 233, blue: 233)
        self.lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    let lineView = UIView.init()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.contentView.bounds
        
    }
}
extension DDAdBankCardVC : CustomBtnProtocol{
    func sendValue(paramete: AnyObject?){
        if let code = paramete as? String {
//            self.countryCode = code
            staticPhoneCode = code
            self.areaCodeButton.myTitle = (code, .normal)
        }
    }
}
