//
//  SetVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/19.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
private let borderMargin : CGFloat = 10
private let rowH  : CGFloat = 44
class SetVC: DDInternalVC {
    var telephone: String = "400-073-6688"
    let setwithPassword = DDRowView.init(frame: CGRect(x: 0 , y: 0 , width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let changePw = DDRowView.init(frame: CGRect(x: 0 , y: 0 , width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let msgSet = DDRowView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let connectUs = DDRowView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let clearDisk = DDRowView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH - borderMargin*2 , height: rowH))
    lazy var loginOut: CustomBtn = {
        let btn = CustomBtn.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - DDSliderHeight - 44, width: SCREENWIDTH, height: 44))
        btn.titleFont = UIFont.systemFont(ofSize: 14)
        btn.myTitleColor = ("323232", .normal)
        btn.myTitle = ("profile_loginOut"|?|, .normal)
        btn.addTarget(self, action: #selector(loginOut(sender:)), for: UIControl.Event.touchUpInside)
        let loginBackImage = UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffcd34"), UIColor.colorWithHexStringSwift("ffab34")], bound: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 60, height: 45))
        btn.setBackgroundImage(loginBackImage, for: UIControl.State.normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 22
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = DDAccount.share.token ?? ""
        let paramete = ["token": token]
        class Model: Codable {
            var telephone: String?
        }
        NetWork.manager.requestData(router: Router.get("system/telephone", DomainType.api, paramete), success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<Model>.self, from: response)
            if let phone = model?.data?.telephone, phone.count > 0 {
                self.setValue(title: "联系我们", subTitle: "hk@16media.com" , arrowHidden : true , to: self.connectUs)
            }
            
        }) {
            
        }

        self.naviBar.title = "profile_setup"|?|
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        self._configSubviews()
        // Do any additional setup after loading the view.
    }
    func _configSubviews()  {
        self.view.addSubview(setwithPassword)
        self.view.addSubview(changePw)
        self.view.addSubview(msgSet)
        self.view.addSubview(connectUs)
        self.view.addSubview(clearDisk)
        self.view.addSubview(loginOut)
        setwithPassword.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControl.Event.touchUpInside)
        changePw.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControl.Event.touchUpInside)
        msgSet.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControl.Event.touchUpInside)
        connectUs.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControl.Event.touchUpInside)
        clearDisk.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControl.Event.touchUpInside)
        loginOut.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControl.Event.touchUpInside)
        changePw.center = CGPoint(x: SCREENWIDTH/2, y: DDNavigationBarHeight + 15 + rowH/2)
        setwithPassword.center = CGPoint.init(x: SCREENWIDTH / 2, y: changePw.max_Y + 2 + rowH/2)
        
        msgSet.center = CGPoint(x: SCREENWIDTH/2, y: setwithPassword.frame.maxY + 1 + rowH/2)
        connectUs.center = CGPoint(x: SCREENWIDTH/2, y: msgSet.frame.maxY + 1 + rowH/2)
        clearDisk.center = CGPoint(x: SCREENWIDTH/2, y: connectUs.frame.maxY + 1 + rowH/2)
        loginOut.frame = CGRect.init(x: 30, y: clearDisk.max_Y + 30, width: SCREENWIDTH - 60, height: 44)
        setValue(title: "profile_setWithPassword"|?|, subTitle: nil, arrowHidden: false, to: setwithPassword)
        setValue(title: "profile_login_password"|?|, subTitle: nil , arrowHidden : false , to: changePw)
        setValue(title: "profile_message_notification"|?|, subTitle: nil , arrowHidden : false , to: msgSet)
        setValue(title: "profile_contact_we"|?|, subTitle: "hk@16media.com" , arrowHidden : true , to: connectUs)
        var cach = CGFloat (SDImageCache.shared().getSize()) / 1024 / 1024
        cach = cach < 1 ? 0 : cach
        let cachFormate = String.init(format: "%.02f", cach )
        setValue(title: "profile_clearDisk"|?|, subTitle: cachFormate + "MB" , arrowHidden : false , to: clearDisk)
        
    }
    func setValue(title : String , subTitle:String? , arrowHidden : Bool = true ,to : DDRowView) {
        to.titleLabel.text = title
        to.subTitleLabel.text = subTitle
        to.additionalImageView.isHidden = arrowHidden
    }
    @objc func loginOut(sender: CustomBtn) {
        let token: String = DDAccount.share.token ?? ""
        let parameter = ["token": token, "equipment_number": ZKQUUID]
        
        NetWork.manager.requestData(router: Router.post("member/logout", .api, parameter), success: { (response) in
            let data = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response)
            if data?.status == 200 {
                
            }else {
                
            }
        }) {
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (_ ) in
                //                print(action._title)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (_ ) in
                DDAccount.share.deleteAccountFromDisk()
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.configRootVC()
                }
               
            })
            let message1  = "profile_sure_loginOt"|?|
            let alert = DDNotice1Alert(message: message1, backgroundImage: nil, image: nil, actions:  [cancel,sure])
            alert.titleLabel.textAlignment = .center
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
            
        })
//        GDAlertView.alert("退出成功", image: nil , time: 2, complateBlock: {
//            DDAccount.share.deleteAccountFromDisk()
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
//                appDelegate.configRootVC()
//            }
//        })
    }
    @objc func rowActionClick(sender : DDRowView) {
        switch sender {
        case setwithPassword:
            let vc = ForgetPasswordVC()
            vc.viewType = .setWithDraw
            self.navigationController?.pushViewController(vc, animated: true)
        case changePw:
            mylog(sender.titleLabel.text)
            let vc = ForgetPasswordVC()
            vc.viewType = .changePassword
            vc.vergionType = 2
            self.navigationController?.pushViewController(vc, animated: true )
        case msgSet:
            mylog(sender.titleLabel.text)
            let vc = DDMessageSetVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case connectUs:
            mylog("联系我们")
//            UIApplication.shared.openURL(URL(string: "telprompt:\(self.telephone)")!)
//            mylog(sender.titleLabel.text)
        case clearDisk:
            SDImageCache.shared().clearDisk()
            SDImageCache.shared().clearMemory()
//            SDImageCache.shared().cleanDisk()
//            let cach = SDImageCache.shared().getSize() / 1024 / 1024
            setValue(title: "profile_clearDisk"|?|, subTitle: "0MB" , arrowHidden : false , to: clearDisk)
            
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
