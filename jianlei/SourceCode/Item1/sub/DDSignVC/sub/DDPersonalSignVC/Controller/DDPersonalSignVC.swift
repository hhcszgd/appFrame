//
//  DDPersonalSignVC.swift
//  Project
//
//  Created by WY on 2019/8/12.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDPersonalSignVC: DDNormalVC {

    var page = 1
    var isNeesDestroy = false
    let timeRow = ShopInfoCell.init(leftImage: "time", title: "", rightImage: "enterthearrow", isUserinteractionEnable: true)
    let groupRow = ShopInfoCell.init(frame: CGRect.zero, leftImage: "team")
    let upContainerView = UIView()
    var paraModel : DDFootprintVC.NotSignDataModel!
    var paraTeamName : String = ""
    let midContainerView = UIView()
    let icon = UIImageView()
    let name = UILabel()
    let signCount = UILabel()
    var apiModel : ApiModel<DDPersonalSignDataModel>?
    var currentYear = ""
    var currentMonth = ""
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var blankView : DDBlankView?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "personal_sign"|?|
        self.tabBarItem.title = "footprint"|?|
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)], for: UIControl.State.normal)
        self.tabBarItem.image = UIImage(named:"fotoplace")
        self.tabBarItem.selectedImage = UIImage(named:"fotoplace_select")
        
        timeRow.lineView?.isHidden = true
        groupRow.lineView?.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy"
        let year = dateFormater.string(from: Date())
        self.currentYear = year
        
        dateFormater.dateFormat = "MM"
        let month = dateFormater.string(from: Date())
        self.currentMonth = month
        
        
        
        mylog(self.title)
//        self.view.backgroundColor = UIColor.random
        layoutCustomSubviews()
        self.requestApi()
    }
    
    func getMonthOfDateStr(dateStr:String?) -> String{
        if let date = dateStr{
            if date.contains("date_year"|?|){
                let dataFormate = DateFormatter()
                dataFormate.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|)"
                let rempDate = dataFormate.date(from: date)
                dataFormate.dateFormat = "dd"
                let string = dataFormate.string(from: rempDate ?? Date())
                return string
            }else if date.contains("-"){
                let dataFormate = DateFormatter()
                dataFormate.dateFormat = "yyyy-MM-dd"
                let rempDate = dataFormate.date(from: date)
                dataFormate.dateFormat = "dd"
                let string = dataFormate.string(from: rempDate ?? Date())
                return string
            }else{
                return "0"
            }
        }else {return "0"}
    }
    func requestApi(loadType:LoadDataType = LoadDataType.initialize)  {
        self.blankView?.remove()
        self.blankView = nil
        if loadType == LoadDataType.loadMore{
            page += 1
        }else{
            page = 1
        }
        DDRequestManager.share.getPersonalSignDetail(type: ApiModel<DDPersonalSignDataModel>.self , create_at: "\(currentYear)-\(currentMonth)", member_id:paraModel.member_id ?? "", team_id:paraModel.team_id ?? "",page:self.page, success: { (model ) in
            
            
            if loadType == LoadDataType.loadMore{
                if model.status == 200 {
                    
                    self.paraTeamName = model.data?.team_name ?? ""
                    if let datas = model.data?.data ,  datas.count  > 0 {
                        let proviousMonth = self.getMonthOfDateStr(dateStr: self.apiModel?.data?.data?.last?.time)
                        let newMonth = self.getMonthOfDateStr(dateStr: model.data?.data?.first?.time)
                        if proviousMonth == newMonth{
                            if let rowModels = model.data?.data?.first?.items{
                                self.apiModel?.data?.data?.last?.items?.append(contentsOf: rowModels)
                                if let sesstions = model.data?.data?.dropFirst(){
                                    self.apiModel?.data?.data?.append(contentsOf: sesstions)
                                    
                                }
                            }
                            
                            
                        }else{
                            self.apiModel?.data?.data?.append(contentsOf: datas)
                            
                        }
                        
                        
//                        self.collectionView.isScrollEnabled =  true
//                        self.collectionView.reloadData()
//                        self.setValueToUI()
                        
                    }else{
//                        self.collectionView.isScrollEnabled = false
                         GDAlertView.alert("load_nomoreStr"|?|, image: nil, time: 2, complateBlock: nil)
                    }
                    
                }else{
//                    GDAlertView.alert(model.message , image: nil , time: 2 , complateBlock: nil )
                }
                
            }else{
                if model.status == 200 {
                    self.apiModel = model
                    self.paraTeamName = model.data?.team_name ?? ""
                    self.setValueToUI()
                    if self.apiModel?.data?.data?.count ?? 0 <= 0 {
                        self.collectionView.isScrollEnabled = false
                        let alert = DDBlankView(message: "no_sign_data_this_month"|?|, image: UIImage(named: "nosign"))
                        alert.action = {
                            mylog("xxxx")
                            self.requestApi()
                        }
                        self.blankView = alert
                        self.collectionView.alert(alert)
                    }else{
                        self.collectionView.isScrollEnabled =  true
                        
                    }
//                    self.collectionView.reloadData()
                    
                }else{
//                    GDAlertView.alert(model.message , image: nil , time: 2 , complateBlock: nil )
                }
            }
            
            
        }){
            self.collectionView.gdLoadControl?.endLoad()
            self.collectionView.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        mylog("DDPersonalSignVC vc destroyed")
    }
}



