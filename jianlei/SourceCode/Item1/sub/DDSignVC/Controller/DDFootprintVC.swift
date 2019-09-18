//
//  DDFootprintVC.swift
//  Project
//
//  Created by WY on 2019/8/9.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation
class DDFootprintVC: DDNormalVC {
    let mineButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 36))
    let grayCover = UIControl()
    var timePicker : UIPickerView?
    var groupPicker : UIPickerView?
    var isNeesDestroy = false 
    let timeRow = DDRowView()
    let groupRow = DDRowView()
    let line = UIView()
    let mapView = GDMapInView()
    let building = UILabel()
    let adjustLocationButton = UIButton()
    let upContainerView = UIView()
    
    let midContainerView = UIView()
    let recentSign = UIButton()
    let notSign = UIButton()
    let selectedIndicator = UIView()
    var page : Int = 1
    var apiModel = ApiModel<FootprintModel>()
    var notSignModel = ApiModel<[NotSignDataModel]>()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var currentTeamModel : DDSelectTeamModel = DDSelectTeamModel()
    var currentTime : String?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let dataFormate = DateFormatter()
//        let rempDate = dataFormate.date(from: create_at)
        dataFormate.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|)"
        let string = dataFormate.string(from: Date())
        self.currentTime = string
        self.title = "团队足迹" // "group_footprint"|?|
        self.tabBarItem.title = "足迹" // footprint"|?|
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)], for: UIControl.State.normal)
        self.tabBarItem.image = UIImage(named:"JL_fotoplace")
        self.tabBarItem.selectedImage = UIImage(named:"JL_fotoplace_sel")
        
