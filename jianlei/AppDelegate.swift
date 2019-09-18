//
//  AppDelegate.swift
//  YiLuMedia
//
//  Created by WY on 2019/82/27.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?{didSet{window?.backgroundColor = UIColor.white}}
    var rootTabBarVC :DDRootTabBarVC?
    var rootNavVC : DDRootNavVC?
//    var firstLaunch = true
    var firstLaunch = false//不要新特性页了
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DDRequestManager.share.testUrlSession()
        startNetworkReachabilityObserver()
        self.registerLoginNotification()
        self.configRootVC()
//        setupOriginPushNotification()
        setupJpush(launchOptions: launchOptions)        
        configureForBugly()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppVersionUpdater.appVersionAlertTips()
//        JPUSHService.resetBadge()
//        DDRequestManager.share.getPublickKey { (publicKey)   in print("xxxxxxxxxxxxxxxx\(String(describing: publicKey))")}
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate{
    ///:configRootVC
    func configRootVC() {
        if  window  == nil {window = UIWindow(frame: UIScreen.main.bounds)}
        let rootNavVC = DDRootNavVC()
        self.window?.rootViewController = rootNavVC
        self.window?.makeKeyAndVisible()
        
        
        
//        if checkIsNewVersion() {//新版本更新deviceID并重新获取publickKey
//            DDRequestManager.share.getPublickKey(force: true , publicKey: { (publicKey) in
//                print("xxxxxxxxxxxxxxxx:\(String(describing: publicKey))")
//            })
//        }
        ///不要新特性页面了fuck
//        var isNeedShowNewFeature : Bool {
//            get{
//                return  !UserDefaults.standard.bool(forKey: "HasOpenThisApp")
//            }
//        }
//        if isNeedShowNewFeature {
//            let rootVC = DDNewFeature(isNewVersion: true)
//            rootVC.done = {
//                self.configRootVC()
//            }
//            self.window?.rootViewController = rootVC
//            self.window?.makeKeyAndVisible()
//            UserDefaults.standard.set(true , forKey: "HasOpenThisApp")
//            return
//        }
        
        let isLogin = DDAccount.share.isLogin
        if isLogin{
            let rootNavVC = DDRootNavVC()
            self.window?.rootViewController = rootNavVC
            self.window?.makeKeyAndVisible()
        }else{
            let loginVC = LoginVC()
            let naviVC = DDBaseNavVC.init(rootViewController: loginVC)
            naviVC.navigationBar.isHidden  = true
            self.window?.rootViewController = naviVC
            self.window?.makeKeyAndVisible()
        }
//        if firstLaunch{
//            DDRequestManager.share.advertApi(true )?.responseJSON(completionHandler: { (response) in
//                if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<ADModel>.self, from: response){
//                    dump(apiModel)
//                    if let imgUrl = apiModel.data?.start_pic{
//                        let para = ["imageUrlStr":imgUrl  , "link":apiModel.data?.link]
//                        DDADView.init(paramete: para).done = {para in
//                            if let dict = para as? [String:String] , let link = dict["link"]{
//                                let vc = GDBaseWebVC()
//                                vc.userInfo = link
//                                if let naviVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
//                                    naviVC.pushViewController(vc , animated: true )
//                                }
//                            }
//                        }
//                    }
//                }
//            })
//
//            firstLaunch = false
//            Thread.sleep(forTimeInterval: 2)
//        }
        
    }
}
extension AppDelegate{
    func registerLoginNotification()  {
        NotificationCenter.default.addObserver(self , selector: #selector(loginResult(sender:)), name: NSNotification.Name.init("loginSuccess"), object: nil )
    }
    @objc func loginResult(sender:Notification)  {
        configRootVC()
        self.request()
        
        
    }
    
    
    func request() {
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("member/\(id)", .api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<PrivatInfoModel>.self, from: response)
            DDAccount.share.examineStatus = model?.data?.examine_status
            
            DDAccount.share.name = model?.data?.name
            DDAccount.share.avatar = model?.data?.avatar
            DDAccount.share.mobile = model?.data?.mobile
            DDAccount.share.electrician_examine_status = model?.data?.electrician_examine_status
            DDAccount.share.save()
            
        }) {
            
        }
    }
}