//action
extension DDPersonalSignVC{
   
   
    @objc func changeTime() {
        let alert = DDMonthSelectView()
        alert.done = {[weak self ] year , month in
            self?.currentYear = year
            if month.count == 1 {
                self?.currentMonth = "0" + month
            }else{
                self?.currentMonth = month                
            }
           self?.requestApi()
        }
        self.view.alert(alert)
    }
    @objc func changeGroup() {
        mylog("change group ")
    }
   
}

// about UI
extension DDPersonalSignVC{
    
   
    
    func layoutCustomSubviews() {
        timeRow.shopInfoBtnClick = { [weak self] (_) in
            self?.changeTime()
        }
//        timeRow.addTarget(self , action: #selector(changeTime), for: UIControl.Event.touchUpInside)
        //张凯强修改
//        groupRow.addTarget(self , action: #selector(changeGroup), for: UIControl.Event.touchUpInside)
        //
        
       
        self.view.addSubview(upContainerView)
        upContainerView.addSubview(timeRow)
        upContainerView.addSubview(groupRow)
       
        self.view.addSubview(midContainerView)
        midContainerView.addSubview(name)
        midContainerView.addSubview(icon)
        midContainerView.addSubview(signCount)
        self.view.addSubview(collectionView)
       
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f6f6f6")
      
        //张凯强
        timeRow.title.textColor = UIColor.colorWithHexStringSwift("999999")
        
//        timeRow.titleLabel.textColor = UIColor.lightGray
//        timeRow.additionalImageView.isHidden = false
        
//        groupRow.titleLabel.textColor = UIColor.lightGray
//        groupRow.additionalImageView.isHidden = true
        
        timeRow.title.font = GDFont.systemFont(ofSize: 16)
        groupRow.title.font = GDFont.systemFont(ofSize: 16)
//        groupRow.titleLabel.font = GDFont.systemFont(ofSize: 16)
        name.font = GDFont.systemFont(ofSize: 17)
        signCount.font = GDFont.systemFont(ofSize: 16)
        name.textColor = UIColor.darkGray
        signCount.textColor = UIColor.lightGray
        setValueToUI()
//        name.text = "大红花🌹"
//        signCount.text = "本月签到N次"
//        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3  * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
//        let groupIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy年MM月dd日"//"yyyy-MM-dd 'at' HH:mm"
//        let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
//        timeAttributeString.append(NSAttributedString(string: " \(dateFormater.string(from: Date()))"))
//        timeRow.titleLabel.attributedText = timeAttributeString
//
//        let groupAttributeString = NSMutableAttributedString(attributedString: groupIcon)
//        groupAttributeString.append(NSAttributedString(string:" 世世代代烤鸭店"))
//        groupRow.titleLabel.attributedText = groupAttributeString
        self.upContainerView.backgroundColor = .white
        
      icon.backgroundColor = UIColor.DDLightGray
        midContainerView.backgroundColor = UIColor.white
        let border : CGFloat = 10  * DDDevice.scale
        timeRow.frame = CGRect(x: 0, y: border, width: self.view.bounds.width, height: 40 * DDDevice.scale)
        groupRow.frame = CGRect(x: 0, y: timeRow.frame.maxY, width: self.view.bounds.width, height: 40 * DDDevice.scale)
       
        upContainerView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: groupRow.frame.maxY )
        
