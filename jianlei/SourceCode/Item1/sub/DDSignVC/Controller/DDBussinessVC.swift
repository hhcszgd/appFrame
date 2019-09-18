//
//  DDBussinessVC.swift
//  Project
//
//  Created by WY on 2019/8/9.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class DDBussinessVC: DDNormalVC {
    
    var hasBeenClick = false
    var firstApiModel :  ApiModel<DDSignPageModel>?
    
    var model : ApiModel<DDSignPageModel>?
    var timer : Timer?
    var currentCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0 )
//    var timeInterval : Int = 500
    /*
    func addTimer() {
        self.reloadTime()
        self.removeTimer()
        //        self.sendCodeBtn.isEnabled = false
//        self.timeInterval -= 1
        //        self.sendCodeBtn.setTitle("\(self.timeInterval)秒后重发", for: UIControl.State.disabled)
        timer = Timer.init(timeInterval: 300, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func daojishi() {
//        self.timeInterval -= 1
        
//        if self.timeInterval <= 0 {
            self.getServerTime()
//           self.timeInterval = 500
//        }else{
//
//        }
    }
    */
    func getServerTime() {
        
         reloadTime()
        
    }
    
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "签到" // "sign_title"|?|
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)], for: UIControl.State.normal)
        self.tabBarItem.image = UIImage(named:"JL_signin")
        self.tabBarItem.selectedImage = UIImage(named:"JL_signin_sel")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let timeLabel = DDRowView()
    let groupLabel = DDRowView()
    let line = UIView()
    let mapView = GDMapInView()
    let building = UILabel()
    let adjustLocationButton = UIButton()
    let signButton = UIButton()
    let signDescribeLabel = UILabel()
    let upContainerView = UIView()
    
    var province = "" //省/直辖市
    var city = "" //城市
    var qu = "" //区
    var street = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "sign_title"|?|
        self.view.backgroundColor = UIColor.random
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "returnImage"), landscapeImagePhone: nil , style: UIBarButtonItem.Style.plain, target: self , action: #selector(goback))
        // Do any additional setup after loading the view.
        configSubviews()
