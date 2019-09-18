//
//  DDItem1VC.swift
//  ZDLao
//
//  Created by WY on 2019/9/13.
//  Copyright © 2019年 jianlei. All rights reserved.
//

import UIKit
import CryptoSwift
import CoreLocation
let DDTitleColor1 = UIColor.brown
let DDBackgroundColor1 = UIColor.green.withAlphaComponent(0.3)

class DDItem1VC: DDNormalVC , UITextFieldDelegate{
    var collection = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var sectionHeaderH : CGFloat = 280 * SCALE
    var sectionFooterH : CGFloat = 0//set dynamiclly
    let describeString = "home_company_describe_content"|?|
    var apiModel : ApiModel<[DDHomeFoundation]> = ApiModel<[DDHomeFoundation]>()

    override func viewDidLoad() {
        super.viewDidLoad()
//        DDLocationManager.share.startUpdatingLocation()
        //        todoSomethingAfterCheckVersion()
        AppVersionUpdater.appVersionAlertTips()
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        //        performRequestApi()
        
//        configCollectionView()// todo  放在请求回调中
        self.title = "工作台"
        
//        self.navigationController?.title = "tabbar_item1_title"|?|
        let name = NSNotification.Name.init("ChangeSquenceSuccess")
        NotificationCenter.default.addObserver(self , selector: #selector(changeSquenceSuccess), name: name , object: nil )
        let teamChangedNotificationName = NSNotification.Name.init("DDTeamChanged")
        NotificationCenter.default.addObserver(self , selector: #selector(teamChanged), name: teamChangedNotificationName , object: nil )
        let refreshControl = GDRefreshControl.init(target: self , selector: #selector(refresh))
        //        let images = [UIImage.init(named: "loading1.png")!, UIImage.init(named: "loading2.png")!, UIImage.init(named: "loading3.png")!, UIImage.init(named: "loading4.png")!, UIImage.init(named: "loading5.png")!]
        //        refreshControl.refreshingImages = images
        //        refreshControl.pullingImages = images
        //        refreshControl.successImage = UIImage.init(named: "loading1.png")!
        //        refreshControl.failureImage = UIImage.init(named: "loading2.png")!
        //        refreshControl.refreshingImages = [UIImage.init()]
        self.collection.gdRefreshControl = refreshControl
//        let leftTitle = UILabel()
//        leftTitle.text = "home_title"|?|
//        leftTitle.font = DDFont.boldSystemFont(ofSize: 20)
//        leftTitle.textColor = UIColor.DDTitleColor
//        leftTitle.bounds = CGRect(x: 0, y: 0, width: 108, height: 44)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftTitle)
        
    }
    @objc func teamChanged()  {
        self.performRequestApi { (isSuccess) in
            if isSuccess{
                self.gotoSign(animated: false)
                let vcCount = self.navigationController?.viewControllers.count ?? 0
                if vcCount >= 3 {
                    let targetIndex = vcCount - 2
                    if let _ = self.navigationController?.viewControllers[targetIndex]{
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.59) {
                            self.navigationController?.viewControllers.remove(at: targetIndex)
                        }
                        
                    }
                }
            }else{
                GDAlertView.alert("network_error_try_again"|?|, image: nil, time: 2 , complateBlock: nil)
            }
        }
        
    }
    @objc func refresh() {
        self.performRequestApi()
//        let web = GDBaseWebVC()
//        web.userInfo = "http://ddyiiyii.com/testJS/domcontrolhtml.html"// "setAttributeOfElement"
//        self.navigationController?.pushViewController(web , animated: true )
//        self.pushVC(vcIdentifier: "DDGetCashVC")
//        self.pushVC(vcIdentifier: "DDBankCardManageVC")
//        self.pushVC(vcIdentifier: "DDAuthenticatedVC")
        
//        self.pushVC(vcIdentifier: "NewAchievementStatisticVC", userInfo: nil )
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.performRequestApi()
    }
    
    @objc func changeSquenceSuccess() {
        performRequestApi()
    }
    func performRequestApi(complated:((Bool)->())? = nil )  {
        self.view.removeAllMaskView(maskClass: DDExceptionView.self)
        DDRequestManager.share.homePage(type: ApiModel<[DDHomeFoundation]>.self, success: { (apiModel ) in
            self.apiModel = apiModel
            
            self.configCollectionView()
        }, failure: { (error ) in
            
            var  notice = ""
            if case DDError.networkError = error{
                notice = "network_error_try_again"|?|
            }else {
                notice = "server_side_error_try_again"|?|
            }
            let vv = DDExceptionView()
            vv.exception = DDExceptionModel(title:notice,image:"notice_noinformation")
            vv.manualRemoveAfterActionHandle = {
                mylog("reload action")
                self.performRequestApi()
            }
            self.view.alert(vv )
            
//            self.configCollectionView()
        }) {
            self.collection.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
        }
        
//        DDRequestManager.share.homePage( true)?.responseJSON(completionHandler: { (response ) in
//            mylog(response.result)
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<HomeDataModel>.self, from: response){
//                self.apiModel = apiModel
//                self.collection.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
//                self.collection.reloadData()
//                complated?(true)
//
//            }else{
//                complated?(false)
//                self.collection.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
//            }
//        })
    }
    func configCollectionView()  {
//        if let c =  self.apiModel.data?.notice.count {
//            if c == 1 {
//                sectionHeaderH = 280 * SCALE
//            }else if c >= 2 {
//                sectionHeaderH = 280 * SCALE + 20
//            }else{
//                sectionHeaderH = 280 * SCALE - 44
//            }
//        }else{
//            sectionHeaderH = 280 * SCALE - 44
//        }
        
        sectionHeaderH = 0
//        sectionFooterH = HomeSectionFooter.totalH(text: describeString)
        sectionFooterH = 0
        let toBorderMargin :CGFloat  = 30
        let itemMargin  : CGFloat = 25
        let itemCountOneRow = 3
        
        
        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout{
            if collection.frame == CGRect.zero{
                flowLayout.minimumLineSpacing = itemMargin
                flowLayout.minimumInteritemSpacing = itemMargin
                flowLayout.sectionInset = UIEdgeInsets(top: 44, left: toBorderMargin, bottom: 0, right: toBorderMargin)
                let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow)) / CGFloat(itemCountOneRow)
                let itemH = itemW * 1.33
                flowLayout.itemSize = CGSize(width: itemW, height: itemH)
                flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
                flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
                flowLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionFooterH)
                self.collection.frame = CGRect(x: 0, y:  DDNavigationBarHeight , width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight)
                self.view.addSubview(collection)
                collection.register(HomeItem.self , forCellWithReuseIdentifier: "HomeItem")
                collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
                collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")
                collection.delegate = self
                collection.dataSource = self
                collection.bounces = true
                collection.alwaysBounceVertical = true
                collection.showsVerticalScrollIndicator = false
                collection.backgroundColor = .white
            }else{
                if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout{
                    flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
                    flowLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionFooterH)
                }
            }
        }
        collection.reloadData()
    }
    
}

