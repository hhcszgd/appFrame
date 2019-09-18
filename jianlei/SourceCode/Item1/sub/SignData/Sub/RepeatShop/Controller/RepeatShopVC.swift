//
//  RepeatShopVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/16.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class RepeatShopVC: DDInternalVC {
    var signType  = DDBussinessNaviVC.SignType.bussiness
    override func viewDidLoad() {
        super.viewDidLoad()
        if let value = self.userInfo as? (SignDataType, String, String, String, String, String) {
            mylog(value)
            self.value = value
        }
        self.request()
        self.configUI()
    
        // Do any additional setup after loading the view.
    }
    var dataArr: [ReapeatSubModel<ReapeatSubSubModel>] = [ReapeatSubModel<ReapeatSubSubModel>]() {
        didSet{
            self.collectionView.reloadData()
        }
    }
    ///类型团队id和时间,团队姓名，时间不同样式, 总人数
    var value: (SignDataType, String, String, String, String, String)?
    func request() {
        let paramete = ["token": DDAccount.share.token ?? "", "create_at": self.value?.2 ?? "", "team_id": self.value?.1 ?? ""]
        let router = Router.get("sign/repeat-shops", .api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<ReapeatModel<ReapeatSubModel<ReapeatSubSubModel>>>.deserialize(from: dict)
            if let data = model?.data?.item {
                self.dataArr = data
            }else {
                
            }
            
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "repeat_shop_num"|?|
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        
    }
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize.init(width: SCREENWIDTH, height: 44)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 1, left: 0, bottom: 10, right: 0)
        let width: CGFloat = SCREENWIDTH
        flowLayout.itemSize = CGSize.init(width: width, height: 115)
        let collection = UICollectionView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.register(SignCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SignCollectionHeader")
        collection.register(SignCollectionType1Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SignCollectionType1Header")
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        collection.register(UINib.init(nibName: "RepeatShopCell", bundle: Bundle.main), forCellWithReuseIdentifier: "RepeatShopCell")
        collection.delegate = self
        collection.dataSource = self
        
        collection.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        return collection
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RepeatShopVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func configUI() {
        self.collectionView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            self.collectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArr.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else {
            let model = self.dataArr[section - 1]
            return model.items?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepeatShopCell", for: indexPath) as! RepeatShopCell
        let model = self.dataArr[indexPath.section - 1]
        let subModel = model.items?[indexPath.item]
        cell.model = subModel
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                let header: SignCollectionType1Header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SignCollectionType1Header", for: indexPath) as! SignCollectionType1Header
                header.value = self.value
                return header
            }else {
                let model = self.dataArr[indexPath.section - 1]
                let header: SignCollectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SignCollectionHeader", for: indexPath) as! SignCollectionHeader
                header.myTitleLabel?.text = model.shop_name
                return header
            }
        }else {
            let footer: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: SCREENWIDTH, height: 145)
        }else {
            return CGSize.init(width: SCREENWIDTH, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREENWIDTH, height: 0.01)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.section - 1]
        let subModel = model.items?[indexPath.item]
        let vc = DDBussinessSignDetailVC()
        let personalModel = PersonalSignRowModel()
        personalModel.id = subModel?.id ?? ""
        vc.paraModel = personalModel
        vc.paraMember_id = subModel?.member_id ?? ""
        self.navigationController?.pushViewController(vc , animated: true)

    }
    
}
