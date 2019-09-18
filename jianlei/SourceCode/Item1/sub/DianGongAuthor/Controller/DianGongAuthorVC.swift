//
//  DianGongAuthorVC.swift
//  Project
//
//  Created by WY on 2019/8/8.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DianGongAuthorVC: DDNormalVC {
    var joinTeamAlert : DDJoinTeamAlert?
    var apiModel  : ApiModel<DianGongInfo>?
    let scrollView = UIScrollView()
    let nameTitle = TempLabel()
    let nameValue = TempTextField()
    
//    let tipsButton = UIButton()
    
    let sexTitle = TempLabel()
    let sexValue = TempTextField()
    
    let idNumTitle = TempLabel()
    let idNumValue = TempTextField()
    
    let dianGongNumTitle = TempLabel()
    let dianGongNumTextfield = TempTextField()
    ///原级别 , 现作业类别
    let levelTitle = TempLabel()
    let levelTextfield = TempTextField()
    ///原职业名称, 现准操项目
    let jobTitle = TempLabel()
    let jobTextfield = TempTextField()
    
    let fazhengdiquTitle = TempLabel()
    let fazhengdiquTextfield = TempTextField()
    
    let startTime = TempLabel()
    let startButton = UIButton()
    let endTime = TempLabel()
    let endButton = UIButton()
    
//    let addressTitle = TempLabel()
//    let addressCity = DDTextFieldWithArrow()
////    let arrowButton  = UIButton()
//
//    let addressDetail = TempTextField()
    
    let pictureTitle = TempLabel()
    
    let pictureCover = UIButton()
    let coverPictureDescrip = TempLabel()
    
    let pictureContent = UIButton()
    let contentPictureDescrip = TempLabel()
    
    let bottomContainer = UIView()
    let unusualTitle = UILabel()
    
    let rejectTitle = TempLabel()
    let rejectValue = TempLabel()
    var bottomGrayBlock = UIView()
    var bottomGrayBlockFrame = CGRect.zero
    let actionButton = UIButton()
    ///电工身份验证-1未提交，0待审核，1，审核通过，2审核不通过。