//        let a : String? = ""
//        mylog(a ?? "应该不会输出")//输出空字符串
//        let s : String? = ""
//        mylog(s ??? "应该会输出")
//        mylog(s->?)//false
//        let x : String? = nil
//        mylog(x->?)//fanse
//        let z : String? = "xx"
//        mylog(z->?)//true
    }
    func setAnnocation() {
        var nun : Int = 0
        if let arr = self.apiModel.data?.sign_data{
            let annotations = arr.map { (model ) -> GDLocation in
                nun += 1
                let location = GDLocation()
                location.title = model.shop_name
                location.serialNumber = "\(nun)"
                location.type = .image1
                if let longitude = model.longitude , let latitude = model.latitude , let lon = CLLocationDegrees(longitude) , let lat = CLLocationDegrees(latitude){
                    location.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    if nun == 1{
                        self.mapView.mapView.setCenter(location.coordinate, animated: false)
                        self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: location.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: false )
                    }
                    
                }
                return location
            }
            
            self.mapView.mapView.removeAnnotations(self.mapView.mapView.annotations)
            self.mapView.mapView.addAnnotations(annotations)
        }
    }
    func requestTeamFootprintPageData(loadType:LoadDataType) {
        if loadType == .loadMore {
            self.page += 1
        }else{
            self.page = 1
        }
        DDRequestManager.share.teamFootprintPage(type: ApiModel<FootprintModel>.self, page: page,create_at:self.currentTime ,team_id:self.currentTeamModel.id, success: { (apimodel ) in
            if apimodel.status == 200{
                
                if loadType == .initialize || loadType == .reload{
                    self.apiModel = apimodel
                    self.setAnnocation()
                    
                    
                    
                }else if loadType == .loadMore{
                    if let signData = apimodel.data?.sign_data , signData.count > 0{
                        self.apiModel.data?.sign_data?.append(contentsOf: signData)
                    }else{//没有更多数据
                        
                    }
                }
                
                if self.collectionView.frame == CGRect.zero{
                    let collectionViewY = self.midContainerView.frame.maxY + 2
                    self.collectionView.frame = CGRect(x: 0, y: collectionViewY, width: self.view.bounds.width, height: self.view.bounds.height - DDTabBarHeight - collectionViewY - 2)
                    if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                        flowLayout.itemSize = self.collectionView.bounds.size
                        flowLayout.scrollDirection = .horizontal
                        flowLayout.minimumLineSpacing = 0
                        flowLayout.minimumInteritemSpacing = 0
                    }
                    
                }
                self.requestNotSignData(loadType:LoadDataType.initialize)
            }else{
                GDAlertView.alert(apimodel.message, image: nil, time: 2, complateBlock: nil)
            }
            self.setValueToUI()
            self.collectionView.reloadData()
            
        })
    }
    func requestNotSignData(loadType:LoadDataType) {
        if notSign.isHidden{return}
        var  time = ""
        if let t = currentTime{
            time = t
        }else{
            time = self.apiModel.data?.now_date ?? ""
        }
        DDRequestManager.share.notSignData(type: ApiModel<[NotSignDataModel]>.self, create_at: time,team_id: self.apiModel.data?.team_id ?? "0" , success: { (apimodel ) in
            if apimodel.status == 200 {
                self.notSignModel = apimodel
                if let item = self.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? DDNotSignItem{
                    item.apiModel = apimodel
                }
                self.setValueToUI()
                self.collectionView.reloadData()
                
            }else{
                GDAlertView.alert(apimodel.message, image: nil , time: 2 , complateBlock: nil )
            }

            
//            if loadType == .initialize || loadType == .reload{
//                self.apiModel = apimodel
//            }else if loadType == .loadMore{
//                if let signData = apimodel.data?.sign_data , signData.count > 0{
//                    self.apiModel.data?.sign_data?.append(contentsOf: signData)
//                }else{//没有更多数据
//
//                }
//            }
        })
    }
    func setValueToUI() {
        
        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3  * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
        let groupIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|)"//"yyyy-MM-dd 'at' HH:mm"
        let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
        var time = ""
        if self.currentTime == nil {
            time = self.apiModel.data?.now_date ?? "\(dateFormater.string(from: Date()))"
        }else{
            time = self.currentTime!
        }
        time = " \(time)"
        timeAttributeString.append(NSAttributedString(string: time))
        timeRow.titleLabel.attributedText = timeAttributeString
        timeRow.layoutIfNeeded()
        timeRow.setNeedsLayout()
        let groupAttributeString = NSMutableAttributedString(attributedString: groupIcon)
        var teamName = ""
        
        if let memberType = self.apiModel.data?.member_type {
            if memberType == "3"{
                groupRow.additionalImageView.isHidden = false
                teamName = self.apiModel.data?.team_name ?? ""
                adjustLocationButton.isHidden = false
//                self.mineButton.isHidden = false
                self.timeRow.additionalImageView.isHidden = false
                adjustLocationButton.isHidden = false
            }else if memberType == "2"{
                groupRow.additionalImageView.isHidden = true
                teamName = self.apiModel.data?.team_name ?? ""
                adjustLocationButton.isHidden = false
//                self.mineButton.isHidden = false
                self.timeRow.additionalImageView.isHidden = false
                adjustLocationButton.isHidden = false
                
            }else if memberType == "1"{
                groupRow.additionalImageView.isHidden = true
                    teamName = self.apiModel.data?.team_name ?? ""
                    adjustLocationButton.isHidden = false
                    //                    self.mineButton.isHidden = false
                    self.timeRow.additionalImageView.isHidden = false
                    adjustLocationButton.isHidden = false
                
            }else if memberType == "0"{
                groupRow.additionalImageView.isHidden = true
                    teamName = "not_join_group_yet"|?|
                    self.timeRow.additionalImageView.isHidden = true
                    adjustLocationButton.isHidden = true
            }
            
            
            
//            else{
//                groupRow.additionalImageView.isHidden = true
//                if (self.apiModel.data?.team_id ?? "0" ) != "0"{
//                    teamName = self.apiModel.data?.team_name ?? ""
//                    adjustLocationButton.isHidden = false
////                    self.mineButton.isHidden = false
//                    self.timeRow.additionalImageView.isHidden = false
//                    adjustLocationButton.isHidden = false
//                }else{//尚未加入任何团队
//                    teamName = "尚未加入任何团队"
//
////                    self.mineButton.isHidden = true
//                    self.timeRow.additionalImageView.isHidden = true
//                    adjustLocationButton.isHidden = true
//
////                    adjustLocationButton.isHidden = true
////                    //                    self.mineButton.isHidden = false
////                    self.timeRow.additionalImageView.isHidden = false
//                }
//            }
        }else{
            groupRow.additionalImageView.isHidden = true
        }
        
        
        
