//
//  DianGongInfoConfirmView.swift
//  Project
//
//  Created by WY on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DianGongInfoWithTeam: DDAlertContainer {
    var action : (() -> Void)?
    var apiModel  : ApiModel<DianGongInfo>?{
        didSet{
            if let model = apiModel{
                self.setContentToUI(apiModel :model)
            }
        }
    }
    let scrollView = UIScrollView()
    let nameTitle = TempLabel()
    let nameValue = TempLabelRight()
    
    let sexTitle = TempLabel()
    let sexValue = TempLabelRight()
    
    let idNumTitle = TempLabel()
    let idNumValue = TempLabelRight()
    
    let dianGongNumTitle = TempLabel()
    let dianGongNumTextfield = TempLabelRight()
    
//    let levelTitle = TempLabel()
//    let levelTextfield = TempLabelRight()
//
//    let jobTitle = TempLabel()
//    let jobTextfield = TempLabelRight()
    /// 原类别,现作业类别
    let levelTitle = TempLabel()
    let levelTextfield = TempLabelRight()
    /// 原职业名称 , 现准操项目
    let jobTitle = TempLabel()
    let jobTextfield = TempLabelRight()
    ///新增发证地区
    let fazhengdiquTitle = TempLabel()
    let fazhengdiquTextfield = TempLabelRight()
    
    
    
    
    let startTime = TempLabel()
    let startTimeValue = TempLabelRight()
    let endTime = TempLabel()
    let endTimeValue = TempLabelRight()
    
    let pictureTitle = TempLabel()
    
    let pictureCover = UIButton()
    
    let pictureContent = UIButton()
    
    let bottomJiange = UIView()
    let teamInfoLabel = TempLabel()
    let leaveTeamButton = UIButton()
    let teamNameTitle = TempLabel()
    let teamNameValue = TempLabelRight()
    
    let teamLeaderTitle = TempLabel()
    let teamLeaderValue = TempLabelRight()
    
    let teamMobileTitle = TempLabel()
    let teamMobileValue = TempLabelRight()
    
    let teamCompanyTitle = TempLabel()
    let teamCompanyValue = TempLabelRight()
    ///电工身份验证-1未提交，0待审核，1，审核通过，2审核不通过。
    var electrician_examine_status: String?
    public  init(){
        super.init(frame: CGRect.zero)
        //        title
        self.backgroundColor = .white
        _addSubviews()
//        self.getDianGongInfo()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

/// user-interface setup
extension DianGongInfoWithTeam {
    func _addSubviews() {
        
        self.addSubview(scrollView)
        scrollView.addSubview(nameTitle)
        nameTitle.text = "DG_name_title"|?|
        scrollView.addSubview(nameValue)
        
        scrollView.addSubview(sexTitle)
        sexTitle.text = "DG_gender_title"|?|
        scrollView.addSubview(sexValue)
        //        maxY = _addLine(maxY: 0)
        scrollView.addSubview(idNumTitle)
        idNumTitle.text = "DG_id_num_title"|?|
        scrollView.addSubview(idNumValue)
        //        maxY = _addLine(maxY: 0)
        scrollView.addSubview(dianGongNumTitle)
        dianGongNumTitle.text = "DG_register_num_title"|?|
        scrollView.addSubview(dianGongNumTextfield)
        //        maxY = _addLine(maxY: 0)
//        scrollView.addSubview(levelTitle)
//        levelTitle.text = "级别"
//        scrollView.addSubview(levelTextfield)
//        //        maxY = _addLine(maxY: 0)
//        scrollView.addSubview(jobTitle)
//        jobTitle.text = "职业名称"
//        scrollView.addSubview(jobTextfield)
        scrollView.addSubview(levelTitle)
        ///
        //        levelTitle.text = "级别"
        levelTitle.text = "DG_project_level_title"|?|
        scrollView.addSubview(levelTextfield)
        //        maxY = _addLine(maxY: 0)
        scrollView.addSubview(jobTitle)
        jobTitle.text = "DG_allow_project_title"|?|
        scrollView.addSubview(jobTextfield)
        
        fazhengdiquTitle.text = "DG_qianfajigou_title"|?|
        scrollView.addSubview(fazhengdiquTitle)
        scrollView.addSubview(fazhengdiquTextfield)
        
        
        
        
        
        
        
        scrollView.addSubview(startTime)
        startTime.text = "DG_start_date"|?|
        scrollView.addSubview(startTimeValue)
        //        arrowButton.addTarget(self , action: #selector(chooseAddress(sender:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(endTime)
        endTime.text = "DG_end_date"|?|
        scrollView.addSubview(endTimeValue)
        //        let addressTitle = TempLabel()
        //        let addressCity = UITextField()
        //        let arrowButton  = UIButton()
        //
        //        let addressDetail = UITextField()
        
        
        //        maxY = _addLine(maxY: 0)
        scrollView.addSubview(pictureTitle)
        pictureTitle.text = "DG_diangongzheng_title"|?|
        
        scrollView.addSubview(pictureCover)
        scrollView.addSubview(pictureContent)
        
        
        scrollView.addSubview(bottomJiange)
        scrollView.addSubview(teamInfoLabel)
        scrollView.addSubview(leaveTeamButton)
        scrollView.addSubview(teamNameTitle)
        scrollView.addSubview(teamNameValue)
        scrollView.addSubview(teamLeaderTitle)
        scrollView.addSubview(teamLeaderValue)
        scrollView.addSubview(teamMobileTitle)
        scrollView.addSubview(teamMobileValue)
        scrollView.addSubview(teamCompanyTitle)
        scrollView.addSubview(teamCompanyValue)
        
        bottomJiange.backgroundColor = UIColor.DDLightGray
        teamInfoLabel.text = "小组信息"
        leaveTeamButton.setTitle("退出小组", for: UIControl.State.normal)
        leaveTeamButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        leaveTeamButton.addTarget(self , action: #selector(leaveTeam(sender:)), for: UIControl.Event.touchUpInside)
        leaveTeamButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
        teamNameTitle.text = "小组名称"
        teamLeaderTitle.text = "组长"
        teamMobileTitle.text = "联系方式"
        teamCompanyTitle.text = "所在公司"
        _layoutSubviews()
    }
    
    func _layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight)
        
        var maxY : CGFloat = 0
        
        let titleMaxW = "DG_diangongzheng_title"|?|.sizeSingleLine(font: nameTitle.font).width
        let horizontalMargin : CGFloat = 15
        nameTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        nameValue.frame = CGRect(x: nameTitle.frame.maxX, y: nameTitle.frame.minY, width: SCREENWIDTH - nameTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: nameTitle.frame.maxY)
        
        sexTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        sexValue.frame = CGRect(x: sexTitle.frame.maxX, y: maxY, width: SCREENWIDTH - sexTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: sexTitle.frame.maxY)
        
        idNumTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        idNumValue.frame = CGRect(x: idNumTitle.frame.maxX, y: maxY, width: SCREENWIDTH - idNumTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: idNumTitle.frame.maxY)
        
        dianGongNumTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        dianGongNumTextfield.frame = CGRect(x: dianGongNumTitle.frame.maxX, y: maxY, width: SCREENWIDTH - dianGongNumTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: dianGongNumTitle.frame.maxY)
        
        levelTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        levelTextfield.frame = CGRect(x: levelTitle.frame.maxX, y: maxY, width: SCREENWIDTH - levelTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: levelTitle.frame.maxY)
        
        jobTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        jobTextfield.frame = CGRect(x: jobTitle.frame.maxX, y: maxY, width: SCREENWIDTH - jobTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: jobTitle.frame.maxY)
        
        
        fazhengdiquTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        fazhengdiquTextfield.frame = CGRect(x: fazhengdiquTitle.frame.maxX, y: maxY, width: SCREENWIDTH - fazhengdiquTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: fazhengdiquTitle.frame.maxY)
        
        
        
        
        
        startTime.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        startTimeValue.frame = CGRect(x: startTime.frame.maxX, y: startTime.frame.minY, width: SCREENWIDTH - startTime.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: startTime.frame.maxY)
        endTime.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        endTimeValue.frame = CGRect(x: startTime.frame.maxX, y: maxY, width: SCREENWIDTH - jobTitle.frame.maxX - horizontalMargin , height: 40)
        maxY = _addLine(maxY: endTimeValue.frame.maxY)
        //        let addressTitle = TempLabel()
        //        let addressCity = UITextField()
        //        let arrowButton  = UIButton()
        //
        //        let addressDetail = UITextField()
        
        pictureTitle.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW + horizontalMargin, height: 40)
        let pictureLeftMargin : CGFloat = 50
        let betweenPictureMargin : CGFloat = 20
        let pictureCoverW = (SCREENWIDTH - horizontalMargin * 2 - pictureTitle.frame.maxX - pictureLeftMargin - betweenPictureMargin ) / 2
        let pictureCoverX =  pictureTitle.frame.maxX + pictureLeftMargin + horizontalMargin
        pictureCover.frame = CGRect(x: pictureCoverX, y: pictureTitle.frame.minY + 12, width:pictureCoverW, height: pictureCoverW)
        //        pictureCover.setImage(UIImage(named:"addtoicon"), for: UIControl.State.normal)
        pictureCover.backgroundColor = UIColor.gray(0.12)
        pictureContent.frame = CGRect(x: pictureCover.frame.maxX + betweenPictureMargin, y: pictureCover.frame.minY, width: pictureCoverW, height: pictureCoverW)
        maxY = pictureContent.frame.maxY + 10
        
        
//        maxY =  pictureTitle.frame.maxY + 10
//        let pictureLeftMargin : CGFloat = 44
//        pictureCover.frame = CGRect(x: pictureLeftMargin, y: maxY, width: SCREENWIDTH - pictureLeftMargin * 2, height: SCREENWIDTH/2)
//        pictureCover.setImage(UIImage(named:"addtoicon"), for: UIControl.State.normal)
//        pictureCover.backgroundColor = UIColor.DDLightGray
//
//        maxY = pictureCover.frame.maxY + 20
//        pictureContent.frame = CGRect(x: pictureLeftMargin, y: maxY, width: SCREENWIDTH - pictureLeftMargin * 2, height: SCREENWIDTH/2)
//        pictureContent.setImage(UIImage(named:"addtoicon"), for: UIControl.State.normal)
//        pictureContent.backgroundColor = UIColor.DDLightGray
//        maxY = pictureContent.frame.maxY + 10
        bottomJiange.frame = CGRect(x: 0, y: maxY, width: SCREENWIDTH, height: 3)
        maxY = bottomJiange.frame.maxY
        teamInfoLabel.frame = CGRect(x: horizontalMargin, y: maxY, width: titleMaxW, height: 40)
        leaveTeamButton.frame = CGRect(x: SCREENWIDTH - 100, y: maxY, width: 100, height: 40)
        maxY =  _addLine(maxY: teamInfoLabel.frame.maxY)
        
        teamNameTitle.frame = CGRect(x: horizontalMargin * 2, y: maxY, width: titleMaxW, height: 40)
        teamNameValue.frame = CGRect(x: teamNameTitle.frame.maxX, y: maxY, width: SCREENWIDTH - teamNameTitle.frame.maxX - 28, height: 40)
        maxY = _addShortLine(maxY: teamNameTitle.frame.maxY)
        
        
        
        
        teamLeaderTitle.frame = CGRect(x: horizontalMargin * 2, y: maxY, width: titleMaxW, height: 40)
        teamLeaderValue.frame = CGRect(x: teamLeaderTitle.frame.maxX, y: maxY, width: SCREENWIDTH - teamLeaderTitle.frame.maxX - 28, height: 40)
        maxY = _addShortLine(maxY: teamLeaderTitle.frame.maxY)
        
        
        
        teamMobileTitle.frame = CGRect(x: horizontalMargin * 2, y: maxY, width: titleMaxW, height: 40)
        teamMobileValue.frame = CGRect(x: teamMobileTitle.frame.maxX, y: maxY, width: SCREENWIDTH - teamMobileTitle.frame.maxX - 28, height: 40)
        maxY = _addShortLine(maxY: teamMobileTitle.frame.maxY)
        
        
        
        teamCompanyTitle.frame = CGRect(x: horizontalMargin * 2, y: maxY, width: titleMaxW, height: 40)
        teamCompanyValue.frame = CGRect(x: teamCompanyTitle.frame.maxX, y: maxY, width: SCREENWIDTH - teamCompanyTitle.frame.maxX - 28, height: 40)
        maxY = _addShortLine(maxY: teamCompanyTitle.frame.maxY)
        
        
        
        
        scrollView.contentSize = CGSize(width: SCREENWIDTH, height: maxY)
        
        
    }
    func _addLine(maxY:CGFloat) -> CGFloat {
        let line = UIView()
        let margin : CGFloat = 10
        line.frame = CGRect(x: margin, y: maxY, width: SCREENWIDTH - margin  * 2 , height: 1.3)
        line.backgroundColor = UIColor.DDLightGray
        self.scrollView.addSubview(line)
        return line.frame.maxY
    }
    func _addShortLine(maxY:CGFloat) -> CGFloat {
        let line = UIView()
        let horizontalMargin : CGFloat = 15
        let margin : CGFloat = horizontalMargin * 2
        line.frame = CGRect(x: margin, y: maxY, width: SCREENWIDTH - margin  * 2 , height: 1.3)
        line.backgroundColor = UIColor.DDLightGray
        self.scrollView.addSubview(line)
        return line.frame.maxY
    }
}