//    var electrician_examine_status: String?
    lazy var dianGongInfoWithTeam : DianGongInfoWithTeam = DianGongInfoWithTeam()
    lazy var dianGongInfoWithoutTeam : DianGongInfoWithoutTeam = DianGongInfoWithoutTeam()
    var originalViewModel  : ApiModel<DianGongInfo>?{
        didSet{
            if let m = originalViewModel{
                self.setContentToUI(apiModel: m )
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DG_installer_author_title"|?|
//        self.userInfo = "1"
//
//        if let status  = self.userInfo as? String {
//            if status == "-1"{//未提交
//                _addSubviews()
//            }else if status == "0"{//待审核
//                //0待审核，1，审核通过，2审核不通过。
//                _addSubviews()
//            }else if status == "1"{//审核通过
//                if let teamID = self.apiModel?.data?.team_member_id , teamID.count > 0{
//                    self.view =  DianGongInfoWithTeam()
//                }else{
//                    self.view = DianGongInfoWithoutTeam()
//
//                }
////                _addSubviews()
//            }else if status == "2"{//审核不通过
//                _addSubviews()
//            }
//        }
        self.view.backgroundColor = .white
        _addSubviews()
        mylog(self.userInfo)
        //
//        changeDianGongInfo()
        self.getDianGongInfo()
        self.view.addSubview(dianGongInfoWithTeam)
        dianGongInfoWithTeam.action = {
            [weak self ] in
            mylog("解散")
            self?.leaveTeam()
        }
        dianGongInfoWithTeam.frame = self.view.bounds
        self.view.addSubview(dianGongInfoWithoutTeam)
        dianGongInfoWithoutTeam.action = {
                [weak self ] in
                mylog("加入团队")
            self?.wheatherJoinTeam()
        }
        dianGongInfoWithoutTeam.frame = self.view.bounds
//        self.view.isHidden = true
        dianGongInfoWithTeam.isHidden = true
        dianGongInfoWithoutTeam.isHidden = true
    }
    
    func canEdit(isCanEdit:Bool) {
        self.dianGongNumTextfield.isUserInteractionEnabled = isCanEdit
        self.levelTextfield.isUserInteractionEnabled = isCanEdit
        self.jobTextfield.isUserInteractionEnabled = isCanEdit
//        self.addressDetail.isUserInteractionEnabled = isCanEdit
        self.pictureCover.isUserInteractionEnabled = isCanEdit
        self.pictureContent.isUserInteractionEnabled = isCanEdit
//        self.addressCity.isUserInteractionEnabled = isCanEdit
        self.fazhengdiquTextfield.isUserInteractionEnabled = isCanEdit
        self.endButton.isUserInteractionEnabled = isCanEdit
        self.startButton.isUserInteractionEnabled = isCanEdit
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.navigationBar.setNeedsLayout()
        mylog(self.navigationController?.navigationBar)
        mylog(self.navigationController?.navigationBar.frame)
//        if DDDevice.type == .iphoneX{
//            self.navigationController?.navigationBar.frame.origin.y = 40
//        }else{
//            self.navigationController?.navigationBar.frame.origin.y = 20
//        }
        if DDDevice.isFullScreen{
            self.navigationController?.navigationBar.frame.origin.y = 40
        }else{
            self.navigationController?.navigationBar.frame.origin.y = 20
        }
    }
}


/// actions
extension DianGongAuthorVC{
    @objc func nameTips(sender:UIButton) {
        
        if let status  = self.apiModel?.data?.electrician_examine_status {
            
            switch status{
            case "-1","2":
                let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                    print(action._title)
                })
                let message1  = "只能绑定该身份信息下的证件"
                let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
                alert.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert( alert)
            default:
                break
            }
        }
        
        
        
    }
    
    @objc func chooseAddress(sender:UIButton) {
//        let alert = DDSelectLiveAreaView()
//        alert.selectComplated = {[weak self ]  areaID , areaname  in
//            self?.apiModel?.data?.live_area_id = areaID
//            self?.addressCity.text = areaname
//        }
//        self.view.alert(alert)
        self.view.endEditing(true)
        
        if let status  = self.apiModel?.data?.electrician_examine_status {
            switch status{
            case "-1","2":
                let alert = DDAlertContainer()
                alert.isHideWhenWhitespaceClick = false
                self.view.alert(alert)
//                self.addressDetail.resignFirstResponder()
                //            sender.view?.isUserInteractionEnabled = false
                let frame = CGRect.init(x: 0, y: SCREENHEIGHT - 400 - TabBarHeight, width: SCREENWIDTH, height: 400)
                let view = AreaSelectView.init(superView: self.view, areaType: GetAreaType.area, subFrame: CGRect.init(x: 0, y: 200, width: SCREENWIDTH, height: SCREENHEIGHT - 200))
                    
                    
//                    AreaSelectView.init(frame: frame, title: "jj", type: 100, url: "area", subFrame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
                view.sureBtn.isHidden = true
                view.containerView.backgroundColor = lineColor
                self.view.addSubview(view)
                
                //            self.address.textColor = UIColor.colorWithHexStringSwift("333333")
                _ = view.finished.subscribe(onNext: { [weak self](address, id) in
                    alert.remove()
//                    self?.addressCity.textField.text = address
                    self?.apiModel?.data?.live_area_id = id
                    
                    //                sender.view?.isUserInteractionEnabled = true
                    view.removeFromSuperview()
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
            default:
                break
            }
        }
       
            
    }
    
    @objc func bottomAction(sender:UIButton) {
        if let status  = self.apiModel?.data?.electrician_examine_status {
            if status == "-1"{
                self.changeDianGongInfo()
            }else if status == "0"{
                //0待审核，1，审核通过，2审核不通过。
            }else if status == "1"{
                mylog("加入团队")
                self.wheatherJoinTeam()
            }else if status == "2"{
                self.changeDianGongInfo()
            }
        }
    }
    func leaveTeam()  {
        if let wait_shop_number = self.apiModel?.data?.wait_shop_number {
            if wait_shop_number == "0"{
                
                
                
                let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                    print(action._title)
                })
                
                let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                    
                    if let teamID = self.apiModel?.data?.team_id{
                        DDRequestManager.share.leaveTeam(type: ApiModel<String>.self, teamID: teamID, success: { (apiModel) in
                            self.getDianGongInfo()
                        }, failure: { (error ) in
                            
                        }, complate: {
                            
                        })
                        
//                        DDRequestManager.share.leaveTeam(teamID: teamID)?.responseJSON(completionHandler: { (response) in
//                            if let model = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self , from: response){
//                                if model.status == 200{
//                                    self.getDianGongInfo()
//                                }else{
//                                    GDAlertView.alert(model.message, image: nil , time: 3, complateBlock: nil)
//                                }
//                            }else{
//                                GDAlertView.alert("请求失败请重试", image: nil , time: 3, complateBlock: nil)
//                            }
//                        })
                    }
                })
                let message1  = "是否解除和小组的关系"
                
                let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"teamrelease"), actions:  [sure,cancel])
                
                alert.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert( alert)
                
                
                
                
                
                
                
                
                
                
                
                
                
            }else{
                let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                    print(action._title)
                })
                let message1  = "您还有指派任务未完成,无法退出小组.请您联系组长取消任务指派或完成安装任务"
                let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
                alert.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert( alert)
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        let sure = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action ) in
//
//
//        })
//        let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action ) in
//        })
//        self.alert(title: "确认解除绑定", detailTitle: nil, style: UIAlertControllerStyle.alert, actions: [sure , cancel])
//
//
        
    }
    func wheatherJoinTeam()  {
        let alert = DDJoinTeamAlert(title: "加入小组")
        self.joinTeamAlert = alert
        alert.confirmClick = {[weak self ] name , mobile in
            if (name ?? "").isEmpty{
                GDAlertView.alert("请填写小组组长", image: nil , time: 2, complateBlock: nil )
                return false
            }else if (mobile ?? "").isEmpty{
                GDAlertView.alert("请填写联系方式", image: nil , time: 2, complateBlock: nil )
                return false
            }
            self?.view.endEditing(true )
            self?.performJoinTeam(teamName: name ?? "", teamMobile: mobile ?? "")
            return false
        }
        
        self.view.alert(alert)
        
//        DDKeyBoardHandler.share.setViewToBeDealt(containerView: alert.subviewsContainer, inPutView: alert.contactTypeTextField)
    }
    
    func performJoinTeam(teamName : String , teamMobile : String ) {
        DDRequestManager.share.joinTeam(type: ApiModel<[String:String]>.self, team_member_name: teamName, team_member_mobile: teamMobile, success: { (apiModel) in
            if apiModel.status == 200 {
                self.joinTeamAlert?.remove()
                let alert = DDAutoDisappearAlert1(message: "加入小组成功,您已是小组成员", image: UIImage(named:"jointheteam"))
                alert.deinitHandle = {[weak self ] in
                    self?.getDianGongInfo()
                }
                self.view.alert(alert)
            }else{
                self.joinTeamAlert?.noticeMessage.text = apiModel.message
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.joinTeamAlert?.noticeMessage.text = nil
                })
            }
        }, failure: { (error ) in
            
        }) {
            
        }
        
