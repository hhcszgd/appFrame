//
//  DDShopMediaPublishVC.swift
//  Project
//
//  Created by WY on 2019/8/18.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import Photos
class DDShopMediaPublishVC: DDInternalVC {
    var collection : UICollectionView?
    var apiModel : ApiModel<[DDShopMediaPublishModel]>?
    let topLabel = UILabel()
    var tempShopID = ""
    ///2:总店 , 1:非总店
    var shopType = "6"
    let bottomButton = UIButton()
    let addButton = UIButton()
    var blankView : DDShopMediaEditStatusView?
    let editButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.naviBar.title = "Shop_media_manager"|?|
        configNaviBar()
        if let shopID = self.userInfo as? String , self.tempShopID.count == 0{
            self.tempShopID = shopID
        }
        if tempShopID < "1"{
            GDAlertView.alert("parameter_error"|?|, image: nil, time: 2) {
                self.navigationController?.popViewController(animated: true )
            }
            return
            
        }
        configCollectionView()
        self.congitGesture()
        configFloatButton()
        if #available(iOS 11.0, *) {
            self.collection?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        PHPhotoLibrary.requestAuthorization { (status ) in
            
        }
        mylog(self.view.bounds.height)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showHasBeenUploadedMedias()
    }
    func showHasBeenUploadedMedias() {
        DDRequestManager.share.showHasBeenUploadMedias(type: ApiModel<[DDShopMediaPublishModel]>.self, shop_id: tempShopID,ttype:self.shopType,success: { (apiModel) in
            
            self.apiModel = apiModel
            self.collection?.reloadData()
        })
    }
    
    override func popToPreviousVC() {
        if editButton.isSelected{
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                print(action._title)
                self.navigationController?.popViewController(animated: true)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                if let a = self.apiModel?.data , let json = DDJsonCode.encode(a){
                    DDRequestManager.share.manageShopAdMedia(type: ApiModel<String>.self, shop_id: self.tempShopID, sort_json: json, success: { (apiModel ) in
                        
                    })
//                        DDRequestManager.share.manageShopAdMedia(shop_id: self.tempShopID, sort_json: json , type : self.shopType)
//                    if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton {
//                        if a.count <= 0{
//                            editButton.isHidden = true
//                        }else{editButton.isHidden = true }
//                    }
                    
                        if a.count <= 0{
                            self.editButton.isHidden = true
                        }else{self.editButton.isHidden = false }
                }




                self.navigationController?.popViewController(animated: true)
            })
            let message1  = "wheher_save_media_change"|?|
            let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"pop-upauthentication"), actions:  [cancel,sure])
            
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
        }else{
            super.popToPreviousVC()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        mylog("管理图片VC销毁")
    }
}
extension DDShopMediaPublishVC{
    func selectMedia()  {
        DDPhotoManager.share.getRequestAuthorizationStatus { (status ) in
            switch status {
            case .authorized:
                
                DispatchQueue.main.async {
                    
//                    let selectMediaVC = DDShopMediaSelectVC()
                    let selectMediaVC = DDShopMediaSelectNewVC()
                    selectMediaVC.shopType = self.shopType
                    selectMediaVC.userInfo = self.apiModel?.data?.count ?? 0// 服务器已有图片数量
                    selectMediaVC.tempShopID = self.tempShopID
                    self.navigationController?.pushViewController(selectMediaVC, animated: true)
                }
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { authorizationStatus in}
            case .denied:
                DispatchQueue.main.async {
                    
                    let alertVC = UIAlertController.init(title: "allow_access_album"|?|, message: nil, preferredStyle: UIAlertController.Style.alert)
                    let cancleAction = UIAlertAction.init(title: "cancel"|?|, style: UIAlertAction.Style.cancel) { (action ) in
                        
                    }
                    let confirmAction = UIAlertAction.init(title: "sure"|?|, style: UIAlertAction.Style.destructive) { (action ) in
                        
                        let url : URL = URL(string: UIApplication.openSettingsURLString)!
                        if UIApplication.shared.canOpenURL(url ) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    alertVC.addAction(cancleAction)
                    alertVC.addAction(confirmAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true , completion: nil )
                }
                
                
            case .restricted:
                DispatchQueue.main.async {
                    let alertVC = UIAlertController.init(title: "allow_access_album1"|?|, message: nil, preferredStyle: UIAlertController.Style.alert)
                    let cancleAction = UIAlertAction.init(title: "cancel"|?|, style: UIAlertAction.Style.cancel) { (action ) in
                        
                    }
                    let confirmAction = UIAlertAction.init(title: "sure"|?|, style: UIAlertAction.Style.destructive) { (action ) in
                        
                        let url : URL = URL(string: UIApplication.openSettingsURLString)!
                        if UIApplication.shared.canOpenURL(url ) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    alertVC.addAction(cancleAction)
                    alertVC.addAction(confirmAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true , completion: nil )
                    
                }
                
            }
        }
        
//        let selectMediaVC = DDShopMediaSelectVC()
//        selectMediaVC.shopType = self.shopType
//        selectMediaVC.userInfo = self.apiModel?.data?.count ?? 0// 服务器已有图片数量
//        selectMediaVC.tempShopID = self.tempShopID
//        self.navigationController?.pushViewController(selectMediaVC, animated: true)
    }
    func configNaviBar() {
        editButton.frame = CGRect.init(x: 0, y: 0, width: 64, height: 44)
        editButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
//        editBtn.setImage(UIImage.init(named: "history"), for: UIControl.State.normal)
//        editButton.setTitle("编辑", for: UIControl.State.normal)
//        editButton.setTitle("完成", for: UIControl.State.selected)
        editButton.setImage(UIImage(named:"edit"), for: UIControl.State.normal)
        editButton.setImage(UIImage(named:"preservation"), for: UIControl.State.selected)
//        editButton.setBackgroundImage(UIImage(named:"edit"), for: UIControl.State.normal)
//        editButton.setBackgroundImage(UIImage(named:"preservation"), for: UIControl.State.selected)
        editButton.backgroundColor = UIColor.clear
        editButton.addTarget(self, action: #selector(editAction(sender:)), for: UIControl.Event.touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        self.naviBar.rightBarButtons = [editButton]
    }

    func configFloatButton() {
        self.view.addSubview(addButton)
        addButton.frame = CGRect(x: self.view.bounds.width - 72, y: self.view.bounds.height * 0.7, width: 64, height: 64)
//        addButton.backgroundColor = .orange
//        addButton.setImage(UIImage(named:"addNew"), for: UIControl.State.normal)
        addButton.setBackgroundImage(UIImage(named:"addNew"), for: UIControl.State.normal)
        addButton.layer.cornerRadius = addButton.bounds.height/2
        addButton.layer.masksToBounds = true
        addButton.addTarget(self , action: #selector(addAction(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func addAction(sender:UIButton)  {
        if self.apiModel?.data?.count ?? 0 >= 30 {
                GDAlertView.alert("shop_media_count_max"|?|, image: nil, time: 2, complateBlock: nil)
        }else{
            self.selectMedia()
            
        }
    }
    @objc func editAction(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        self.bottomButton.isHidden = sender.isSelected
        self.addButton.isHidden = sender.isSelected
        self.collection?.reloadData()
        if !sender.isSelected{
            if let a = self.apiModel?.data , let json = DDJsonCode.encode(a){
//                DDRequestManager.share.manageShopAdMedia(shop_id: tempShopID, sort_json: json , type : shopType)
                DDRequestManager.share.manageShopAdMedia(type: ApiModel<String>.self, shop_id: self.tempShopID, sort_json: json,ttype:self.shopType, success: { (apiModel ) in
                    
                })
//                if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton {
                    if a.count <= 0{
                        self.editButton.isHidden = true
                    }else{self.editButton.isHidden = false }
//                }
            }
        }else{}
        mylog("edit")
    }
    @objc func releaseShopMedia(sender:UIButton)  {
        DDRequestManager.share.releaseShopMedia(type: ApiModel<String>.self, shop_id: tempShopID,ttype:self.shopType, success: { (apiModel ) in
            if apiModel.status == 200{
                self.showHasBeenUploadedMedias()
                //                    self.bottomButton.backgroundColor = UIColor.gray(0.6)
                //                    self.bottomButton.isEnabled = false
            }else{
                self.bottomButton.backgroundColor = UIColor.orange
                self.bottomButton.isEnabled = true
                
            }
        })
        
//        DDRequestManager.share.releaseShopMedia(shop_id: tempShopID , type : shopType)?.responseJSON(completionHandler: { (response ) in
//            if let resultModel = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response){
//                if resultModel.status == 200{
//                    self.showHasBeenUploadedMedias()
////                    self.bottomButton.backgroundColor = UIColor.gray(0.6)
////                    self.bottomButton.isEnabled = false
//                }else{
//                    self.bottomButton.backgroundColor = UIColor.orange
//                    self.bottomButton.isEnabled = true
//
//                }
//            }
//        })
    }
    func configCollectionView()  {
        self.view.addSubview(topLabel)
        topLabel.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: 44)
        topLabel.text = "switch_to_edit_or_delete"|?|
//        topLabel.textAlignment = .center
        topLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        topLabel.textColor = .orange
        self.view.addSubview(bottomButton)
        bottomButton.setTitle("send_to_screen"|?|, for: UIControl.State.normal)
        self.bottomButton.setTitle("has_sent_to_screen"|?|, for: UIControl.State.disabled)
        self.bottomButton.isEnabled = false
        self.bottomButton.backgroundColor = UIColor.lightGray
        bottomButton.addTarget(self , action: #selector(releaseShopMedia(sender:)), for: UIControl.Event.touchUpInside)
//        bottomButton.backgroundColor = .orange
        let bottomButtonX : CGFloat = 0
        bottomButton.frame = CGRect(x: bottomButtonX, y: self.view.bounds.height - DDSliderHeight - 44, width: self.view.bounds.width - bottomButtonX * 2, height: 44 + DDSliderHeight)
        
        let toBorderMargin :CGFloat  = 10
        let itemMargin  : CGFloat = 10
        let itemCountOneRow = 3
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: toBorderMargin, bottom: 0, right: toBorderMargin)
        let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow)) / CGFloat(itemCountOneRow)
        let itemH = itemW
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
//        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
        let temp = UICollectionView.init(frame: CGRect(x: 0, y:  topLabel.frame.maxY , width: self.view.bounds.width, height: bottomButton.frame.minY - topLabel.frame.maxY ), collectionViewLayout: flowLayout)
        self.collection = temp
        temp.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.view.addSubview(temp)
        temp.register(DDShopMediaPublishItem.self , forCellWithReuseIdentifier: "DDShopMediaPublishItem")
//        collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
//        collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = true
        temp.alwaysBounceVertical = true
        temp.showsVerticalScrollIndicator = false
        temp.backgroundColor = .white
        
//        self.view.addSubview(blankView)
//        blankView.isHidden = true
//        blankView.frame = self.view.bounds

    }

}





extension DDShopMediaPublishVC : DDItemDeleteActionDelegate {
    func deleteAction(item: UICollectionViewCell) {
        if let index = self.collection?.indexPath(for: item){
            self.apiModel?.data?.remove(at: index.item)
            self.collection?.reloadData()
        }
    }
}




import SDWebImage
extension DDShopMediaPublishVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath)
        if let item = collectionView.cellForItem(at: indexPath) as? DDShopMediaPublishItem{
            if let image = item.imageView.image{
                let alert = DDShopMediaReview()
//                alert.imageview.setBackgroundImageUrl(url:  self.apiModel?.data?[indexPath.item].image_url, status: UIControl.State.normal)
                alert.imageview.setBackgroundImageUrl(url:  self.apiModel?.data?[indexPath.item].image_url, placeholderImage: image, status: UIControl.State.normal)

                UIApplication.shared.keyWindow?.alert(alert)
            }
        }
       
    }
    ///1 : 有图 , 2 : 编辑状态下无图 ,3 : 非编辑状态下无图
    func switchAddViewStatus(status:Int  )  {
        
        mylog("上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上")
        if status == 1{//有图片
            blankView?.isHidden = true
            if editButton.isSelected{
                    self.addButton.isHidden = true
            }else{
                self.addButton.isHidden = false
            }
        }else{
            mylog("looOoossssosososososososososososososososososoososo")
            if self.apiModel == nil {return}
            if blankView == nil {
                blankView = DDShopMediaEditStatusView()
                blankView?.action = {[weak self ] in
                    self?.selectMedia()
                }
            }
            if let blankview = blankView , blankview.superview == nil {
                self.view.addSubview(blankview)
                blankview.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight)
            }
            blankView?.isHidden = false
            self.addButton.isHidden = true
            blankView?.status = status
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.apiModel?.data?.count ?? 0
        judgeStatus()
        
        if count > 0 {
            switchAddViewStatus(status: 1)
//            if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton{
                self.topLabel.isHidden = false
                self.editButton.isHidden = false
                if editButton.isSelected{
                    mylog("可编辑")
                    self.bottomButton.isHidden = true
                }else{self.bottomButton.isHidden = false}
//            }
            
        
        }else{
            
            self.bottomButton.isHidden = true
            self.topLabel.isHidden = true
//            if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton {
                if editButton.isSelected{
                    editButton.isHidden = false
                    switchAddViewStatus(status: 2)
                }else{
                    editButton.isHidden = true
                    switchAddViewStatus(status: 3)
                }
//            }
        }
        return count//  apiModel?.data?.count ?? 0
    }
    func judgeStatus() {
        self.bottomButton.backgroundColor = UIColor.lightGray
        self.bottomButton.setBackgroundImage(nil , for: UIControl.State.disabled)
        self.bottomButton.setBackgroundImage(nil , for: UIControl.State.normal)
        self.bottomButton.isEnabled = false
        for model  in self.apiModel?.data ?? [] {
            if model.status == "0" , !self.bottomButton.isEnabled{//存在未发布的
//                self.bottomButton.backgroundColor = UIColor.orange
                self.bottomButton.setBackgroundImage(UIImage(named: "bottom_button_bg"), for: UIControl.State.normal)
                self.bottomButton.isEnabled = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "DDShopMediaPublishItem", for: indexPath)
        if let itemUnwrap = item as? DDShopMediaPublishItem , let model = self.apiModel?.data?[indexPath.row]{
            if model.status == "0" , !self.bottomButton.isEnabled{//存在未发布的
                self.bottomButton.backgroundColor = UIColor.orange
                self.bottomButton.isEnabled = true
            }
            itemUnwrap.model = model
            itemUnwrap.delegate = self
            if self.editButton.isSelected{
                mylog("可编辑")
                itemUnwrap.deleteButton.isHidden = false
            }else{itemUnwrap.deleteButton.isHidden = true}
            
        }
        //        item.backgroundColor = UIColor.randomColor()
        return item
    }
    
    
    
    
    
    
    
    
    
    ////
    /// core method about moveing item
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("invoke after moved , deal dataSource at here ")
        mylog("sourceIndexPath: \(sourceIndexPath) , sourceIndexPath: \(destinationIndexPath)")
//                self.apiModel?.data?.swapAt(sourceIndexPath.item, destinationIndexPath.item)
        if let sourceItemModel = self.apiModel?.data?.remove(at: sourceIndexPath.item){
            self.apiModel?.data?.insert(sourceItemModel, at: destinationIndexPath.item)
            
        }
        
                //                self.dataSource[0].swapAt(sourceIndexPath.item, destinationIndexPath.item)
        

//        collectionView.reloadData()//刷新会有残影
    }
    
    
    
    func congitGesture()  {
        let longPress = UILongPressGestureRecognizer.init(target: self , action: #selector(handleGesture(gesture:)))
        collection?.addGestureRecognizer(longPress)
    }
    //    installsStandardGestureForInteractiveMovement
    @objc func handleGesture(gesture :  UILongPressGestureRecognizer)  {
        //        print(gesture.state.rawValue)
        if !self.editButton.isSelected{
            return
        }
        switch(gesture.state) {
        case UIGestureRecognizer.State.began:
            guard let selectedIndexPath =  self.collection?.indexPathForItem(at: gesture.location(in: self.collection)) else {break}
            collection?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizer.State.changed:
            collection?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizer.State.ended:
            collection?.endInteractiveMovement()
        default:
            collection?.cancelInteractiveMovement()
        }
    }
}