//        if self.currentTeamModel.team_name == nil {
//            teamName = self.apiModel.data?.team_name ?? ""
//        }else{
//            teamName = self.currentTeamModel.team_name!
//        }
        
        
        groupAttributeString.append(NSAttributedString(string:" \(teamName)"))
        groupRow.titleLabel.attributedText = groupAttributeString
        groupRow.layoutIfNeeded()
        groupRow.setNeedsLayout()
        
        
        
        
        
        
        building.attributedText = ["have_sign_totally"|?|,self.apiModel.data?.total ?? "0","次"].setColor(colors: [UIColor.darkGray,UIColor.orange , UIColor.darkGray])
        let notSignString = self.apiModel.data?.not_sign ?? "0"
        let notSignAttributeString = ["have_not_sign"|?| , notSignString , "people"|?|].setColor(colors: [UIColor.darkGray , UIColor.orange ,UIColor.darkGray ])
        self.notSign.setAttributedTitle(notSignAttributeString, for: UIControl.State.normal)
        
        
//        let location = GDLocation()
//        location.coordinate = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
//        self.mapView.addPlaceMark(location: GDLocation())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mylog(self.title)
        self.view.backgroundColor = UIColor.random
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "returnImage"), landscapeImagePhone: nil , style: UIBarButtonItem.Style.plain, target: self , action: #selector(goback))
        // Do any additional setup after loading the view.
        self.setNavigationItem()
        layoutCustomSubviews()
        locationChanged()
        NotificationCenter.default.addObserver(self , selector: #selector(locationChanged), name: DDLocationManager.GDLocationChanged, object: nil)
//        requestTeamFootprintPageData(loadType: LoadDataType.initialize)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        mylog("team footprint vc destroyed")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestTeamFootprintPageData(loadType: LoadDataType.initialize)
    }
}



//action
extension DDFootprintVC{
    @objc func mineButtonClick(sender:UIButton)  {
        mylog("mine click")
        let vc = DDPersonalSignVC()
        let model = DDFootprintVC.NotSignDataModel()
        let t = NotSignPersonModel()
        t.avatar = DDAccount.share.avatar
        t.name = DDAccount.share.name
        model.memberName = t
        model.create_at = self.currentTime
        model.team_id = self.apiModel.data?.team_id
        model.member_id = DDAccount.share.id
        vc.paraModel = model
        vc.paraTeamName = self.currentTeamModel.team_name ?? (self.apiModel.data?.team_name ?? "")
        
        
//        if let navi = self.navigationController as? DDFootprintNaviVC{
//            vc.signType = navi.signType
//        }
        
        self.navigationController?.pushViewController(vc , animated: true )
    }
    @objc func goback() {
        self.navigationController?.navigationController?.popViewController(animated: true )
        self.isNeesDestroy = true 
    }
    @objc func locationChanged() {
        if let lo = self.mapView.mapView.userLocation.location{
            DDLocationManager.share.placemarkFromLocation(location: lo ) { (placeMark) in
                DDLocationManager.share.updateUserCurrentLoactionOnDisk(placeMark?.addressDictionary)  
            }
            
        }
    }
    
    @objc func adjustLocation() {
        
        if let memberType = self.apiModel.data?.member_type {
            if memberType != "1"{
                let vc = DDTotalSignVC()
                vc.userInfo = nil
                vc.paraTime = self.currentTime ?? ""
                vc.paraTeamId = self.apiModel.data?.team_id ?? ""
                vc.paraTeamName = self.apiModel.data?.team_name ?? ""
//                vc.completed = {[weak self ] adjustedAddressString in
//                    //            self?.building.text = adjustedAddressString
//                }
                self.navigationController?.pushViewController(vc , animated: true )
                
            }else{
                if let permission = self.apiModel.data?.sign_data_permission , permission == "1"{
                    let vc = DDTotalSignVC()
                    vc.userInfo = nil
                    vc.paraTime = self.currentTime ?? ""
                    vc.paraTeamId = self.apiModel.data?.team_id ?? ""
                    vc.paraTeamName = self.apiModel.data?.team_name ?? ""
//                    vc.completed = {[weak self ] adjustedAddressString in
//                        //            self?.building.text = adjustedAddressString
//                    }
                    self.navigationController?.pushViewController(vc , animated: true )
                    
                }else{
                    let alert = DDAutoDisappearAlert1(message: "can_not_access_others"|?|, image: UIImage(named:"jointheteam"))
//                    alert.deinitHandle = {[weak self ] in
//                        //                    self?.getDianGongInfo()
//                    }
                    self.view.alert(alert)
                }
                
                
            }
        }
        
        
    }
    