//        DDRequestManager.share.joinTeam(team_member_name: teamName, team_member_mobile: teamMobile)?.responseJSON(completionHandler: { (response) in
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<[String:String]>.self, from: response){
//                mylog(apiModel.data)
//                if apiModel.status == 200 {
//                    self.joinTeamAlert?.remove()
//                    let alert = DDAutoDisappearAlert1(message: "加入小组成功,您已是小组成员", image: UIImage(named:"jointheteam"))
//                    alert.deinitHandle = {[weak self ] in
//                        self?.getDianGongInfo()
//                    }
//                    self.view.alert(alert)
//                }else{
//                    self.joinTeamAlert?.noticeMessage.text = apiModel.message
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
//                            self.joinTeamAlert?.noticeMessage.text = nil
//                    })
//                }
//            }
//        })
        
        
//        var isSuccess = true
//        if isSuccess{
//            self.joinTeamAlert?.remove()
//            let alert = DDAutoDisappearAlert1(message: "加入团队成功,您已是团队成员", image: UIImage(named:"jointheteam"))
//            self.view.alert(alert)
//        }else{
//            self.joinTeamAlert?.noticeMessage.text = "驳回原因:xxxxxxxx"
//        }
        
    }
    @objc func coverImageAction(sender:UIButton) {
       
        if let status  = self.apiModel?.data?.electrician_examine_status {
            
            switch status{
            case "-1","2":
                self.uploadImage1(imageid: "1")
            default:
                break
            }
        }
    }
    
    @objc func contentImageAction(sender:UIButton) {
        
        if let status  = self.apiModel?.data?.electrician_examine_status {
            
            switch status{
            case "-1","2":
                self.uploadImage1(imageid: "2")
            default:
                break
            }
        }
    }
    
    func addWaterImage(_ waterImage : UIImage , in backgroundImage : UIImage) -> UIImage {
        let backgroundImage = backgroundImage.compressImageQuality(quality: 0.1)
        let img = backgroundImage.compressImageSize()
        let img2 = img.addWaterImage(waterImage , waterImageRect : nil )
        let img3 = img2.compressImageQuality(quality: 0.1)
        let img4 = img3.compressImageSize()
        return img4
    }
    func uploadImage1(imageid: String) {
//        SystemMediaPicker.share.selectMovie().pickMovieCompletedHandler = { movieData  in
//            let image = UIImage(named:"")
        SystemMediaPicker.share.selectImage().pickImageCompletedHandler = { image in
            if let img = image {
                if imageid == "1"{//封面
                    self.pictureCover.setImage(image, for: UIControl.State.normal)
                    self.coverPictureDescrip.isHidden = true
                }else{//内容
                    self.pictureContent.setImage(image, for: UIControl.State.normal)
                    self.contentPictureDescrip.isHidden = true
                }
                DispatchQueue.global().async(execute: {
                    
                    let whater = UIImage.init(named: "water")
                    let totalImage = self.addWaterImage(whater!, in: img)
//                    GDAlertView.alert(nil , image: totalImage, time: 3, complateBlock: nil )
//                    DDRequestManager.share.uploadMediaToTencentYun(image: totalImage, progressHandler: {
                    DDRequestManager.share.uploadShopAdMediaToTencentYun(image: totalImage, progressHandler: {
                        
                        (a, b, c) in
//                        let propert: String = String.init(format: "%0.0f", Float(b) / Float(c) * 100)
                        
                    }, compateHandler: { (imageStr , dataSize ,sha1HexStr) in
                        mylog(imageStr)
                        let imgStr = imageStr ?? ""
                        if imgStr == "failure" {
                            DispatchQueue.main.async {
                                self.pictureCover.setImage(UIImage(named:"addinstallation"), for: UIControl.State.normal)
                                self.pictureContent.setImage(UIImage(named:"addinstallation"), for: UIControl.State.normal)
                                self.coverPictureDescrip.isHidden = false
                                self.contentPictureDescrip.isHidden = false
                                
                            }
                            return
                        }
                        if imageid == "1"{//封面
                            self.pictureCover.setImage(totalImage, for: UIControl.State.normal)
                            self.coverPictureDescrip.isHidden = true
                            self.apiModel?.data?.electrician_certificate_front_image = imgStr
                        }else{//内容
                            self.apiModel?.data?.electrician_certificate_back_image = imgStr
                            self.pictureContent.setImage(totalImage, for: UIControl.State.normal)
                            self.contentPictureDescrip.isHidden = true
                        }
                        
                        
                    })
                })
                
            }else{/*获取图片失败*/}
        }
        
    }
