//
//  ChaXunMapVC.swift
//  Project
//
//  Created by 张凯强 on 2019/1/21.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ChaXunMapVC: GDNormalVC {
    var areaName: String = ""
    var area: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "区域分布"
        self.requestAnnocation()
        layoutMapview()
        self.view.addSubview(self.cityBtn)
        self.cityBtn.frame = CGRect.init(x: SCREENWIDTH - 120 - 10, y: DDNavigationBarHeight + 10, width: 120, height: 57)
        // Do any additional setup after loading the view.
    }
    lazy var cityBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "switch"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.init(named: "button_bg"), for: UIControlState.normal)
        btn.setTitle("切换城市", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("323232"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(changeCity(sender:)), for: UIControlEvents.touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
        return btn
    }()
    //MARK:切换城市
    @objc func changeCity(sender: UIButton) {
        if let window = UIApplication.shared.keyWindow {
            let containerView = MapViewChangeCity.init(superView: window)
            containerView.selectFinished = { [weak self] (value) in
                self?.setAnnocation(city: value.1)
            }
        }
        
    }
    
    //MARK:布局地图
    func layoutMapview() {
        self.view.addSubview(mapView)
        mapView.mapView.showsUserLocation = false
        mapView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight)
    }
    //MARK:设置大头针
    func setAnnocation(city:String? = nil ) {
        var nun : Int = 0
        if self.dataArr.count > 0 {
            let annotations = self.dataArr.map { (model ) -> GDLocation in
                nun += 1
                let location = GDLocation()
//                location.title = model.shop_name
//                location.serialNumber = "\(nun)"
                
                location.type = model.locationType ?? .image1
                if let longitude = model.longitude , let latitude = model.latitude , let lon = CLLocationDegrees(longitude) , let lat = CLLocationDegrees(latitude){
                    location.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    
                }
                return location
            }
            
            
            
            
            //            if let firstAnnotations = annotations.first{
            //
            //                self.mapView.mapView.setCenter(firstAnnotations.coordinate, animated: true)
            //                self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: firstAnnotations.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: true )
            //            }else{
            //                self.mapView.mapView.showsUserLocation = true
            //            }
            
            if let city = city{
                DDLocationManager.share.placemarkFromString(placeStr: city) { (placeMark ) in
                    if let coordinate = placeMark?.location?.coordinate  {
                        self.mapView.mapView.setCenter(coordinate, animated: true)
                        self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.22, longitudeDelta: 0.22)), animated: true )
                    }else{
                        self.mapView.mapView.showsUserLocation = true
                    }
                }
            }else{
                self.mapView.mapView.showsUserLocation = true
            }
            
            if self.mapView.mapView.annotations.count > 0 {
                self.mapView.mapView.removeAnnotations(self.mapView.mapView.annotations)
            }
            self.mapView.mapView.addAnnotations(annotations)
        }
    }
    class LocationModel: GDModel {
        var longitude : String?
        var latitude : String?
        var locationType: GDLocationType?
        
        
    }
    //MARK:地图
    let mapView = GDMapInView()
 
    var dataArr: [LocationModel] = [] {
        didSet{
            if self.areaName.hasSuffix("...") {
                var area = self.areaName
                area = area.replace(keyWord: "...", to: "")
                self.setAnnocation(city: area)
            }else {
                self.setAnnocation(city: self.areaName)
            }
            
        }
    }
    var selectShopAreaId: String = ""
    var globalParamete: [String: String] = [:]
    
    //MARK:请求大头针数据
    func requestAnnocation() {
        let paramete = ["token": DDAccount.share.token ?? "","advert_id": self.globalParamete["advert_id"] ?? "1", "advert_time": self.globalParamete["advert_time"] ?? "", "rate": self.globalParamete["rate"] ?? "", "start_at": self.globalParamete["start_at"] ?? "", "end_at": self.globalParamete["end_at"] ?? "", "area_id": self.selectShopAreaId]
        let router = Router.get("member/1/map", DomainType.api, paramete)
        NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<MapModel>.deserialize(from: dict)
            var containerArr = [LocationModel]()
            if let arr = model?.data?.shop, arr.count > 0 {
                
                arr.forEach({ (mapModel) in
                    let subModel = LocationModel()
                    subModel.latitude = mapModel.latitude
                    subModel.longitude = mapModel.longitude
                    subModel.locationType = GDLocationType.image3
                    containerArr.append(subModel)
                })

            }
            if let arr = model?.data?.selectedShop, arr.count > 0 {
                
                arr.forEach({ (mapModel) in
                    let subModel = LocationModel()
                    subModel.latitude = mapModel.latitude
                    subModel.longitude = mapModel.longitude
                    subModel.locationType = GDLocationType.image2
                    containerArr.append(subModel)
                })
                
            }
            self.dataArr = containerArr
            
            
        
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
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
class MapViewChangeCity: DDCoverView, UITableViewDelegate, UITableViewDataSource {
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(self.containerTable)
        self.containerTable.backgroundColor = UIColor.white
        self.containerTable.frame = CGRect.init(x: SCREENWIDTH - 120 - 10, y: DDNavigationBarHeight + 10, width: 120, height: 44 * 4)
        self.request()
    }
    
    ///请求数据
    func request() {
        let token = DDAccount.share.token ?? ""
        var paremete = ["token":token]
        paremete["is_buy"] = "1"
        let _ = NetWork.manager.requestData(router: Router.get("area", .api, paremete)).subscribe(onNext: { (dict) in
            if let model = BaseModelForArr<AreaModel>.deserialize(from: dict), let arr = model.data {
                self.dataArr = arr
                
                
            }
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dataArr: [AreaModel] = [] {
        didSet{
            self.containerTable.reloadData()
        }
    }
    lazy var containerTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.white
        table.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        table.layer.cornerRadius = 6
        
        self.addSubview(table)
        return table
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
    
        cell.selectionStyle = .none
        let rightImageView = UIImageView.init(image: UIImage.init(named: "0117_mine_arrow"))
        rightImageView.bounds = CGRect.init(x: 0, y: 0, width: rightImageView.image?.size.width ?? 0, height: rightImageView.image?.size.height ?? 0)
        cell.accessoryView = rightImageView
        cell.textLabel?.text = self.dataArr[indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = UIColor.colorWithHexStringSwift("323232")
        return cell
        
  
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let areaName = self.dataArr[indexPath.row].name ?? ""
        self.selectFinished?(("", areaName))
        self.remove()
        
        
    }
    @objc func sureAction(sender: UIButton) {
        var area: String = ""
        //        var areaName: String = ""
        self.dataArr.forEach({ (model) in
            if model.isSelected {
                area += model.id + ","
            }
        })
        if area.hasSuffix(",") {
            area = String(area.prefix(area.count - 1))
            //                area.substring(to: area.index(area.endIndex, offsetBy: -1))
            //            areaName = areaName.substring(to: areaName.index(areaName.endIndex, offsetBy: -1))
        }
        
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": token, "area_id": area, "area_type": "3"]
        let _ = NetWork.manager.requestData(router: Router.post("member/\(id)/order/area", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<Area>.deserialize(from: dict)
            if model?.status == 200 {
                if let areaName = model?.data?.area_name {
                    self.selectFinished?((area, areaName))
                }
                self.remove()
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
        }, onCompleted: {
            mylog("结束")
        }, onDisposed: {
            mylog("回收")
        })
    }
    
    var selectFinished: (((String, String)) -> ())?
    //选定数据
    
    
    
    
    
}
