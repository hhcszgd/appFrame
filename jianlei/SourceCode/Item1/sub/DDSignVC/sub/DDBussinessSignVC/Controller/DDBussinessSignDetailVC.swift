//
//  DDBussinessSignDetailVC.swift
//  Project
//
//  Created by WY on 2019/8/10.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class DDBussinessSignDetailVC: DDNormalVC {
    var paraMember_id : String = ""
    var paraModel : PersonalSignRowModel!
//    var images : [GDIBPhoto] = {
//        var tempArr = [GDIBPhoto]()
//        for i in 0...9{
//            let mo = GDIBPhoto(dict: nil )
//            mo.image = UIImage(named:"generalstorephoto")
//            tempArr.append(mo )
//        }
//        return tempArr
//    }()
    let upContainerView = UIScrollView()
    var isNeesDestroy = false
    let timeRow = UILabel()
    
    let lateSignLogo = UILabel()
    
    let groupRow = UILabel()
    let locationRow = UILabel()
    let mapView = GDMapInView()
    let signPeople = DDDoubleLabel()
    let shop = DDDoubleLabel()
    let shopArea = DDDoubleLabel()
    let mirrorCount = DDDoubleLabel()
    /// 最低消费
    let minConsumption = DDDoubleLabel()
    let mobile = DDDoubleLabel()
    let shopType = DDDoubleLabel()
    let isHasScreen = DDDoubleLabel()
    let tips = DDDoubleLabel()

    let pictureTitleLabel = UILabel()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
