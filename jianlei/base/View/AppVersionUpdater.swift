//
//  AppVersionUpdater.swift
//  YiLuMedia
//
//  Created by WY on 2019/82/28.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit

class AppVersionUpdater: NSObject {
    static var alertTimes = 0
    static func checkAppVersion(callBack:@escaping (Bool?,String?) -> Void) {
        DDRequestManager.share.checkLatestAppVersion(type: ApiModel<CheckAppVersionResultModel>.self, success: { (apiModel) in
            let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            if  apiModel.data?.version ?? "" > currentAppVersion{ // 有新版本了
                if apiModel.data?.upgrade_type ?? "" == "1"{//强制更新
                    callBack(true , apiModel.data?.desc)
                }else{//非强制更新
                    callBack(false,apiModel.data?.desc)
                }
            }else{//无新版本
                callBack(nil,apiModel.data?.desc)
            }
        }, failure: { (error ) in
            callBack(nil,nil )
        }) {
            mylog("check version end!")
        }
    }
    
    static func appVersionAlertTips() {
        if let window = UIApplication.shared.keyWindow {
            for subview in window.subviews {
                if subview.isKind(of: DDAlertOrSheet.self){
                    return
                }
            }
        }
        
        checkAppVersion { (result , description) in
            if let result = result{
                var actions = [DDAlertAction]()
                
                let sure = DDAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action ) in
                    print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
//                    let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"//玉龍傳媒
                    let urlStr = "https://itunes.apple.com/us/app/%e4%b8%80%e8%b7%af%e5%82%b3%e5%aa%92/id1455308781?l=zh&ls=1&mt=8" //一路傳媒
                    if let url = URL(string: urlStr){
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url )
                        }
                    }
                })
                actions.append(sure)
                if result{
                    print("force update")
                    sure.isAutomaticDisappear = false
                    
                }else{
                    if self.alertTimes >= 1 {return}
                    let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action ) in
                        print("cancel update")
                    })
                    actions.append(cancel)
                }
                let alertView = DDAlertOrSheet(title: "新版本提示", message: description , preferredStyle: UIAlertController.Style.alert, actions: actions)
                alertView.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert(alertView)
                self.alertTimes += 1
            }else{
                print("无最新版本")
            }
        }
    }
    
}
struct CheckAppVersionResultModel  :  Codable{
    ///升级类型(1、强制升级 2、不强制)
    var upgrade_type : String
    ///    版本类型(0、修订版本 1、次版本 2、主版本)
    var version_type : String?
    var version : String
    var url  : String
    var desc : String
}
