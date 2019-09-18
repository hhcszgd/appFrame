//
//  EditInfoVC.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/9/14.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class EditInfoVC: DDInternalVC {

    
//    "profile_contact_mobile" = "聯繫電話";
//    "profile_editinfo_address" = "詳細地址";
//    "profile_email" = "郵箱";
//
//    "profile_school" = "畢業院校";
//    "profile_education" = "學歷";
//    "profile_general_info" = "基本信息";
//    "profile_other_info" = "其他信息";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "profile_editInfo"|?|
        self.request()
        self.configUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: DDTabBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDTabBarHeight - DDSliderHeight))
    @objc func configUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.colorWithRGB(red: 240, green: 240, blue: 240)
        self.scrollView.addSubview(titleView1)
        self.scrollView.addSubview(self.contactMobile)
        self.scrollView.addSubview(self.address)
        self.scrollView.addSubview(self.email)
        
        self.scrollView.addSubview(self.school)
        self.scrollView.addSubview(self.education)
        self.scrollView.addSubview(titleView2)
        self.contactMobile.frame = CGRect.init(x: 0, y: self.titleView1.max_Y + 1, width: SCREENWIDTH, height: 45)
        self.address.frame = CGRect.init(x: 0, y: self.contactMobile.max_Y + 1, width: SCREENWIDTH, height: 45)
        self.email.frame = CGRect.init(x: 0, y: self.address.max_Y + 1, width: SCREENWIDTH, height: 45)
        self.titleView2.frame = CGRect.init(x: 0, y: self.email.max_Y + 10, width: SCREENWIDTH, height: 45)
        self.school.frame = CGRect.init(x: 0, y: self.titleView2.max_Y + 1, width: SCREENWIDTH, height: 45)
        self.education.frame = CGRect.init(x: 0, y: self.school.max_Y + 1, width: SCREENWIDTH, height: 45)
        
        
        //交互
        self.contactMobile.shopInfoBtnClick = {[weak self] (_) in
            let vc = ForgetPasswordVC()
            vc.vergionType = 3
            vc.viewType = .changeContactMobile
            self?.navigationController?.pushViewController(vc, animated: true)
            vc.finishChangeContactMobile = {[weak self] (mobile) in
                self?.contactMobile.subTitleValue = mobile
            }
        }
        self.address.shopInfoBtnClick = {[weak self](_) in
            let vc = ContactMobileVC()
            vc.areaName = self?.data?.area_name ?? ""
            vc.areaID = self?.data?.area ?? ""
            vc.address = self?.data?.address ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
            vc.finished = { [weak self] (value) in
                self?.address.subTitleValue = value.areaName
                self?.data?.area_name = value.areaName
                self?.data?.area = value.areaid
                self?.data?.address = value.address
                
            }
            
        }
        self.email.shopInfoBtnClick = {[weak self] (_) in
            
            self?.cofigEmail()
        }
        self.school.shopInfoBtnClick = { [weak self] (_) in
            self?.configSchool()
        }
        self.education.shopInfoBtnClick = { [weak self] (_) in
            self?.selectEducation()
            
        }
        
        
        
        
    }
    func cofigEmail() {

        let containerView = EnterValueAlterView.init(superView: self.view, placeholder: "enterEmailPlaceholder"|?|, action: FoundatonType.email)
        containerView.finishEnter = { [weak self] (value) in
            self?.email.subTitleValue = value
        }
    }
    func configSchool() {
        let containerView = EnterValueAlterView.init(superView: self.view, placeholder: "enterSchoolPlaceholder"|?|, action: FoundatonType.school)
        containerView.finishEnter = { [weak self] (value) in
            self?.school.subTitleValue = value
            
        }
    }
    func selectEducation() {
        let containerView = SelectEducation.init(superView: self.view)
        containerView.title = "select_education_title"|?|
        containerView.dataArr = self.educationArr
        containerView.selectFinished = { [weak self] (value) in
            self?.education.subTitleValue = value.1
            
        }
        
       
    }
    var educationArr: [AreaModel]{
        get {
            let model1 = AreaModel.init()
            model1.name = "education1"|?|
            let model2 = AreaModel.init()
            model2.name = "education2"|?|
            let model3 = AreaModel.init()
            model3.name = "education3"|?|
            let model4 = AreaModel.init()
            model4.name = "education4"|?|
            let model5 = AreaModel.init()
            model5.name = "education5"|?|
            let model6 = AreaModel.init()
            model6.name = "education6"|?|
            let model7 = AreaModel.init()
            model7.name = "education7"|?|
            let model8 = AreaModel.init()
            model8.name = "education8"|?|
            let arr = [model1, model2, model3, model4, model5, model6, model7, model8]
            arr.forEach { (model) in
                model.rightImage = "select.png"
            }
            return arr
            
        }
    }
    
    
    var data: PrivatInfoModel?
    func request() {
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("member/\(id)", .api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<PrivatInfoModel>.self, from: response)
            
            let redColor = UIColor.colorWithHexStringSwift("ea6e61")
            if model?.status == 200 {
                self.data = model?.data
                if let mobile = model?.data?.mobile, mobile.count > 0 {
                    self.contactMobile.subTitleValue = model?.data?.mobile
                }else {
                    self.contactMobile.subTitleValue = "profile_edit"|?|
                }
                
                if let area = model?.data?.area_name, area.count > 0 {
                    self.address.subTitleValue = area
                }else {
                    self.address.subTitleValue = "profile_edit"|?|
                }
                if let email = model?.data?.email, email.count > 0 {
                    self.email.subTitleValue = model?.data?.email ?? "profile_edit"|?|
                }else {
                    self.email.subTitleValue = "profile_edit"|?|
                }
                
                if let school = model?.data?.school, school.count > 0 {
                    self.school.subTitleValue = model?.data?.school
                }else {
                    self.school.subTitleValue =  "profile_edit"|?|
                }
                if let education = model?.data?.education, education.count > 0 {
                    self.education.subTitleValue = model?.data?.education
                }else {
                    self.education.subTitleValue = "profile_edit"|?|
                }
                
                
            }
            
        }) {
            
        }
    }
    
    
    let contactMobile = ShopInfoCell.init(title: "profile_contact_mobile"|?|, rightImage: "profile_arrow", subTitle: "")
    let address = ShopInfoCell.init(title: "profile_editinfo_address"|?|, rightImage: "profile_arrow", subTitle: "")
    let email = ShopInfoCell.init(title: "profile_email"|?|, rightImage: "profile_arrow", subTitle: "")
    let school = ShopInfoCell.init(title: "profile_school"|?|, rightImage: "profile_arrow", subTitle: "")
    let education = ShopInfoCell.init(title: "profile_education"|?|, rightImage: "profile_arrow", subTitle: "")
    
    
    
    let titleView1 = ShopInfoCell.init(frame: CGRect.init(x: 0, y: 13, width: SCREENWIDTH, height: 45), title: "profile_general_info"|?|, rightImage: "")
    let titleView2 = ShopInfoCell.init(frame: CGRect.zero, title: "profile_other_info"|?|, rightImage: "")

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class PrivatInfoModel: Codable {
    var education: String?
    var school: String?
    var area: String?
    var area_name: String?
    var address: String?
    var mobile: String?
    var email: String?
    var name: String?
    var avatar: String?
    
    ///用户类型(1、兼职人员 2、正式兼职人员)
    var member_type: String?
    ///审核结果(-1、未提交 0、待审核 1、审核通过 2、审核不通过)
    var examine_status: String?
    ///安装人员认证
    var electrician_examine_status: String?
    
}