/// interaction with server
extension DianGongInfoWithTeam {
    func getDianGongInfo() {
        //获取
        DDRequestManager.share.getDianGongInfo(type: ApiModel<DianGongInfo>.self, success: { (apiModel) in
            self.apiModel = apiModel
        }, failure: { (error ) in
            
        }) {
            
        }
//        DDRequestManager.share.getDianGongInfo()?.responseJSON(completionHandler: { (response ) in
//            print("get ............................")
//            dump(response.result)
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<DianGongInfo>.self, from: response){
//                self.apiModel = apiModel
//            }
//        })
        
        
    }
    func setContentToUI(apiModel : ApiModel<DianGongInfo>) {
        self.nameValue.text = self.apiModel?.data?.name
        self.sexValue.text = (self.apiModel?.data?.sex ?? "1") == "1" ? "DG_male"|?| : "DG_female"|?|
        self.idNumValue.text = self.apiModel?.data?.id_number
//        self.levelTextfield.text = self.apiModel?.data?.electrician_certificate_level
        self.levelTextfield.text = self.apiModel?.data?.electrician_certificate_type
        self.jobTextfield.text = self.apiModel?.data?.professional_name
        self.fazhengdiquTextfield.text = self.apiModel?.data?.electrician_certificate_area_name
        self.dianGongNumTextfield.text  = self.apiModel?.data?.electrician_certificate_number
        self.startTimeValue.text = self.apiModel?.data?.electrician_expire_start
        self.endTimeValue.text = self.apiModel?.data?.electrician_expire_end
        self.teamNameValue.text = self.apiModel?.data?.team_name
        self.teamCompanyValue.text = self.apiModel?.data?.company_name
        self.teamMobileValue.text = self.apiModel?.data?.team_member_mobile
        self.teamLeaderValue.text = self.apiModel?.data?.team_member_name
        //        let imglink = "http://i1.bjyltf.com/function/default_avatar.jpg"
        if let url = URL(string: self.apiModel?.data?.electrician_certificate_front_image ?? "")
            //        if let url = URL(string: imglink)
        {
            self.pictureCover.sd_setImage(with: url, for: UIControl.State.normal, completed: { (img , error , cachType, url ) in
                
            })
            
        }
        if let url = URL(string: self.apiModel?.data?.electrician_certificate_back_image ?? ""){
            self.pictureContent.sd_setImage(with: url, for: UIControl.State.normal, completed: { (img , error , cachType, url ) in
                
            })
            
        }
    }
    
    @objc func leaveTeam(sender:UIButton) {
        mylog("解除绑定")
        self.action?()
    }
    
}