//        locationChanged()
        NotificationCenter.default.addObserver(self , selector: #selector(locationChanged), name: DDLocationManager.GDLocationChanged, object: nil)
//        addTimer()
//        self.getSignPageData()
    }
    
    
    
    func reloadTime()  {
        DDRequestManager.share.getServerTime(type: ApiModel<String>.self, success: { (model ) in
            if let time = model.data{
                let dataFormate = DateFormatter()
                dataFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let tempDate = dataFormate.date(from: time){
                    let c = Calendar.current
                    let set = Set([Calendar.Component.hour , Calendar.Component.minute])
                    let a = c.dateComponents(set, from: tempDate)
                    mylog(a.hour)
                    mylog(a.minute)
                    var timeStr = ""
                    if let hour = a.hour, let minute = a.minute{
                        let hourStr = hour > 9 ? "\(hour)" : "0\(hour)"
                        let minuteStr = minute > 9 ? "\(minute)" : "0\(minute)"
                        timeStr = " \("sign_title"|?|)\n\(hourStr) : \(minuteStr)"
                    }else{
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "HH:mm"
                        timeStr = " \("sign_title"|?|)\n\(dateFormater.string(from: Date()))"
//                        self.signButton.setTitle(" 签到\n\(dateFormater.string(from: Date()))", for: UIControl.State.normal)
                    }
                    self.signButton.setTitle(timeStr, for: UIControl.State.normal)
                    self.signButton.setTitle(timeStr, for: UIControl.State.disabled)
                }else{
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "HH:mm"
                    self.signButton.setTitle(" \("sign_title"|?|)\n\(dateFormater.string(from: Date()))", for: UIControl.State.normal)
                }
            }else{
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "HH:mm"
                self.signButton.setTitle(" \("sign_title"|?|)\n\(dateFormater.string(from: Date()))", for: UIControl.State.normal)
            }
            mylog(model.message )
        }, failure: { (error) in
            mylog(error )
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "HH:mm"
            self.signButton.setTitle(" \("sign_title"|?|)\n\(dateFormater.string(from: Date()))", for: UIControl.State.normal)
        }) {
            
        }
    }
    
    func getSignPageData( success:((ApiModel<DDSignPageModel>)->())? = nil ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil) {
        DDRequestManager.share.getBussinessSignPageData(type: ApiModel<DDSignPageModel>.self, success: { (model ) in
            mylog(model.data)
            if model.status == 200{
//                if let oldTeamId = self.firstApiModel?.data?.team_id , let newTeamID =  model.data?.team_id , oldTeamId != newTeamID {
//                    NotificationCenter.default.post(Notification.init(name: Notification.Name.init("DDTeamChanged")))
//                    return
//                }
                self.model = model
                if self.firstApiModel == nil {
                    self.firstApiModel = model
                }
                self.layoutCustomSubviews()
                
            }else{
                    GDAlertView.alert(model.message, image: nil, time: 2, complateBlock: nil)
            }
            success?(model)
        }){
            complate?()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.removeTimer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSignPageData()
//        addTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.mapView.showsUserLocation = false
        self.mapView.mapView.showsUserLocation = true
    }
    deinit {
        mylog("业务签到页面deinit")
        NotificationCenter.default.removeObserver(self)
    }
    @objc func locationChanged() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            if let lo = self.mapView.mapView.userLocation.location{
                DDLocationManager.share.placemarkFromLocation(location: lo ) { (placeMark) in
                    DDLocationManager.share.updateUserCurrentLoactionOnDisk( placeMark?.addressDictionary)
                    //                self.building.text = placeMark?.name
                    //                let formatedAddress = (placeMark?.addressDictionary?["FormattedAddressLines"] as? [String]) ?? [""]
                    //                let provinceAreaStrect = (formatedAddress.first ?? "") + " "
                    //                let buildingName = placeMark?.name ?? ""
                    //                let fullName = provinceAreaStrect + buildingName
                    //                self.building.text = fullName
                    if placeMark == nil {
                        if self == self.navigationController?.children.last{
                            GDAlertView.alert("ReverseGeocodeLocationError"|?|, image: nil, time: 2, complateBlock: nil)
                        }
                    }else{
                        
                        self.province = (placeMark?.addressDictionary?["State"] as? String) ?? "" //省/直辖市
                        self.city = (placeMark?.addressDictionary?["City"] as? String ) ?? ""//城市
                        self.qu = (placeMark?.addressDictionary?["SubLocality"] as? String ) ?? "" //区
                        self.street = (placeMark?.addressDictionary?["Street"] as? String ) ?? "" //
                        self.currentCoordinate = lo.coordinate
                        self.mapView.mapView.setCenter(lo.coordinate, animated: false)
                        self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: lo.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: false )
                        self.building.text = self.street
                    }
                }
                
            }else{
                if self == self.navigationController?.children.last{
                    GDAlertView.alert("FailureToGetUserLocation"|?|, image: nil, time: 2, complateBlock: nil)
                }
            }
        }

    }
    @objc func adjustLocation() {
        let vc = DDAdjustLocationVC()
        vc.userInfo = nil
        vc.completed = {[weak self ] adjustedAddressString in
            self?.building.text = adjustedAddressString
        }
        self.navigationController?.pushViewController(vc , animated: true )
    }
    
    func configSubviews()  {
        adjustLocationButton.addTarget(self , action: #selector(adjustLocation), for: UIControl.Event.touchUpInside)
        self.view.backgroundColor = UIColor.DDLightGray
        self.view.addSubview(upContainerView)
        upContainerView.addSubview(timeLabel)
        upContainerView.addSubview(groupLabel)
        upContainerView.addSubview(line)
        upContainerView.addSubview(mapView)
        upContainerView.addSubview(building)
//        upContainerView.addSubview(adjustLocationButton)
        
        building.font = GDFont.systemFont(ofSize: 16)
        adjustLocationButton.titleLabel?.font = GDFont.systemFont(ofSize: 16)
        
        timeLabel.titleLabel.font = GDFont.systemFont(ofSize: 16)
        groupLabel.titleLabel.font = GDFont.systemFont(ofSize: 16)
        
        timeLabel.titleLabel.textColor = UIColor.lightGray
        building.textColor = UIColor.lightGray
        groupLabel.titleLabel.textColor = UIColor.lightGray
        self.view.addSubview(signButton)
        self.view.addSubview(signDescribeLabel)
        signDescribeLabel.textColor = UIColor.lightGray
        signDescribeLabel.textAlignment = .center
        self.upContainerView.backgroundColor = .white
        signButton.setBackgroundImage(UIImage(named: "JL_signinbutton"), for: UIControl.State.normal)
        signButton.setBackgroundImage(UIImage(named: "JL_signinbutton_gray"), for: UIControl.State.disabled)
        signButton.contentHorizontalAlignment = .center
        signButton.titleLabel?.numberOfLines = 2
        
        self.mapView.mapView.showsUserLocation = true
        signButton.addTarget(self , action: #selector(signAction(sender:)), for: UIControl.Event.touchUpInside)
        
        //        layoutCustomSubviews()
    }
    @objc func signAction(sender:UIButton) {
        if let address = building.text , address.count > 0{//go on
            if !hasBeenClick{ hasBeenClick = true }else{return}
            mylog("perform sign")
            getSignPageData(success: {[weak self ] (model ) in
                self?.hasBeenClick = false
//                if let oldTeamId = self?.firstApiModel?.data?.team_id , let newTeamID =  model.data?.team_id , oldTeamId != newTeamID {
//                      NotificationCenter.default.post(Notification.init(name: Notification.Name.init("DDTeamChanged")))
//                    return
//                }
//                if model.data?.interval ?? "" == "1"{//不能签到
//                    GDAlertView.alert("\("sign_interval_should_not_less_than"|?|)\(self?.model?.data?.sign_interval_time ?? "0")\("date_minute"|?|)", image: nil , time: 2 , complateBlock: nil )
//                    self?.hasBeenClick = false
//                }else{
                    var para = [String:String]()
//                    para["team_id"] = self?.model?.data?.team_id
                    para["teamName"] = self?.model?.data?.team
//                    para["shop_address"] = self?.building.text
                    para["shop_address"] = "\(self?.province ?? "")\(self?.city ?? "")\(self?.qu ?? "")\(self?.street ?? "")"
                    if let longitude = self?.currentCoordinate.longitude,let latitude = self?.currentCoordinate.latitude{
                        para["longitude"] = "\(longitude)"
                        para["latitude"] = "\(latitude)"
                    }
                    
                    para["province"] = self?.province
                    para["city"] = self?.city
                    para["qu"] = self?.qu
                    para["street"] = self?.street
//                    let vc = BussinessSignVC()
//                    vc.userInfo = para
//                    self?.navigationController?.pushViewController(vc , animated: true )
                    self?.pushVC(vcIdentifier: "BussinessSignVC", userInfo: para)
//                }
            })
        }else{
//            GDAlertView.alert("getting_location_try_again_later"|?|, image: nil, time: 2, complateBlock: nil)
//            self.locationChanged()
            self.mapView.mapView.showsUserLocation = false
            self.mapView.mapView.showsUserLocation = true
            return
        }
//        if !hasBeenClick{ hasBeenClick = true }else{return}
//        mylog("perform sign")
//        getSignPageData(success: {[weak self ] (model ) in
//            if model.data?.interval ?? "" == "1"{//不能签到
//                GDAlertView.alert("签到间隔不能少于\(self?.model?.data?.sign_interval_time ?? "0")分钟", image: nil , time: 2 , complateBlock: nil )
//                self?.hasBeenClick = false
//            }else{
//                var para = [String:String]()
//                para["team_id"] = self?.model?.data?.team_id
//                para["teamName"] = self?.model?.data?.team_name
//                para["shop_address"] = self?.building.text
//                if let longitude = DDLocationManager.share.locationManager.location?.coordinate.longitude,let latitude = DDLocationManager.share.locationManager.location?.coordinate.latitude{
//                    para["longitude"] = "\(longitude)"
//                    para["latitude"] = "\(latitude)"
//                }
//                let vc = BussinessSignVC()
//                vc.userInfo = para
//                self?.navigationController?.pushViewController(vc , animated: true )
//            }
//        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hasBeenClick = false
    }
    func layoutCustomSubviews() {
//        if let temp = self.model?.data?.over_time , !temp.isEmpty{
////            signDescribeLabel.text = "超时签到"
//            if let id = self.model?.data?.team_id , id == "0"{
//                signDescribeLabel.text = ""
//            }else{
//                    signDescribeLabel.text = "sign_overtime"|?|
//            }
////            signDescribeLabel.attributedText =  ["已超时签到" , "\(status)" , "分钟" ].setColor(colors: [UIColor.gray , UIColor.orange , UIColor.gray])
//        }else{
            if let temp = self.model?.data?.sign_num , temp > "0"{
                signDescribeLabel.text = "\("have_sign_today"|?|)\(temp)\("times"|?|)"
            }else{
                signDescribeLabel.text = "have_not_sign_today"|?|
            }
//        }
       
        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
        let groupIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        //        let dateFormater = DateFormatter()
        //        dateFormater.dateFormat = "yyyy年MM月dd日"//"yyyy-MM-dd 'at' HH:mm"
        let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
        timeAttributeString.append(NSAttributedString(string: " \(self.model?.data?.date ?? "")"))
        timeLabel.titleLabel.attributedText = timeAttributeString
        var groupName = ""
//        if let temp = self.model?.data?.team_name , !temp.isEmpty{
//            groupName = temp
//            self.signButton.isEnabled = true
//        }else{
//            groupName = "尚未加入任何团队"
//            self.signButton.isEnabled = false
//        }
        
        if (self.model?.data?.team ?? "0" ) != "暂未加入任何团队"{//尚未加入任何团队
            groupName = self.model?.data?.team ?? ""
            self.signButton.isEnabled = true
        }else{
            groupName = "暂未加入任何团队"
            self.signButton.isEnabled = false
        }
        
        
        
        
        
        
        let groupAttributeString = NSMutableAttributedString(attributedString: groupIcon)
        groupAttributeString.append(NSAttributedString(string:" \(groupName)"))
        groupLabel.titleLabel.attributedText = groupAttributeString
        
        let border : CGFloat = 10 * DDDevice.scale
        timeLabel.frame  = CGRect(x: 0, y: border, width: self.view.bounds.width, height: 40 * DDDevice.scale)
        groupLabel.frame  = CGRect(x: 0, y: timeLabel.frame.maxY, width: self.view.bounds.width , height: 40 * DDDevice.scale)
        line.frame = CGRect(x: 0, y: groupLabel.frame.maxY + border, width: self.view.bounds.width , height: 2)
        line.backgroundColor = UIColor.gray(0.1)
        
        
        //        adjustLocationButton.sizeToFit()
        adjustLocationButton.frame = CGRect(x:self.view.bounds.width -  border - adjustLocationButton.bounds.width, y: line.frame.maxY, width: adjustLocationButton.bounds.width, height: 44 * DDDevice.scale)
        building.adjustsFontSizeToFitWidth = true
        building.frame = CGRect(x: border, y: line.frame.maxY , width: adjustLocationButton.frame.minX - border, height: 44 * DDDevice.scale)
        
        
        mapView.frame = CGRect(x: border, y: building.frame.maxY , width: self.view.bounds.width - border * 2, height: 110 * DDDevice.scale)
        adjustLocationButton.setTitle("location_change_little"|?|, for: UIControl.State.normal)
        adjustLocationButton.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        adjustLocationButton.setImage(UIImage(named:"adjustloction"), for: UIControl.State.normal)
////        adjustLocationButton.sizeToFit()
//        adjustLocationButton.frame = CGRect(x:self.view.bounds.width -  border - adjustLocationButton.bounds.width, y: mapView.frame.maxY, width: adjustLocationButton.bounds.width, height: 54 * DDDevice.scale)
//        building.adjustsFontSizeToFitWidth = true
//        building.frame = CGRect(x: border, y: mapView.frame.maxY , width: adjustLocationButton.frame.minX - border, height: 54 * DDDevice.scale)
//
        upContainerView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: mapView.frame.maxY)
        
        
        
        let signButtonWH : CGFloat = self.view.bounds.width/2 * DDDevice.scale
        let leftH : CGFloat = self.view.bounds.height - upContainerView.frame.maxY  - DDTabBarHeight
        let signButtonY : CGFloat = upContainerView.frame.maxY + leftH/2 - signButtonWH/2 - 10
        signButton.frame = CGRect(x: self.view.bounds.width/2 - signButtonWH/2 , y: signButtonY, width: signButtonWH, height: signButtonWH)
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "HH:mm"
        
        signButton.setTitle(" \("sign_title"|?|)\n\(self.model?.data?.time ?? "")", for: UIControl.State.normal)
        signDescribeLabel.frame = CGRect(x: 0, y: signButton.frame.maxY + border , width: self.view.bounds.width, height: 22 * DDDevice.scale)
    }

    func performZoom(zoomLevel : CLLocationDegrees)  {
        var  zoomLevel  = zoomLevel
        if zoomLevel <= 0.001 {
            zoomLevel = 0.001
        }else if zoomLevel >= 111 {
            zoomLevel = 111
        }
        let coordinate = self.mapView.mapView.centerCoordinate
        let span = MKCoordinateSpan.init(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        self.mapView.mapView.setRegion(region, animated: true)
    }
    @objc func goback() {
        self.navigationController?.navigationController?.popViewController(animated: true )
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.mapView.mapView.setCenter(self.mapView.mapView.userLocation.coordinate, animated: true)
//        self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: self.mapView.mapView.userLocation.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true )
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


//class DDOpraterSuddenlyChangeTeam {
//    class func action(vc:UIViewController){
//        if let naviVC = vc.navigationController as? DDBussinessNaviVC {
//            if let tabBarVC =  naviVC.tabBarController as? DDSignTabBarVC{
//                tabBarVC.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//            }
//        }
//    }
//}


/*
  NotificationCenter.default.post(Notification.init(name: Notification.Name.init("DDTeamChanged")))
 */
