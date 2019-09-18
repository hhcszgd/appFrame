//
//  DDAuthenticatedVC.swift
//  YiLuMedia
//
//  Created by WY on 2019/9/10.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class DDAuthenticatedVC: DDInternalVC {
    let backgroundImage = UIImageView(image: UIImage(named: "profile_renzheng_bg_02"))
    let icon =  UIImageView(image: UIImage(named: "profile_renzheng_not_apply"))
    let authenticatedLogo = UIImageView(image: UIImage(named: "profile_label"))
    let midBackview = UIView()
    fileprivate let name = DDAuthenticatedRow()
    fileprivate let gender = DDAuthenticatedRow()
    fileprivate let idNum = DDAuthenticatedRow()
    fileprivate let idImage = DDAuthenticatedRow()
    fileprivate let rejectReason = DDAuthenticatedRow()
    var apiModel : ApiModel<DDAuthenticateInfo> = ApiModel<DDAuthenticateInfo>()
    let noauthVC: DDNotAuthenticateVC = DDNotAuthenticateVC()
    private let bottomButton = UIButton()
    var test : Int  = -2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = .clear
        let attributeTitle : NSMutableAttributedString = NSMutableAttributedString(string: "authenticate_navi_title"|?|)
        attributeTitle.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(0, attributeTitle.string.count))
        self.naviBar.attributeTitle = attributeTitle
        naviBar.backBtn.setImage(UIImage(named:"profile_return_white"), for: UIControl.State.normal)
        // Do any additional setup after loading the view.
        _addSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestApi()
    }
}
///action
extension DDAuthenticatedVC{
    func requestApi() {
//        self.view.removeAllMaskView(maskClass: DDExceptionView.self)
        DDRequestManager.share.authenticateInfo(type: ApiModel<DDAuthenticateInfo>.self, success: { (apiModel) in
            self.apiModel = apiModel
            if self.apiModel.data == nil {
                self.apiModel.data = DDAuthenticateInfo()
            }
            self._layoutSubviews()
        }, failure: { (error ) in
//            let vv = DDExceptionView()
//            vv.exception = DDExceptionModel(title:"数据异常,请点击重试",image:"notice_noinformation")
//            vv.manualRemoveAfterActionHandle = {
//                mylog("reload action")
//                self.requestApi()
//            }
//            self.view.alert(vv )
            self.view.alpha = 1
        })
    }
    @objc func buttonButtomAction(sender:UIButton)  {
        ///(-1、待提交 0、待审核 1、审核通过 2、审核不通过)
        let type = self.apiModel.data?.examine_status ?? "-1"
        if type == "1" {
            mylog("成功")
        }else if type == "0" {
            mylog("待審核")
        }else if type == "2" {
            let vc = DDPersonInfoVC()
            vc.personalInfo = self.apiModel.data
            self.navigationController?.pushViewController(vc , animated: true )
        }else if type == "-1"{
            mylog("待提交")
        }
    }
}
///ui
extension DDAuthenticatedVC{
    func _addSubviews() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(icon)
        self.view.addSubview(authenticatedLogo)
        self.view.addSubview(midBackview)
        self.view.addSubview(name)
        self.view.addSubview(gender)
        self.view.addSubview(idNum)
        self.view.addSubview(idImage)
        self.view.addSubview(rejectReason)
        self.view.addSubview(bottomButton)
        self.addChild(noauthVC)
        self.view.addSubview(noauthVC.view)
//        self.view.isHidden = true
        self.view.alpha = 0
        
//        name.model = ("authenticate_name"|?|,"Guarantee legitimate rights and interests")
//        gender.model = ("authenticate_gender"|?|,"Enjoy more privileges")
//        idNum.model = ("authenticate_idnum"|?|,"Increasing Income")
//        idImage.model = ("authenticate_idimage"|?|,"Increasing Income")
//        rejectReason.model = ("authenticate_reject_reason"|?|,"Increasing Income")
        rejectReason.bottomLine.isHidden = true
        bottomButton.setTitle("reauthenticate_perform"|?|, for: UIControl.State.normal)
        bottomButton.backgroundColor = UIColor.black
        midBackview.backgroundColor = .white
        bottomButton.addTarget(self , action: #selector(buttonButtomAction(sender:)), for: UIControl.Event.touchUpInside)
        authenticatedLogo.isHidden = true
    }
    
