//
//  DDShopMediaManageVC.swift
//  Project
//
//  Created by WY on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DDShopMediaManageVC: UICollectionViewController {

//    var collection : UICollectionView?
    var apiModel : ApiModel<[DDShopMediaPublishModel]>?
    let topLabel = UILabel()
    var tempShopID = "6"
    ///2:总店 , 1:非总店
    var shopType = "6"
    let bottomButton = UIButton()
    let addButton = UIButton()
    var blankView : DDShopMediaEditStatusView? = DDShopMediaEditStatusView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "素材管理"
        configNaviBar()
        if let shopID = self.userInfo as? String{
            self.tempShopID = shopID
        }
        configCollectionView()
//        self.congitGesture()
        configFloatButton()
        if #available(iOS 11.0, *) {
            self.collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
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
        DDRequestManager.share.showHasBeenUploadMedias(type: ApiModel<[DDShopMediaPublishModel]>.self, shop_id: tempShopID,success: { (apiModel) in
            
            self.apiModel = apiModel
            self.collectionView?.reloadData()
        })
        
        
//        DDRequestManager.share.showHasBeenUploadMedias(shop_id: tempShopID , type:shopType)?.responseJSON(completionHandler: { (response ) in
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<[DDShopMediaPublishModel]>.self, from: response){
//                self.apiModel = apiModel
//                self.collectionView?.reloadData()
//            }
//        })
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
extension DDShopMediaManageVC{
    func selectMedia()  {
        let selectMediaVC = DDShopMediaSelectVC()
        selectMediaVC.userInfo = self.apiModel?.data?.count ?? 0// 服务器已有图片数量
        selectMediaVC.tempShopID = self.tempShopID
        self.navigationController?.pushViewController(selectMediaVC, animated: true)
    }
    func configNaviBar() {
        let editBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        editBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        //        editBtn.setImage(UIImage.init(named: "history"), for: UIControl.State.normal)
        editBtn.setTitle("编辑", for: UIControl.State.normal)
        editBtn.setTitle("完成", for: UIControl.State.selected)
        editBtn.backgroundColor = UIColor.clear
        editBtn.addTarget(self, action: #selector(editAction(sender:)), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        
    }
    
    func configFloatButton() {
        self.view.addSubview(addButton)
        addButton.frame = CGRect(x: self.view.bounds.width - 72, y: self.view.bounds.height * 0.7, width: 64, height: 64)
        //        addButton.backgroundColor = .orange
        addButton.setImage(UIImage(named:"add"), for: UIControl.State.normal)
        addButton.layer.cornerRadius = addButton.bounds.height/2
        addButton.layer.masksToBounds = true
        addButton.addTarget(self , action: #selector(addAction(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func addAction(sender:UIButton)  {
        self.selectMedia()
    }
    @objc func editAction(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        self.bottomButton.isHidden = sender.isSelected
        self.addButton.isHidden = sender.isSelected
        self.collectionView?.reloadData()
        if !sender.isSelected{
            if let a = self.apiModel?.data , let json = DDJsonCode.encode(a){
//                DDRequestManager.share.manageShopAdMedia(shop_id: tempShopID, sort_json: json , type : shopType)
                
                DDRequestManager.share.manageShopAdMedia(type: ApiModel<String>.self, shop_id: self.tempShopID, sort_json: json, success: { (apiModel ) in
                    
                })
                if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton {
                    if a.count <= 0{
                        editButton.isHidden = true
                    }else{editButton.isHidden = true }
                }
            }
        }
        mylog("edit")
    }
    @objc func releaseShopMedia(sender:UIButton)  {
        DDRequestManager.share.releaseShopMedia(type: ApiModel<String>.self, shop_id: tempShopID,ttype:self.shopType,success: { (apiModel ) in
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
//                    //                    self.bottomButton.backgroundColor = UIColor.gray(0.6)
//                    //                    self.bottomButton.isEnabled = false
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
        topLabel.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: 32)
        topLabel.text = "点击编辑可删除素材或调整素材顺序"
        topLabel.textAlignment = .center
        topLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        topLabel.textColor = .white
        self.view.addSubview(bottomButton)
        bottomButton.setTitle("投放到屏幕", for: UIControl.State.normal)
        self.bottomButton.setTitle("已投放", for: UIControl.State.disabled)
        self.bottomButton.isEnabled = false
        self.bottomButton.backgroundColor = UIColor.lightGray
        bottomButton.addTarget(self , action: #selector(releaseShopMedia(sender:)), for: UIControl.Event.touchUpInside)
        //        bottomButton.backgroundColor = .orange
        let bottomButtonX : CGFloat = 0
        bottomButton.frame = CGRect(x: bottomButtonX, y: self.view.bounds.height - DDSliderHeight - 64, width: self.view.bounds.width - bottomButtonX * 2, height: 64)
        
        let toBorderMargin :CGFloat  = 10
        let itemMargin  : CGFloat = 10
        let itemCountOneRow = 3
        
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.bounces = true
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = .white
        collectionView?.frame =  CGRect(x: bottomButtonX, y: SCREENHEIGHT - DDSliderHeight - 64, width: SCREENHEIGHT - bottomButtonX * 2, height: 64)
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.minimumLineSpacing = itemMargin
            flowLayout.minimumInteritemSpacing = itemMargin
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: toBorderMargin, bottom: 0, right: toBorderMargin)
            let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow)) / CGFloat(itemCountOneRow)
            let itemH = itemW
            flowLayout.itemSize = CGSize(width: itemW, height: itemH)
            flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        }
        //        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
//        let temp = UICollectionView.init(frame: CGRect(x: 0, y:  topLabel.frame.maxY , width: self.view.bounds.width, height: bottomButton.frame.minY - topLabel.frame.maxY ), collectionViewLayout: flowLayout)
//        self.collectionView = temp
//        self.view.addSubview(temp)
        collectionView?.register(DDShopMediaPublishItem.self , forCellWithReuseIdentifier: "DDShopMediaPublishItem")
        //        collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
        //        collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")

        
        //        self.view.addSubview(blankView)
        //        blankView.isHidden = true
        //        blankView.frame = self.view.bounds
        blankView?.action = {[weak self ] in
            self?.selectMedia()
        }
    }
    
}





extension DDShopMediaManageVC : DDItemDeleteActionDelegate {
    func deleteAction(item: UICollectionViewCell) {
        if let index = self.collectionView?.indexPath(for: item){
            self.apiModel?.data?.remove(at: index.item)
            self.collectionView?.reloadData()
        }
    }
}





extension DDShopMediaManageVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath)
        if let item = collectionView.cellForItem(at: indexPath) as? DDShopMediaPublishItem{
            if let image = item.imageView.image{
                let alert = DDShopMediaReview()
                alert.imageview.setBackgroundImage(image, for: UIControl.State.normal)
                UIApplication.shared.keyWindow?.alert(alert)
            }
        }
        
    }
    ///1 : 有图 , 2 : 编辑状态下无图 ,3 : 非编辑状态下无图
    func switchAddViewStatus(status:Int  )  {
        
        mylog("上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上上")
        if status == 1{//有图片
            blankView?.isHidden = true
            self.addButton.isHidden = false
        }else{
            mylog("looOoossssosososososososososososososososososoososo")
            if let blankview = blankView , blankview.superview == nil {
                self.view.addSubview(blankview)
                blankview.frame = self.view.bounds
            }
            blankView?.isHidden = false
            self.addButton.isHidden = true
            blankView?.status = status
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.apiModel?.data?.count ?? 0
        judgeStatus()
        
        if count > 0 {
            switchAddViewStatus(status: 1)
            if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton{
                self.topLabel.isHidden = false
                editButton.isHidden = false
                if editButton.isSelected{
                    mylog("可编辑")
                    self.bottomButton.isHidden = true
                }else{self.bottomButton.isHidden = false}
            }
            
            
        }else{
            
            self.bottomButton.isHidden = true
            self.topLabel.isHidden = true
            if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton {
                if editButton.isSelected{
                    editButton.isHidden = false
                    switchAddViewStatus(status: 2)
                }else{
                    editButton.isHidden = true
                    switchAddViewStatus(status: 3)
                }
            }
        }
        return count//  apiModel?.data?.count ?? 0
    }
    func judgeStatus() {
        self.bottomButton.backgroundColor = UIColor.lightGray
        self.bottomButton.isEnabled = false
        for model  in self.apiModel?.data ?? [] {
            if model.status == "0" , !self.bottomButton.isEnabled{//存在未发布的
                self.bottomButton.backgroundColor = UIColor.orange
                self.bottomButton.isEnabled = true
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "DDShopMediaPublishItem", for: indexPath)
        if let itemUnwrap = item as? DDShopMediaPublishItem , let model = self.apiModel?.data?[indexPath.row]{
            if model.status == "0" , !self.bottomButton.isEnabled{//存在未发布的
                self.bottomButton.backgroundColor = UIColor.orange
                self.bottomButton.isEnabled = true
            }
            itemUnwrap.model = model
            itemUnwrap.delegate = self
            if let editButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton , editButton.isSelected{
                mylog("可编辑")
                itemUnwrap.deleteButton.isHidden = false
            }else{itemUnwrap.deleteButton.isHidden = true}
            
        }
        //        item.backgroundColor = UIColor.randomColor()
        return item
    }
    
    
    
    
    
    
    
    
    
    ////
    /// core method about moveing item
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("invoke after moved , deal dataSource at here ")
        mylog("sourceIndexPath: \(sourceIndexPath) , sourceIndexPath: \(destinationIndexPath)")
//        self.apiModel?.data?.swapAt(sourceIndexPath.item, destinationIndexPath.item)
        if let sourceItemModel = self.apiModel?.data?.remove(at: sourceIndexPath.item){
            self.apiModel?.data?.insert(sourceItemModel, at: destinationIndexPath.item)
            
        }
        
        collectionView.reloadData()
    }
    
    
}