    @objc func changeTime() {
//        if (self.apiModel.data?.team_id ?? "0" ) != "0"{//尚未加入任何团队
//            alertTimePicker() // 什么时候都能选时间20180030//又改回普通人未加入团队就不能不能更改时间了(超管无团队时 , team_id为bussiness 和 maintain)
//        }else{
//
//        }
        if (self.apiModel.data?.member_type ?? "0" ) != "0"{//除了尚未加入任何团队的普通人
            alertTimePicker()
        }
        
    }
    @objc func changeGroup() {
        mylog("change group ")
        
        if let memberType = self.apiModel.data?.member_type , memberType == "3"{
                let vc = DDSelectTeamVC()
                vc.done = {[weak self ] (teamModel) in
                    self?.currentTeamModel = teamModel
                    self?.requestTeamFootprintPageData(loadType: LoadDataType.initialize)
                    self?.requestNotSignData(loadType:LoadDataType.initialize)
                }
                self.navigationController?.pushViewController(vc , animated: true )
        }
        
    }
    @objc func recentSignClick(sender:UIButton) {
        mylog("recentSignClick ")
        sender.isSelected = true
        selectedIndicator.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY, width: sender.bounds.width, height: 4)
        notSign.isSelected = false
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true )
    }
    @objc func notSignClick(sender:UIButton) {
        mylog("notSignClick ")
        if collectionView.numberOfItems(inSection: 0) == 1 {
            return
        }
        
        sender.isSelected = true
        selectedIndicator.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY, width: sender.bounds.width, height: 4)
        recentSign.isSelected = false
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionView.ScrollPosition.right, animated: true )
        
        requestNotSignData(loadType:.initialize)
    }
    
}

// about UI
extension DDFootprintVC{
    