extension DDItem1VC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        mylog(indexPath)
        //        var targetVC : UIViewController!
        let model = apiModel.data?[indexPath.item]
        let target = model?.target ?? ""
        switch target {
        case "guanggao":
            self.pushVC(vcIdentifier: "DDSalemanmoOrderListVC")
            return
        case "anzhuang":
            self.pushVC(vcIdentifier: "InstallBusinessVC")

        case "huoban":
            self.pushVC(vcIdentifier: "DDPartnerListVC")
            //            let partnerListVC = DDPartnerListVC()
        //            targetVC = partnerListVC
        case "chaxun":
            self.pushVC(vcIdentifier: "ChaXunVC")
            //            let vc = ChaXunVC()
        //            targetVC = vc
        case "tongji":
            self.pushVC(vcIdentifier: "NewAchievementStatisticVC")
            //            let achievementStatisticVC = NewAchievementStatisticVC()
        //            targetVC = achievementStatisticVC
        case "pingmu":
            self.pushVC(vcIdentifier: "ScreenManagerVC")
            //            let screenManager = ScreenManagerVC()
        //            targetVC = screenManager
        case "bianji":
            self.pushVC(vcIdentifier: "DDFuncEditVC")
            //            let editVC = DDFuncEditVC(collectionViewLayout: UICollectionViewFlowLayout())
            //            targetVC = editVC
            
        case "peixun" :// 业务培训的target是peixun
            self.pushVC(vcIdentifier: "DDPeiXunVC")
            break
        case "wap":
            mylog(model?.link_url)
            if let url = model?.link_url , url.contains("install-list/list"){
                self.pushVC(vcIdentifier: "ScreenInstallVC", userInfo: model?.link_url)
            }else{
                self.pushVC(vcIdentifier: "LEDApplicationVC" , userInfo : model?.link_url)
                
            }
            //            let editVC = HomeWebVC()
            //            let tempModel = DDActionModel()
            //            tempModel.keyParameter = model.link_url
            //
            //            editVC.showModel = tempModel
        //            targetVC = editVC
        case "screen":
            self.pushVC(vcIdentifier: "ScreenInstallVC", userInfo: model?.link_url)
            
        case "myshop":
            //            self.pushVC(vcIdentifier: "MyShopVC")
            self.myShopClick(type: "4")
            //            let editVC = MyShopVC()
            //            targetVC = editVC
            break
        case "1"://单个自营
            let vc = MyShopVC()
            vc.userInfo = ["shopID":model?.shop_id, "type":"2"]
            self.navigationController?.pushViewController(vc , animated: true )
            break
        case "2"://未申请店铺
            let vc = DDShopListVC()
            self.navigationController?.pushViewController(vc , animated: true )
            
            //            let vcc = DDNoShopVC()
        //            self.navigationController?.pushViewController(vcc , animated: true )
        case "3"://单个总店
            let vc = MyShopVC()
            vc.userInfo = ["shopID":model?.shop_id, "type":"1"]
            self.navigationController?.pushViewController(vc , animated: true )
            break
        case "4"://多家店铺
            let vc = DDShopListVC()
            self.navigationController?.pushViewController(vc , animated: true )
        case "xiaozu" :
            self.setGroupAction()
            
     
        case "sign" :
            mylog("签到")
            self.gotoSign()
        case "team_admin" :
            mylog("团队管理")
            self.pushVC(vcIdentifier: "TeamControllerVC", userInfo: nil)
        case "project" :
            mylog("工程分布")
            self.pushVC(vcIdentifier: "DDProjectsMapVC", userInfo: nil )
            break
        case "sign_count" :
            mylog("签到数据")
            var paramete = [String: String]()
            if let teamID = model?.team_id, let memberType = model?.sign_member_type, let teamType = model?.sign_team_type {
                paramete["teamID"] = teamID
                paramete["memberType"] = memberType
                paramete["teamType"] = teamType
            }
            
            
            
            self.pushVC(vcIdentifier: "SignDataVC", userInfo: paramete)
        default:
            return
        }
    }
    
    
    
    
    func gotoSign(animated:Bool = true ) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch DDLocationManager.share.authorizationStatus() {
            case CLAuthorizationStatus.authorizedAlways:
                mylog("现在是前后台定位服务")
                jumpToSignVC(animated: animated)
            case CLAuthorizationStatus.authorizedWhenInUse:
                mylog("现在是前台定位服务")
                jumpToSignVC(animated: animated)
            case CLAuthorizationStatus.denied:
                openLoactionService()
                mylog("现在是用户拒绝使用定位服务")
            case CLAuthorizationStatus.notDetermined:
//                openLoactionService()
                mylog("用户暂未选择定位服务选项")
            case CLAuthorizationStatus.restricted:
                openLoactionService()
                mylog("现在是用户可能拒绝使用定位服务")
            }
        }else{
            mylog("请开启手机的定位服务")
            let sure = UIAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default) { (action) in
            }
            self.alert(title: "location_enable"|?|, detailTitle: "location_enable_tips"|?|, style: UIAlertController.Style.alert, actions: [sure ])
        }
        
        
        
        
 
    }
    
    func jumpToSignVC(animated:Bool = true ) {
        
        let tableVC = DDSignTabBarVC()
        
        let footprintVC = DDFootprintVC()
        let footprintNaviVC = DDFootprintNaviVC.init(rootViewController: footprintVC)
//        let signType  = self.apiModel.data?.sign_team_type ?? "1"
        let signType  = "1"
        //        if DomainType.api.rawValue.contains(".cc"){
        //            signType = "2"
        //        }
        if signType == "1"  {//业务签到
            let bussinessVC = DDBussinessVC()
            let bussinessNaviVC = DDBussinessNaviVC.init(rootViewController: bussinessVC)
            bussinessNaviVC.signType = .bussiness
            footprintNaviVC.signType = .bussiness
            tableVC.setViewControllers([bussinessNaviVC,footprintNaviVC], animated: true )
        }else if signType == "2"  {//维修签到
            let maintainVC = DDMaintainVC()
            let maintainNaviVC = DDBussinessNaviVC.init(rootViewController: maintainVC)
            maintainNaviVC.signType = .maintain
            footprintNaviVC.signType = .maintain
            tableVC.setViewControllers([maintainNaviVC,footprintNaviVC], animated: true )
        }else{//未知状况            let bussinessVC = DDBussinessVC()
            let bussinessVC = DDBussinessVC()
            let bussinessNaviVC = DDBussinessNaviVC.init(rootViewController: bussinessVC)
            bussinessNaviVC.signType = .bussiness
            footprintNaviVC.signType = .bussiness
            tableVC.setViewControllers([bussinessNaviVC,footprintNaviVC], animated: true )
            //            GDAlertView.alert("非业务和维护人员,暂无权查看", image: nil, time: 2, complateBlock: nil)
            //            return
        }
        self.navigationController?.pushViewController(tableVC, animated: animated)
    }
    func openLoactionService() {
        
            let sure = UIAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default) { (action) in
                self.openSetting()
            }
            let cancel = UIAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default) { (action) in
            }
            self.alert(title: "location_enable_whether_turn_on"|?|, detailTitle: nil, style: UIAlertController.Style.alert, actions: [sure , cancel ])
        
    }
    func myShopClick(type:String) {
        switch type {
        case "1"://单个自营
            break
        case "2"://未申请店铺
            let vc = DDNoShopVC()
            self.navigationController?.pushViewController(vc , animated: true )
        case "3"://单个总店
            break
        case "4"://多家店铺
            let vc = DDShopListVC()
            self.navigationController?.pushViewController(vc , animated: true )
        default:
            break
        }
    }
    
    func setGroupAction() {
        
//        let authorized = apiModel.data?.member_examine_status ?? ""
//        if authorized == "1"{
//            let hasGroup = apiModel.data?.create_team_status ?? ""
//            if hasGroup == "0"{//未创建
//                let hasJoinGroup = apiModel.data?.join_team_status ?? ""
//                if hasJoinGroup  == "1"{
//                    let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//                        //                        print(action._title)
//                    })
//                    let message1  =  "您已是小组成员,暂无权限查看此模块"//"您已是小组成员,不能创建小组"
//                    let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
//                    alert.isHideWhenWhitespaceClick = false
//                    UIApplication.shared.keyWindow?.alert( alert)
//                }else{
//                    self.pushVC(vcIdentifier: "DDSetWithoutGroupVC", userInfo: nil)
//                }
//
//
//
//            }else{// 已创建
//                self.pushVC(vcIdentifier: "DDSetWithGroupVC", userInfo: apiModel.data?.create_team_status ?? "" )
//            }
//
//
//
//            //            let hasJoinGroup = apiModel.data?.join_team_status ?? ""
//            //            if hasJoinGroup  == "1"{
//            //                let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//            //                    print(action._title)
//            //                })
//            //                let message1  = "您已是小组成员,不能创建小组"
//            //                let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
//            //                alert.isHideWhenWhitespaceClick = false
//            //                UIApplication.shared.keyWindow?.alert( alert)
//            //            }else{
//            //
//            //                let hasGroup = apiModel.data?.create_team_status ?? ""
//            //                if hasGroup == "0"{
//            //                    self.pushVC(vcIdentifier: "DDSetWithoutGroupVC", userInfo: nil)
//            //                }else{
//            //                    self.pushVC(vcIdentifier: "DDSetWithGroupVC", userInfo: apiModel.data?.create_team_status ?? "" )
//            //                }
//            //            }
//            //-1、待提交 0、待审核 1、审核通过 2、审核不通过
//        }else if authorized == "-1"{
//            let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//                //                print(action._title)
//            })
//
//            let sure = DDAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action ) in
//
//                let vc = DDUserVerifiedVC() //JudgeVC()
//                self.navigationController?.pushViewController(vc, animated: true)
//            })
//            let message1  = "您还未进行实名认证,无法创建小组,是否前去进行实名认证"
//            let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"pop-upauthentication"), actions:  [cancel,sure])
//
//            alert.isHideWhenWhitespaceClick = false
//            UIApplication.shared.keyWindow?.alert( alert)
//        }else{
//            let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//                //                print(action._title)
//            })
//            let message1  = "您的实名认证还未通过,暂时无法创建安装小组"
//            let alert = DDNotice2Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"),  actions:  [cancel])
//            alert.isHideWhenWhitespaceClick = false
//            UIApplication.shared.keyWindow?.alert( alert)
//        }
        
    }
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind ==  UICollectionView.elementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader", for: indexPath) as? HomeSectionHeader{
                //                header.backgroundColor = UIColor.randomColor()
                header.bannerActionDelegate = self
                header.msgActionDelegate = self
                if let model = self.apiModel.data?.notice{
                    header.msgModels =    model
                }
                if let model = self.apiModel.data?.banner{
                    header.bannerModels = model
                }
                header.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: sectionHeaderH)
                return header
                
            }
        }else if kind == UICollectionView.elementKindSectionFooter  {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter", for: indexPath)
            if let footer = footer as? HomeSectionFooter{
                footer.describeString = describeString
            }
//            footer.bounds = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 40)
            return footer
        }
        return UICollectionReusableView.init()
    }
    
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItem", for: indexPath)
        if let itemUnwrap = item as? HomeItem , let model = self.apiModel.data?[indexPath.item]{
            itemUnwrap.model = model
        }
        //        item.backgroundColor = UIColor.randomColor()
        return item
    }
    
}
extension DDItem1VC : BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{
    func performMsgAction(indexPath: IndexPath) {
//        if let data = self.apiModel.data{
//            let msgModel = data.notice[indexPath.item % data.notice.count]
//            toWebView(messageID: msgModel.id)
//            mylog(indexPath)
//
//        }
    }
    @objc func toWebView(messageID:String) {
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: DomainType.wap.rawValue + "message/\(messageID)?type=notice")
        //        let model = DDActionModel.init()
        //        model.keyParameter = DomainType.wap.rawValue + "message/\(messageID)?type=notice"
        //        let web : GDBaseWebVC = GDBaseWebVC()
        //        web.showModel = model
        //        self.navigationController?.pushViewController(web , animated: true )
    }
    func testGotoRewardDetailVC() {
//        let vc = DDRewardDetailVC()
//        self.navigationController?.pushViewController(vc , animated: true)
    }
    func moreBtnClick() {
        mylog("to message page ")
        if DomainType.api.rawValue.contains("https://tpi.hilao.cn/") {
//            let vc = DianGongAuthorVC()
//            self.navigationController?.pushViewController(vc , animated: true )
//            self.pushVC(vcIdentifier: "DianGongAuthorVC", userInfo: DDAccount.share.electrician_examine_status)
//            return
        }
        if let naviVC = rootNaviVC?.tabBarVC.selectedViewController as? UINavigationController{
            naviVC.popToRootViewController(animated: false)
        }
        if let tarBarControllers = rootNaviVC?.tabBarVC.viewControllers{
            for (index , vc ) in tarBarControllers.enumerated(){
                if vc is DDItem2NavVC{
                    rootNaviVC?.tabBarVC.selectedIndex = index
                }
            }
        }
    }
    
    func performBannerAction(indexPath : IndexPath) {
        
//        if let data = self.apiModel.data{
//            let model = data.banner[indexPath.item % data.banner.count]
//            if model.target ?? "" == "share"{
//                self.pushVC(vcIdentifier: "DDShareToWeiChatWebVC", userInfo: model.link_url)
//            }else{
//                self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: model.link_url)
//            }
//        }
        
        //        mylog(indexPath)
        //        model.keyParameter = model.link_url
        //        let web : GDBaseWebVC = GDBaseWebVC()
        //        web.showModel = model
        //        self.navigationController?.pushViewController(web , animated: true )
    }
    
    
}
import SDWebImage
class HomeItem : UICollectionViewCell {
    var model : DDHomeFoundation = DDHomeFoundation(){
        didSet{
            if let url  = URL(string:model.image_url) {
                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                imageView.image = DDPlaceholderImage
            }
            label.text = model.name
        }
    }
    
    
    let imageView = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView )
        self.contentView.addSubview(label )
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        label.text = "exemple"
        label.textAlignment = .center
        label.textColor = UIColor.DDSubTitleColor
        label.font = DDFont.systemFont(ofSize: 13.4)
        label.adjustsFontSizeToFitWidth = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0 , y : 0 , width : self.bounds.width , height : self.bounds.width)
        label.frame = CGRect(x:0  , y : imageView.frame.maxY , width : self.bounds.width , height : self.bounds.height - self.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DDItem1VC{
    /*
     func todoSomethingAfterCheckVersion() {
     checkAppVersion { (result , description) in
     
     if let result = result{
     var actions = [DDAlertAction]()
     
     let sure = DDAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action ) in
     print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
     let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"
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
     let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action ) in
     print("cancel update")
     })
     actions.append(cancel)
     }
     let alertView = DDAlertOrSheet(title: "新版本提示", message: description , preferredStyle: UIAlertControllerStyle.alert, actions: actions)
     alertView.isHideWhenWhitespaceClick = false
     UIApplication.shared.keyWindow?.alert(alertView)
     }else{
     print("无最新版本")
     }
     }
     
     
     
     
     //            print(result)
     //            var actions = [UIAlertAction]()
     //            let sure = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action ) in
     //                print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
     //               let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"
     //                    if let url = URL(string: urlStr){
     //                    if UIApplication.shared.canOpenURL(url) {
     //                        UIApplication.shared.openURL(url )
     //                    }
     //                }
     //            })
     //
     //            actions.append(sure)
     //
     //            if let result = result{
     //                if result{
     //                    print("force update")
     //                }else{
     //                    let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action ) in
     //                        print("cancel update")
     //                    })
     //                        actions.append(cancel)
     //                }
     //                self.alert(title: description ?? "提示", detailTitle: nil , actions: actions)
     //            }
     //        }
     }
     
     
     /// checkAppVersion
     ///
     /// - Parameter callBack: callBack block's parameter equal nil means need't update , false means optional update , true means force update
     /// - Parameter description : alert Message
     func checkAppVersion(callBack:@escaping (Bool?,String?) -> Void) {
     DDRequestManager.share.checkLatestAppVersion()?.responseJSON(completionHandler: { (response) in
     if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<CheckAppVersionResultModel>.self, from: response){
     print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
     dump(apiModel)
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
     
     }
     })
     }
     */
    func noPayPasswordAlertWhileGetCash() {
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//                //                print(action._title)
//            })
//
//            let sure = DDAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action ) in
//                //                print(action._title)
//                NotificationCenter.default.post(name: NSNotification.Name.init("noPayPasswordAlertWhileGetCash"), object: nil)
//
//
//            })
//            let message1  = "您还未设置支付密码,无法提现,是否前去设置支付密码"
//
//            let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"pop-uppaymentpassword"), actions:  [cancel,sure])
//
//            alert.isHideWhenWhitespaceClick = false
//            UIApplication.shared.keyWindow?.alert( alert)
//
//        })
    }
    
    func noAuthorizedAlertWhileBandCard() {
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//                //                print(action._title)
//            })
//
//            let sure = DDAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action ) in
//                let vc = DDUserVerifiedVC() // JudgeVC()
//                self.navigationController?.pushViewController(vc, animated: true)
//            })
//            let message1  = "您还未进行实名认证,无法绑定银行卡,是否前去进行实名认证"
//            let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"pop-upauthentication"), actions:  [cancel,sure])
//
//            alert.isHideWhenWhitespaceClick = false
//            UIApplication.shared.keyWindow?.alert( alert)
//
//        })
    }
    func noAuthorizedAlertWhileGetCash() {
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action ) in
//                //                print(action._title)
//            })
//
//            let sure = DDAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action ) in
//                NotificationCenter.default.post(name: NSNotification.Name.init(" DDUserVerifiedVC"), object: nil)
//            })
//            let message1  = "您还未进行实名认证,无法提现,是否前去进行实名认证"
//            let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"pop-upauthentication"), actions:  [cancel,sure])
//
//            alert.isHideWhenWhitespaceClick = false
//            UIApplication.shared.keyWindow?.alert( alert)
//
//        })
    }
    
    
}
