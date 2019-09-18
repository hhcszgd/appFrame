//
//  DDAddCompanyBankCardVV.swift
//  Project
//
//  Created by WY on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAddCompanyBankCardVC: DDNormalVC {
    var doneHandle : (()->())?
    var cover  : DDCoverView?
    lazy var areaCodeButton: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 34), lineColor: "cccccc")
        btn.myTitleColor = ("323232", .normal)
        btn.delegate = self 
        btn.titleFont = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    var timer : Timer?
    var timeInterval : Int = 60
    var apiModel : ApiModel<[DDBandBrandModel]>?
    var selectedBankBrandModel : DDBandBrandModel?
    
    let nameTitle = TempLabel()
    let nameValue = TempTextField()
    
    let shortCompanyNameTitle = TempLabel()
    let shortCompanyNameValue = TempTextField()
    
    let tipsButton = UIButton()
    
    let bankNumberTitle = TempLabel()
    let bankNumberValue = TempTextField()
    
    let bankTypeTitle = TempLabel()
    let bankTypeValue = UITextField()
    
    
//    let bankNameTitle = TempLabel()
//    let bankNameValue = TempTextField()
    
    let mobileTitle = TempLabel()
    let mobileTextfield = TempTextField()
    ///原级别 , 现作业类别
    let codeTitle = TempLabel()
    let codeTextfield = TempTextField()
//    ///原职业名称, 现准操项目
//    let jobTitle = TempLabel()
//    let jobTextfield = TempTextField()
//
//    let fazhengdiquTitle = TempLabel()
//    let fazhengdiquTextfield = TempTextField()
    let getCodeButton = UIButton()
    let bandButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "bandBankCardTitle"|?|
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        _addSubviews()
//        getUserRealName()
        self.requestAPI()
    }
    func requestAPI()  {
       DDRequestManager.share.getBankBrandList(type: ApiModel<[DDBandBrandModel]>.self, success: {apiModel in
            self.apiModel = apiModel
       })
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
                        self.nameValue.text = DDAccount.share.name
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
}


