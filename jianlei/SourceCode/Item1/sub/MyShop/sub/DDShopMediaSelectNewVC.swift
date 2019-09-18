//
//  DDShopMediaSelectNewVC.swift
//  Project
//
//  Created by WY on 2019/82/3.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//
import UIKit
import Photos
class DDShopMediaSelectNewVC: DDInternalVC {
    deinit {
        mylog("image selecor destroyed")
    }
    enum ActionType : String {
        case prepareUpload
        case uploading
        case uploaded
        case nothingSelected
        case someFailure
    }
    var canEdit = true
    var mediaCountInServer : Int = 0
    var hasSelectedMediaCount : Int = 0
    var collection : UICollectionView!
    var assets : [DDAsset] = [DDAsset]()
    let bottomButton = UIButton()
    var imagePicker : DDShopImagePicker?
    var currentUploadingIndex:Int  = 0
    var uploadFailureAssets = [DDAsset]()
    //    var currentUploadingIndexInFailureAssets : Int  = 0
    var shopType : String = ""
    var tempShopID = "0"
    var actionType : ActionType = .nothingSelected{
        didSet{
            switch actionType {
            case .prepareUpload:
                self.bottomButton.setTitle("press_to_upload_media"|?|, for: UIControl.State.normal)
                self.bottomButton.setBackgroundImage(UIImage(named: "bottom_button_bg"), for: UIControl.State.normal)
            case .uploading:
                canEdit = false
                self.bottomButton.setTitle("uploading_media"|?|, for: UIControl.State.normal)
                self.bottomButton.backgroundColor = UIColor.gray
                self.bottomButton.setBackgroundImage(nil, for: UIControl.State.normal)
            case .uploaded:
                self.bottomButton.setTitle("upload_success"|?|, for: UIControl.State.normal)
                self.bottomButton.setBackgroundImage(UIImage(named: "bottom_button_bg"), for: UIControl.State.normal)
                self.collection.reloadData()
                GDAlertView.alert("upload_success"|?|, image: nil, time: 2) {[weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            case .nothingSelected:
                self.bottomButton.setTitle("select_media"|?|, for: UIControl.State.normal)
                self.bottomButton.setBackgroundImage(UIImage(named: "bottom_button_bg"), for: UIControl.State.normal)
                self.collection.reloadData()
            case .someFailure:
                self.bottomButton.setTitle("some_media_upload_failure"|?|, for: UIControl.State.normal)
                self.bottomButton.setBackgroundImage(UIImage(named: "bottom_button_bg"), for: UIControl.State.normal)
                self.collection.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "press_to_upload_media"|?|
        if tempShopID < "1"{
            GDAlertView.alert("parameter_error"|?|, image: nil, time: 2) {
                self.navigationController?.popViewController(animated: true )
            }
            return
            
        }
        if let hasUploadCount = self.userInfo as? Int {
            self.mediaCountInServer = hasUploadCount
        }
        configCollectionView()
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.pickImage()
        bottomButton.addTarget(self , action: #selector(bottomButtonClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func bottomButtonClick(sender:UIButton) {
        switch actionType {
        case .prepareUpload:
            self.collection.reloadData()
            self.uploadImage()
        case .uploading:
            mylog("上传中 , 请稍后")
        case .uploaded:
//            self.navigationController?.popViewController(animated: true)
            break
        case .nothingSelected:
            pickImage()
        case .someFailure:
            uploadFailureImage()
        }
    }
    
    func uploadFailureImage() {
        self.actionType = .uploading
        if let first = self.uploadFailureAssets.first {
            if let indexInAssets = assets.index(of: first){
                upload(index: indexInAssets) {[weak self] isSuccess in
                    if isSuccess{
                        self?.uploadFailureAssets.removeFirst()
                        self?.uploadFailureImage()
                    }else{
                        self?.actionType = .someFailure
                    }
                }
            }else{
                mylog("something error ")
                actionType = .uploaded
            }
        }else{//传完了
            if uploadFailureAssets.isEmpty{
                actionType = .uploaded
            }else{
                actionType = .someFailure
            }
        }
    }
    
    func uploadImage() {
        mylog("xxxxxxxxxx..........xxxxxxx")
        self.actionType = .uploading
        mylog(currentUploadingIndex)
        if currentUploadingIndex < self.assets.count {
            self.actionType = .uploading
            upload(index: currentUploadingIndex) {[weak self] isSuccess in
                self?.currentUploadingIndex += 1
                self?.uploadImage()
            }
        }else{//传完了
            if uploadFailureAssets.isEmpty{
                actionType = .uploaded
            }else{
                actionType = .someFailure
            }
        }
    }
    func upload(index:Int , compated:@escaping ((Bool) -> ()))  {
        if index < 0 || index > self.assets.count - 1 {
            compated(false)
            return
        }
        let model  = self.assets[index]
        DDPhotoManager.share.getMediaByPHAsset(asset: model.asset) {[weak self] (image, imageInfo) in
            if let image1 = image{
                
                let image = image1.addshopMediaStr(str: "media_water_mark_text"|?|)
                //                addShopMediaWaterImage(UIImage(named: "shopMedisWaterMark")!)
                
                DDRequestManager.share.uploadShopAdMediaToTencentYun(image: image, progressHandler: {[weak self] (_, hasReceived, total) in
                    mylog(CGFloat(hasReceived)/CGFloat(total))
                    if let item = self?.collection.cellForItem(at: IndexPath(item: index, section: 0)) as? DDShopMediaSelectedItem{
                        model.process = CGFloat(hasReceived)/CGFloat(total)
                        model.showType = .uploading
                        item.updateProcess(process:CGFloat(hasReceived)/CGFloat(total))
                    }
                    }, compateHandler: {[weak self] (urlStr,imageSize,sha1HexString) in
                        if let successUrlStr = urlStr {
                            mylog("上传成功\(String(describing: urlStr))")
                            mylog("上传成功\(String(describing: imageSize))")
                            mylog("上传成功\(String(describing: sha1HexString))")
//                            DDRequestManager.share.saveShopMediaUrl(shop_id: self?.tempShopID ?? "", image_url: successUrlStr ,imageSize:imageSize, sha1HexString : sha1HexString , type: self?.shopType)?.responseJSON(completionHandler: { (response ) in
//                                mylog("图片保存结果\(String(describing: response.value ))")
//                            })
                            
                            DDRequestManager.share.saveShopMediaUrl(type:ApiModel<String>.self, shop_id: self?.tempShopID ?? "", image_url: successUrlStr ,imageSize:imageSize, sha1HexString : sha1HexString , shopType: self?.shopType, success: { (apiModel ) in
                                mylog("图片保存成功")
                            }, failure: { (error ) in
                                mylog("图片保存失败")
                            })
                            
                            
                            model.showType = .uploaded
                            if let item = self?.collection.cellForItem(at: IndexPath(item: index, section: 0)) as? DDShopMediaSelectedItem{
                                //                                item.uploadSuccess()
                                item.model = model
                            }
                            compated(true)
                        }else{//上传失败
                            mylog("上传失败")
                            if let asset = self?.assets[index] , let _self = self{
                                
                                if !_self.uploadFailureAssets.contains(asset){
                                    _self.uploadFailureAssets.append(asset)
                                }
                            }
                            model.showType = .failure
                            compated(false)
                            if let item = self?.collection.cellForItem(at: IndexPath(item: index, section: 0)) as? DDShopMediaSelectedItem {
                                //                                item.uploadFailure()
                                item.model = model
                            }
                        }
                })
            }else{
                model.showType = .failure
                compated(false)
            }
        }
    }
    
    /*
    func upload(index:Int , compated:@escaping ((Bool) -> ()))  {
        if index < 0 || index > self.assets.count - 1 {
            compated(false)
            return
        }
        let model  = self.assets[index]
        DDPhotoManager.share.getMediaByPHAsset(asset: model.asset) {[weak self] (image, imageInfo) in
            if let image = image{
                DDRequestManager.share.uploadShopAdMediaToTencentYun(image: image, progressHandler: {[weak self] (_, hasReceived, total) in
                    mylog(CGFloat(hasReceived)/CGFloat(total))
                    if let item = self?.collection.cellForItem(at: IndexPath(item: index, section: 0)) as? DDShopMediaSelectedItem{
                        model.process = CGFloat(hasReceived)/CGFloat(total)
                        model.showType = .uploading
                        item.updateProcess(process:CGFloat(hasReceived)/CGFloat(total))
                    }
                    }, compateHandler: {[weak self] (urlStr,imageSize,sha1HexString) in
                        if let successUrlStr = urlStr {
                            mylog("上传成功\(String(describing: urlStr))")
                            DDRequestManager.share.saveShopMediaUrl(type:ApiModel<String>.self, shop_id: self?.tempShopID ?? "", image_url: successUrlStr ,imageSize:imageSize, sha1HexString : sha1HexString , shopType: self?.shopType, success: { (apiModel ) in
                                mylog("图片保存成功")
                            }, failure: { (error ) in
                                mylog("图片保存失败")
                            })
                            
//                            DDRequestManager.share.saveShopMediaUrl(shop_id: self?.tempShopID ?? "", image_url: successUrlStr ,imageSize:imageSize, sha1HexString : sha1HexString , type: self?.shopType)?.responseJSON(completionHandler: { (response ) in
//                                mylog("图片保存结果\(String(describing: response.value ))")
//                            })
                            
                            
                            model.showType = .uploaded
                            if let item = self?.collection.cellForItem(at: IndexPath(item: index, section: 0)) as? DDShopMediaSelectedItem{
//                                item.uploadSuccess()
                                item.model = model
                            }
                            compated(true)
                        }else{//上传失败
                            mylog("上传失败")
                            if let asset = self?.assets[index] , let _self = self{
                                
                                if !_self.uploadFailureAssets.contains(asset){
                                    _self.uploadFailureAssets.append(asset)
                                }
                            }
                            model.showType = .failure
                            compated(false)
                            if let item = self?.collection.cellForItem(at: IndexPath(item: index, section: 0)) as? DDShopMediaSelectedItem {
//                                item.uploadFailure()
                                item.model = model
                            }
                        }
                })
            }else{
                model.showType = .failure
                compated(false)
            }
        }
    }
    */
    func pickImage() {
        if 30 - mediaCountInServer - self.assets.count <= 0 {
            GDAlertView.alert("shop_media_count_max"|?|, image: nil, time: 2, complateBlock: nil)
            return
        }
        let a = DDShopImagePicker(frame: CGRect.zero, targetSelectedCount: 30 - mediaCountInServer - self.assets.count)
        a.isHideWhenWhitespaceClick = false
        self.imagePicker = a
        a.completedHandle = {[weak self ] imageAssets in
            self?.imagePicker = nil
            if let imageAssetsUnwrap = imageAssets , imageAssetsUnwrap.count > 0{
                if self?.actionType != .uploading{
                    self?.actionType = .prepareUpload
                }
                imageAssetsUnwrap.forEach({ (asset ) in
                    let a = DDAsset()
                    a.asset = asset
                    self?.assets.append(a)
                })
                self?.collection.reloadData()
            }else{
                if self?.assets.count == 0{
                    self?.actionType = .nothingSelected
                    self?.popToPreviousVC()
                }
            }
            mylog(imageAssets)
        }
        UIApplication.shared.keyWindow?.alert(a)
    }
    override func popToPreviousVC() {
        if uploadFailureAssets.count > 0 || (assets.count > 0 && currentUploadingIndex < self.assets.count){
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                print(action._title)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
//                let vc = DDUserVerifiedVC() // JudgeVC()
                self.navigationController?.popViewController(animated: true)
            })
            let message1  = "cancel_and_give_unuploaded_media_up"|?|
            let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"pop-upauthentication"), actions:  [cancel,sure])
            
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
        }else{
            super.popToPreviousVC()
        }
        mylog("whether go back")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension DDShopMediaSelectNewVC{
    func selectMedia()  {
        let selectMediaVC = DDShopMediaSelectVC()
        selectMediaVC.userInfo = 12// 服务器已有图片数量
        self.navigationController?.pushViewController(selectMediaVC, animated: true)
    }
    func configNaviBar() {
        let doneBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        doneBtn.setTitle("add_media_title"|?|, for: UIControl.State.normal)
        doneBtn.backgroundColor = UIColor.clear
        doneBtn.addTarget(self, action: #selector(doneAction(sender:)), for: UIControl.Event.touchUpInside)
        self.naviBar.rightBarButtons = [ doneBtn]
        doneBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        
    }
    
    @objc func doneAction(sender:UIButton)  {
        mylog("done")
        pickImage()
    }
    func configCollectionView()  {
        
        self.view.addSubview(bottomButton)
        bottomButton.setTitle("press_to_upload_media"|?|, for: UIControl.State.normal)
        bottomButton.backgroundColor = .orange
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
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  DDNavigationBarHeight , width: self.view.bounds.width, height: bottomButton.frame.minY - DDNavigationBarHeight ), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        self.collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collection.register(DDShopMediaSelectedItem.self , forCellWithReuseIdentifier: "DDShopMediaSelectedItem")
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
    }
    
}
extension DDShopMediaSelectNewVC : DDItemDeleteActionDelegate {
    func deleteAction(item: UICollectionViewCell) {
        if let index = self.collection.indexPath(for: item){
            self.assets.remove(at: index.item)
            if index.item < currentUploadingIndex{currentUploadingIndex -= 1}
            self.collection.reloadData()
        }
    }
}
extension DDShopMediaSelectNewVC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath)
//        if uploadFailureAssets.contains( assets[indexPath.item]){
//            mylog("这个失败了")
//            upload(index: indexPath.item) { isSuccess in
//                if isSuccess{
//                    if let indexInFailureSet = self.uploadFailureAssets.index(of: self.assets[indexPath.item]){
//                        self.uploadFailureAssets.remove(at: indexInFailureSet)
//                    }
//                    self.collection.reloadData()
//                }
//            }
//        }else{mylog("这个成功了,或者等待上传")}
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = assets.count
//        if count <= 0 {self.actionType = .nothingSelected}else{
//            if currentUploadingIndex == assets.count {
//
//                if uploadFailureAssets.isEmpty{
//                    actionType = .uploaded
//                }else{
//                    actionType = .someFailure
//                }
//            }
//        }
        return  count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "DDShopMediaSelectedItem", for: indexPath)
        if let itemUnwrap = item as? DDShopMediaSelectedItem {
            itemUnwrap.delegate = self
            let model = self.assets[indexPath.row]
            model.canEdit = canEdit
            itemUnwrap.model = model
//            if self.actionType == .uploading{
//                itemUnwrap.deleteButton.isHidden = true
//            }else{
//                    if model.
//                itemUnwrap.deleteButton.isHidden = false
//            }
            if indexPath.item < currentUploadingIndex{//已上传
                if uploadFailureAssets.contains(assets[indexPath.item]){
//                    itemUnwrap.uploadFailure()
                }else{
//                    itemUnwrap.uploadSuccess()
                }
            }else{//未上传
//                itemUnwrap.penddingUpload()
            }
        }
        return item
    }
    
}


