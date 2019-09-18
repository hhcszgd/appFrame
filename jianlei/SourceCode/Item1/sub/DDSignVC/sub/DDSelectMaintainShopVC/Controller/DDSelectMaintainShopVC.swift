//
//  DDSelectMaintainShopVC.swift
//  Project
//
//  Created by WY on 2019/8/10.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//not to be used

import UIKit
import MapKit
import CoreLocation
class DDSelectMaintainShopVC: DDNormalVC {
    /*
    let mapView = GDMapInView()
    let adjustPoint = UIImageView()
    var adjustedAddressString : String = ""
    var completed : ((String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择店铺"
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self , selector: #selector(locationChanged), name: DDLocationManager.GDLocationChanged, object: nil)
//        setNavigationItem()
        setCustomSubviews()
        self.locationChanged()
        
    }
    deinit {
        completed?(adjustedAddressString)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let anocation = GDLocation()
        anocation.coordinate = CLLocationCoordinate2D(latitude: self.mapView.mapView.userLocation.coordinate.latitude + 0.0002, longitude: self.mapView.mapView.userLocation.coordinate.longitude + 0.001)
//        anocation.subtitle = "subtitle"
//        anocation.title = "title"
        anocation.type = GDLocationType.image1
        self.mapView.addPlaceMark(location: anocation)
    }
    func setCustomSubviews() {
        self.view.addSubview(mapView)
        mapView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
//        self.mapView.addSubview(adjustPoint)
//        let adjustPointWH : CGFloat = 11
//        adjustPoint.frame = CGRect(x: mapView.bounds.width/2 - adjustPointWH/2, y: mapView.bounds.height/2 - adjustPointWH/2, width: adjustPointWH, height: adjustPointWH)
//        adjustPoint.backgroundColor = UIColor.red
        mapView.mapDidEndMove = {[weak self] in
            if let _self = self {
                let coonidate = _self.mapView.mapView.convert(_self.adjustPoint.center, toCoordinateFrom: _self.mapView)
                DDLocationManager.share.placemarkFromLocation(location: CLLocation(latitude: coonidate.latitude, longitude: coonidate.longitude), completHandle: { (placeMark ) in
                    mylog("获取的位置是\(placeMark?.name)")
                    _self.adjustedAddressString = placeMark?.name ?? ""
                })
                mylog("屏幕中心处的坐标\(coonidate.latitude) , \(coonidate.longitude)")
                
            }
            
        }
    }
    @objc func locationChanged() {
        if let lo = self.mapView.mapView.userLocation.location{
            DDLocationManager.share.placemarkFromLocation(location: lo ) { (placeMark) in
                
                self.mapView.mapView.setCenter(lo.coordinate, animated: false)
                self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: lo.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: false )
            }
            
        }
    }
    
    func setNavigationItem() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 36))
        button.setTitle("确定", for: UIControl.State.normal)
        button.backgroundColor = .orange
        button.addTarget(self , action: #selector(sureButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 5
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func sureButtonClick(sender:UIButton)  {
        mylog("sure click")
    }
*/
}
