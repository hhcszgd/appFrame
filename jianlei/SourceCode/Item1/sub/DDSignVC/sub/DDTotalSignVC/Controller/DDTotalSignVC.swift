//
//  DDTotalSignVC.swift
//  Project
//
//  Created by WY on 2019/8/12.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class DDTotalSignVC: DDNormalVC {
    let timeRow = UILabel()
    let locationRow = UILabel()
    let signTimesRow = UILabel()
    var paraTeamId : String!
    var paraTeamName : String!
    var paraTime : String!
    let mapView = GDMapInView()
    let adjustPoint = UIImageView()
    var adjustedAddressString : String = ""
    var completed : ((String)->())?
    var apiModel  : ApiModel<DDAllSignDataModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "all_sign"|?|
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self , selector: #selector(locationChanged), name: DDLocationManager.GDLocationChanged, object: nil)
        //        setNavigationItem()
        setCustomSubviews()
        self.locationChanged()
        requestApi()
    }
    func requestApi() {
        DDRequestManager.share.getAllSignPoint(type: ApiModel<DDAllSignDataModel>.self, team_id: paraTeamId, create_at: paraTime, success: { (model ) in
            if model.status == 200 {
                self.apiModel = model
                self.layoutLabels()
                self.setAnnocation()
                
            }else{
                GDAlertView.alert(model.message, image: nil , time: 2, complateBlock: nil )
            }
            
        })
    }
    func setAnnocation() {
        var nun : Int = 0
        if let arr = self.apiModel?.data?.sign_data{
            let annotations = arr.map { (model ) -> GDLocation in
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
            self.mapView.mapView.addAnnotations(annotations)
        }
    }
    deinit {
        completed?(adjustedAddressString)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        self.view.addSubview(timeRow)
        self.view.addSubview(locationRow)
        self.view.addSubview(signTimesRow)
        timeRow.backgroundColor = UIColor.white
        locationRow.backgroundColor = UIColor.white
        signTimesRow.backgroundColor = UIColor.white
        
        timeRow.textColor = UIColor.lightGray
        locationRow.textColor = UIColor.lightGray
        signTimesRow.textColor = UIColor.lightGray
        
        timeRow.textAlignment  = .center
        locationRow.textAlignment  = .center
        signTimesRow.textAlignment  = .center
        
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
        timeAttributeString.append(NSAttributedString(string: " \(paraTime!)"))
        timeRow.attributedText = timeAttributeString
        
        let signTimesAttributeString = NSMutableAttributedString(attributedString: signTimesIcon)
        let signCountAttribute = [" \("have_sign_totally"|?|)","\(self.apiModel?.data?.total ?? "0")","次"].setColor(colors: [UIColor.lightGray,UIColor.orange,UIColor.lightGray])
        signTimesAttributeString.append(signCountAttribute)
        signTimesRow.attributedText = signTimesAttributeString
        
        let locationIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let locationAttributeString = NSMutableAttributedString(attributedString: locationIcon)
        locationAttributeString.append(NSAttributedString(string:" \(paraTeamName!)"))
        locationRow.attributedText = locationAttributeString
        
        
        
        
        
        timeRow.ddSizeToFit(contentInset: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        locationRow.ddSizeToFit(contentInset: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        signTimesRow.ddSizeToFit(contentInset: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        timeRow.frame = CGRect(x: 10, y: mapView.frame.minY + 40, width: timeRow.bounds.width, height: timeRow.bounds.height)
        
        locationRow.frame = CGRect(x: 10, y: timeRow.frame.maxY + 10, width: locationRow.bounds.width, height: locationRow.bounds.height)
        
        signTimesRow.frame = CGRect(x: 10, y: locationRow.frame.maxY + 10, width: signTimesRow.bounds.width, height: signTimesRow.bounds.height)
        timeRow.layer.cornerRadius = timeRow.bounds.height/2
        locationRow.layer.cornerRadius = timeRow.bounds.height/2
        signTimesRow.layer.cornerRadius = timeRow.bounds.height/2
        timeRow.layer.masksToBounds = true
        locationRow.layer.masksToBounds = true
        signTimesRow.layer.masksToBounds = true
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
extension DDTotalSignVC{
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
