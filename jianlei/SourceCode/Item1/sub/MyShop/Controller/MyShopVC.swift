//
//  MyShopVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/1.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage

enum ShopStatus: String {
    case 待审核 = "待审核"
    case 待安装 = "待安装"
    case 被驳回 = "被驳回"
    case 安装完成 = "安装完成"
}

class MyShopVC: DDInternalVC, UICollectionViewDelegate, UICollectionViewDataSource, ShopGuangGaoCellDelegate, ShopIndxThreeCellDelegate, ShopScreenInfoViewDelegate {
    
    
//    var selectAddressView: MyShopAddressView?
    var myCollectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout?
    let subView: MyshopSubView = MyshopSubView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 40))
    var addressArr: [ScreensModel] = []
    var shopModel: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>?
    var zongDianData: ShopZongDianInfo<ShopInfoModel, FendianList>?
    let shopImageView: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 200))
    lazy var effect: UIVisualEffectView = {
        let blur = UIBlurEffect.init(style: UIBlurEffect.Style.dark)
        
        let effectView = UIVisualEffectView.init(effect: blur)
        effectView.alpha = 0.1
        effectView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        
        return effectView
    }()
    var isFirst: Bool = true
    let shopHeader = ShopTopHeaderView.init(frame: CGRect.init(x: 20, y: DDNavigationBarHeight + 3, width: SCREENWIDTH - 40, height: (SCREENWIDTH - 40) * 0.29))
    ///控制器类型总店1，分店2
    var vcType: String = "1"
    var shopID: String = ""
    var cover: DDCoverView?
    override func viewDidLoad() {
        super.viewDidLoad()
        mylog(self.userInfo)
        if let dict = self.userInfo as? [String: String?], let shopID = dict["shopID"] as? String, let type = dict["type"] as? String {
            self.vcType = type
            self.shopID = shopID
        }
        NotificationCenter.default.addObserver(self, selector: #selector(enditFendian(userInfo:)), name: NSNotification.Name.init("MyshopEditFendian"), object: nil)
        self.configCollection()
    }
    @objc func enditFendian(userInfo: Notification) {
        if let dict = userInfo.userInfo, let model = dict["model"] as? FendianList {
            let vc = AddShopInfoVC()
            vc.funcationType = "edit"
            vc.userInfo = self.shopID
            vc.fendianModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.request(shopID: nil)
    }
    
    func evaluateWeihu(info: AnyObject?) {
        ///跳转到评价详情
        self.pushVC(vcIdentifier: "FuwuPingJiaVC", userInfo: self.shopModel?.shop?.maintain?.sign_id)
    }
    
    func evaluateListWeihu(info: AnyObject?) {
        ///跳转到评价列表
        self.pushVC(vcIdentifier: "WeiHuListVC", userInfo: self.shopID)
        
    }
    
    
    var shopCount: Int = 0
    func uploadUI() {
        mylog("更新")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopGuangGaoCell", for: indexPath) as! ShopGuangGaoCell
            cell.delegate = self
            if self.zongDianData != nil {
                cell.zongDianData = self.zongDianData
            }else {
                cell.shopModel = self.shopModel
            }

            return cell

        }else
        if indexPath.item == 1{
            if self.vcType == "1" {
                //总店
                let cell: ShopIndexTwoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopIndexTwoCell", for: indexPath) as! ShopIndexTwoCell
                cell.zongDianData = self.zongDianData
                
                return cell
            }else {
                //分店
                let cell: ShopIndexFenTwoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopIndexFenTwoCell", for: indexPath) as! ShopIndexFenTwoCell
                cell.targetView?.mydelegate = self
                cell.model = self.shopModel
                return cell
            }
            
        }else if indexPath.item == 2 {
            if self.vcType == "1" {
                //总店
                let cell: ShopIndxThreeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopIndxThreeCell", for: indexPath) as! ShopIndxThreeCell
                cell.delegate = self

                cell.shopID = self.shopID
                return cell
            }else {
                //分店
                let cell: ShopIndexFenThreeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopIndexFenThreeCell", for: indexPath) as! ShopIndexFenThreeCell
                cell.model = self.shopModel
                return cell
            }
        }
        return UICollectionViewCell.init()
    }
    func showAlertView() {
        let width = (280 / 375.0) * SCREENWIDTH
        let height = 0.5 * width
        let alertView = ShopAlertViewType1.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        alertView.center = CGPoint.init(x: SCREENWIDTH / 2.0, y: SCREENHEIGHT / 2.0)
        let cover = DDCoverView.init(superView: self.view)
        alertView.clickBlock = {
            cover.remove()
        }
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cover.addSubview(alertView)
        
    }
    
    
    ///编辑上传图片
    func editUploadPicture() {
//        self.pushVC(vcIdentifier: "PhotoManagerVC", userInfo: nil)
        if self.shopModel?.shop?.agreed == "0" {
            self.showAlertView()
            return
            
        }
        if self.zongDianData?.shop_info?.agreed == "0" {
            self.showAlertView()
            return
        }
        
//        
        let v = DDShopMediaPublishVC()
//        let v = DDShopMediaManageVC.init(collectionViewLayout: UICollectionViewFlowLayout())
        v.tempShopID = self.shopID
        v.shopType = self.vcType == "1" ? "2" : "1"
        self.navigationController?.pushViewController(v , animated: true )
    }
    ///添加分店
    func addFenDian() {
        let vc = AddShopInfoVC()
        vc.funcationType = "add"
        vc.userInfo = self.shopID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func applyInstallAction(_ sender: UIButton) {
        
        self.pushVC(vcIdentifier: "LEDApplicationVC", userInfo: DomainType.wap.rawValue +  "shop/create?type=dianpu")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / (SCREENWIDTH))
        if index == 0 {
            self.subView.guangGaoAction(self.subView.shopGuangGao)

        }else if (index == 1) {
            self.subView.screenInfoAction(self.subView.screenInfo)

        }else if (index == 2) {
            self.subView.shopInfoAction(self.subView.shopInfo)
        }
//        if index == 0 {
//            self.subView.screenInfoAction(self.subView.screenInfo)
//
//        }else if (index == 1) {
//            self.subView.shopInfoAction(self.subView.shopInfo)
//
//        }
    }
    deinit {
        mylog("习奥会")
        NotificationCenter.default.removeObserver(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MyShopVC: ShopTopHeaderViewDelegate {
    
    ///协议
    @objc func xiyiAction() {
        if self.vcType == "1" {
            if let url = self.zongDianData?.shop_info?.agreement_name {
                self.pushVC(vcIdentifier: "BaseWebVC", userInfo: url)
                mylog(url)
            }
        }else {
            if let url = self.shopModel?.shop?.agreement_name {
                self.pushVC(vcIdentifier: "BaseWebVC", userInfo: url)
                mylog(url)
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
 
    @objc func naviBarBtn(sender: UIButton) {
        let paramete = ["type": self.vcType, "shopID": self.shopID]
        //TODO:跳转
        if self.vcType == "2" {
            if self.shopModel?.shop?.reward_agreed == "0" {
                let alertView = MyShopImageUploadProtocol.init(frame: CGRect.init(x: 40, y: DDNavigationBarHeight + 20 , width: SCREENWIDTH - 80, height: SCREENHEIGHT - DDNavigationBarHeight - 20 - DDSliderHeight - 80), url: DomainType.wap.rawValue + "shop/reward-agreed" + "?token=\(DDAccount.share.token ?? "")", type: self.vcType, shopId: self.shopID, title: "扫码协议")
                self.cover = DDCoverView.init(superView: self.view)
                self.cover?.addSubview(alertView)
                self.cover?.deinitHandle = {[weak self] in
                    self?.cover = nil
                    
                }
                alertView.clickBlock = { [weak self] (bo) in
                    if bo {
                        self?.shopModel?.shop?.reward_agreed = "1"
                        self?.pushVC(vcIdentifier: "BoundtyVC", userInfo: paramete)
                    }else {
                        
                    }
                    self?.cover?.removeFromSuperview()
                    self?.cover = nil
                    
                }
                
            }else{
                self.pushVC(vcIdentifier: "BoundtyVC", userInfo: paramete)
            }
        }
        if self.vcType == "1" {
            if self.zongDianData?.shop_info?.reward_agreed == "0" {
                let alertView = MyShopImageUploadProtocol.init(frame: CGRect.init(x: 40, y: DDNavigationBarHeight + 20 , width: SCREENWIDTH - 80, height: SCREENHEIGHT - DDNavigationBarHeight - 20 - DDSliderHeight - 80), url: DomainType.wap.rawValue + "shop/reward-agreed" + "?token=\(DDAccount.share.token ?? "")", type: self.vcType, shopId: self.shopID, title: "扫码协议")
                self.cover = DDCoverView.init(superView: self.view)
                self.cover?.addSubview(alertView)
                alertView.clickBlock = { [weak self] (bo) in
                    if bo {
                        self?.zongDianData?.shop_info?.reward_agreed = "1"
                        self?.pushVC(vcIdentifier: "BoundtyVC", userInfo: paramete)
                    }else {
                        
                    }
                    self?.cover?.removeFromSuperview()
                    self?.cover = nil
                    
                }
                self.cover?.deinitHandle = {[weak self] in
                    self?.cover = nil
                    
                }
                
            }else {
                self.pushVC(vcIdentifier: "BoundtyVC", userInfo: paramete)
            }
            
        }
        
        
      
        
        
        
        
        
    }
    
    func configCollection() {
        //背景色
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        //设置导航栏
        self.naviBar.attributeTitle = NSMutableAttributedString.init(string: "shopTitle"|?|, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.naviBar.backBtn.setImage(UIImage.init(named: "return_white"), for: UIControl.State.normal)
        self.naviBar.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.shopImageView)
        self.shopImageView.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: (SCREENWIDTH - 40) * 0.29 + DDNavigationBarHeight + 3 + 20)
        self.shopImageView.image = UIImage.init(named: "myshop_bg")
        
        let rightBtn = UIButton.init()
        rightBtn.setImage(UIImage.init(named: "Viewprotocol"), for: UIControl.State.normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        rightBtn.addTarget(self, action: #selector(xiyiAction), for: UIControl.Event.touchUpInside)
        self.naviBar.rightBarButtons = [rightBtn]
        
        //布局header
        
        self.view.addSubview(self.shopHeader)
        self.shopHeader.delegate = self
        self.shopHeader.tyep = self.vcType
        
        
        self.subView.frame = CGRect.init(x: 15, y: self.shopImageView.max_Y - 22.5, width: SCREENWIDTH - 30, height: 45 * SCALE)
        self.subView.layer.cornerRadius = 10
        self.subView.layer.masksToBounds = true
        //默认显示分店，如果是1则是总店
        if self.vcType == "1" {
            self.subView.screenInfo.setTitle("shop_qianyueHeader"|?|, for: UIControl.State.normal)
            self.subView.shopInfo.setTitle("shop_fendian_list"|?|, for: UIControl.State.normal)
        }

        self.view.addSubview(self.subView)
        self.subView.clickBlock = { [weak self] (index) in
            self?.myCollectionView?.scrollToItem(at: IndexPath.init(item: index - 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)

        }
        

        self.flowLayout = UICollectionViewFlowLayout.init()
        self.myCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: self.subView.max_Y + 13, width: SCREENWIDTH, height: SCREENHEIGHT - self.subView.max_Y - 13), collectionViewLayout: self.flowLayout!)
        self.view.addSubview(self.myCollectionView!)
        if #available(iOS 10.0, *) {
            self.myCollectionView?.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }

        self.myCollectionView?.register(ShopIndexTwoCell.self, forCellWithReuseIdentifier: "ShopIndexTwoCell")
        self.myCollectionView?.register(ShopIndexFenTwoCell.self, forCellWithReuseIdentifier: "ShopIndexFenTwoCell")
        self.myCollectionView?.register(ShopGuangGaoCell.self, forCellWithReuseIdentifier: "ShopGuangGaoCell")
        self.myCollectionView?.register(ShopIndxThreeCell.self, forCellWithReuseIdentifier: "ShopIndxThreeCell")
        self.myCollectionView?.register(ShopIndexFenThreeCell.self, forCellWithReuseIdentifier: "ShopIndexFenThreeCell")
        self.flowLayout?.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let itemsWidth: CGFloat = SCREENWIDTH
        let itemsHeight: CGFloat = (self.myCollectionView?.height)!
        self.flowLayout?.itemSize = CGSize.init(width: itemsWidth, height: itemsHeight)
        self.myCollectionView?.bounces = false
        self.myCollectionView?.delegate = self
        self.myCollectionView?.dataSource = self
        self.flowLayout?.minimumLineSpacing = 0
        self.flowLayout?.minimumInteritemSpacing = 0
        self.myCollectionView?.isPagingEnabled = true
        self.isFirst = false
    }
    
    
   
    func request(shopID: String?) {
        let token = DDAccount.share.token ?? ""
        let memberID = DDAccount.share.id ?? ""
        var paramete: [String: String] = ["token": token]
        if vcType == "2" {
            paramete["shop_id"] = self.shopID
        }
        
        let url = (self.vcType == "1") ? "my-shop/detail/\(self.shopID)" : "member/\(memberID)/myshop"
        let _ = NetWork.manager.requestData(router: Router.get(url, .api, paramete)).subscribe(onNext: { (dict) in
            
            if self.vcType == "1" {
                let model = BaseModel<ShopZongDianInfo<ShopInfoModel, FendianList>>.deserialize(from: dict)
                if let data = model?.data {
                    self.zongDianData = data
                    self.myCollectionView?.reloadData()
                    self.shopHeader.configWithInfo(image: self.zongDianData?.shop_info?.head_image ?? "", name: self.zongDianData?.shop_info?.company_name ?? "", status: self.zongDianData?.shop_info?.examine_status ?? "", screenStatus: "")
                }
                
                
            }else {
                let model = BaseModel<ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>>.deserialize(from: dict)
                
                if let data = model?.data {
                    self.shopModel = data
                    
                    self.myCollectionView?.reloadData()
                    if let _ = self.shopModel?.item?.first, let arr = self.shopModel?.item, arr.count > 0 {
                        if shopID == nil {
                            self.addressArr = arr
                            self.shopCount = arr.count
                            UserDefaults.standard.setValue(self.shopCount, forKey: "ShopCount")
                        }
                    }
                    self.shopHeader.configWithInfo(image: (self.shopModel?.shop?.shopImage ?? "") + "?imageView2/0/h/400" , name: self.shopModel?.shop?.name ?? "", status: (self.shopModel?.shop?.status ?? ""), screenStatus: (self.shopModel?.shop?.screenStatus ?? ""))
                
                
                
            }
            
                
                
                
               
                
                self.uploadUI()
            }
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
}


class MyshopSubView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.shopGuangGao)
        self.addSubview(self.screenInfo)
        self.addSubview(self.shopInfo)
    
        let line1 = UIView.init()
        line1.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        
        let line2 = UIView.init()
        line2.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
//
        self.addSubview(line1)
        self.addSubview(line2)
        self.shopGuangGao.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
            make.height.equalTo(frame.height - 10)
            make.width.equalTo(self.screenInfo.snp.width).multipliedBy(0.85)
            make.right.equalTo(line1.snp.left)
        }
        line1.snp.makeConstraints { (make) in
            make.height.equalTo(frame.height / 2.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(2)
        }
        
        
        self.screenInfo.snp.makeConstraints { (make) in
            make.left.equalTo(line1.snp.right)
            make.centerY.equalToSuperview()
            make.height.equalTo(frame.height - 10)
            make.right.equalTo(line2.snp.left)
//            make.left.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.height.equalTo(frame.height - 10)
//            make.width.equalTo(self.shopInfo.snp.width)
//            make.right.equalTo(line2.snp.left)
        }
        line2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(frame.height / 2.0)
            make.width.equalTo(2)
        }
//        self.shopInfo.snp.makeConstraints { (make) in
//            make.left.equalTo(line2.snp.right)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(frame.height - 10)
//            make.right.equalToSuperview()
//
//        }
        self.shopInfo.snp.makeConstraints { (make) in
            make.left.equalTo(line2.snp.right)
            make.centerY.equalToSuperview()
            make.height.equalTo(frame.height - 10)
            make.right.equalToSuperview().offset(-30)
            make.width.equalTo(self.screenInfo.snp.width).multipliedBy(0.85)
        }
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.shopGuangGao.snp.centerX)
            make.bottom.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(3.5)
        }
        
        self.addSubview(self.lineView2)
        self.lineView2.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.screenInfo.snp.centerX)
            make.bottom.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(3.5)
        }

        self.addSubview(self.lineView3)
        self.lineView3.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.shopInfo.snp.centerX)
            make.bottom.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(3.5)
        }
        self.lineView.isHidden = true
        self.lineView2.isHidden = true
        self.lineView3.isHidden = true
        
        self.shopGuangGao.setTitle("shopHeader_shop_storeAdvertising"|?|, for: UIControl.State.normal)
        self.shopGuangGao.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        self.shopGuangGao.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        self.shopGuangGao.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        
        
        self.screenInfo.setTitle("screenInfo"|?|, for: UIControl.State.normal)
        self.screenInfo.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        self.screenInfo.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        self.screenInfo.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        
        self.shopInfo.setTitle("shopInfo"|?|, for: UIControl.State.normal)
        self.shopInfo.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        self.shopInfo.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        self.shopInfo.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        
        self.shopGuangGao.addTarget(self, action: #selector(guangGaoAction(_:)), for: UIControl.Event.touchUpInside)
        self.screenInfo.addTarget(self, action: #selector(screenInfoAction(_:)), for: UIControl.Event.touchUpInside)
        self.shopInfo.addTarget(self, action: #selector(shopInfoAction(_:)), for: UIControl.Event.touchUpInside)
        
//        self.screenInfoAction(self.screenInfo)
        self.guangGaoAction(self.shopGuangGao)
    }
    lazy var lineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1.75
        return view
    }()
    lazy var lineView2: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1.75
        return view
    }()
    lazy var lineView3: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1.75
        return view
    }()
    @objc func shopInfoAction(_ sender: UIButton) {
        self.lineView3.isHidden = false
        sender.isSelected = true
        self.lineView.isHidden = true
        self.lineView2.isHidden = true
        self.screenInfo.isSelected = false
        self.shopGuangGao.isSelected = false
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.screenInfo.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.shopGuangGao.titleLabel?.font = UIFont.systemFont(ofSize: 15)
       self.clickBlock?(3)
        
    }
    @objc func guangGaoAction(_ sender: UIButton) {
        self.lineView.isHidden = false
        sender.isSelected = true
        self.lineView3.isHidden = true
        self.lineView2.isHidden = true
        
        self.shopInfo.isSelected = false
        self.screenInfo.isSelected = false
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.shopInfo.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.screenInfo.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.clickBlock?(1)
    
    }
    
    @objc func screenInfoAction(_ sender: UIButton) {
        self.lineView2.isHidden = false
        sender.isSelected = true
        self.lineView.isHidden = true
        self.lineView3.isHidden = true
        self.shopGuangGao.isSelected = false
        self.shopInfo.isSelected = false
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.shopInfo.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.shopGuangGao.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.clickBlock?(2)
        
        
    }
    var clickBlock: ((Int) -> ())?
    
    
    
    
    let shopInfo: UIButton = UIButton.init()
    let screenInfo: UIButton = UIButton.init()
    let shopGuangGao: UIButton = UIButton.init()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MyShopImageUploadProtocol: UIView {
    init(frame: CGRect, url: String, type: String, shopId: String, title: String) {
        super.init(frame: frame)
    
        let titleView = self.configTuPianGuiFan(title: title, isHidden: true)
        self.addSubview(titleView)
        titleView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: 46 * SCALE)
        let lineView = UIView.init()
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
            make.height.equalTo(1)
        }
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")



        self.addSubview(self.webView)
        self.backgroundColor = UIColor.white
        self.webView.frame = CGRect.init(x: 0, y: 46 * SCALE + 1, width: frame.width, height: frame.height - 46 * SCALE - 1 - 44)
        mylog(url)
        let cc = URL.init(string: url)
        if let myUrl = cc {
            let request = URLRequest.init(url: myUrl)
            self.webView.loadRequest(request)
        }
        self.shopID = shopId
        if type == "1" {
            self.type = "2"
        }else {
            self.type = "1"
        }
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: self.webView.max_Y, width: frame.width, height: 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        self.layer.addSublayer(gradientLayer)
        
        self.addSubview(self.cancle)
        self.addSubview(self.sureBtn)
        self.cancle.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        self.sureBtn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        self.cancle.setTitle("cancel"|?|, for: UIControl.State.normal)
        self.sureBtn.setTitle("sure"|?|, for: UIControl.State.normal)
        self.cancle.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.sureBtn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.cancle.setTitleColor(UIColor.colorWithHexStringSwift("fac7b9"), for: UIControl.State.normal)
        self.sureBtn.setTitleColor(UIColor.colorWithHexStringSwift("ffffff"), for: UIControl.State.normal)
        
        self.cancle.frame = CGRect.init(x: 0, y: self.webView.max_Y, width: frame.width / 2.0, height: 44)
        self.sureBtn.frame = CGRect.init(x: self.cancle.max_X, y: self.webView.max_Y, width: frame.width / 2.0, height: 44)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
       
        
        
        
        
    }
    
    func configTuPianGuiFan(title: String, isHidden: Bool = true) -> UIView {
        let contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        
        let imageView = UIView.init()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
        imageView.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: title)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.sizeToFit()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        
        
        
        
        return contentView
        
    }
    
    var type: String = "1"
    var shopID: String = ""
    var clickBlock: ((Bool) -> ())?
    
    @objc func btnClick(btn: UIButton) {
        if btn == self.cancle {
            self.clickBlock?(false)
        }else {
            let token = DDAccount.share.token ?? ""
            let paramete = ["shop_id": self.shopID, "shop_type": self.type, "agreed": "1", "token": token]
            let router = Router.post("shop/agree-reward", DomainType.api, paramete)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                let model = BaseModel<GDModel>.deserialize(from: dict)
                if model?.status == 200 {
                    self.clickBlock?(true)
                }else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }, onError: { (error) in
                
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
            
        }
        
        
        
        
    }
    
    let webView = UIWebView.init()
    
    let cancle: UIButton = UIButton.init()
    let sureBtn: UIButton = UIButton.init()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





