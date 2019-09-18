//
//  DDMaintainSignDetailVC.swift
//  Project
//
//  Created by WY on 2019/8/10.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class DDMaintainSignDetailVC: DDNormalVC {
    var paraModel : PersonalSignRowModel!
    var paraMember_id : String = ""
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
//    let shopArea = DDDoubleLabel()
//    let mirrorCount = DDDoubleLabel()
    /// 最低消费
    let connectPerson = DDDoubleLabel()
    let mobile = DDDoubleLabel()
    let maintainContent = DDDoubleLabel()
//    let isHasScreen = DDDoubleLabel()
    let tips = DDDoubleLabel()
    var apiModel : ApiModel<DDOneSignDetailModel>?
    let pictureTitleLabel = UILabel()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let commentTitleLabel = DDLabel()
    let commentContentLabel = DDLabel()
    let commentType = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "sign_detail"|?|
        mylog(self.title)
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        layoutCustomSubviews()
        upContainerView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
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
    deinit {
        NotificationCenter.default.removeObserver(self)
        mylog("team footprint vc destroyed")
    }
}



//action
extension DDMaintainSignDetailVC{
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
extension DDMaintainSignDetailVC{
    
    func layoutCustomSubviews() {
        self.view.addSubview(upContainerView)
        upContainerView.backgroundColor = UIColor.DDLightGray
        upContainerView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        upContainerView.addSubview(timeRow)
        upContainerView.addSubview(lateSignLogo)
        upContainerView.addSubview(groupRow)
        upContainerView.addSubview(locationRow)
        upContainerView.addSubview(mapView)
        upContainerView.addSubview(signPeople)
        upContainerView.addSubview(shop)
//        upContainerView.addSubview(shopArea)
//        upContainerView.addSubview(mirrorCount)
        upContainerView.addSubview(connectPerson)
        upContainerView.addSubview(mobile)
        upContainerView.addSubview(maintainContent)
//        upContainerView.addSubview(isHasScreen)
        upContainerView.addSubview(tips)
        upContainerView.addSubview(pictureTitleLabel)
        upContainerView.addSubview(collectionView)
        self.mapView.mapView.showsUserLocation = false
        upContainerView.addSubview(commentTitleLabel )
        upContainerView.addSubview(commentContentLabel )
        upContainerView.addSubview(commentType)
        commentType.textAlignment = .center
        self.view.backgroundColor = UIColor.DDLightGray
//        mapView.mapView.isScrollEnabled = false
//        mapView.mapView.isZoomEnabled = false
        
        timeRow.textColor = UIColor.lightGray
        groupRow.textColor = UIColor.lightGray
        locationRow.textColor = UIColor.lightGray
        timeRow.font = GDFont.systemFont(ofSize: 16)
        groupRow.font = GDFont.systemFont(ofSize: 16)
        locationRow.font = GDFont.systemFont(ofSize: 16)
        pictureTitleLabel.text = "  \("shop_face_picture_and_others"|?|)"
        pictureTitleLabel.textColor = UIColor.darkGray
        pictureTitleLabel.font = GDFont.systemFont(ofSize: 16)
        commentTitleLabel.font = GDFont.systemFont(ofSize: 16)
        commentContentLabel.font = GDFont.systemFont(ofSize: 14)
        commentContentLabel.textColor = UIColor.lightGray
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
        
        let locationIcon = UIImage(named: "loction")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let locationAttributeString = NSMutableAttributedString(attributedString: locationIcon)
        locationAttributeString.append(NSAttributedString(string:" 北京丰台希望路绝望屯梦想大厦"))
        locationRow.attributedText = locationAttributeString
        
        
        
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
        
//        let locationIcon = UIImage(named: "loction")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
        let locationAttributeString = NSMutableAttributedString(attributedString: groupIcon)
        locationAttributeString.append(NSAttributedString(string:" \(apiModel?.data?.shop_address ?? "")"))
        locationRow.attributedText = locationAttributeString
        
        
        
        
        
        
        
        
        
        
//        let border : CGFloat = 10  * DDDevice.scale
        let verticalMargin  : CGFloat = 0  * DDDevice.scale
        signPeople.frame = CGRect(x: 0, y: mapView.frame.maxY + verticalMargin, width: self.view.bounds.width , height: 10)
        signPeople.texts = ("sign_people"|?|, self.apiModel?.data?.member_name ?? "")
        
        shop.frame = CGRect(x: 0, y: signPeople.frame.maxY + verticalMargin, width: self.view.bounds.width , height: 10)
        shop.texts = ("visit_shop_again"|?|,self.apiModel?.data?.shop_name ?? "")
//        shopArea.frame = CGRect(x: 0, y: shop.frame.maxY + border, width: self.view.bounds.width , height: 10)
//        shopArea.texts = ("店铺面积",self.apiModel?.data?.shop_acreage ?? "0")
//        mirrorCount.frame = CGRect(x: 0, y: shopArea.frame.maxY + border, width: self.view.bounds.width , height: 10)
//        mirrorCount.texts = ("镜面数量",self.apiModel?.data?.shop_mirror_number ?? "0")
        connectPerson.frame = CGRect(x: 0, y: shop.frame.maxY + verticalMargin, width: self.view.bounds.width , height: 10)
        connectPerson.texts = ("shop_contact_people"|?|,self.apiModel?.data?.contacts_name ?? "0")
        mobile.frame = CGRect(x: 0, y: connectPerson.frame.maxY + verticalMargin, width: self.view.bounds.width , height: 10)
        mobile.texts = ("contact_number"|?|,self.apiModel?.data?.contacts_mobile ?? "无")
        maintainContent.frame = CGRect(x: 0, y: mobile.frame.maxY + verticalMargin, width: self.view.bounds.width , height: 10)
        let maintainContentString : String  = self.apiModel?.data?.content ??  ""
//        if let arr = self.apiModel?.data?.maintain_content {
//            for item in arr{
//                maintainContentString.append(item)
//            }
//        }else{
//            maintainContentString = "无"
//        }
        maintainContent.texts = ("maintain_content"|?|,maintainContentString)
//
//        isHasScreen.frame = CGRect(x: 0, y: shopType.frame.maxY + border, width: self.view.bounds.width , height: 10)
//        var screenBrandName = ""
//        if let brandName = self.apiModel?.data?.screen_brand_name , brandName.count > 0{
//            screenBrandName = " \(brandName)"
//        }
//        var screenShowInfo = screenBrandName + (self.apiModel?.data?.screen_number ?? "")
//        if screenShowInfo.count <= 0 {
//            screenShowInfo = "0"
//        }else{
//            if screenShowInfo != "0"{
//                screenShowInfo.append("台")
//            }
//        }
//        isHasScreen.texts = ("有无屏幕", screenShowInfo)
//        isHasScreen.texts = ("有无屏幕",self.apiModel?.data?.screen_number ?? "无")
        
        tips.frame = CGRect(x: 0, y: maintainContent.frame.maxY + verticalMargin, width: self.view.bounds.width , height: 10)
        tips.texts = ("tips"|?|,self.apiModel?.data?.description ?? "empty"|?|)
        pictureTitleLabel.frame = CGRect(x: 0, y: tips.frame.maxY, width: self.view.bounds.width, height: 40 * DDDevice.scale)
        pictureTitleLabel.backgroundColor = UIColor.white
        collectionView.frame = CGRect(x: 0, y: pictureTitleLabel.frame.maxY , width: self.view.bounds.width, height: 88 * DDDevice.scale)
        
        ////
        commentTitleLabel.frame = CGRect(x: 0, y: collectionView.frame.maxY + 15, width: self.view.bounds.width, height: 40)
        commentTitleLabel.text = "maintain_comment_from_shop"|?|
        
        commentContentLabel.frame = CGRect(x: 0, y: commentTitleLabel.frame.maxY + 10, width: self.view.bounds.width, height: 0)
        var evaluateString = ""
        switch self.apiModel?.data?.evaluate ?? "" {
        case "1":
            evaluateString = "good_comment"|?|
        case "2":
            evaluateString = "regular_comment"|?|
        case "3":
            evaluateString = "bad_comment"|?|
        default:
            evaluateString = "not_comment"|?|
        }
        commentType.text = evaluateString
        commentType.font = UIFont.systemFont(ofSize: 14)
        commentType.ddSizeToFit(contentInset: UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        commentType.center = CGPoint(x: self.view.bounds.width - 10 - commentType.bounds.width/2, y: commentTitleLabel.frame.midY)
        commentType.layer.borderColor = UIColor.orange.cgColor
        commentType.layer.borderWidth = 1
        commentType.layer.masksToBounds = true
        commentType.layer.cornerRadius = commentType.bounds.height/2
        commentType.textColor = UIColor.orange
        commentContentLabel.text = self.apiModel?.data?.evaluate_description ?? ""
        ////
        
        
        upContainerView.contentSize = CGSize(width: self.view.bounds.width, height: commentContentLabel.frame.maxY + 10)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.itemSize = CGSize(width: collectionView.bounds.size.height - 10, height: collectionView.bounds.size.height - 10)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
        }
        collectionView.reloadData()
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
            flowLayout.itemSize = CGSize(width: collectionView.bounds.size.height - 10, height: collectionView.bounds.size.height - 10)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
        }
    }
    
}
extension DDMaintainSignDetailVC : UICollectionViewDelegate , UICollectionViewDataSource{
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
        _ = GDIBContentView.init(photos: images, showingPage: indexPath.item)
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
//            let margin : CGFloat = 13 * DDDevice.scale
            imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDLabel: UIView {
        var textInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var textColor = UIColor.darkGray{
            didSet{
                label.textColor = textColor
            }
        }
        
        var font = UIFont.systemFont(ofSize: 17){
            didSet{
                label.font = font
            }
        }
        var text : String = ""{
            didSet{
                label.text = text
                let labelW = self.bounds.width - textInset.left - textInset.right
                label.frame = CGRect(x: textInset.left, y: textInset.top, width:labelW , height: self.bounds.height - textInset.top - textInset.bottom)
                if let size = label.text?.sizeWith(font: label.font, maxWidth: labelW){
                    if size.width <= 0 {
                         self.frame.size.height = 0
                    }
                    else if size.height > label.frame.height {
                        self.frame.size.height = size.height + textInset.top + textInset.bottom
                        label.frame = CGRect(x: textInset.left, y: textInset.top, width:labelW , height: self.bounds.height - textInset.top - textInset.bottom)
                    }
                }
            }
        }
        private let label = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(label)
            label.numberOfLines = 0
            label.textColor = UIColor.darkGray
            self.backgroundColor = .white
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
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
                
                title.frame = CGRect(x: inset.left, y: inset.top, width: title.bounds.width, height: self.bounds.height - inset.top - inset.bottom)
                self.layoutIfNeeded()
                self.setNeedsLayout()
            }
        }
        let title = UILabel()
        let subtitle = UILabel()
        let inset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
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
            self.backgroundColor = UIColor.white
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