        midContainerView.frame = CGRect(x: 0, y: upContainerView.frame.maxY + 15 * DDDevice.scale, width: self.view.bounds.width, height: 88 * DDDevice.scale)
        let iconY : CGFloat = 10
        icon.frame = CGRect(x: 10, y: iconY, width: (midContainerView.bounds.height - iconY * 2) , height: (midContainerView.bounds.height - iconY * 2))
        
        icon.layer.cornerRadius = icon.bounds.width/2
        icon.clipsToBounds = true 
        name.frame = CGRect(x: icon.frame.maxX + 10, y: icon.frame.minY, width: midContainerView.bounds.width - icon.frame.maxX - 10, height: icon.bounds.height/2)
        signCount.frame = CGRect(x: icon.frame.maxX + 10, y: icon.frame.midY, width: midContainerView.bounds.width - icon.frame.maxX - 10, height: icon.bounds.height/2)
        
       
        //        selectedIndicator.frame = CGRect(x: recentSign.frame.minX, y: recentSign.frame.maxY, width: recentSign.bounds.width, height: 4)
        layoutCollectionView()
    }
    func setValueToUI() {

        
        
        
//        name.text = self.paraModel?.memberName?.name//"大红花🌹"
        name.text = self.apiModel?.data?.member_name
//        signCount.text = "本月签到N次"
        signCount.attributedText = ["本月簽到","\(self.apiModel?.data?.total_num ?? "0")","次"].setColor(colors: [UIColor.lightGray,UIColor.orange,UIColor.lightGray])
        
//        let timeIcon = UIImage(named: "time")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3  * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale)) ?? NSAttributedString()
        let groupIcon = UIImage(named: "team")?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3 * DDDevice.scale, width: 15 * DDDevice.scale, height: 15 * DDDevice.scale))  ?? NSAttributedString()
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy年MM月dd日"//"yyyy-MM-dd 'at' HH:mm"
//        let timeAttributeString = NSMutableAttributedString(attributedString: timeIcon)
//        timeAttributeString.append(NSAttributedString(string: " \(currentYear)年\(currentMonth)月"))
//        timeRow.titleLabel.attributedText = timeAttributeString
        timeRow.title.text = String.init(format: "%@\("date_year"|?|)%@\("date_month"|?|)", currentYear, currentMonth)
        timeRow.layoutIfNeeded()
        timeRow.setNeedsLayout()
        
        if self.paraModel.memberName?.avatar == nil {
            icon.setImageUrl( url: self.apiModel?.data?.avatar)
        }else{
            icon.setImageUrl(url: self.paraModel.memberName?.avatar)
        }
        let groupAttributeString = NSMutableAttributedString(attributedString: groupIcon)
        groupAttributeString.append(NSAttributedString(string:" \(paraTeamName)"))
        //张凯强修改
//        groupRow.titleLabel.attributedText = groupAttributeString
        groupRow.title.text = self.apiModel?.data?.team_name
    }
    func layoutCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
