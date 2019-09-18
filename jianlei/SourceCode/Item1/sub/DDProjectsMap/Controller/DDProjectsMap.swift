//
//  DDProjectsMap.swift
//  jianlei
//
//  Created by WY on 2019/9/5.
//  Copyright © 2019 WY. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
class DDProjectsMapVC: DDNormalVC {


    let mapView = GDMapInView()
    var apiModel  : ApiModel<DDAllSignDataModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工程分布"
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self , selector: #selector(locationChanged), name: DDLocationManager.GDLocationChanged, object: nil)
        //        setNavigationItem()
        setCustomSubviews()
        self.locationChanged()
        requestApi()
        
    }
    
    func requestApi() {
//        DDRequestManager.share.getAllSignPoint(type: ApiModel<DDAllSignDataModel>.self, team_id: paraTeamId, create_at: paraTime, success: { (model ) in
//            if model.status == 200 {
//                self.apiModel = model
//                self.layoutLabels()
//                self.setAnnocation()
//
//            }else{
//                GDAlertView.alert(model.message, image: nil , time: 2, complateBlock: nil )
//            }
//
//        })
    }
    func setAnnocation() {
        let test = GDLocation()
        test.type = .image1
        test.title = "xxxtitle"
//        test.subtitle = "xxxsubtitle"
        test.coordinate = CLLocationCoordinate2D(latitude: 39.83264471473504, longitude: 116.29211742657485)
        
        let test1 = GDLocation()
        test1.type = .image2
//        test1.title = "xxxtitle"
        test1.subtitle = "xxxstttt tttttt tttttttt  tttttt tubtitle zzzzzzz llll ... 000000 99999 lllll kkkkkkk hhhhhhhhhhhhhhhhhhh hhyyy yyyyyy"
        test1.coordinate = CLLocationCoordinate2D(latitude: 39.83264471473504, longitude: 115.00911742657485)
        let annotations = [test , test1]
        self.mapView.mapView.addAnnotations(annotations)
        return
        
        
        
        
        var nun : Int = 0
        if let arr = self.apiModel?.data?.sign_data{
            var annotations = arr.map { (model ) -> GDLocation in
                nun += 1
                let location = GDLocation()
                location.title = model.shop_name
                location.serialNumber = "\(nun)"
                location.type = .image1
                var longitude = model.longitude
                var latitude = model.latitude
                if DDLocationManager.share.userLocateCountry.countryName == "中国" {
                    latitude = model.gd_latitude == nil ? model.latitude : model.gd_latitude
                    longitude = model.gd_longitude == nil ? model.longitude : model.gd_longitude
                }
                
                if let longitude = longitude , let latitude = latitude , let lon = CLLocationDegrees(longitude) , let lat = CLLocationDegrees(latitude){
                    location.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    
                }
                return location
            }
            
            if let firstAnnotations = annotations.first{
                
                self.mapView.mapView.setCenter(firstAnnotations.coordinate, animated: true)
                self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: firstAnnotations.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: true )
            }else{
                self.mapView.mapView.showsUserLocation = true
            }
            
            
            
            if self.mapView.mapView.annotations.count > 0 {
                self.mapView.mapView.removeAnnotations(self.mapView.mapView.annotations)
            }
//            let test = GDLocation()
//            test.type = .image1
//            test.title = "xxxtitle"
//            test.subtitle = "xxxsubtitle"
//            test.coordinate = CLLocationCoordinate2D(latitude: 39.83264471473504, longitude: 116.29211742657485)
//
//            let test1 = GDLocation()
//            test1.type = .origen
//            test1.title = "xxxtitle"
//            test1.subtitle = "xxxsubtitle"
//            test1.coordinate = CLLocationCoordinate2D(latitude: 39.83264471473504, longitude: 116.29211742657485)
//            annotations = [test]
            self.mapView.mapView.addAnnotations(annotations)
        }
    }
    deinit {
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAnnocation()
        //        let anocation = GDLocation()
        //        anocation.coordinate = CLLocationCoordinate2D(latitude: self.mapView.mapView.userLocation.coordinate.latitude + 0.0002, longitude: self.mapView.mapView.userLocation.coordinate.longitude + 0.001)
        ////                anocation.subtitle = "subtitle sb"
        //                anocation.title = "55"
        //        anocation.type = GDLocationType.image1
        //        self.mapView.addPlaceMark(location: anocation)
    }
    func setCustomSubviews() {
        self.view.addSubview(mapView)
        mapView.mapView.showsUserLocation = false

        mapView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        
        ///获取屏幕中心的位置 , 实现拖动微调功能///
        //        self.mapView.addSubview(adjustPoint)
        //        let adjustPointWH : CGFloat = 11
        //        adjustPoint.frame = CGRect(x: mapView.bounds.width/2 - adjustPointWH/2, y: mapView.bounds.height/2 - adjustPointWH/2, width: adjustPointWH, height: adjustPointWH)
        //        adjustPoint.backgroundColor = UIColor.red
        //        mapView.mapDidEndMove = {[weak self] in
        //            if let _self = self {
        //                let coonidate = _self.mapView.mapView.convert(_self.adjustPoint.center, toCoordinateFrom: _self.mapView)
        //                DDLocationManager.share.placemarkFromLocation(location: CLLocation(latitude: coonidate.latitude, longitude: coonidate.longitude), completHandle: { (placeMark ) in
        //                    mylog("获取的位置是\(placeMark?.name)")
        //                    _self.adjustedAddressString = placeMark?.name ?? ""
        //                })
        //                mylog("屏幕中心处的坐标\(coonidate.latitude) , \(coonidate.longitude)")
        //
        //            }
        //
        //        }
        
        layoutLabels()
    }
    
    func layoutLabels() {
        
        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3  * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
        let signTimesIcon = UIImage(named: "loction")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|)"//"yyyy-MM-dd 'at' HH:mm"
        let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
        //        timeAttributeString.append(NSAttributedString(string: " \(dateFormater.string(from: Date()))"))
        
        
    }
    @objc func locationChanged() {
        if let lo = self.mapView.mapView.userLocation.location{
            DDLocationManager.share.placemarkFromLocation(location: lo ) { (placeMark) in
                
                //                self.mapView.mapView.setCenter(lo.coordinate, animated: false)
                //                self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: lo.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: false )
            }
            
        }
    }
    
    func setNavigationItem() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 36))
        button.setTitle("sure"|?|, for: UIControl.State.normal)
        button.backgroundColor = .orange
        button.addTarget(self , action: #selector(sureButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 5
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func sureButtonClick(sender:UIButton)  {
        mylog("sure click")
    }
    
    
}
extension DDProjectsMapVC{
    class DDAllSignDataModel: Codable {
        var total : String?
        var sign_data : [DDSignLocationModel]?
    }
    class DDSignLocationModel: Codable {
        var shop_name : String?
        var shop_address : String?
        var longitude : String?
        var latitude : String?
        var gd_longitude : String?
        var gd_latitude : String?
        var late_sign : String?
        var create_at : String?
    }
    
}