    func _layoutSubviews()  {
        icon.setImageUrl(url: apiModel.data?.avatar)
        name.model = ("authenticate_name"|?|,apiModel.data?.name ?? "")
        gender.model = ("authenticate_gender"|?|,(apiModel.data?.sex ?? "") == "1" ? "男" : "女")
        idNum.model = ("authenticate_idnum"|?|,apiModel.data?.id_number ?? "")
        idImage.model = ("authenticate_idimage"|?|,(apiModel.data?.name ?? "").count > 0 ? "authenticate_complete"|?| : "authenticate_not_complete"|?|)
        rejectReason.model = ("authenticate_reject_reason"|?|,apiModel.data?.examine_desc ?? "")
        
        
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * 0.7)
        let iconWH : CGFloat = 64 * SCALE
        icon.frame = CGRect(x:28 , y: DDNavigationBarHeight + 40, width: iconWH, height: iconWH)
        icon.layer.cornerRadius = iconWH/2
        icon.clipsToBounds = true 
        authenticatedLogo.frame = CGRect(x: icon.frame.maxX + 16, y: icon.frame.midY - 30/2, width: 68, height: 28)
        let midBackviewX : CGFloat = 20
        let midBackviewY = icon.frame.maxY + 26
        let midBackviewW = view.bounds.width - midBackviewX * 2
        let rowW = midBackviewW - 20 * 2
        
        let rowx : CGFloat = midBackviewX + 20
        let rowTopBottomMargin : CGFloat = 2
        let row1Y = midBackviewY + rowTopBottomMargin
        let rowMargin : CGFloat = 1
        
        let rowH : CGFloat = 38 * SCALE
        
        var midBackviewH : CGFloat = rowTopBottomMargin * 2 + rowH * 4 + rowMargin * 3
        ///(-1、待提交 0、待审核 1、审核通过 2、审核不通过)
        let type = self.apiModel.data?.examine_status ?? "-1"
        mylog(type)
        if type == "1" {
            authenticatedLogo.isHidden = false
            idImage.bottomLine.isHidden = true
            rejectReason.isHidden = true
            bottomButton.isHidden = true
            noauthVC.view.isHidden = true
        }else if type == "0" {
            idImage.bottomLine.isHidden = true
            authenticatedLogo.isHidden = true
            rejectReason.isHidden = true
            bottomButton.isHidden = false
            bottomButton.setTitle("padding_authenticate"|?|, for: UIControl.State.normal)
            bottomButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            noauthVC.view.isHidden = true
        }else if type == "2" {
            authenticatedLogo.isHidden = true
            midBackviewH = rowTopBottomMargin * 2 + rowH * 5 + rowMargin * 4
            idImage.bottomLine.isHidden = false
            rejectReason.isHidden = false
            bottomButton.isHidden = false
            bottomButton.setTitle("reauthenticate_perform"|?|, for: UIControl.State.normal)
            bottomButton.backgroundColor = .black
            noauthVC.view.isHidden = true
        }else if type == "-1"{
            noauthVC.view.isHidden = false
            mylog("待提交")
        }
//        self.view.isHidden = false
        self.view.alpha = 1
        midBackview.frame = CGRect(x: midBackviewX, y: midBackviewY, width:midBackviewW , height: midBackviewH)
        midBackview.layer.cornerRadius = 6
        midBackview.layer.shadowOpacity = 0.5
        midBackview.layer.shadowColor = UIColor.gray.cgColor
        midBackview.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        
        name.frame = CGRect(x: rowx, y: row1Y, width: rowW, height: rowH)
        gender.frame = CGRect(x: rowx, y: row1Y + rowH + rowMargin, width: rowW, height: rowH)
        idNum.frame = CGRect(x: rowx, y: row1Y + (rowH + rowMargin) * 2, width: rowW, height: rowH)
        idImage.frame =  CGRect(x: rowx, y: row1Y + (rowH + rowMargin) * 3, width: rowW, height: rowH)
        rejectReason.frame =  CGRect(x: rowx, y: row1Y + (rowH + rowMargin) * 4, width: rowW, height: rowH)
        bottomButton.frame = CGRect(x: 15, y: midBackview.frame.maxY + 30, width: view.bounds.width - 30, height: 40)
        bottomButton.layer.cornerRadius = bottomButton.bounds.height/2
    }
    
}

class DDAuthenticatedRow: UIView {
    var model : (title:String,subtitle:String) = (title:"",subtitle:"") {
        didSet{
            titleLabel.text = model.title
            subtitleLabel.text = model.subtitle
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    let bottomLine = UIView()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(bottomLine)
        titleLabel.font = DDFont.systemFont(ofSize: 15)
        subtitleLabel.font = DDFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.DDTitleColor
        subtitleLabel.textColor = UIColor.DDSubTitleColor
        subtitleLabel.textAlignment = .right
        bottomLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
//        subtitleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 0, width: titleLabel.bounds.width + 5, height: self.bounds.height)
        let subttileLableX = titleLabel.frame.maxX + 5
        subtitleLabel.frame = CGRect(x:subttileLableX , y: 0, width:bounds.width - subttileLableX, height: self.bounds.height)
        bottomLine.frame = CGRect(x: -20, y: self.bounds.height - 0.5, width: self.bounds.width + 40, height: 0.5)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