    func setNavigationItem() {
//        mineButton.setTitle("mine_in_sign_page"|?|, for: UIControl.State.normal)
        mineButton.setImage(UIImage(named: "mine"), for: UIControl.State.normal)
        mineButton.backgroundColor = .clear
        mineButton.setTitleColor(UIColor.gray , for: UIControl.State.normal)
        mineButton.addTarget(self , action: #selector(mineButtonClick(sender:)), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mineButton)
    }

    func layoutCustomSubviews() {
        timeRow.addTarget(self , action: #selector(changeTime), for: UIControl.Event.touchUpInside)
        groupRow.addTarget(self , action: #selector(changeGroup), for: UIControl.Event.touchUpInside)
        adjustLocationButton.addTarget(self , action: #selector(adjustLocation), for: UIControl.Event.touchUpInside)
        recentSign.addTarget(self , action: #selector(recentSignClick(sender:)), for: UIControl.Event.touchUpInside)
        notSign.addTarget(self , action: #selector(notSignClick(sender:)), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(upContainerView)
        upContainerView.addSubview(timeRow)
        upContainerView.addSubview(groupRow)
        upContainerView.addSubview(line)
        upContainerView.addSubview(mapView)
        upContainerView.addSubview(building)
        upContainerView.addSubview(adjustLocationButton)
        self.view.addSubview(midContainerView)
        midContainerView.addSubview(recentSign)
        midContainerView.addSubview(notSign)
        midContainerView.addSubview(selectedIndicator)
        building.font = GDFont.systemFont(ofSize: 16)
        adjustLocationButton.titleLabel?.font = GDFont.systemFont(ofSize: 16)
        recentSign.titleLabel?.font = GDFont.systemFont(ofSize: 16)
        notSign.titleLabel?.font = GDFont.systemFont(ofSize: 16)
        self.view.addSubview(collectionView)
        self.mapView.mapView.showsUserLocation = true
        
        self.view.backgroundColor = UIColor.DDLightGray
        building.textColor = UIColor.lightGray
        
        
        timeRow.titleLabel.textColor = UIColor.lightGray
        timeRow.additionalImageView.isHidden = false
        
        groupRow.titleLabel.textColor = UIColor.lightGray
        
        timeRow.titleLabel.font = GDFont.systemFont(ofSize: 16)
        groupRow.titleLabel.font = GDFont.systemFont(ofSize: 16)
//        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3  * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
//        let groupIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy年MM月dd日"//"yyyy-MM-dd 'at' HH:mm"
//        let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
//        timeAttributeString.append(NSAttributedString(string: " \(dateFormater.string(from: Date()))"))
//        timeRow.titleLabel.attributedText = timeAttributeString
//        
//        let groupAttributeString = NSMutableAttributedString(attributedString: groupIcon)
//        groupAttributeString.append(NSAttributedString(string:" 世世代灌灌灌灌灌更改代烤鸭店"))
//        groupRow.titleLabel.attributedText = groupAttributeString
        self.upContainerView.backgroundColor = .white
//
        adjustLocationButton.setTitle("  \("access_all"|?|)", for: UIControl.State.normal)
        adjustLocationButton.isHidden = true
        adjustLocationButton.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        adjustLocationButton.setImage(UIImage(named:"check"), for: UIControl.State.normal)
        adjustLocationButton.sizeToFit()
        
        
        building.attributedText = ["have_sign_totally"|?|,"0","times"|?|].setColor(colors: [UIColor.darkGray,UIColor.orange , UIColor.darkGray])
        
        selectedIndicator.backgroundColor = UIColor.orange
        
        recentSign.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        recentSign.setTitleColor(UIColor.orange, for: UIControl.State.selected)
        notSign.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        notSign.setTitleColor(UIColor.orange, for: UIControl.State.selected)
        recentSign.setTitle("sign_new"|?|, for: UIControl.State.normal)
        recentSign.setTitle("sign_new"|?|, for: UIControl.State.selected)
        notSign.setTitle("have_not_sign"|?|, for: UIControl.State.normal)
        notSign.setTitle("have_not_sign"|?|, for: UIControl.State.selected)
        midContainerView.backgroundColor = UIColor.white
        let border : CGFloat = 10  * DDDevice.scale
        timeRow.frame = CGRect(x: 0, y: border, width: self.view.bounds.width, height: 40 * DDDevice.scale)
        groupRow.frame = CGRect(x: 0, y: timeRow.frame.maxY, width: self.view.bounds.width, height: 40 * DDDevice.scale)
        line.frame = CGRect(x: 0, y: groupRow.frame.maxY + border, width: self.view.bounds.width , height: 2)
        line.backgroundColor = UIColor.gray(0.1)
        mapView.frame = CGRect(x: border, y: line.frame.maxY + border * 2, width: self.view.bounds.width - border * 2, height: 110 * DDDevice.scale)
        adjustLocationButton.frame = CGRect(x:self.view.bounds.width -  border - adjustLocationButton.bounds.width, y: mapView.frame.maxY, width: adjustLocationButton.bounds.width, height: 54 * DDDevice.scale)
        
        building.frame = CGRect(x: border, y: mapView.frame.maxY , width: adjustLocationButton.frame.minX - border, height: 54  * DDDevice.scale)
        upContainerView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: building.frame.maxY)
        
        midContainerView.frame = CGRect(x: 0, y: upContainerView.frame.maxY + 15 * DDDevice.scale, width: self.view.bounds.width, height: 50 * DDDevice.scale)
        recentSign.frame = CGRect(x: 20, y: 0, width: 100 * DDDevice.scale, height: 40 * DDDevice.scale)
        notSign.frame = CGRect(x:recentSign.frame.maxX + 40 * DDDevice.scale, y: 0, width: 100 * DDDevice.scale, height: 40 * DDDevice.scale)
//        selectedIndicator.frame = CGRect(x: recentSign.frame.minX, y: recentSign.frame.maxY, width: recentSign.bounds.width, height: 4)
        layoutCollectionView()
        self.recentSignClick(sender: recentSign)
    }
    func layoutCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.register(DDRecentSignItem.self , forCellWithReuseIdentifier: "DDRecentSignItem")
        collectionView.register(DDNotSignItem.self , forCellWithReuseIdentifier: "DDNotSignItem")
//        let collectionViewY = midContainerView.frame.maxY + 2
        collectionView.backgroundColor = UIColor.orange
        collectionView.frame = CGRect.zero
//        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: self.view.bounds.width, height: self.view.bounds.height - DDTabBarHeight - collectionViewY - 2)
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
//            flowLayout.itemSize = collectionView.bounds.size
//            flowLayout.scrollDirection = .horizontal
//            flowLayout.minimumLineSpacing = 0
//            flowLayout.minimumInteritemSpacing = 0
//        }
    }
    
}
extension DDFootprintVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let memberType = self.apiModel.data?.member_type {
            if memberType == "3"{//超管身份
               self.notSign.isHidden = false
                return 2
            }else if memberType == "2"{//负责人身份
                self.notSign.isHidden = false
                return 2
            }else if memberType == "1"{//普通有团队身份
                self.notSign.isHidden = false
                return 2
            }else if memberType == "0"{//普通无团队
                self.notSign.isHidden = true
                return 1
            }
            
            
//            else {//普通有团队身份
//                if (self.apiModel.data?.team_id ?? "0" ) != "0"{//普通已经加团队
//                    self.notSign.isHidden = false
//                    return 2
//                }else{////普通未加团队
//                    self.notSign.isHidden = true
//                    return 1
//                }
//            }
        }
        self.notSign.isHidden = true
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDRecentSignItem", for: indexPath)
            if let c = cell as? DDRecentSignItem{
                c.memberType = self.apiModel.data?.member_type ?? ""
                if let memberType = self.apiModel.data?.member_type {
                    if memberType == "3"{//超管身份
                        if let ms = self.apiModel.data?.sign_data{
                            c.models = ms
                        }else{
                            c.models = []
                        }
                    }else if memberType == "2"{//负责人身份
                        if let ms = self.apiModel.data?.sign_data{
                            c.models = ms
                        }else{
                            c.models = []
                        }
                    }else if memberType == "1"{//普通有团队身份
                            if let ms = self.apiModel.data?.sign_data{
                                c.models = ms
                            }else{
                                c.models = []
                            }
                    }else if memberType == "0"{//普通无团队身份
                        
                            if let ms = self.apiModel.data?.sign_data{
                                c.models = ms
                            }else{
                                c.models = nil
                            }
                    }
//                    else{//普通身份
//                        if (self.apiModel.data?.team_id ?? "0" ) != "0"{//普通已经加团队
//                            if let ms = self.apiModel.data?.sign_data{
//                                c.models = ms
//                            }else{
//                                c.models = []
//                            }
//                        }else{////普通未加团队
//                            if let ms = self.apiModel.data?.sign_data{
//                                c.models = ms
//                            }else{
//                                c.models = nil
//                            }
//                        }
//                    }
                }
                c.delegate = self
            }
            cell.backgroundColor = UIColor.red
            return cell
        }else {//indexPath.item == 1
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDNotSignItem", for: indexPath)
            if let c = cell as? DDNotSignItem{
                c.delegate = self
            }
            cell.backgroundColor = UIColor.blue
            return cell
        }
    }
    
    
}
extension DDFootprintVC : DDNotSignItemDelegate , DDRecentSignItemDelegate{
    func notSignItemClick(collection: UICollectionView, indexPath: IndexPath) {
        mylog(indexPath)
        
        if let memberType = self.apiModel.data?.member_type {
            if memberType != "1"{
                
               
                
                
                if let notSignPersonModel = self.notSignModel.data?[indexPath.item]{
                    let vc = DDPersonalSignVC()
                    vc.paraModel = notSignPersonModel
                    vc.paraTeamName = self.currentTeamModel.team_name ??? (self.apiModel.data?.team_name ?? "")
//                    if let navi = self.navigationController as? DDFootprintNaviVC{
//                        vc.signType = navi.signType
//                    }
                    self.navigationController?.pushViewController(vc, animated: true )
                    
                }else{
                    GDAlertView.alert("parameter_error"|?|, image: nil, time: 2, complateBlock: nil)
                }
                
            }else{
                if let permission = self.apiModel.data?.sign_data_permission , permission == "1"{
//                    let vc = DDTotalSignVC()
//                    vc.userInfo = nil
//                    vc.paraTime = self.currentTime ?? ""
//                    vc.paraTeamId = self.apiModel.data?.team_id ?? ""
//                    vc.paraTeamName = self.apiModel.data?.team_name ?? ""
//                    vc.completed = {[weak self ] adjustedAddressString in
//                        //            self?.building.text = adjustedAddressString
//                    }
//                    self.navigationController?.pushViewController(vc , animated: true )
                    if let notSignPersonModel = self.notSignModel.data?[indexPath.item]{
                        let vc = DDPersonalSignVC()
                        vc.paraModel = notSignPersonModel
                        vc.paraTeamName = self.currentTeamModel.team_name ?? (self.apiModel.data?.team_name ?? "")
//                        if let navi = self.navigationController as? DDFootprintNaviVC{
//                            vc.signType = navi.signType
//                        }
                        self.navigationController?.pushViewController(vc, animated: true )
                    }else{
                        GDAlertView.alert("parameter_error"|?|, image: nil, time: 2, complateBlock: nil)
                    }
                }else{
                    if let notSignPersonModel = self.notSignModel.data?[indexPath.item] , let id = notSignPersonModel.member_id , id == (DDAccount.share.id ?? ""){
                        let vc = DDPersonalSignVC()
                        vc.paraModel = notSignPersonModel
                        vc.paraTeamName = self.currentTeamModel.team_name ?? (self.apiModel.data?.team_name ?? "")
//                        if let navi = self.navigationController as? DDFootprintNaviVC{
//                            vc.signType = navi.signType
//                        }
                        self.navigationController?.pushViewController(vc, animated: true )
                    }else{
                        
                        let alert = DDAutoDisappearAlert1(message: "can_not_access_others"|?|, image: UIImage(named:"jointheteam"))
//                        alert.deinitHandle = {[weak self ] in
//                            //                    self?.getDianGongInfo()
//                        }
                        self.view.alert(alert)
                    }
                }
            }
        }
        
        
        
    }
    