import SDWebImage
extension DDShopMediaSelectNewVC {
    
    class DDShopMediaSelectedItem : UICollectionViewCell {
        var model : DDAsset = DDAsset(){
            didSet{
                DDPhotoManager.share.getMediaByPHAsset(asset: model.asset , targetSize: CGSize(width: 88, height: 88)) { (image , dict ) in
                    self.imageView.image = image
                }
                    self.deleteButton.isHidden = !model.canEdit
                switch model.showType {
                case .waitingForUpload:
                    self.penddingUpload()
                case .uploading:
                    self.updateProcess(process: model.process)
                case .uploaded:
                    self.uploadSuccess()
                case .failure:
                    self.uploadFailure()
                }
            }
        }
        
        
        let imageView = UIImageView()
        let label = UILabel()
        let processLine = DDProcessLine()
        let deleteButton = UIButton()
        
        weak var delegate : DDItemDeleteActionDelegate?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(imageView )
            imageView.isUserInteractionEnabled = true
            self.contentView.addSubview(deleteButton)
            deleteButton.addTarget(self , action: #selector(deleteAction(sender:)), for: UIControl.Event.touchUpInside)
            //        deleteButton.setImage(UIImage(named:"delete"), for: UIControl.State.normal)
            deleteButton.setBackgroundImage(UIImage(named:"deleteBlack"), for: UIControl.State.normal)
            self.contentView.addSubview(processLine)
            self.contentView.addSubview(label )
            label.text = "pendding_upload"|?|
            label.textAlignment = .center
            label.textColor = UIColor.red
            label.font = GDFont.systemFont(ofSize: 13.4)
            label.adjustsFontSizeToFitWidth = true
            self.imageView.backgroundColor = UIColor.DDLightGray1
            processLine.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            processLine.indicaterColor = UIColor.orange.withAlphaComponent(0.6)
            processLine.embelishCorner = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        override func willMove(toWindow newWindow: UIWindow?) {
            if newWindow == nil {self.delegate = nil  }/// in case of memary leaking
        }
        private func uploadSuccess(){
            label.text = "upload_success"|?|
            self.processLine.progress = 1.0
        }
        private func penddingUpload()  {
            label.text = "pendding_upload"|?|
            self.processLine.progress = 0.0
        }
        private func uploadFailure(){
            label.text = "reupload_after_failure"|?|
            self.processLine.progress = 0.0
        }
        func updateProcess(process:CGFloat){
            self.processLine.progress = process
//            if process >= 1.0{
                //label.text = "上传完成"
//            }else{
                label.text = "uploading_media"|?|
//            }
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            imageView.frame = CGRect(x: 0 , y : 0 , width : self.bounds.width , height : self.bounds.height)
            label.frame = CGRect(x:0  , y :self.bounds.height - 20, width : self.bounds.width , height : 20)
            processLine.frame = CGRect(x:0  , y :self.bounds.height - 20, width : self.bounds.width , height : 20)
            let deleteButtonWH : CGFloat = 30
            let deleteBtnOffset:CGFloat = 2
            deleteButton.frame = CGRect(x: self.bounds.width - deleteButtonWH + deleteBtnOffset, y: -deleteBtnOffset, width: deleteButtonWH, height: deleteButtonWH)
        }
        @objc func deleteAction(sender:UIButton) {
            self.delegate?.deleteAction(item: self)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDAsset : NSObject{
        enum ActionType : String {
            case waitingForUpload
            case uploading
            case uploaded
            case failure
        }
        var asset = PHAsset()
        var process : CGFloat  = 0.0
        var showType : ActionType = .waitingForUpload{
            didSet{}
        }
        var canEdit = true
        
    }

    
}
