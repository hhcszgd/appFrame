//
//  DDPersonInfoVC.swift
//  YiLuMedia
//
//  Created by WY on 2019/9/10.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class DDPersonInfoVC: DDNormalVC {
    let backView = UIView()
    let line1 = UIView()
    let line2 = UIView()
    let nameTitle = UILabel()
    let nameValue = UITextField()
    let gender = UILabel()
    let male = UIButton()
    let female = UIButton()
    let idNumTitle = UILabel()
    let idNumValue = UITextField()
    let bottomButton = UIButton()
    var personalInfo : DDAuthenticateInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "authenticate_info_navi_title"|?|
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem =   UIBarButtonItem.init(title: "nil" , style: UIBarButtonItem.Style.plain, target: nil , action: nil )//去掉title
//        self.navigationItem.setHidesBackButton(true , animated: true )//隐藏返回键
        self.navigationItem.backBarButtonItem =   UIBarButtonItem.init(title: nil  , style: UIBarButtonItem.Style.plain, target: nil , action: nil )//去掉title
        
        _addSubviews()
        _layoutSubviews()
    }
}
///delegate
extension DDPersonInfoVC : UITextFieldDelegate{
    
}
///actions
extension DDPersonInfoVC{
    @objc func action(sender:UIButton){
        if sender == male{
            male.isSelected = true
            female.isSelected = false
        }else if sender == female{
            female.isSelected = true
            male.isSelected = false
        }else if sender == bottomButton{
            mylog("next")
            guard let name = nameValue.text , name.count > 0 else{
                GDAlertView.alert("authenticate_info_name_placeholder"|?|, image: nil, time: 2, complateBlock: nil)
                return
            }
            guard let idNumber = idNumValue.text , idNumber.count > 0 else{
                GDAlertView.alert("authenticate_info_id_placeholder"|?|, image: nil, time: 2, complateBlock: nil)
                return
            }
            let vc = DDIdImageVC()
//            let genderStr = male.isSelected ? "1" : "2"
//            vc.baseInfo = (self.nameValue.text ?? "" , genderStr , idNumValue.text ?? "")
            self.personalInfo?.name = self.nameValue.text ?? ""
            self.personalInfo?.id_number = idNumValue.text
            self.personalInfo?.sex = male.isSelected ? "1" : "2"
            vc.personalInfo = self.personalInfo
            self.navigationController?.pushViewController(vc, animated: true )
            
        }
    }
}
/// UI
extension DDPersonInfoVC{
    func _addSubviews() {
        self.view.addSubview(backView)
        self.view.addSubview(nameTitle)
        self.view.addSubview(nameValue)
        self.view.addSubview(gender)
        self.view.addSubview(male)
        self.view.addSubview(female)
        self.view.addSubview(idNumTitle)
        self.view.addSubview(idNumValue)
        self.view.addSubview(line1)
        self.view.addSubview(line2)
        self.view.addSubview(bottomButton)
        nameValue.delegate = self
        idNumValue.delegate = self
        nameTitle.text = "authenticate_info_name"|?|
        nameValue.placeholder = "authenticate_info_name_placeholder"|?|
        gender.text = "authenticate_info_gender"|?|
        idNumTitle.text = "authenticate_info_gender"|?|
        idNumValue.placeholder = "authenticate_info_id_placeholder"|?|
        male.setImage(UIImage(named: "login_checkmark_select"), for: UIControl.State.selected)
        male.setImage(UIImage(named: "login_checkmark"), for: UIControl.State.normal)
        male.setTitle("  " + "authenticate_info_male"|?|, for: UIControl.State.normal)
        male.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        female.setImage(UIImage(named: "login_checkmark_select"), for: UIControl.State.selected)
        female.setTitle("  " + "authenticate_info_female"|?|, for: UIControl.State.normal)
        female.setImage(UIImage(named: "login_checkmark"), for: UIControl.State.normal)
        female.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        backView.backgroundColor = UIColor.white
        bottomButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        bottomButton.setTitle("authenticate_info_next"|?|, for: UIControl.State.normal)
        let immg =  UIImage.getImage(startColor: UIColor.colorWithHexStringSwift("fbce35"), endColor: UIColor.colorWithHexStringSwift("f9ac35"), startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5), size: CGSize(width: SCREENWIDTH, height: 50))
        bottomButton.setBackgroundImage(immg, for: UIControl.State.normal)
        nameTitle.textColor = UIColor.darkGray
        nameTitle.font = DDFont.systemFont(ofSize: 15)
        gender.textColor = UIColor.darkGray
        gender.font = DDFont.systemFont(ofSize: 15)
        idNumTitle.textColor = UIColor.darkGray
        idNumTitle.font = DDFont.systemFont(ofSize: 15)
        nameValue.font = DDFont.systemFont(ofSize: 14)
        idNumValue.font = DDFont.systemFont(ofSize: 14)
        line1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        line2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        male.isSelected = true
        self.male.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
        self.female.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
        bottomButton.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
    }
    func _layoutSubviews() {
        self.nameValue.text = personalInfo?.name
        self.idNumValue.text = personalInfo?.id_number
        if (personalInfo?.sex ?? "") == "2" {//nv
            self.action(sender: female)
        }else {
            self.action(sender: male)
        }
//        self.gender.text = (apiModel.data?.sex ?? "") == "1" ? "男" : "女"
        
        let rowH : CGFloat = 40
        let backViewH = rowH * 3
        let backViewY = DDNavigationBarHeight + 22
        backView.frame = CGRect(x: 0, y: backViewY, width: view.bounds.width, height: backViewH)
        bottomButton.frame = CGRect(x: 15, y: backView.frame.maxY + 30, width: view.bounds.width - 30, height: 50)
        nameTitle.sizeToFit()
        gender.sizeToFit()
        male.sizeToFit()
        female.sizeToFit()
        idNumTitle.sizeToFit()
        let titleX : CGFloat = 10
        nameTitle.frame = CGRect(x: titleX, y: backView.frame.minY, width: nameTitle.bounds.width + 5, height: rowH)
        gender.frame = CGRect(x: titleX, y: nameTitle.frame.maxY, width: gender.bounds.width + 5, height: rowH)
        idNumTitle.frame = CGRect(x: titleX, y: gender.frame.maxY, width: idNumTitle.bounds.width + 5, height: rowH)
        let subtitleX : CGFloat = idNumTitle.frame.maxX + 10
        nameValue.frame = CGRect(x: subtitleX, y: nameTitle.frame.minY, width: view.bounds.width - subtitleX, height: rowH)
        
        male.frame = CGRect(x: subtitleX, y: gender.frame.minY, width: male.bounds.width, height: rowH)
        female.frame = CGRect(x: male.frame.maxX + 20, y: gender.frame.minY, width: female.bounds.width, height: rowH)
        
        idNumValue.frame = CGRect(x: subtitleX, y: idNumTitle.frame.minY, width: view.bounds.width - subtitleX, height: rowH)
        let lineH : CGFloat = 1
        line1.frame =  CGRect(x: 0, y: backView.frame.minY + rowH - lineH/2, width: view.bounds.width, height: lineH)
        line2.frame =  CGRect(x: 0, y: backView.frame.minY + rowH * 2 - lineH/2, width: view.bounds.width, height: lineH)
        bottomButton.layer.cornerRadius = bottomButton.bounds.height/2
        bottomButton.clipsToBounds = true
        
    }
}