//    func uploadImage1(imageid: String) {
//        upload.current = self
//        upload.changeHeadPortrait()
//        upload.finished = { (image) in
//            if let img = image {
//                if imageid == "1"{//封面
//                    self.pictureCover.setImage(image, for: UIControl.State.normal)
//                    self.coverPictureDescrip.isHidden = true
//                }else{//内容
//                    self.pictureContent.setImage(image, for: UIControl.State.normal)
//                    self.contentPictureDescrip.isHidden = true
//                }
//                DispatchQueue.global().async(execute: {
//
//                    let whater = UIImage.init(named: "water.png")
//                    let totalImage = self.addWaterImage(whater!, in: img)
//
//                    DDRequestManager.share.uploadMediaToTencentYun(image: totalImage, progressHandler: { (a, b, c) in
//                        let propert: String = String.init(format: "%0.0f", Float(b) / Float(c) * 100)
//
//                    }, compateHandler: { (imageStr) in
//                        mylog(imageStr)
//                        let imgStr = imageStr ?? ""
//                        if imgStr == "failure" {
//                            DispatchQueue.main.async {
//                                self.pictureCover.setImage(UIImage(named:"addinstallation"), for: UIControl.State.normal)
//                                self.pictureContent.setImage(UIImage(named:"addinstallation"), for: UIControl.State.normal)
//                                self.coverPictureDescrip.isHidden = false
//                                self.contentPictureDescrip.isHidden = false
//
//                            }
//                            return
//                        }
//                        if imageid == "1"{//封面
//                            self.pictureCover.setImage(image, for: UIControl.State.normal)
//                            self.coverPictureDescrip.isHidden = true
//                            self.apiModel?.data?.electrician_certificate_front_image = imgStr
//                        }else{//内容
//                            self.apiModel?.data?.electrician_certificate_back_image = imgStr
//                            self.pictureContent.setImage(image, for: UIControl.State.normal)
//                            self.contentPictureDescrip.isHidden = true
//                        }
//
//
//                    })
//                })
//
//            }else{/*获取图片失败*/}
//
//        }
//
//    }
    
    
}
/// user-interface setup
extension DianGongAuthorVC {
    func _addSubviews() {

        nameValue.isUserInteractionEnabled = false
        sexValue.isUserInteractionEnabled = false
        idNumValue.isUserInteractionEnabled = false
        self.view.addSubview(scrollView)
        scrollView.addSubview(nameTitle)
        nameTitle.text = "DG_name_title"|?|
        scrollView.addSubview(nameValue)
//        scrollView.addSubview(tipsButton)
//        tipsButton.setImage(UIImage(named:"exclamationmarkicon"), for: UIControl.State.normal)
//        tipsButton.addTarget(self , action:#selector(nameTips(sender:)), for: UIControl.Event.touchUpInside)
//        maxY = _addLine(maxY: 0)
        scrollView.addSubview(sexTitle)
        sexTitle.text = "DG_gender_title"|?|
        scrollView.addSubview(sexValue)
//        maxY = _addLine(maxY: 0)
        scrollView.addSubview(idNumTitle)
        idNumTitle.text = "DG_id_num_title"|?|
        scrollView.addSubview(idNumValue)
        self.nameValue.textColor = UIColor.DDSubTitleColor
        self.sexValue.textColor = UIColor.DDSubTitleColor
        self.idNumValue.textColor = UIColor.DDSubTitleColor
//        maxY = _addLine(maxY: 0)
        scrollView.addSubview(dianGongNumTitle)
        dianGongNumTitle.text = "DG_register_num_title"|?|
        scrollView.addSubview(dianGongNumTextfield)
        dianGongNumTextfield.placeholder = "DG_register_num_placeholder"|?|
//        maxY = _addLine(maxY: 0)
        scrollView.addSubview(levelTitle)
//        levelTitle.text = "级别"
        levelTitle.text = "DG_project_level_title"|?|
        scrollView.addSubview(levelTextfield)
//        levelTextfield.placeholder = "填写证件级别(选填)"
        levelTextfield.placeholder = "DG_project_level_placeholder"|?|
//        maxY = _addLine(maxY: 0)
        scrollView.addSubview(jobTitle)
//        jobTitle.text = "职业名称"
        jobTitle.text = "DG_allow_project_title"|?|
        scrollView.addSubview(jobTextfield)
//        jobTextfield.placeholder = "填写职业名称"
        jobTextfield.placeholder = "DG_allow_project_placeholder"|?|
        
        fazhengdiquTitle.text = "DG_qianfajigou_title"|?|
        scrollView.addSubview(fazhengdiquTitle)
        fazhengdiquTextfield.placeholder = "DG_qianfajigou_placeholder"|?|
        scrollView.addSubview(fazhengdiquTextfield)
        
        
        
        scrollView.addSubview(startTime)
        startTime.text = "DG_start_date"|?|
        scrollView.addSubview(startButton)
        startButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        startButton.setTitleColor(UIColor.lightGray, for: UIControl.State.selected)
        startButton.setTitle("DG_select_date"|?|, for: UIControl.State.normal)
        startButton.setBackgroundImage(UIImage.ImageWithColor(color: UIColor.orange, frame: CGRect(x: 0, y: 0, width: 88, height: 44)), for: UIControl.State.normal)
        startButton.setBackgroundImage(UIImage.ImageWithColor(color: UIColor.clear, frame: CGRect(x: 0, y: 0, width: 88, height: 44)), for: UIControl.State.selected)
        startButton.addTarget(self , action: #selector(selectStartTime(sender:)), for: UIControl.Event.touchUpInside)
        endButton.addTarget(self , action: #selector(selectEndTime(sender:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(endTime)
        endTime.text = "DG_end_date"|?|
        scrollView.addSubview(endButton)
        endButton.setTitle("DG_select_date"|?|, for: UIControl.State.normal)
        endButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        endButton.setTitleColor(UIColor.lightGray, for: UIControl.State.selected)
        endButton.setBackgroundImage(UIImage.ImageWithColor(color: UIColor.orange, frame: CGRect(x: 0, y: 0, width: 88, height: 44)), for: UIControl.State.normal)
        endButton.setBackgroundImage(UIImage.ImageWithColor(color: UIColor.clear, frame: CGRect(x: 0, y: 0, width: 88, height: 44)), for: UIControl.State.selected)
        
        nameValue.textAlignment = .right
        sexValue.textAlignment = .right
        idNumValue.textAlignment = .right
        dianGongNumTextfield.textAlignment = .right
        levelTextfield.textAlignment = .right
        jobTextfield.textAlignment = .right
        fazhengdiquTextfield.textAlignment = .right
//        scrollView.addSubview(addressTitle)
//        addressTitle.text = "现住地址"
//        scrollView.addSubview(addressCity)
//        addressCity.textField.placeholder = "选择地区"
//        addressCity.addTarget(self , action: #selector(chooseAddress(sender:)), for: UIControl.Event.touchUpInside)
//        scrollView.addSubview(addressDetail)
//        addressDetail.placeholder = "详细地址"
        
        scrollView.addSubview(pictureTitle)
        pictureTitle.text = "DG_diangongzheng_title"|?|
        
        scrollView.addSubview(pictureCover)
        pictureCover.addTarget(self , action:#selector(coverImageAction(sender:)), for: UIControl.Event.touchUpInside)
//        pictureCover.addSubview(coverPictureDescrip)
        scrollView.addSubview(coverPictureDescrip)
        pictureCover.setImage(UIImage(named:"addinstallation"), for: UIControl.State.normal)
        coverPictureDescrip.font = UIFont.systemFont(ofSize: 13)
        coverPictureDescrip.text = "DG_upload_img_notice"|?|
        coverPictureDescrip.textAlignment = .left
        coverPictureDescrip.numberOfLines = 3
        scrollView.addSubview(pictureContent)
        pictureContent.addTarget(self , action:#selector(contentImageAction(sender:)), for: UIControl.Event.touchUpInside)
        pictureContent.setImage(UIImage(named:"addinstallation"), for: UIControl.State.normal)
        pictureContent.addSubview(contentPictureDescrip)
        contentPictureDescrip.font = UIFont.systemFont(ofSize: 13)
        contentPictureDescrip.text = "DG_upload_img_notice"|?|
        contentPictureDescrip.textAlignment = .center
        self.view.addSubview(bottomContainer)
        
        rejectTitle.text = "DG_reject_reason"|?|
        rejectValue.text = ""
        rejectValue.textAlignment = .right
        scrollView.addSubview(rejectTitle)
        scrollView.addSubview(rejectValue)
        rejectValue.font = UIFont.systemFont(ofSize: 14)
        rejectValue.textColor = UIColor.lightText
        
        bottomContainer.addSubview(unusualTitle)
        unusualTitle.textAlignment = .center
        unusualTitle.textColor = UIColor.red
        unusualTitle.font = UIFont.systemFont(ofSize: 14)
        
//        unusualTitle.text = "驳回原因:证件信息不存在"
        bottomContainer.addSubview(actionButton)
//        actionButton.backgroundColor = .orange
        let actionButtonImageBounds = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 64 * SCALE)
        let normalImage = UIImage(gradientColors: [UIColor.colorWithHexStringSwift("fbec35"),UIColor.colorWithHexStringSwift("f5aa34")], bound: actionButtonImageBounds)
        let disableImage = UIImage(gradientColors: [UIColor.colorWithHexStringSwift("cbcccd"),UIColor.colorWithHexStringSwift("cacbcc")], bound: actionButtonImageBounds)
        actionButton.setBackgroundImage(normalImage, for: UIControl.State.normal)
        actionButton.setBackgroundImage(disableImage, for: UIControl.State.disabled)
        actionButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        actionButton.setTitleColor(UIColor.white, for: UIControl.State.disabled)
        actionButton.addTarget(self , action:#selector(bottomAction(sender:)), for: UIControl.Event.touchUpInside)
        bottomContainer.backgroundColor = UIColor.white
        if let status  = self.userInfo as? String {// self.apiModel?.data?.electrician_examine_status {
            if status == "-1"{
//                pictureCover.addSubview(coverPictureDescrip)
//                pictureContent.addSubview(contentPictureDescrip)
//                pictureContent.addTarget(self , action:#selector(contentImageAction(sender:)), for: UIControl.Event.touchUpInside)
//                pictureCover.addTarget(self , action:#selector(coverImageAction(sender:)), for: UIControl.Event.touchUpInside)
//                arrowButton.addTarget(self , action: #selector(chooseAddress(sender:)), for: UIControl.Event.touchUpInside)
                actionButton.setTitle("DG_upload_author_info"|?|, for: UIControl.State.normal)
            }else if status == "0"{
                //0待审核，1，审核通过，2审核不通过。
//                unusualTitle.text = "待审核"
                actionButton.setTitle("DG_checking"|?|, for: UIControl.State.normal)
            }else if status == "1"{
//                self.actionButton.setTitle("加入小组", for: UIControl.State.normal)
                self.actionButton.setTitle("DG_passed"|?|, for: UIControl.State.normal)
            }else if status == "2"{
//                pictureContent.addTarget(self , action:#selector(contentImageAction(sender:)), for: UIControl.Event.touchUpInside)
//                pictureCover.addTarget(self , action:#selector(coverImageAction(sender:)), for: UIControl.Event.touchUpInside)
//                arrowButton.addTarget(self , action: #selector(chooseAddress(sender:)), for: UIControl.Event.touchUpInside)
//                unusualTitle.text = self.apiModel?.data?.examine_desc
                actionButton.setTitle("DG_modify_author_info"|?|, for: UIControl.State.normal)
            }
        }
        _layoutSubviews()
    }
    
    @objc func selectStartTime(sender:UIButton)  {
        let alert = DDTimeSelectView()
//        let dateFormater:  DateFormatter = DateFormatter()
//        dateFormater.dateFormat = "yyyy/MM/dd"
//        let s = dateFormater.date(from: "2019/8/01")
        alert.timePicker.maximumDate =  Date()
        alert.timePicker.minimumDate = nil
        alert.done = {[weak self ] date in
            let dateFormater:  DateFormatter = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            let string = dateFormater.string(from: date)
            if !sender.isSelected{
                sender.frame.origin.x -= 40
                sender.frame.size.width += 40
                sender.contentHorizontalAlignment = .right
            }
            sender.isSelected = true
            sender.setTitle(string, for: UIControl.State.selected)
        }
        self.view.alert(alert)
    }
    @objc func selectEndTime(sender:UIButton)  {
        let alert = DDTimeSelectView()
        alert.timePicker.maximumDate =  nil
        alert.timePicker.minimumDate = Date()
        alert.done = {[weak self ] date in
            let dateFormater:  DateFormatter = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            let string = dateFormater.string(from: date)
            if !sender.isSelected{
                sender.frame.origin.x -= 40
                sender.frame.size.width += 40
                sender.contentHorizontalAlignment = .right
            }
            sender.isSelected = true
            sender.setTitle(string, for: UIControl.State.selected)

        }
        self.view.alert(alert)
    }
    
    func _layoutSubviews() {
        
        let bottomContainerH : CGFloat = 64 * SCALE
        bottomContainer.frame = CGRect(x: 0, y: SCREENHEIGHT - bottomContainerH, width: SCREENWIDTH, height: bottomContainerH)
//        unusualTitle.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 20)
        actionButton.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: bottomContainerH)
//        actionButton.embellishView(redius: 5)
        scrollView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - bottomContainerH)
        
        var maxY : CGFloat = 0
        let titleMaxW = "DG_diangongzheng_title"|?|.sizeSingleLine(font: nameTitle.font).width
        let horizontalMargin : CGFloat = 15
        nameTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
//        tipsButton.frame = CGRect(x: SCREENWIDTH - horizontalMargin - 40, y: nameTitle.frame.minY, width: 40, height: 40)
        nameValue.frame = CGRect(x: nameTitle.frame.maxX, y: nameTitle.frame.minY, width: SCREENWIDTH - nameTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = _addLine(maxY: nameTitle.frame.maxY)
        
        sexTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        sexValue.frame = CGRect(x: sexTitle.frame.maxX, y: maxY, width: SCREENWIDTH - sexTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = _addLine(maxY: sexTitle.frame.maxY)
        
        idNumTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        idNumValue.frame = CGRect(x: idNumTitle.frame.maxX, y: maxY, width: SCREENWIDTH - idNumTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = _addLine(maxY: idNumTitle.frame.maxY)
        
        dianGongNumTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        dianGongNumTextfield.frame = CGRect(x: dianGongNumTitle.frame.maxX, y: maxY, width: SCREENWIDTH - dianGongNumTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = _addLine(maxY: dianGongNumTitle.frame.maxY)
        
        levelTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        levelTextfield.frame = CGRect(x: levelTitle.frame.maxX, y: maxY, width: SCREENWIDTH - levelTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = _addLine(maxY: levelTitle.frame.maxY)
        
        jobTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        jobTextfield.frame = CGRect(x: jobTitle.frame.maxX, y: maxY, width: SCREENWIDTH - jobTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = _addLine(maxY: jobTitle.frame.maxY)
        
        ///新增
        fazhengdiquTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        fazhengdiquTextfield.frame = CGRect(x: fazhengdiquTitle.frame.maxX, y: maxY, width: SCREENWIDTH - fazhengdiquTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = _addLine(maxY: fazhengdiquTextfield.frame.maxY)
        
        
        startTime.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        startButton.frame = CGRect(x: scrollView.bounds.width - horizontalMargin - 88, y: startTime.frame.minY + 3, width: 88, height: 34)
        startButton.layer.cornerRadius = 5
        startButton.layer.masksToBounds = true
        maxY = _addLine(maxY: startTime.frame.maxY)
        
        endTime.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        endButton.frame = CGRect(x: scrollView.bounds.width - horizontalMargin - 88, y: endTime.frame.minY + 3, width: 88, height: 34)
        maxY = _addLine(maxY: endTime.frame.maxY)
        endButton.layer.cornerRadius = 5
        endButton.layer.masksToBounds = true
        
//        addressTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
//        addressCity.frame = CGRect(x: addressTitle.frame.maxX, y: addressTitle.frame.minY, width: SCREENWIDTH - addressTitle.frame.maxX, height: 40)
//        maxY = _addLine(maxY: addressTitle.frame.maxY)
//        addressDetail.frame = CGRect(x: addressTitle.frame.maxX, y: maxY, width: SCREENWIDTH - jobTitle.frame.maxX, height: 40)
//        maxY = _addLine(maxY: addressDetail.frame.maxY)
        
        pictureTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        maxY =  pictureTitle.frame.maxY + 10
        
        
        let pictureLeftMargin : CGFloat = 50
        let betweenPictureMargin : CGFloat = 20
        let pictureCoverW = (SCREENWIDTH - horizontalMargin * 2 - pictureTitle.frame.maxX - pictureLeftMargin - betweenPictureMargin ) / 2
        let pictureCoverX =  pictureTitle.frame.maxX + pictureLeftMargin + horizontalMargin
        pictureCover.frame = CGRect(x: pictureCoverX, y: pictureTitle.frame.minY + 12, width:pictureCoverW, height: pictureCoverW)
        //        pictureCover.setImage(UIImage(named:"addtoicon"), for: UIControl.State.normal)
        pictureCover.backgroundColor = UIColor.gray(0.12)
        coverPictureDescrip.frame = CGRect(x: horizontalMargin, y: pictureTitle.frame.maxY - 10 , width: pictureCover.frame.minX - horizontalMargin , height: 44)
        
        pictureContent.frame = CGRect(x: pictureCover.frame.maxX + betweenPictureMargin, y: pictureCover.frame.minY, width: pictureCoverW, height: pictureCoverW)
        //        pictureContent.setImage(UIImage(named:"addtoicon"), for: UIControl.State.normal)
        pictureContent.backgroundColor = UIColor.gray(0.12)
//        contentPictureDescrip.frame = CGRect(x: 0, y: pictureContent.bounds.height - 30, width: pictureContent.bounds.width, height: 20)
        
        /*
        let pictureLeftMargin : CGFloat = 44
        pictureCover.frame = CGRect(x: pictureLeftMargin, y: maxY, width: SCREENWIDTH - pictureLeftMargin * 2, height: SCREENWIDTH/2)
//        pictureCover.setImage(UIImage(named:"addtoicon"), for: UIControl.State.normal)
        pictureCover.backgroundColor = UIColor.gray(0.12)
        coverPictureDescrip.frame = CGRect(x: 0, y: pictureCover.bounds.height - 30, width: pictureCover.bounds.width, height: 20)
        
        maxY = pictureCover.frame.maxY + 20
        pictureContent.frame = CGRect(x: pictureLeftMargin, y: maxY, width: SCREENWIDTH - pictureLeftMargin * 2, height: SCREENWIDTH/2)
//        pictureContent.setImage(UIImage(named:"addtoicon"), for: UIControl.State.normal)
        pictureContent.backgroundColor = UIColor.gray(0.12)
        contentPictureDescrip.frame = CGRect(x: 0, y: pictureContent.bounds.height - 30, width: pictureContent.bounds.width, height: 20)
        */
        
        
        maxY = pictureContent.frame.maxY + 30
        maxY = _addLine(maxY: maxY, lineHeight : 22)
        rejectTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        rejectValue.frame = CGRect(x: rejectTitle.frame.maxX, y: maxY, width: SCREENWIDTH - rejectTitle.frame.maxX - horizontalMargin, height: 40)
        maxY = rejectValue.frame.maxY
        
        scrollView.contentSize = CGSize(width: SCREENWIDTH, height: maxY)
        _addLine(maxY: maxY , lineHeight : 444)

    }
    func _addLine(maxY:CGFloat , lineHeight : CGFloat = 1.3) -> CGFloat {
        let line = UIView()
        let margin : CGFloat = 10
        line.frame = CGRect(x: 0, y: maxY, width: SCREENWIDTH  , height: lineHeight)
        line.backgroundColor = UIColor.DDLightGray
        self.scrollView.addSubview(line)
        if lineHeight == 444 {
            self.bottomGrayBlockFrame = line.frame
            self.bottomGrayBlock = line
        }
        return line.frame.maxY
    }
    
}

/// interaction with server
extension DianGongAuthorVC {
    func getDianGongInfo() {
        //获取
        DDRequestManager.share.getDianGongInfo(type: ApiModel<DianGongInfo>.self,  success: { (apiModel) in
            ///////测试各种状态 , 等待删除//////
//            apiModel.data?.electrician_examine_status = "2"
            ///////测试各种状态 , 等待删除//////
            
            
            self.apiModel = apiModel
            self.setContentToUI(apiModel: apiModel)
            //                self.nameValue.text = self.apiModel?.data?.name
            //                self.sexValue.text = self.apiModel?.data?.sex
            //                self.idNumValue.text = self.apiModel?.data?.id_number
            let tempStatus = apiModel.data?.electrician_examine_status
            if let status = tempStatus{
                ///电工身份验证-1未提交，0待审核，1，审核通过，2审核不通过。
                switch status{
                case "-1"://未提交，
                    self.canEdit(isCanEdit: true)
                    self.dianGongInfoWithTeam.isHidden = true
                    self.dianGongInfoWithoutTeam.isHidden = true
                    self.originalViewModel = apiModel
                case "0"://待审核
                    self.canEdit(isCanEdit: false)
                    self.dianGongInfoWithTeam.isHidden = true
                    self.dianGongInfoWithoutTeam.isHidden = true
                    self.originalViewModel = apiModel
                case "1"://审核通过
                    self.view.bringSubviewToFront(self.bottomContainer)
                    if let teamID = self.apiModel?.data?.team_id , teamID.count > 0 {
                        if (self.apiModel?.data?.team_member_id ?? "404") == (DDAccount.share.id ?? ""){
                            mylog("自己创建的团队")
                            self.dianGongInfoWithoutTeam.joinTeamButton.isHidden = true
                            self.dianGongInfoWithTeam.isHidden = true
                            self.dianGongInfoWithoutTeam.isHidden = false
                            self.dianGongInfoWithoutTeam.apiModel = apiModel
                        }else{//别人创建的团队
                            self.dianGongInfoWithoutTeam.joinTeamButton.isHidden = false
                            self.dianGongInfoWithTeam.isHidden = false
                            self.dianGongInfoWithoutTeam.isHidden = true
                            self.dianGongInfoWithTeam.apiModel = apiModel
                        }
                        //                            self.dianGongInfoWithoutTeam.joinTeamButton.isHidden = true
                    }else{//没有加入也没有创建团队
                        self.dianGongInfoWithTeam.isHidden = true
                        self.dianGongInfoWithoutTeam.isHidden = false
                        self.dianGongInfoWithoutTeam.apiModel = apiModel
                    }
                    break
                case "2"://审核不通过
                    self.canEdit(isCanEdit: true)
                    self.dianGongInfoWithTeam.isHidden = true
                    self.dianGongInfoWithoutTeam.isHidden = true
                    self.originalViewModel = apiModel
                default:
                    print("xxx")
                }
            }
        }, failure: { (error ) in
            
        })
    }
    func setContentToUI(apiModel:ApiModel<DianGongInfo>) {
        self.nameValue.text = apiModel.data?.name
        self.sexValue.text = (apiModel.data?.sex ?? "1") == "1" ? "DG_male"|?| : "DG_female"|?|
        self.idNumValue.text = apiModel.data?.id_number
        
//        self.levelTextfield.text = apiModel.data?.electrician_certificate_level
        let number = (self.apiModel?.data?.electrician_certificate_number ?? "" ).count > 0
        self.levelTextfield.text  = ( (self.apiModel?.data?.electrician_certificate_type ?? "" ).isEmpty && number ) ? "-" :self.apiModel?.data?.electrician_certificate_type
        self.jobTextfield.text = ((apiModel.data?.professional_name ?? "" ).isEmpty && number ) ? "-" : apiModel.data?.professional_name
        self.fazhengdiquTextfield.text = ((apiModel.data?.electrician_certificate_area_name ?? "").isEmpty && number) ? "-" : apiModel.data?.electrician_certificate_area_name
        self.dianGongNumTextfield.text  = apiModel.data?.electrician_certificate_number
//        self.addressCity.textField.text = apiModel.data?.live_area_name
//        self.addressDetail.text = apiModel.data?.live_address
        if let str =  apiModel.data?.examine_desc , str.count > 0{
            
//            self.unusualTitle.text = "驳回原因: " + (apiModel.data?.examine_desc ?? "")
            rejectValue.text =  (apiModel.data?.examine_desc ?? "")
        }
//        let imglink = "http://i1.bjyltf.com/function/default_avatar.jpg"
        if let url = URL(string: apiModel.data?.electrician_certificate_front_image ?? "")
//        if let url = URL(string: imglink)
        {
            self.pictureCover.sd_setImage(with: url, for: UIControl.State.normal, completed: { (img , error , cachType, url ) in
                
            })
            
        }
        if let url = URL(string: apiModel.data?.electrician_certificate_back_image ?? ""){
            self.pictureContent.sd_setImage(with: url, for: UIControl.State.normal, completed: { (img , error , cachType, url ) in
                
            })
            
        }
        self.bottomGrayBlock.frame.origin.y = self.bottomGrayBlockFrame.origin.y - rejectTitle.bounds.height
        if let status  = self.apiModel?.data?.electrician_examine_status {
            if status == "-1"{
                actionButton.setTitle("DG_upload_author_info"|?|, for: UIControl.State.normal)
                actionButton.isEnabled = true
                self.coverPictureDescrip.isHidden = false
                self.contentPictureDescrip.isHidden = false
                
            }else if status == "0"{
                actionButton.setTitle("DG_checking"|?|, for: UIControl.State.normal)
                actionButton.isEnabled = false
                self.coverPictureDescrip.isHidden = true
                self.contentPictureDescrip.isHidden = true
                if !startButton.isSelected{
                    startButton.frame.origin.x -= 40
                    startButton.frame.size.width += 40
                    startButton.contentHorizontalAlignment = .right
                    startButton.isSelected = true
                    startButton.setTitle(apiModel.data?.electrician_expire_start, for: UIControl.State.selected)
                    
                }
                if !endButton.isSelected{
                    endButton.frame.origin.x -= 40
                    endButton.frame.size.width += 40
                    endButton.contentHorizontalAlignment = .right
                    endButton.isSelected = true
                    endButton.setTitle(apiModel.data?.electrician_expire_end, for: UIControl.State.selected)
                }
                
            }else if status == "1"{
                actionButton.setTitle("DG_passed"|?|, for: UIControl.State.normal)
                actionButton.isEnabled = false
                //                self.actionButton.setTitle("加入小组", for: UIControl.State.normal)
                self.coverPictureDescrip.isHidden = true
                self.contentPictureDescrip.isHidden = true
            }else if status == "2"{
                rejectTitle.text = "DG_reject_reason"|?|
                rejectValue.text =  (apiModel.data?.examine_desc ?? "unknown")
                self.bottomGrayBlock.frame.origin.y = self.bottomGrayBlockFrame.origin.y
                self.coverPictureDescrip.isHidden = true
                self.contentPictureDescrip.isHidden = true
                if let str =  apiModel.data?.examine_desc , str.count > 0{
                    self.unusualTitle.text = "\("DG_reject_reason"|?|): " + (apiModel.data?.examine_desc ?? "")
                }
//                unusualTitle.text = "驳回原因: " + (self.apiModel?.data?.examine_desc ?? "")
                actionButton.setTitle("DG_modify_author_info"|?|, for: UIControl.State.normal)
                actionButton.isEnabled = true
                if !startButton.isSelected{
                    startButton.frame.origin.x -= 40
                    startButton.frame.size.width += 40
                    startButton.contentHorizontalAlignment = .right
                    startButton.isSelected = true
                    startButton.setTitle(apiModel.data?.electrician_expire_start, for: UIControl.State.selected)
                    
                }
                if !endButton.isSelected{
                    endButton.frame.origin.x -= 40
                    endButton.frame.size.width += 40
                    endButton.contentHorizontalAlignment = .right
                    endButton.isSelected = true
                    endButton.setTitle(apiModel.data?.electrician_expire_end, for: UIControl.State.selected)
                }
            }
        }
        
        
        
    }
    func changeDianGongInfo() {
        ///修改
//        self.apiModel?.data?.electrician_certificate_back_image = "http://i1.bjyltf.com/sysfunc/20180713/95791531446191.png"
//        self.apiModel?.data?.electrician_certificate_front_image = "http://i1.bjyltf.com/sysfunc/20180713/95791531446191.png"
        if (dianGongNumTextfield.text ?? "").isEmpty  {
            GDAlertView.alert("DG_register_num_placeholder"|?|, image: nil, time: 2, complateBlock: nil)
            return
            
        }else if (levelTextfield.text  ?? "").isEmpty {
            GDAlertView.alert("DG_project_level_placeholder"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if (jobTextfield.text  ?? "").isEmpty {
            GDAlertView.alert("DG_allow_project_placeholder"|?|, image: nil, time: 2, complateBlock: nil)//职业名称
            return
        }else if (fazhengdiquTextfield.text  ?? "").isEmpty {
            GDAlertView.alert("DG_qianfajigou_placeholder"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if (startButton.title(for: UIControl.State.selected) ?? "").isEmpty  {
            GDAlertView.alert("DG_start_date_notice"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else if (endButton.title(for: UIControl.State.selected) ?? "").isEmpty  {
            GDAlertView.alert("DG_end_date_notice"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        else if (self.apiModel?.data?.electrician_certificate_front_image ?? "").count < 3  {
            GDAlertView.alert("DG_not_upload_img_notice"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }else  if (self.apiModel?.data?.electrician_certificate_back_image ?? "").count < 3  {
            GDAlertView.alert("DG_not_upload_img_notice"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        self.apiModel?.data?.electrician_certificate_number = self.dianGongNumTextfield.text ?? ""
//        self.apiModel?.data?.electrician_certificate_level = self.levelTextfield.text ?? ""
        self.apiModel?.data?.electrician_certificate_type = self.levelTextfield.text ?? ""
        
//        self.apiModel?.data?.live_address = self.addressDetail.text ?? ""
        self.apiModel?.data?.professional_name = self.jobTextfield.text ?? ""
        self.apiModel?.data?.electrician_certificate_area_name = self.fazhengdiquTextfield.text ?? ""
        self.apiModel?.data?.electrician_expire_start = startButton.title(for: UIControl.State.selected) ?? ""
        self.apiModel?.data?.electrician_expire_end = endButton.title(for: UIControl.State.selected) ?? ""
        let sure = UIAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
            self.requestApiForChange()
        })
        let cancel = UIAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.cancel, handler: { (action ) in
        })
        self.alert(title: "DG_confirm_submmit"|?|, detailTitle: "DG_confirm_discribe"|?|, style: UIAlertController.Style.alert, actions: [sure , cancel])
    }
    func requestApiForChange() {
        DDRequestManager.share.changeDianGongInfo(type: ApiModel<String>.self, parameters: (self.apiModel?.data)!, success: { (apiModel) in
            if apiModel.status == 200{
                // to do something
                let alert = DDAutoDisappearAlert2(message: "DG_info_has_submmited"|?|, image: UIImage(named:"certificationsuccess"))
                alert.action = {[weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                self.view.alert(alert)
                //                    GDAlertView.alert("提交成功", image: nil, time: 3, complateBlock: {
                //                        self.getDianGongInfo()
                //                    })
            }else{
                GDAlertView.alert(apiModel.message, image: nil , time: 2 , complateBlock: nil )
            }
        }, failure: { (error ) in
            
        }) {
            
        }
        /*
        DDRequestManager.share.changeDianGongInfo(parameters:(self.apiModel?.data)! )?.responseJSON(completionHandler: { (response) in
            print("change ............................")
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response){
                if apiModel.status == 200{
                    // to do something
                    let alert = DDAutoDisappearAlert2(message: "认证信息已提交", image: UIImage(named:"certificationsuccess"))
                    alert.action = {[weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    self.view.alert(alert)
//                    GDAlertView.alert("提交成功", image: nil, time: 3, complateBlock: {
//                        self.getDianGongInfo()
//                    })
                }else{
                    GDAlertView.alert(apiModel.message, image: nil , time: 2 , complateBlock: nil )
                }
            }
        })
        */
    }
}

extension DianGongAuthorVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
}
struct DianGongInfo: Codable {
    var  electrician_certificate_back_image : String?
    var  electrician_certificate_front_image : String?
    /// 去掉该字段,新增type表示作业类别
//    var  electrician_certificate_level : String?
    /// 新增作业类别 ,有一天,又改成了 工程级别
    var  electrician_certificate_type : String?
    var  electrician_certificate_number : String?
    ///审核状态(-1、待提交 0、待审核 1、审核通过 2、审核不通过)
    var electrician_examine_status : String?
    var  examine_desc : String?
    var  id_number : String
    var  member_id : String?
    var  name  : String
    ///原职业名称 , 改成现准操项目, 有一天,又改成了 准许工程
    var  professional_name : String
    /// (1、男 2、女)
    var  sex  : String
    ///这三个作废
    var live_area_id:String?
    var live_area_name : String?
    var live_address : String?
    // 0 是无任务 , 可以离开团队 , 否则不能离开团队
    var wait_shop_number : String?
    var team_name : String?
    var team_member_id : String?
    var company_name : String?
    var team_member_mobile : String?
    var team_member_name : String?
    var team_id : String?
    ///新增电工发证地区 有一天,又改成了 签发机构
    var electrician_certificate_area_name : String?
    ///新增
    var electrician_expire_start : String?
    var electrician_expire_end : String?
}
//class TempLabel :  UILabel{
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.textColor = UIColor.DDTitleColor
//    }
//
//}

//class TempTextField :  UITextField , UITextFieldDelegate{
//    
//    override func layoutSubviews() {
//        if self.delegate == nil {
//            self.delegate = self
//        }
//        super.layoutSubviews()
//        self.textColor = UIColor.DDSubTitleColor
//        self.returnKeyType = .done
//        self.font = UIFont.systemFont(ofSize: 14)
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        UIApplication.shared.keyWindow?.endEditing(true)
//        return true
//    }
//}

class DDTextFieldWithArrow: UIControl {
    let textField = UITextField()
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textField)
        self.addSubview(imageView)
        imageView.image = UIImage(named:"enterthearrow")
        imageView.isUserInteractionEnabled = false
        textField.isUserInteractionEnabled = false
        imageView.contentMode =  .scaleAspectFit//.scaleToFill//.scaleAspectFill//
        self.textField.textColor = UIColor.DDSubTitleColor
        self.textField.returnKeyType = .done
        self.textField.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let arrowWidth : CGFloat = 44
        let arrowH : CGFloat = 19
        let arrowY = (self.bounds.height - arrowH ) / 2
        imageView.frame = CGRect(x: self.bounds.width - arrowWidth, y: arrowY, width: arrowWidth, height: arrowH)
        textField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - arrowWidth, height: self.bounds.height)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