//        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.register(DDPersonalPageItem.self , forCellWithReuseIdentifier: "DDPersonalPageItem")
        collectionView.register(DDPersonalPageSectionHeader.self , forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DDPersonalPageSectionHeader")
        let collectionViewY = midContainerView.frame.maxY + 15 * DDDevice.scale
        collectionView.backgroundColor = UIColor.white
        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: self.view.bounds.width, height: self.view.bounds.height  - collectionViewY - 2)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 72 * DDDevice.scale)
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 44 )
        }
        let loadControl = GDLoadControl.init(target: self , selector: #selector(loadMoreData))
        collectionView.gdLoadControl = loadControl
        collectionView.gdLoadControl?.loadHeight = 40
    }
    @objc func loadMoreData() {
        self.requestApi(loadType: LoadDataType.loadMore)
    }
}
extension DDPersonalSignVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.apiModel?.data?.data?[indexPath.section].items?[indexPath.row]{
                if model.team_type ?? "" == "1" {//业务签到
                    let vc = DDBussinessSignDetailVC()
                    vc.paraModel = model
                    vc.paraMember_id = paraModel.member_id ?? ""
                    self.navigationController?.pushViewController(vc , animated: true)
                }else{//维护签到
                    
                    let vc = DDMaintainSignDetailVC()
                    vc.paraModel = model
                    vc.paraMember_id = paraModel.member_id ?? ""
                    self.navigationController?.pushViewController(vc , animated: true)
                }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.apiModel?.data?.data?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apiModel?.data?.data?[section].items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDPersonalPageItem", for: indexPath)
//            cell.backgroundColor = UIColor.random
        if let temp = cell as? DDPersonalPageItem{
//            temp.signType = self.signType
            temp.model = self.apiModel?.data?.data?[indexPath.section].items?[indexPath.row]
        }
            return cell
       
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind ==  UICollectionElementKindSectionHeader{//因为只注册了header , 所以此处只可能是header
//        }
        let header =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DDPersonalPageSectionHeader", for: indexPath)
        if let tempHeader = header as? DDPersonalPageSectionHeader{
             let time = self.apiModel?.data?.data?[indexPath.section].time ?? ""
            
//            let dataFormate = DateFormatter()
//            let rempDate = dataFormate.date(from: time)
//            dataFormate.dateFormat = "yyyy年MM月dd日"
//            let string = dataFormate.string(from: rempDate ?? Date())
//
            
            //张凯强
            let strArr = time.components(separatedBy: "-")
            if strArr.count == 3 {
                let result = String.init(format: "%@\("date_year"|?|)%@\("date_month"|?|)%@\("date_day"|?|)", strArr.first ?? "", strArr[1], strArr.last ?? "")
                tempHeader.timeLabel.text  = result
            }else {
                tempHeader.timeLabel.text  = time
            }
            
        }
        return header
    }
    
}
class DDPersonalPageSectionHeader: UICollectionReusableView {
    let imageView = UIImageView()
    let timeLabel = UILabel()
    let line = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(timeLabel)
        self.addSubview(line)
        imageView.image = UIImage(named: "date")
        line.backgroundColor = UIColor.DDLightGray
        timeLabel.text = "xx年xx月xx日"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewWH : CGFloat = 20
        imageView.frame = CGRect(x: 10, y: self.bounds.height/2 - imageViewWH/2, width: imageViewWH, height: imageViewWH)
        timeLabel.sizeToFit()
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imageView.snp.right).offset(10)
        }
        line.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.timeLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(1)
        }