/// actions
extension DDAddCompanyBankCardVC{
    @objc func bandButtonClick(sender:UIButton){
        if nameValue.text == nil || nameValue.text!.count == 0 {
            GDAlertView.alert("accountNameIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if nameValue.text!.count > 35 && (shortCompanyNameValue.text == nil || shortCompanyNameValue.text!.count == 0){
            GDAlertView.alert("請輸入銀行認證的公司名稱的縮寫", image: nil, time: 2, complateBlock: nil)
            return
        }
//        else if bankNameValue.text == nil  || bankNameValue.text!.count == 0 {
//            GDAlertView.alert("accountNumberIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
//            return
//        }
        else if bankTypeValue.text == nil  || bankTypeValue.text!.count == 0 {
            GDAlertView.alert("bankIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
//        else if bankNameValue.text == nil || bankNameValue.text!.count == 0  {
//            GDAlertView.alert("openAccountPointIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
//            return
//        }
        else if mobileTextfield.text == nil || mobileTextfield.text!.count == 0  {
            GDAlertView.alert("mobileIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if codeTextfield.text == nil || codeTextfield.text!.count == 0  {
            GDAlertView.alert("authorCodeIsEmpty"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        
//        if !nameValue.text!.userNameLawful() {
//            GDAlertView.alert("请输入2到6位汉字的用户名", image: nil, time: 2, complateBlock: nil)
//            return
//        }
//        if !((bankNumberValue.text ?? "").bankCardCheck())  {
//            GDAlertView.alert("请输入正确的银行卡号", image: nil, time: 2, complateBlock: nil)
//            return
//        }
        if (bankNumberValue.text ?? "").count <= 6 ||  (bankNumberValue.text ?? "").count >= 26 {
            GDAlertView.alert("typeinCorrectBankNumber"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
//        if (bankNameValue.text ?? "").count <= 0 {
//            GDAlertView.alert("typeinOpenAccountBank"|?|, image: nil, time: 2, complateBlock: nil)
//            return
//        }
        
        if !codeTextfield.text!.authoCodeLawful() {
            GDAlertView.alert("typeinAuthorCode"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        if !mobileTextfield.text!.mobileLawful() {
            GDAlertView.alert("typeinCorrectMobile"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        var shorCompanyName : String = ""
        if (nameValue.text ?? "" ).count > 35 {
            shorCompanyName = shortCompanyNameValue.text ?? ""
        }
        let countryCode = self.areaCodeButton.phoneCode
        DDRequestManager.share.bandBankCard(type: ApiModel<String>.self, ownName: self.nameValue.text ?? "", cardNum: bankNumberValue.text!, mobile: mobileTextfield.text! , bankID : "\(selectedBankBrandModel?.id ?? 0)", verify: self.codeTextfield.text ?? "",cardType:"2", bankName : nil /*self.bankNameValue.text*/ ,abbreviation_name : shorCompanyName,countryCode:countryCode, success: { (apiModel) in
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
    
    @objc func nameTips(sender:UIButton) {
        let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//            print(action._title)
        })
        let message1  = "onlyCanBandYourselfBankcard"|?|
        let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
        alert.isHideWhenWhitespaceClick = false
        UIApplication.shared.keyWindow?.alert( alert)
    }
    
    @objc func bottomAction(sender:UIButton) {
        
    }
    
}
/// user-interface setup
extension DDAddCompanyBankCardVC {
    func _addSubviews() {
        nameValue.backgroundColor = .white
        nameTitle.backgroundColor = .white
        
        shortCompanyNameTitle.backgroundColor = .white
        shortCompanyNameValue.backgroundColor = .white
        
//        bankNameValue.backgroundColor = .white
//        bankNameTitle.backgroundColor = .white
        bankNumberValue.keyboardType = .numberPad
        
        bankTypeTitle.backgroundColor = .white
        bankTypeValue.backgroundColor = .white
        
        bankNumberTitle.backgroundColor = .white
        bankNumberValue.backgroundColor = .white
        
        mobileTitle.backgroundColor = .white
        mobileTextfield.backgroundColor = .white
        
        codeTitle.backgroundColor = .white
        codeTextfield.backgroundColor = .white
        
        
//        bankNameValue.textColor = UIColor.DDSubTitleColor
        bankTypeValue.font = UIFont.systemFont(ofSize: 14)
//        bankNameValue.delegate = self
//        nameValue.isUserInteractionEnabled = false
//        bankNumberValue.isUserInteractionEnabled = false
//        bankNumberValue.isUserInteractionEnabled = false
        self.view.addSubview(nameTitle)
        nameTitle.text = "  \("accountName"|?|)"
        nameValue.placeholder = "typeinAccountName"|?|
        self.view.addSubview(nameValue)
        nameValue.delegate = self 
        
        shortCompanyNameTitle.text =  "  公司名稱縮寫"
        shortCompanyNameValue.placeholder =  "請輸入銀行認證的公司名稱縮寫"
        self.view.addSubview(shortCompanyNameTitle)
        self.view.addSubview(shortCompanyNameValue)
//        self.view.addSubview(tipsButton)
//        tipsButton.setImage(UIImage(named:"exclamationmarkicon"), for: UIControl.State.normal)
//        tipsButton.addTarget(self , action:#selector(nameTips(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(bankNumberTitle)
        bankNumberTitle.text = "  \("accountNumber"|?|)"
        self.view.addSubview(bankNumberValue)
        bankNumberValue.placeholder = "typeinBankNumber"|?|
        bankNumberValue.keyboardType = .numberPad
        
        bankTypeTitle.text = ""
        self.view.addSubview(bankTypeTitle)
        bankTypeTitle.text = "  \("openAccountBank"|?|)"
        bankTypeValue.placeholder = "pleaseChooseBankTitle"|?|
        bankTypeValue.adjustsFontSizeToFitWidth = true
        bankTypeValue.minimumFontSize = 8
        bankTypeValue.textColor = UIColor.lightGray
        bankTypeValue.delegate = self
        self.view.addSubview(bankTypeValue)
        
//        self.view.addSubview(bankNameTitle)
//        bankNameTitle.text = "  \("openAccountSpecifyBank"|?|)"
//        self.view.addSubview(bankNameValue)
//        bankNameValue.placeholder = "pleaseTypeinOpenAccountSpecifyBank"|?|
//        self.nameValue.textColor = UIColor.DDSubTitleColor
//        self.bankNumberValue.textColor = UIColor.DDSubTitleColor
//        self.bankNameValue.textColor = UIColor.DDSubTitleColor
        self.view.addSubview(mobileTitle)
        mobileTitle.text = "  \("mobileNumber"|?|)"
        self.view.addSubview(areaCodeButton)
        self.view.addSubview(mobileTextfield)
        mobileTextfield.keyboardType = .numberPad
//        mobileTextfield.placeholder = "填输入银行预留手机号"
        mobileTextfield.placeholder = "pleaseTypeinBossMobile"|?|
        
//        getCodeButton.setTitle("发送验证码", for: UIControl.State.normal)
//        getCodeButton.setTitleColor(UIColor.orange, for: UIControl.State.normal)
//        getCodeButton.setTitleColor(UIColor.lightGray, for: UIControl.State.disabled)
//        getCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
////        getCodeButton.backgroundColor = .orange
//        self.view.addSubview(getCodeButton)
//        getCodeButton.addTarget(self , action: #selector(getAutoCode), for: UIControl.Event.touchUpInside)
        
        
        self.view.addSubview(codeTitle)
        codeTitle.text = "  \("authorCode"|?|)"
        self.view.addSubview(codeTextfield)
        codeTextfield.keyboardType = .numberPad
        codeTextfield.placeholder = "typeinAuthorCodeCompany"|?|
        getCodeButton.setTitle("sendCodeTitle"|?|, for: UIControl.State.normal)
        getCodeButton.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        getCodeButton.setTitleColor(UIColor.lightGray, for: UIControl.State.disabled)
        getCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //        getCodeButton.backgroundColor = .orange
        self.view.addSubview(getCodeButton)
        getCodeButton.addTarget(self , action: #selector(getAutoCode), for: UIControl.Event.touchUpInside)
        
        
        
        self.view.addSubview(bandButton)
        bandButton.setTitle("band"|?|, for: UIControl.State.normal)
        bandButton.backgroundColor = .orange
        bandButton.addTarget(self , action: #selector(bandButtonClick(sender:)), for: UIControl.Event.touchUpInside)
//        self.view.addSubview(jobTitle)
//        //        jobTitle.text = "职业名称"
//        jobTitle.text = "准操项目"
//        self.view.addSubview(jobTextfield)
//        //        jobTextfield.placeholder = "填写职业名称"
//        jobTextfield.placeholder = "填写准操项目"
//
//        fazhengdiquTitle.text = "发证地区"
//        self.view.addSubview(fazhengdiquTitle)
//        fazhengdiquTextfield.placeholder = "填写证件红色公章上所写地区"
//        self.view.addSubview(fazhengdiquTextfield)
       
        _layoutSubviews()
    }
    
    func _layoutSubviews(hideShortCompanyName:Bool = true  ) {

//        let bottomContainerH = 72 + DDSliderHeight
        if hideShortCompanyName == self.shortCompanyNameTitle.isHidden {
            return
        }else{
            shortCompanyNameTitle.isHidden = hideShortCompanyName
            shortCompanyNameValue.isHidden = hideShortCompanyName
        }
        for subview in self.view.subviews {
            if subview.isMember(of: DDDDView.self ){
                subview.removeFromSuperview()
            }
        }
        var maxY : CGFloat = DDNavigationBarHeight + 11
        let titleMaxW = "  \("accountName"|?|)".sizeSingleLine(font: nameTitle.font).width + 10
        let horizontalMargin : CGFloat = 0
        nameTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
//        tipsButton.frame = CGRect(x: SCREENWIDTH - horizontalMargin - 40, y: nameTitle.frame.minY, width: 40, height: 40)
//        nameValue.frame = CGRect(x: nameTitle.frame.maxX, y: nameTitle.frame.minY, width: tipsButton.frame.minX - nameTitle.frame.maxX, height: 40)
        nameValue.frame = CGRect(x: nameTitle.frame.maxX, y: nameTitle.frame.minY, width: SCREENWIDTH - nameTitle.frame.maxX, height: 40)
        maxY = _addLine(maxY: nameTitle.frame.maxY)
        
        if hideShortCompanyName {
            bankNumberTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
            bankNumberValue.frame = CGRect(x: bankNumberTitle.frame.maxX, y: maxY, width: SCREENWIDTH - bankNumberTitle.frame.maxX, height: 40)
        }else{
            shortCompanyNameTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + 38 + horizontalMargin, height: 40)
            shortCompanyNameValue.frame = CGRect(x: shortCompanyNameTitle.frame.maxX, y: maxY, width: SCREENWIDTH - shortCompanyNameTitle.frame.maxX, height: 40)
            maxY = _addLine(maxY: shortCompanyNameTitle.frame.maxY)
            bankNumberTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
            bankNumberValue.frame = CGRect(x: bankNumberTitle.frame.maxX, y: maxY, width: SCREENWIDTH - bankNumberTitle.frame.maxX, height: 40)
        }
        
        
//        bankNumberTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
//        bankNumberValue.frame = CGRect(x: bankNumberTitle.frame.maxX, y: maxY, width: SCREENWIDTH - bankNumberTitle.frame.maxX, height: 40)
        maxY = _addLine(maxY: bankNumberTitle.frame.maxY)
        
        bankTypeTitle.frame  = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        bankTypeValue.frame = CGRect(x: bankTypeTitle.frame.maxX, y: maxY, width: SCREENWIDTH - bankTypeTitle.frame.maxX, height: 40)
        maxY = _addLine(maxY: bankTypeTitle.frame.maxY)
        
        
//        bankNameTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
//        bankNameValue.frame = CGRect(x: bankNameTitle.frame.maxX, y: maxY, width: SCREENWIDTH - bankNameTitle.frame.maxX, height: 40)
//        maxY = _addLine(maxY: bankNameTitle.frame.maxY)
        
        mobileTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        areaCodeButton.frame =  CGRect(x: mobileTitle.frame.maxX, y: maxY, width: 72, height: 40)
        mobileTextfield.frame = CGRect(x: areaCodeButton.frame.maxX, y: maxY, width: SCREENWIDTH - areaCodeButton.frame.maxX, height: 40)
        let getCodeButtonW : CGFloat = 111
        let getCodeButtonRightMargin : CGFloat = 10
        let getCodeButtonTopMargin : CGFloat = 8
//        getCodeButton.frame = CGRect(x: self.view.bounds.width - getCodeButtonW - getCodeButtonRightMargin, y: maxY + getCodeButtonTopMargin, width: 111, height: mobileTitle.bounds.height - getCodeButtonTopMargin * 2)
        
        maxY = _addLine(maxY: mobileTitle.frame.maxY)
        
        codeTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        codeTextfield.frame = CGRect(x: codeTitle.frame.maxX, y: maxY, width: SCREENWIDTH - codeTitle.frame.maxX, height: 40)
        
        getCodeButton.frame = CGRect(x: self.view.bounds.width - getCodeButtonW - getCodeButtonRightMargin, y: maxY + getCodeButtonTopMargin, width: 111, height: mobileTitle.bounds.height - getCodeButtonTopMargin * 2)
        maxY = _addLine(maxY: codeTitle.frame.maxY)
        
//        jobTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
//        jobTextfield.frame = CGRect(x: jobTitle.frame.maxX, y: maxY, width: SCREENWIDTH - jobTitle.frame.maxX, height: 40)
//        maxY = _addLine(maxY: jobTitle.frame.maxY)
//
//        ///新增
//        fazhengdiquTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
//        fazhengdiquTextfield.frame = CGRect(x: fazhengdiquTitle.frame.maxX, y: maxY, width: SCREENWIDTH - fazhengdiquTitle.frame.maxX, height: 40)
//        maxY = _addLine(maxY: fazhengdiquTextfield.frame.maxY)
        let buttonX : CGFloat = 50
        bandButton.frame = CGRect(x: buttonX, y: maxY + 84, width: self.view.bounds.width - buttonX * 2, height: 44)
        bandButton.embellishView(redius: bandButton.frame.height/2)
        getCodeButton.layer.borderWidth = 1
        getCodeButton.layer.borderColor = UIColor.orange.cgColor
        getCodeButton.embellishView(redius: getCodeButton.bounds.height/2)
        
        
    }
    func _addLine(maxY:CGFloat) -> CGFloat {
        let line = DDDDView()
        let margin : CGFloat = 10
        line.frame = CGRect(x: margin, y: maxY, width: SCREENWIDTH - margin  * 2 , height: 1.3)
        line.backgroundColor = UIColor.DDLightGray
        self.view.addSubview(line)
        return line.frame.maxY
    }
    
}

class DDDDView: UIView {
    
}

/// timer
extension DDAddCompanyBankCardVC {
    func addTimer() {
        self.getCodeButton.isEnabled = false
        self.timeInterval -= 1
        self.getCodeButton.setTitle("\(self.timeInterval)秒后重发", for: UIControl.State.disabled)
        timer = Timer.init(timeInterval: 1, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
        self.getCodeButton.isEnabled = true
        self.timeInterval = 60
        self.getCodeButton.setTitle("sendCodeTitle"|?|, for: UIControl.State.normal)
        
    }
    @objc func daojishi() {
        self.timeInterval -= 1
        if self.timeInterval <= 0 {
            self.removeTimer()
        }else{
            //            UIView.animate(withDuration: 0.1, animations: {
            self.getCodeButton.setTitle("\(self.timeInterval)\("resendTitle"|?|)", for: UIControl.State.disabled)
            //            })
        }
    }
    @objc func getAutoCode() {
        if let mobileStr = self.mobileTextfield.text , mobileStr.count > 0 {
            
            if !mobileTextfield.text!.mobileLawful() {
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
            })
        }else{
            GDAlertView.alert("typeinMobile"|?|, image: nil , time: 2, complateBlock: nil )
        }
    }
}

extension DDAddCompanyBankCardVC : UITextFieldDelegate ,DDBankChooseDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == bankTypeValue{
            
            chooseBankClick()
            self.view.endEditing(true)
            return false
        }else{return  true }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textt = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        mylog(textt)
        if  textField == self.nameValue{
            
            if  textt.count > 35 {
                _layoutSubviews(hideShortCompanyName: false )
            }else{
                _layoutSubviews(hideShortCompanyName: true  )
            }
        }
        
        return true
    }
    // DDBankChooseDelegate
    func didSelectRowAt(indexPath : IndexPath){
        mylog(indexPath)
        if let selectedBankBrandModel = self.apiModel?.data?[indexPath.row]{
            self.selectedBankBrandModel = selectedBankBrandModel
            self.bankTypeValue.text = selectedBankBrandModel.name
        }
        self.cover?.remove()
        self.cover = nil
    }
    @objc func conerClick()  {
        //        self.levelSelectButton.isSelected = false
        if let corverView = self.cover{
            for (_ ,view) in corverView.subviews.enumerated(){
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    view.frame = CGRect(x: 0 , y: self.view.bounds.height, width: self.view.bounds.width , height: 500)
                    corverView.alpha = 0
                }, completion: { (bool ) in
                    view.removeFromSuperview()
                    corverView.remove()
                    self.cover = nil
                })
            }
        }
    }
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
        let pickerContainerH :CGFloat = 250
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
class TempLabel :  UILabel{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textColor = UIColor.DDTitleColor
    }
    
}

class TempTextField :  UITextField , UITextFieldDelegate{
    
    override func layoutSubviews() {
        if self.delegate == nil {
            self.delegate = self
        }
        super.layoutSubviews()
        self.textColor = UIColor.DDSubTitleColor
        self.returnKeyType = .done
        self.font = UIFont.systemFont(ofSize: 14)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        UIApplication.shared.keyWindow?.endEditing(true)
        return true
    }
}
extension DDAddCompanyBankCardVC : CustomBtnProtocol{
    func sendValue(paramete: AnyObject?){
        if let code = paramete as? String {
            //            self.countryCode = code
            staticPhoneCode = code
            self.areaCodeButton.myTitle = (code, .normal)
        }
    }
}