extension DDProjectsMapVC{
    struct Para : Equatable {
        var img:String
        var title: String
    }
//    enum ProjectType : Int {
//        case processing = 0
//        case done
//        case applying
//        case failure
//    }
    class ProjectProcessBar:UIView {
        ///nil:未选择 , 0:进行中 , 1:已完成 , 2:投标中 , 3: 未中标
        var selectIndex : Int?
        private var oldModel : [Para]?
        var model : [Para] =  [
            Para(img:"img2" , title:"进行中") ,
            Para(img:"img2" , title:"已完成") ,
            Para(img:"img2" , title:"投标中"),
            Para(img:"img2" , title:"未中标")
            ]{
            willSet{
                oldModel = model
            }
            didSet{
                self.layoutIfNeeded()
                self.setNeedsLayout()
            }

        }
        override func layoutSubviews() {
            super.layoutSubviews()
            if oldModel == nil  {oldModel = model}
            if oldModel! != model{
                self.subviews.forEach { (subview) in
                    subview.removeFromSuperview()
                }
                let oneW = self.bounds.width / CGFloat(model.count)
                for (index , para)  in model.enumerated() {
                    
                    let b = UIButton(frame: CGRect(x: CGFloat(index) * oneW, y: 0, width: oneW, height: self.bounds.height))
                    b.tag = index
                    b.setImage(UIImage(named:para.img), for: UIControl.State.normal)
                    b.setTitle(" " + para.title, for: UIControl.State.normal)
                    b.adjustsImageWhenHighlighted = false
                    self.addSubview(b)
                }                
            }
            
            if self.selectIndex != nil {
                self.subviews.forEach { (subview) in
                    if subview.tag == self.selectIndex!{
                        subview.isHidden == false
                        subview.frame = CGRect(x: 0, y: 0, width: self.bounds.width / CGFloat(subviews.count), height: self.bounds.height)
                    }else{
                        subview.isHidden == true
                    }
                }
            }
            
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            
        }
        func click(sender:UIButton)  {
            self.selectIndex = sender.tag
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}