var apiModel : ApiModel<DDOneSignDetailModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "sign_detail"|?|
        mylog(self.title)
        self.view.backgroundColor = UIColor.random
        // Do any additional setup after loading the view.
        layoutCustomSubviews()
        locationChanged()
        NotificationCenter.default.addObserver(self , selector: #selector(locationChanged), name: DDLocationManager.GDLocationChanged, object: nil)
        requestApi()
    }
    func requestApi() {
        DDRequestManager.share.getOneTimeSignDetail(type: ApiModel<DDOneSignDetailModel>.self, id: paraModel.id ?? "", member_id: paraMember_id, success: { (model ) in
            if model.status == 200 {
                self.apiModel = model
                self.setRowValues()
            }else{
                GDAlertView.alert(model.message, image: nil , time: 2 , complateBlock: nil )
            }
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        mylog("team footprint vc destroyed")
    }
}



//action
extension DDBussinessSignDetailVC{
    @objc func locationChanged() {
        if let lo = self.mapView.mapView.userLocation.location{
            DDLocationManager.share.placemarkFromLocation(location: lo ) { (placeMark) in
                //                self.building.text = placeMark?.name
//                self.mapView.mapView.setCenter(lo.coordinate, animated: false)
//                self.mapView.mapView.setRegion(MKCoordinateRegion.init(center: lo.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: false )
            }
            
        }
    }
}

// about UI
extension DDBussinessSignDetailVC{
    
    func layoutCustomSubviews() {
        self.view.addSubview(upContainerView)
        upContainerView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        upContainerView.addSubview(timeRow)
        upContainerView.addSubview(lateSignLogo)
        upContainerView.addSubview(groupRow)
        upContainerView.addSubview(locationRow)
        upContainerView.addSubview(mapView)
        upContainerView.addSubview(signPeople)
        upContainerView.addSubview(shop)
        upContainerView.addSubview(shopArea)
        upContainerView.addSubview(mirrorCount)
        upContainerView.addSubview(minConsumption)
        upContainerView.addSubview(mobile)
        upContainerView.addSubview(shopType)
        upContainerView.addSubview(isHasScreen)
        upContainerView.addSubview(tips)
        upContainerView.addSubview(pictureTitleLabel)
        upContainerView.addSubview(collectionView)
        self.mapView.mapView.showsUserLocation = false
//        mapView.mapView.isScrollEnabled = false
//        mapView.mapView.isZoomEnabled = false 
        self.view.backgroundColor = UIColor.DDLightGray
        
        
        timeRow.textColor = UIColor.lightGray
        groupRow.textColor = UIColor.lightGray
        locationRow.textColor = UIColor.lightGray
        timeRow.font = GDFont.systemFont(ofSize: 16)
        groupRow.font = GDFont.systemFont(ofSize: 16)
        locationRow.font = GDFont.systemFont(ofSize: 16)
        pictureTitleLabel.text = "  \("shop_face_picture_and_others"|?|)"
        pictureTitleLabel.textColor = UIColor.darkGray
        pictureTitleLabel.font = GDFont.systemFont(ofSize: 16)
        
        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3  * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
        let groupIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|)"//"yyyy-MM-dd 'at' HH:mm"
        let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
        timeAttributeString.append(NSAttributedString(string: " \(dateFormater.string(from: Date()))"))
        timeRow.attributedText = timeAttributeString
        
        let groupAttributeString = NSMutableAttributedString(attributedString: groupIcon)
        groupAttributeString.append(NSAttributedString(string:" 世世代代烤鸭店"))
        groupRow.attributedText = groupAttributeString
        
//        let locationIcon = UIImage(named: "loction")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let locationAttributeString = NSMutableAttributedString(attributedString: groupIcon)
        locationAttributeString.append(NSAttributedString(string:" 北京丰台希望路绝望屯梦想大厦"))
        locationRow.attributedText = locationAttributeString
        
        self.upContainerView.backgroundColor = .white
        
       
        let border : CGFloat = 10  * DDDevice.scale
        timeRow.frame = CGRect(x: 10, y: border, width: self.view.bounds.width - 10, height: 40 * DDDevice.scale)
        groupRow.frame = CGRect(x: 10, y: timeRow.frame.maxY, width: self.view.bounds.width - 10, height: 40 * DDDevice.scale)
        locationRow.frame = CGRect(x: 10, y: groupRow.frame.maxY, width: self.view.bounds.width - 10, height: 40 * DDDevice.scale)
        mapView.frame = CGRect(x: border, y: locationRow.frame.maxY + border, width: self.view.bounds.width - border * 2, height: 110 * DDDevice.scale)
        configCollectionView()
        self.setRowValues()
        
    }
    func setRowValues() {
        
        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3  * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
        let groupIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let signDate = dateFormater.date(from: self.apiModel?.data?.create_at ?? ""){
            dateFormater.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|) HH:mm:ss"//"yyyy-MM-dd 'at' HH:mm"
            let showTimeString = dateFormater.string(from: signDate)
            let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
            timeAttributeString.append(NSAttributedString(string: " \(showTimeString)"))
            timeRow.attributedText = timeAttributeString
            
            if self.apiModel?.data?.late_sign ?? "" == "1"{
                let timeStrSize = timeAttributeString.string.sizeSingleLine(font: timeRow.font)
                self.lateSignLogo.isHidden = false
                self.lateSignLogo.text = "sign_overtime"|?|
                self.lateSignLogo.font = UIFont.systemFont(ofSize: 12)
                self.lateSignLogo.sizeToFit()
                lateSignLogo.textAlignment = .center
                self.lateSignLogo.frame = CGRect(x: timeStrSize.width + 30, y: timeRow.frame.midY - (lateSignLogo.bounds.height + 6) / 2, width: lateSignLogo.bounds.width + 20, height: lateSignLogo.bounds.height + 6)
                self.lateSignLogo.textColor = UIColor.colorWithHexStringSwift("e66b63")
                self.lateSignLogo.backgroundColor = UIColor.colorWithHexStringSwift("fee4e2")
                lateSignLogo.layer.borderColor = UIColor.colorWithHexStringSwift("e66b63").cgColor
                lateSignLogo.layer.borderWidth = 1
                lateSignLogo.layer.cornerRadius = lateSignLogo.bounds.height/2
                lateSignLogo.clipsToBounds = true
            }else{self.lateSignLogo.isHidden = true }
        }
        
        let groupAttributeString = NSMutableAttributedString(attributedString: groupIcon)
        groupAttributeString.append(NSAttributedString(string:" \(self.apiModel?.data?.team_name ?? "")"))
        groupRow.attributedText = groupAttributeString
        
        let locationIcon = UIImage(named: "loction")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let locationAttributeString = NSMutableAttributedString(attributedString: locationIcon)
        locationAttributeString.append(NSAttributedString(string:" \(apiModel?.data?.shop_address ?? "")"))
        locationRow.attributedText = locationAttributeString
        
        
        
        
        
        
        
        
        
        
        let border : CGFloat = 10  * DDDevice.scale
        signPeople.frame = CGRect(x: 0, y: mapView.frame.maxY + border, width: self.view.bounds.width , height: 10)
        signPeople.texts = ("sign_people"|?|, self.apiModel?.data?.member_name ?? "")
        
        shop.frame = CGRect(x: 0, y: signPeople.frame.maxY + border, width: self.view.bounds.width , height: 10)
        shop.texts = ("visit_shop"|?|,self.apiModel?.data?.shop_name ?? "")
        shopArea.frame = CGRect(x: 0, y: shop.frame.maxY + border, width: self.view.bounds.width , height: 10)
        shopArea.texts = ("shop_area"|?|,self.apiModel?.data?.shop_acreage ?? "0")
        mirrorCount.frame = CGRect(x: 0, y: shopArea.frame.maxY + border, width: self.view.bounds.width , height: 10)
        mirrorCount.texts = ("mirror_count"|?|,self.apiModel?.data?.shop_mirror_number ?? "0")
        minConsumption.frame = CGRect(x: 0, y: mirrorCount.frame.maxY + border, width: self.view.bounds.width , height: 10)
        minConsumption.texts = ("minimum_consumption"|?|,self.apiModel?.data?.minimum_charge ?? "0")
        mobile.frame = CGRect(x: 0, y: minConsumption.frame.maxY + border, width: self.view.bounds.width , height: 10)
        mobile.texts = ("contact_number"|?|,self.apiModel?.data?.contacts_mobile ?? "empty"|?|)
        shopType.frame = CGRect(x: 0, y: mobile.frame.maxY + border, width: self.view.bounds.width , height: 10)
        var typeString = "unknown"|?|
        if let t = self.apiModel?.data?.shop_type , t.count > 0 {
            switch t {
            //1、租赁 2、自营 3、连锁
            case "1":
                typeString = "lease"|?|
            case "2":
                typeString = "self_support"|?|
            case "3":
                typeString = "chain"|?|
            default:
                typeString = "unknown"|?|
            }
        }
        shopType.texts = ("shop_type"|?|,typeString)
        
        isHasScreen.frame = CGRect(x: 0, y: shopType.frame.maxY + border, width: self.view.bounds.width , height: 10)
        var screenBrandName = ""
        if let brandName = self.apiModel?.data?.screen_brand_name , brandName.count > 0{
            screenBrandName = "\(brandName) "
        }
        let screenShowInfo =  (self.apiModel?.data?.screen_number ?? "0")
//        if screenShowInfo.count <= 0 {
//            screenShowInfo = "0"
//            screenShowInfo.append("台")
//        }else{
////            if screenShowInfo != "0"{
//                screenShowInfo.append("台")
////            }else{
////                screenShowInfo.append("台")
////            }
//        }
//        if screenShowInfo.count <= 0 {  screenShowInfo = "0" }//当为空字符串时
//        screenShowInfo.append("台")
        isHasScreen.texts = ("this_are_screen_or_not"|?|, screenBrandName + screenShowInfo)
        tips.frame = CGRect(x: 0, y: isHasScreen.frame.maxY + border, width: self.view.bounds.width , height: 10)
        tips.texts = ("tips"|?|,self.apiModel?.data?.description ?? "none_current"|?|)
        pictureTitleLabel.frame = CGRect(x: 10, y: tips.frame.maxY, width: self.view.bounds.width, height: 40 * DDDevice.scale)
        collectionView.frame = CGRect(x: 0, y: pictureTitleLabel.frame.maxY , width: self.view.bounds.width, height: 78 * DDDevice.scale)
        upContainerView.contentSize = CGSize(width: self.view.bounds.width, height: collectionView.frame.maxY + 10)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.itemSize = CGSize(width: collectionView.bounds.size.height, height: collectionView.bounds.size.height)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
        }
        collectionView.reloadData()
        