import SDWebImage
protocol DDItemDeleteActionDelegate: NSObjectProtocol {
    func deleteAction(item:UICollectionViewCell)
}

class DDShopMediaPublishItem : UICollectionViewCell {
    var model : DDShopMediaPublishModel = DDShopMediaPublishModel(){
        didSet{
            
            if let url  = URL(string:(model.image_url ?? "").appending("?imageView2/1/w/120/h/360")) {
                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                imageView.image = DDPlaceholderImage
            }
            if model.status == "0"{
                label.isHidden = false
                label.text = "not_to_be_sent"|?|
            }else{
                label.isHidden = true
                
            }
            
        }
    }
    weak var delegate : DDItemDeleteActionDelegate?
    
    let deleteButton = UIButton()
    let imageView = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView )
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true 
        self.contentView.addSubview(deleteButton)
        deleteButton.isHidden = true
        deleteButton.addTarget(self , action: #selector(deleteAction(sender:)), for: UIControl.Event.touchUpInside)
        deleteButton.setBackgroundImage(UIImage(named:"deleteBlack"), for: UIControl.State.normal)
        self.contentView.addSubview(label )
        label.text = "not_to_be_sent"|?|
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = GDFont.systemFont(ofSize: 14.4)
        label.isHidden = true
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.adjustsFontSizeToFitWidth = true
        self.imageView.backgroundColor = UIColor.DDLightGray1
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0 , y : 0 , width : self.bounds.width , height : self.bounds.height)
        label.frame = CGRect(x:0  , y :self.bounds.height - 20, width : self.bounds.width , height : 20)
        let deleteButtonWH : CGFloat = 30
        let deleteBtnOffset : CGFloat = 2
        deleteButton.frame = CGRect(x: self.bounds.width - deleteButtonWH + deleteBtnOffset, y: -deleteBtnOffset, width: deleteButtonWH, height: deleteButtonWH)
    }
    @objc func deleteAction(sender:UIButton) {
        self.delegate?.deleteAction(item: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {self.delegate = nil  }/// in case of memary leaking
    }
}

