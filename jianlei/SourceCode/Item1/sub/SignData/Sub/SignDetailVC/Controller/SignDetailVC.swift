//
//  SignDetailVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class SignDetailVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let value = self.userInfo as? (SignDataType, String, String, String, String, String) {
            mylog(value)
            self.value = value
        }
        self.request()
        self.configUI()
        if let type = self.value?.0 {
            switch type {
            case .action1:
                self.naviBar.title = "chaoshiSign"|?|
            case .action2:
                self.naviBar.title = "weidabiao"|?|
            case .action3:
                self.naviBar.title = "weiqiandao"|?|
            case .action5:
                self.naviBar.title = "zhongping"|?|
            case .action6:
                self.naviBar.title = "chaping"|?|
            case .leave_early_number:
                self.naviBar.title = "zaotui"|?|
            default:
                break
            }
        }
        
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        
        // Do any additional setup after loading the view.
    }
    var signType  = DDBussinessNaviVC.SignType.bussiness
    ///类型团队id和时间,团队姓名，时间不同样式, 总人数
    var value: (SignDataType, String, String, String, String, String)?
    var dataArr: [SignDetailModel<SignDetailSubModel>] = [SignDetailModel<SignDetailSubModel>]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    func request() {
        let paramete = ["member_type": self.value?.0.rawValue ?? "", "token": DDAccount.share.token ?? "", "create_at": self.value?.2 ?? "", "team_id": self.value?.1 ?? ""]
        let router = Router.get("sign/get-view", .api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<SignDetailModel<SignDetailSubModel>>.deserialize(from: dict)
            if let data = model?.data {
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
        
        
    }
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize.init(width: SCREENWIDTH, height: 44)
        let width: CGFloat = SCREENWIDTH / 5.0
        flowLayout.itemSize = CGSize.init(width: width, height: width * 1.1)
        let collection = UICollectionView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.register(SignCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SignCollectionHeader")
        collection.register(SignCollectionType1Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SignCollectionType1Header")
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        collection.register(TeamDetailcell.self, forCellWithReuseIdentifier: "TeamDetailcell")
        collection.delegate = self
        collection.dataSource = self
        
        collection.backgroundColor = UIColor.white
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
extension SignDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamDetailcell", for: indexPath) as! TeamDetailcell
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
                let header: SignCollectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SignCollectionHeader", for: indexPath) as! SignCollectionHeader
                let model = self.dataArr[indexPath.section - 1]
                header.myTitleLabel?.text = model.team_name
                return header
            }
        }else {
            let footer: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            if indexPath.section == (self.dataArr.count) {
                footer.backgroundColor = UIColor.white
            }else {
                footer.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
            }
            
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: SCREENWIDTH, height: 160)
        }else {
            return CGSize.init(width: SCREENWIDTH, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: SCREENWIDTH, height: 0.01)
        }else {
            return CGSize.init(width: SCREENWIDTH, height: 10)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let modelData = self.dataArr[indexPath.section - 1]
        let subModel = modelData.items?[indexPath.item]
        let vc = DDPersonalSignVC()
        let model = DDFootprintVC.NotSignDataModel()
        let t = DDFootprintVC.NotSignPersonModel()
        t.avatar = subModel?.avatar
        t.name = subModel?.name
        model.memberName = t
        model.create_at = self.value?.4
        model.team_id = self.value?.1
        model.member_id = subModel?.member_id
        vc.paraModel = model
        vc.paraTeamName = self.value?.3 ?? ""
//        vc.signType = self.signType
        
        self.navigationController?.pushViewController(vc , animated: true )
    }
    
    
}