//        if let longitude = self.apiModel?.data?.longitude , let latitude = self.apiModel?.data?.latitude , let lon = CLLocationDegrees(longitude) , let lat = CLLocationDegrees(latitude){
//            let location : GDLocation = GDLocation()
////            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//            let coordinate = CLLocationCoordinate2DMake(lat , lon )
//            location.coordinate = coordinate
//            self.mapView.addPlaceMark(location: location)
//            self.mapView.mapView.setCenter(coordinate, animated: true )
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var latitude = self.apiModel?.data?.latitude
        var longitude = self.apiModel?.data?.longitude
        if DDLocationManager.share.userLocateCountry.countryName == "中国" {
            latitude = self.apiModel?.data?.gd_latitude == nil ? self.apiModel?.data?.latitude : self.apiModel?.data?.gd_latitude
            longitude = self.apiModel?.data?.gd_longitude == nil ? self.apiModel?.data?.longitude : self.apiModel?.data?.gd_longitude
        }
        if let longitude = longitude , let latitude = latitude , let lon = CLLocationDegrees(longitude) , let lat = CLLocationDegrees(latitude){
            let location : GDLocation = GDLocation()
            location.subtitle = self.apiModel?.data?.shop_name
            location.type = .image1
            //            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let coordinate = CLLocationCoordinate2DMake(lat , lon )
            location.coordinate = coordinate
            self.mapView.addPlaceMark(location: location)
            self.mapView.mapView.setCenter(coordinate, animated: true )
            self.mapView.mapView.setRegion(MKCoordinateRegion.init(center:coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.004, longitudeDelta: 0.004)), animated: false )
        }
    }
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        collectionView.isPagingEnabled = true
//        collectionView.isScrollEnabled = false
        collectionView.register(DDSignDetailImageItem.self , forCellWithReuseIdentifier: "DDSignDetailImageItem")
        collectionView.backgroundColor = UIColor.white