    func recentSignItemClick(collection: UICollectionView, indexPath: IndexPath) {
        mylog(indexPath)
        if let model = self.apiModel.data?.sign_data?[indexPath.item]{
                if model.team_type ?? ""  == "1" {
                    let vc = DDBussinessSignDetailVC()
                    let personalModel = PersonalSignRowModel()
                    personalModel.id = model.id
                    vc.paraModel = personalModel
                    vc.paraMember_id = model.member_id ?? ""//缺少memberID
                    self.navigationController?.pushViewController(vc , animated: true)
                }else{
                    let vc = DDMaintainSignDetailVC()
                    let personalModel = PersonalSignRowModel()
                    personalModel.id = model.id
                    vc.paraModel = personalModel
                    vc.paraMember_id = model.member_id ?? ""//缺少memberID
                    self.navigationController?.pushViewController(vc , animated: true)
                }
        }
        
    }
    func reloadAction(){
        self.requestTeamFootprintPageData(loadType: LoadDataType.loadMore)
    }
    
}
extension DDFootprintVC : UIPickerViewDataSource ,UIPickerViewDelegate{
    func showCover() {
        grayCover.isHidden = false
        if grayCover.superview == nil {
            grayCover.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            self.view.addSubview(grayCover)
            grayCover.frame = self.view.bounds
        }
    }
    func hideCover() {
        grayCover.isHidden = true
    }
    func alertTimePicker() {
        let alert = DDTimeSelectView()
        alert.done = {[weak self ] date in
            let dateFormater:  DateFormatter = DateFormatter()
            dateFormater.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|)"
            let string = dateFormater.string(from: date)
            self?.currentTime = string
            self?.requestTeamFootprintPageData(loadType: LoadDataType.initialize)
            self?.requestNotSignData(loadType:LoadDataType.initialize)
        }
        self.view.alert(alert)
//        showCover()
//
//        if self.timePicker == nil {
//            let startFrame = CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: collectionView.bounds.height)
//            let timePicker = UIPickerView(frame: startFrame)
//            timePicker.backgroundColor = UIColor.orange
//            self.view.addSubview(timePicker)
//            self.timePicker = timePicker
//            timePicker.dataSource = self
//            timePicker.delegate = self
//            UIView.animate(withDuration: 0.2) {
//                self.timePicker?.frame = self.collectionView.frame
//            }
//        }
    }
    func dismissTimePicker() {
        UIView.animate(withDuration: 0.25, animations: {
            let startFrame = CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: self.collectionView.bounds.height)
            self.timePicker?.frame = startFrame
        }) { (bool ) in
            self.timePicker?.dataSource = nil
            self.timePicker?.delegate = nil
            self.timePicker?.removeFromSuperview()
            self.timePicker = nil
            self.hideCover()
        }
    }
    func alertGroupPicker() {
        showCover()
        if self.groupPicker == nil{
            let startFrame = CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: collectionView.bounds.height)
            let groupPicker = UIPickerView(frame: startFrame)
            self.view.addSubview(groupPicker)
            groupPicker.dataSource = self
            groupPicker.delegate = self
        }
        UIView.animate(withDuration: 0.2) {
            self.groupPicker?.frame = self.collectionView.frame
        }
    }
    func dismissGroupPicker() {
        UIView.animate(withDuration: 0.25, animations: {
            let startFrame = CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: self.collectionView.bounds.height)
            self.groupPicker?.frame = startFrame
        }) { (bool ) in
            self.groupPicker?.dataSource = nil
            self.groupPicker?.delegate = nil
            self.groupPicker?.removeFromSuperview()
            self.groupPicker = nil
            self.hideCover()
        }
    }
    //datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.timePicker{
            
        }else if pickerView == self.groupPicker{
            
        }
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.timePicker{
            
        }else if pickerView == self.groupPicker{
            
        }
        return 6
    }
    //delegate
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        if pickerView == self.timePicker{
            
        }else if pickerView == self.groupPicker{
            
        }
        return  88
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 44
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView == self.timePicker{
            
        }else if pickerView == self.groupPicker{
            
        }
        return "xxxxx"
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?{}
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
//
//    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 1 {
            pickerView.reloadComponent(2)
        }
        if pickerView == self.timePicker{
            dismissTimePicker()
        }else if pickerView == self.groupPicker{
            
        }
    }
}