class DDShopMediaPublishModel: NSObject , Codable {
    var shop_id : String?
    var image_url : String?
    var id : String?
    /// 0未发布1已发布
    var status : String?
}
class DDShopMediaEditStatusView: UIView {
     //2 : 编辑状态下无图 ,3 : 非编辑状态下无图
    let singleTextLabel = UILabel()
    let midLabel = UILabel()
    let imageView = UIImageView()
    let button = UIButton()
    var action : (() -> ())?
    var status : Int  = 3 {
        didSet{
            if status == 2{
                singleTextLabel.isHidden = false
                midLabel.isHidden = true
                imageView.isHidden = true
                button.isHidden = true
            }else if status == 3{
                
                singleTextLabel.isHidden = true
                midLabel.isHidden = false
                imageView.isHidden = false
                button.isHidden = false
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(singleTextLabel)
        self.addSubview(midLabel)
        self.addSubview(imageView)
        self.addSubview(button)
        singleTextLabel.textAlignment = .center
        midLabel.textAlignment = .center
        midLabel.numberOfLines = 2
//        button.backgroundColor = UIColor.orange
        button.setBackgroundImage(UIImage(named: "bottom_button_bg"), for: UIControl.State.normal)
        button.clipsToBounds = true 
        button.setTitle("add_media"|?|, for: UIControl.State.normal)
        imageView.image = UIImage(named:"nopicture")
        singleTextLabel.text = "no_image_at_media_lib"|?|
        midLabel.text = "no_image_at_media_lib"|?|
        singleTextLabel.textColor = UIColor.lightGray
        midLabel.textColor = UIColor.lightGray
        self.button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func buttonClick(sender:UIButton) {
        self.action?()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        singleTextLabel.frame = CGRect(x: 0, y: self.bounds.height/2 - 100, width: self.bounds.width , height: 44)
        midLabel.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width , height: 64)
        let imageWH : CGFloat = 100
        imageView.frame = CGRect(x: self.bounds.width/2 - imageWH/2, y: midLabel.frame.minY - 100, width: imageWH , height: imageWH)
        let buttonX : CGFloat = 32
        button.frame = CGRect(x: buttonX, y: midLabel.frame.maxY, width: self.bounds.width - buttonX * 2 , height: 44)
        button.layer.cornerRadius = button.bounds.height/2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
