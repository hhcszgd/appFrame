//
//  DDSelectShopVC.swift
//  Project
//
//  Created by WY on 2019/8/16.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation
class DDSelectShopVC: DDNormalVC {
    
    var model : ApiModel<[DDSelectShopModel]>?
    let searchBar = DDSearchBar()
    let tableView = UITableView()
    let mapView = GDMapInView()
    var selectedIndexPath  : IndexPath = IndexPath(row: 0, section: 111   ){
        didSet{
            if let model = self.model?.data , model.count > 0 , selectedIndexPath.row >= 0 && selectedIndexPath.row < model.count
            {
                self.selectedModel = self.model?.data?[selectedIndexPath.row]
                self.tableView.reloadData()
            }
        }
    }
    var selectedModel : DDSelectShopModel? {
        didSet{
            setAnnocation()
            
        }
    }
    var done : ((DDSelectShopModel?)->())?
//    let adjustPoint = UIImageView()
//    var adjustedAddressString : String = ""
    var completed : ((String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = ApiModel<[DDSelectShopModel]>()
        self.title = "chooes_shop"|?|//)地点微调"
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self , selector: #selector(locationChanged), name: DDLocationManager.GDLocationChanged, object: nil)
        setNavigationItem()
        setCustomSubviews()
        self.locationChanged()
        performRequest()
    }
    deinit {
//        completed?(adjustedAddressString)
    }
    func performRequest() {
        _ = DDRequestManager.share.selectRepairShopList(type: ApiModel<[DDSelectShopModel]>.self , success: { (model ) in
            mylog(model.data)
            if model.status == 200 {
                self.model = model
                self.tableView.reloadData()
//                self.view.alert
                
            }else{
                GDAlertView.alert(model.message, image: nil , time: 2, complateBlock: nil )
            }
        })
    }
    
    func setAnnocation() {
        let location = GDLocation()
        location.title = self.selectedModel?.name
        location.type = .image1
        if let longitude = self.self.selectedModel?.loc?.coordinates?.first , let latitude = self.self.selectedModel?.loc?.coordinates?.last {
                location.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
        }
        self.mapView.mapView.removeAnnotations(self.mapView.mapView.annotations)
        self.mapView.mapView.addAnnotation(location)
        self.mapView.mapView.setCenter(location.coordinate, animated: true)
        self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: location.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: true )
    }
    func setCustomSubviews() {
        self.view.addSubview(mapView)
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        tableView.delegate = self
        tableView.dataSource = self
        let H = (self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight) / 2
        mapView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: H)
        tableView.frame = CGRect(x: 0, y: mapView.frame.maxY, width: self.view.bounds.width, height:H)
        searchBar.frame = CGRect(x: 20, y: mapView.frame.minY + 10, width: self.view.bounds.width - 40, height: 44)
        searchBar.layer.cornerRadius = searchBar.bounds.height/2
        searchBar.layer.masksToBounds = true
        searchBar.doneAction = { [weak self ] text in
            let vc = DDSearchShopVC()
            vc.userInfo = self?.searchBar.textField.text
            vc.done = {[weak self ] model in
                self?.selectedModel = model
                if let m = model {
                    self?.model?.data = [m]
                }
                self?.selectedIndexPath = IndexPath(row: 0, section: 0   )
            }
            self?.present(vc, animated: true , completion: {
                
            })
            mylog(text)
        }
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
        button.setTitle("sure"|?|, for: UIControl.State.normal)
        button.backgroundColor = .orange
        button.addTarget(self , action: #selector(sureButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 5
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func sureButtonClick(sender:UIButton)  {
        mylog("sure click")
        if  self.selectedModel == nil {
            GDAlertView.alert("chooes_shop_please"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
//        if let cell = self.tableView.cellForRow(at: self.selectedIndexPath) as? ShopCell{
            self.done?(self.selectedModel)
            self.navigationController?.popViewController(animated: true)
//        }
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
extension DDSelectShopVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let mm = self.model?.data?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell") as? ShopCell{
            if indexPath == self.selectedIndexPath{
                cell.isSelected = true
            }else{
                cell.isSelected = false
            }
            cell.name.text = self.model?.data?[indexPath.row].name
            cell.address.text = self.model?.data?[indexPath.row].address
            return cell
        }else{
            let cell = ShopCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ShopCell")
            if indexPath == self.selectedIndexPath{
                cell.isSelected = true
            }else{
                cell.isSelected = false
            }
            
            cell.name.text = self.model?.data?[indexPath.row].name
            cell.address.text = self.model?.data?[indexPath.row].address
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
//        cell?.layoutIfNeeded()
//        cell?.setNeedsLayout()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
//        cell?.layoutIfNeeded()
//        cell?.setNeedsLayout()
    }
    class ShopCell: UITableViewCell {
        let name = UILabel()
        let address = UILabel()
        let selectButton = UIButton()
        let bottomLine = UIView()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(name )
            self.contentView.addSubview(address )
            self.contentView.addSubview(selectButton )
            self.contentView.addSubview(bottomLine )
            selectButton.setImage(UIImage(named: ""), for: UIControl.State.normal)
            selectButton.setImage(UIImage(named: "select"), for: UIControl.State.selected)
            name.font = GDFont.systemFont(ofSize: 16)
            address.font = GDFont.systemFont(ofSize: 14)
            name.textColor = UIColor.darkGray
            address.textColor = UIColor.lightGray
            bottomLine.backgroundColor = UIColor.DDLightGray
            selectButton.isUserInteractionEnabled = false 
//            selectButton.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControl.Event.touchUpInside)

        }
//        @objc func buttonClick(sender:UIButton) {
//            sender.isEnabled = !sender.isEnabled
//        }
        override var isSelected: Bool{
            didSet{
                selectButton.isSelected = isSelected
            }
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let selectButtonY : CGFloat = 20
            let selectButtonWH : CGFloat = self.bounds.height - selectButtonY * 2
            let selectButtonX = self.bounds.width - selectButtonWH - 20
            selectButton.frame = CGRect(x: selectButtonX, y: selectButtonY, width: selectButtonWH, height: selectButtonWH)
            let leftMargin : CGFloat = 10
            let topBottomMargin : CGFloat = 6
            let midMargin : CGFloat = 10
            name.frame = CGRect(x: leftMargin, y: topBottomMargin, width: selectButtonX - leftMargin - midMargin , height: (self.bounds.height - topBottomMargin * 2 ) * 0.6 )
            address.frame = CGRect(x: leftMargin, y: name.frame.maxY, width: selectButtonX - leftMargin - midMargin, height: (self.bounds.height - topBottomMargin * 2 ) * 0.4)
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - 1.5, width: self.bounds.width, height: 1.5)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
class DDSelectShopModel: Codable {
    var id : String?
    var name : String?
    var address : String?
    var loc : DDLocationModel?
    class DDLocationModel: Codable {
        /// 第一个元素是精度 , 第二个元素是维度
        var coordinates : [Double]?//第一个元素是精度 , 第二个元素是维度
    }
}
