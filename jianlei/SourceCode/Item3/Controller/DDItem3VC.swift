//
//  DDItem3VC.swift
//  ENWay
//
//  Created by WY on 2019/82/13.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit
import SDWebImage
class DDItem3VC: DDNormalVC {
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title =  "tabbar_item3_title"|?|
        
//        self.request() 
        self.configUI()
        
    }
    
  
    func request() {
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("member/\(id)", .api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<PrivatInfoModel>.self, from: response)
            DDAccount.share.examineStatus = model?.data?.examine_status
            if DDAccount.share.examineStatus == "1" {
                self.judgeImage.isHidden = false
            }else {
                self.judgeImage.isHidden = true
                
            }
            DDAccount.share.name = model?.data?.name
            DDAccount.share.avatar = model?.data?.avatar
            DDAccount.share.mobile = model?.data?.mobile
            DDAccount.share.electrician_examine_status = model?.data?.electrician_examine_status
            DDAccount.share.save()
            
            self.userNameLabel.text = model?.data?.name
            self.phoneNumberLabel.text = "profile_mobile"|?| + (model?.data?.mobile ?? "")
            self.userHeaderImage.sd_setImage(with: imgStrConvertToUrl(model?.data?.avatar ?? ""), placeholderImage: profilePlaceholderImage, options: SDWebImageOptions.cacheMemoryOnly, completed: { (image, error, type, url) in
                
            })
            
                
            
            
        }) {
            
        }
    }
    func uploadInfo() {
        self.userNameLabel.text = DDAccount.share.name
        self.phoneNumberLabel.text = "profile_mobile"|?| + (DDAccount.share.mobile ?? "")
        self.userHeaderImage.sd_setImage(with: imgStrConvertToUrl(DDAccount.share.avatar ?? ""), placeholderImage: profilePlaceholderImage, options: SDWebImageOptions.cacheMemoryOnly, completed: { (image, error, type, url) in
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uploadInfo()
        self.request()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
   
    @objc func uploadHeaderImage(tap: UITapGestureRecognizer) {
        SystemMediaPicker.share.selectImage().pickImageCompletedHandler = { [weak self] (image)in
            if let trueImage = image {
                TencentYunUploader.uploadMediaToTencentYun(image: trueImage, progressHandler: { (a, b, c) in
                    
                }, compateHandler: { (imageStr) in
                    let id = DDAccount.share.id ?? ""
                    var paramete = ["token": DDAccount.share.token ?? ""]
                        paramete["avatar"] = imageStr
                    
                    let router = Router.put("member/\(id)", DomainType.api, paramete)
                    NetWork.manager.requestData(router: router, success: { (response) in
                        let model = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response)
                        if model?.status == 200 {
                            self?.userHeaderImage.image = image
                            DDAccount.share.avatar = imageStr
                            DDAccount.share.save()
                            GDAlertView.alert("頭像上傳成功", image: nil, time: 1, complateBlock: nil)
                        }else {
                            GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                        }
                    }) {
                        GDAlertView.alert("重新上傳", image: nil, time: 1, complateBlock: nil)
                    }
                    
                    
                    
                })
            }
            
            
        }
    }
    
    func configUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.colorWithRGB(red: 240, green: 240, blue: 240)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(self.backImage)
        if let image = self.backImage.image {
            let propert = image.size.height / image.size.width
            self.backImage.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: propert * SCREENWIDTH)
            
        }
        self.backImage.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer.init(target: self, action: #selector(uploadHeaderImage(tap:)))
        self.userHeaderImage.isUserInteractionEnabled = true
        self.userHeaderImage.addGestureRecognizer(imageTap)
        self.backImage.addSubview(self.userNameLabel)
        self.backImage.addSubview(self.phoneNumberLabel)
        self.backImage.addSubview(self.userHeaderImage)
        self.backImage.addSubview(self.judgeImage)
        self.userNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(63 * SCALE)
            make.left.equalToSuperview().offset(33 * SCALE)
        }
        self.userNameLabel.text = "用户名"
        self.phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(33 * SCALE)
            
        }
        
        self.phoneNumberLabel.text = "电话"
        
        self.userHeaderImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60 * SCALE)
            make.right.equalToSuperview().offset(-30 * SCALE)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        self.userHeaderImage.layer.masksToBounds = true
        self.userHeaderImage.layer.cornerRadius = 30
        
        self.renzhengImage = "profile_label"
        
        self.scrollView.addSubview(self.containerView)
        self.containerView.frame = CGRect.init(x: 13, y: self.backImage.max_Y - 40, width: SCREENWIDTH - 26, height: 50 * 5)
        self.scrollView.addSubview(self.nameJudgeCell)
        self.scrollView.addSubview(self.installMember)
        self.scrollView.addSubview(self.userInfoCell)
        self.scrollView.addSubview(self.about)
        self.scrollView.addSubview(self.set)
        self.containerView.layer.cornerRadius = 13
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowRadius = 5
        self.containerView.layer.shadowOpacity = 0.5
        self.containerView.layer.shadowOffset = CGSize.init(width: 2, height: 4)
        self.containerView.backgroundColor = UIColor.white
        

        
        self.nameJudgeCell.frame = CGRect.init(x: self.containerView.x, y: self.containerView.y, width: self.containerView.width, height: 50)
        self.installMember.frame = CGRect.init(x: self.containerView.x, y: self.nameJudgeCell.max_Y, width: self.containerView.width, height: 50)
        self.userInfoCell.frame = CGRect.init(x: self.containerView.x, y: self.installMember.max_Y, width: self.containerView.width, height: 50)
        self.about.frame = CGRect.init(x: self.containerView.x, y: self.userInfoCell.max_Y, width: self.containerView.width, height: 50)
        self.set.frame = CGRect.init(x: self.containerView.x, y: self.about.max_Y, width: self.containerView.width, height: 50)
        self.nameJudgeCell.backgroundColor = UIColor.clear
        self.userInfoCell.backgroundColor = UIColor.clear
        self.about.backgroundColor = UIColor.clear
        self.set.backgroundColor = UIColor.clear
        self.set.lineView?.isHidden = true
        
        self.nameJudgeCell.shopInfoBtnClick = {[weak self](bo) in
            mylog("实名认证")
            let vc = DDAuthenticatedVC()
            self?.navigationController?.pushViewController(vc , animated: true )
        }
        self.userInfoCell.shopInfoBtnClick = {[weak self] (bo) in
            mylog("个人资料")
            let vc = EditInfoVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.about.shopInfoBtnClick = { [weak self] (bo) in
            mylog("关于")
            let vc = AboutVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.set.shopInfoBtnClick = { [weak self] (bo) in
            mylog("设置")
            self?.pushVC(vcIdentifier: "SetVC", userInfo: nil)
        }
        self.installMember.shopInfoBtnClick = {[weak self] (bo) in
            self?.setJudge()
            
        }
        
        
    }
    func setJudge() {
        if let realNameAuthor = DDAccount.share.examineStatus{
            switch realNameAuthor {
            case "-1"://未提交
                // 先认证
                noAuthorizedAlertWhileGetCash()
                
                break
            case "0"://待审核
                let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                })
                let message1  = "profile_install_member_judge_message1"|?|
                let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
                alert.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert( alert)
                break
            case "1"://审核通过
                if let diangongAuthor = DDAccount.share.electrician_examine_status{
                    self.pushVC(vcIdentifier: "DianGongAuthorVC", userInfo: DDAccount.share.electrician_examine_status)
                    
                    switch diangongAuthor {
                    case "-1"://未提交
                        break
                    case "0"://待审核
                        break
                    case "1"://审核通过
                        break
                    case "2"://审核不通过
                        break
                    default:
                        break
                    }
                    
                }
            case "2"://审核不通过
                let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (_ ) in
                    //                    print(action._title)
                })
                let message1  = "profile_install_member_judge_message1"|?|
                let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
                alert.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert( alert)
                break
            default:
                let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (_ ) in
                    //                    print(action._title)
                })
                let message1  = "profile_install_member_judge_message1"|?|
                let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
                alert.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert( alert)
            }
            
            
            
            
        }
        
        
    }
    func noAuthorizedAlertWhileGetCash() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (_ ) in
                //                print(action._title)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (_ ) in
                let vc =  DDAuthenticatedVC() //JudgeVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let message1  = "profile_install_member_judge_message2"|?|
            let alert = DDNotice1Alert(message: message1, backgroundImage: nil, image: nil, actions:  [cancel,sure])
            
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
            
        })
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.layer.cornerRadius = 13
    }
    
    let nameJudgeCell = ShopInfoCell.init(leftImage: "profile_renzheng", title: "profile_renzheng"|?|, rightImage: "profile_arrow", isUserinteractionEnable: true)
    let userInfoCell = ShopInfoCell.init(leftImage: "profile_ziliao", title: "profile_ziliao"|?|, rightImage: "profile_arrow", isUserinteractionEnable: true)
    let about = ShopInfoCell.init(leftImage: "profile_about", title: "profile_about"|?|, rightImage: "profile_arrow", isUserinteractionEnable: true)
    let set = ShopInfoCell.init(leftImage: "profile_setup", title: "profile_setup"|?|, rightImage: "profile_arrow", isUserinteractionEnable: true)
    let installMember = ShopInfoCell.init(leftImage: "profile_about", title: "profile_install_member_judge"|?|, rightImage: "profile_arrow", isUserinteractionEnable: true)
    

    var renzhengImage: String = "" {
        didSet{
            let image = UIImage.init(named: renzhengImage)
            self.judgeImage.image = image
            self.judgeImage.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(33 * SCALE)
                make.top.equalTo(self.phoneNumberLabel.snp.bottom).offset(10)
                make.width.equalTo(image?.size.width ?? 0)
                make.height.equalTo(image?.size.height ?? 0)
            }
        }
    }
    
    
    
    let userNameLabel = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 20), textColor: UIColor.colorWithHexStringSwift("ffffff"), text: "")
    let phoneNumberLabel = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("ffffff"), text: "")
    ///认证
    let judgeImage = UIImageView.init(image: UIImage.init(named: "profile_label"))
    let containerView = UIView.init()
    let userHeaderImage = UIImageView.init()
    let backImage = UIImageView.init(image: UIImage.init(named: "mine_bg"))
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
  
  
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        coordinator.animateAlongsideTransition(in: tableView, animation: { (context ) in
//            mylog("animating")
//            mylog("1 -> \(size)")
//        }) { (context ) in
//
//            self.tableView.snp.remakeConstraints { (make ) in
//                let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
//                make.top.equalTo(self.view).offset(h)
//                make.left.right.bottom.equalTo(self.view)
//                mylog("2 -> \(size)")
//            }
//        }
//        super.viewWillTransition(to: size, with: coordinator)
//    }

}

extension DDItem3VC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPeixunCell") {

            return cell
        }else{
            let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDPeixunCell")
            cell.contentView.backgroundColor = DDBackgroundColor1
            cell.textLabel?.textColor = DDTitleColor1
            cell.textLabel?.text = "\(indexPath.row)"
            return cell
        }
    }

}