extension DDFootprintVC{
    class FootprintModel: NSObject , Codable {
        var team_id : String?
        var now_date : String?
        var team_name : String?
        var sign_data : [SignDataModel]?
        var total : String?
        var not_sign : String?
        ///   成员类别(1、普通成员 2、负责人 3、管理人)
        var member_type:String?
        /// 1:普通成员可以查看别人的信息 , 0:普通成员不不不可以查看别的信息
        var sign_data_permission : String?
        /// DDBussinessNaviVC.SignType:bussiness&maintain
//        var signType : String?
    }
    class SignDataModel: NSObject ,Codable{
        var id : String?
        var member_name : String?
        var member_id : String?//缺少字段
        var member_avatar : String?
        var shop_address : String?
        var longitude : String?
        var latitude : String?
        var late_sign : String?
        var shop_name : String?
        var create_at : String
        
        ///签到类型 1:业务签到  ,  2:维护签到
        var team_type : String?
    }
    class NotSignDataModel: NSObject ,Codable{
        var create_at: String?
        var team_id: String?
        var member_id : String?
        var id : String?
        var memberName : NotSignPersonModel?
        ///签到类型 1:业务签到  ,  2:维护签到
        var team_type : String?
    }
    class NotSignPersonModel: NSObject ,Codable{
        var name: String?
        var avatar : String?
        var id : String?
        ///签到类型 1:业务签到  ,  2:维护签到
        var team_type : String?
    }
}