//        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: self.view.bounds.width, height: self.view.bounds.height - DDTabBarHeight - collectionViewY - 2)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.itemSize = CGSize(width: collectionView.bounds.size.height, height: collectionView.bounds.size.height)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
        }
    }
    
}
extension DDBussinessSignDetailVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apiModel?.data?.image_url?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSignDetailImageItem", for: indexPath)
            if let c = cell as? DDSignDetailImageItem{
                c.imageView.setImageUrl(url: self.apiModel?.data?.image_url?[indexPath.item])
            }
            cell.backgroundColor = UIColor.DDLightGray
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath )
        var images = [GDIBPhoto]()
        for imgUrl in (self.apiModel?.data?.image_url ?? []) {
            let photoModel = GDIBPhoto(dict: nil)
            photoModel.imageURL = imgUrl
            images.append(photoModel)
        }
        let _ = GDIBContentView.init(photos: images, showingPage: indexPath.item)
    }
    
}

/// layout this view by frame and texts
///
/// step1 .frame = CGRect(x: 12, y:12, width:12, height:12)
/// step2 .texts = ("titleText",""subttileText) //frame.size.height will be adjusted by subtitleText
/// step3 .insert = UIEdgeInsetsMake(6, 10, 6, 10)
class DDSignDetailImageItem: UICollectionViewCell {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        let margin : CGFloat = 13 * DDDevice.scale
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DDDoubleLabel: UIView {
    var texts : (String,String) = ("",""){
        didSet{
            title.text = texts.0
            subtitle.text = texts.1
            let originFrame = self.frame
            title.sizeToFit()
            title.frame = CGRect(x: inset.left, y: inset.top, width: title.bounds.width, height: self.bounds.height - inset.top - inset.bottom)
            let subtitleW = self.bounds.width - title.frame.maxX - 20
            var subtitleH = max(self.title.font.lineHeight, self.subtitle.font.lineHeight)
            if let size = subtitle.text?.sizeWith(font: subtitle.font, maxWidth: subtitleW){
                subtitleH = max(subtitleH, size.height)
            }
            title.frame.size.height = subtitleH
            subtitle.frame = CGRect(x:title.frame.maxX + 10, y: inset.top, width: subtitleW, height: subtitleH)
            self.frame = CGRect(x: originFrame.origin.x, y: originFrame.origin.y, width: originFrame.width, height: subtitleH + inset.top + inset.bottom)
//            self.frame = CGRect(x: originFrame.minX, y: originFrame.minY, width: self.bou, height: <#T##CGFloat#>)
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    let title = UILabel()
    let subtitle = UILabel()
    let inset = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(title)
        self.addSubview(subtitle)
        title.textColor = UIColor.darkGray
        subtitle.textColor = UIColor.lightGray
        title.font = GDFont.systemFont(ofSize: 15)
        subtitle.font = GDFont.systemFont(ofSize: 15)
        subtitle.textAlignment = .right
        subtitle.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DDOneSignDetailModel: Codable {
    
    var id : String?  //  string    签到id
    var team_id : String?  //    string    团队id
    var team_name : String?  //    string    团队id
    var member_name : String?  //    string签到人名
    var member_avatar : String?  //    string    签到人头像
    var area_id : String?  //    string    地区id
    var shop_name : String?  //    string    店铺名
    var shop_acreage : String?  //    string    店铺面积
    var shop_mirror_number : String?  //    string    镜面数量
    var shop_address : String?  //    string    店铺地址
    var longitude : String?  //    string
    var latitude : String?  //  string
    var gd_longitude : String?  //    string    高德经度
    var gd_latitude : String?  //  string    高德维度
    var bd_longitude : String?  //   string    百度经度
    var bd_latitude : String?  //   string    百度维度
    var minimum_charge : String?  //   string    最低消费
//    var mobile : String?  //    string    联系电话
    var contacts_mobile : String?
    var contacts_name : String?
    ///    string    店铺类型1、租赁 2、自营 3、连锁
    var shop_type : String?
    var screen_brand_name : String?  //   string    品牌名称
    var screen_number : String?  //    string    广告机数量
    var description : String?  //   string    描述
    var frist_sign : String?  //  string    是否是第一次签到
    var late_sign : String?  //  string    是否是迟到签到
    var create_at : String?  //  string    签到时间
    var image_url : [String]? //    array    签到图片
    var maintain_content : [String]? //    array    '维护内容',
    var content : String? //    array    '维护内容',
    var screen_start_at : String?  //   string    '设备开机时间',
    var screen_end_at : String?  //   string    '设备关机时间',
    ///   string    '签到评价(1、好评 2、中评 3、差评)',
    var evaluate : String?
    var  evaluate_description : String?
    var evaluate_at : String?  //   string    '评价时间',
    ///签到类型 1:业务签到  ,  2:维护签到
    var team_type : String?
    
}