//        timeLabel.frame = CGRect(x: imageView.frame.maxX + 10, y: imageView.frame.midY - 15, width: timeLabel.bounds.width, height: 30)
//        line.frame = CGRect(x: timeLabel.frame.maxX + 10, y: imageView.frame.midY - 1, width: self.bounds.width - timeLabel.frame.maxX - 10, height: 2)
    }
    
}
class DDPersonalPageItem: UICollectionViewCell {
//    var signType = DDBussinessNaviVC.SignType.bussiness
    
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let shopLocation = UILabel()
    let arrowImageView = UIImageView()
    let status = UILabel()
    var model : PersonalSignRowModel?{
        didSet{
            if model?.team_type ?? "" == "1"{//业务签到
                if model?.late_sign ?? "" == "1"{
                    status.text = "sign_overtime"|?|
                    status.isHidden = false
                }else{
                    status.isHidden = true
                }
//                status.text = "签到状态\(model?.late_sign ?? "" )"
            }else{//维护签到
                var commonStr = ""
                if (model?.evaluate ?? "" ) == "1" {
                    commonStr = "good_comment"|?|
                }else if (model?.evaluate ?? "" ) == "2" {
                    commonStr = "regular_comment"|?|
                }else if (model?.evaluate ?? "" ) == "3" {
                    commonStr = "bad_comment"|?|
                }else{
                    commonStr = "not_comment"|?|
                }
                
                status.text = commonStr
            }
            
            nameLabel.text = model?.shop_name
            shopLocation.text = model?.shop_address
            timeLabel.text = model?.tm
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(shopLocation)
        self.contentView.addSubview(arrowImageView)
        self.contentView.addSubview(status)
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = UIImage(named:"enterthearrow")
        //        nameLabel.backgroundColor = UIColor.yellow
        //        timeLabel.backgroundColor = UIColor.green
        //        shopName.backgroundColor = UIColor.yellow
        //        shopLocation.backgroundColor = UIColor.blue
        nameLabel.font = GDFont.systemFont(ofSize: 16)
        shopLocation.font = GDFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.darkGray
        status.backgroundColor = UIColor.white// UIColor.orange.withAlphaComponent(0.3)
        status.textColor = UIColor.orange
        timeLabel.text = "12:12"
        status.text = "sign_overtime"|?|
        status.textAlignment = .center
        timeLabel.textColor = UIColor.black
        shopLocation.textColor = UIColor.lightGray
        timeLabel.font = GDFont.systemFont(ofSize: 16)
        status.font = GDFont.systemFont(ofSize: 13)
        nameLabel.text = "哪里的店,哪里的楼"
        shopLocation.text = "北京北京市航丰路1号20000000000015室"
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let arrowImageViewW : CGFloat = 10
        let arrowImageViewH : CGFloat = 14
        arrowImageView.frame = CGRect(x: self.bounds.width - 20, y: self.bounds.height/2 - arrowImageViewH/2, width: arrowImageViewW, height: arrowImageViewH)
        status.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        status.frame = CGRect(x: arrowImageView.frame.minX - status.bounds.width - 10, y: self.bounds.height/2 - status.bounds.height/2, width: status.bounds.width, height: 20 * DDDevice.scale)
        
        let margin : CGFloat = 13 * DDDevice.scale
        timeLabel.sizeToFit()
        let timeLabelH : CGFloat = 22 * DDDevice.scale
        timeLabel.frame = CGRect(x:margin , y: self.bounds.height/2 - timeLabelH, width: timeLabel.bounds.width, height:timeLabelH)
        let nameLabelW  = status.isHidden ? arrowImageView.frame.minX - nameLabel.frame.minX : status.frame.minX - nameLabel.frame.minX
        nameLabel.frame = CGRect(x:timeLabel.frame.maxX + 10 , y: timeLabel.frame.minY, width: nameLabelW, height: timeLabel.frame.height)
        let locationW  = status.isHidden ? arrowImageView.frame.minX - nameLabel.frame.minX : status.frame.minX - nameLabel.frame.minX
        shopLocation.frame =  CGRect(x:nameLabel.frame.minX , y: self.bounds.height/2, width: locationW, height:  18)
        
        status.layer.masksToBounds = true
        status.layer.cornerRadius = status.bounds.height/2
        status.layer.borderColor = UIColor.orange.cgColor
        status.layer.borderWidth = 1
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DDPersonalSignDataModel : Codable {
    var total_num : String?
    var avatar: String?
    var member_name: String?
    var team_name: String?
    
    
    var data : [DataModel]?
    
    class DataModel : Codable {
        var time : String?
        var items : [PersonalSignRowModel]?
    }
}

class PersonalSignRowModel: NSObject ,Codable{
    var id : String?
    var member_name : String?
    var shop_address : String?
    var member_avatar : String?
    var shop_name : String?
    var tm : String?//几点几分
    var rq : String?//几年几月
    var evaluate : String?//状态吧
    var late_sign : String?
    ///签到类型 1:业务签到  ,  2:维护签到
    var team_type : String?
}




