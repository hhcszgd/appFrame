//
//  TeamDetailVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/9.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class TeamDetailVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        
        // Do any additional setup after loading the view.
    }
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "team_detail"|?|
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        
    }
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let width: CGFloat = SCREENWIDTH / 5.0
        flowLayout.itemSize = CGSize.init(width: width, height: width * 1.1)
        let collection = UICollectionView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.register(TeamDetailCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TeamDetailCollectionHeader")
        collection.register(TeamDetailcell.self, forCellWithReuseIdentifier: "TeamDetailcell")
        collection.register(TeamDetailFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "TeamDetailFooter")
        collection.delegate = self
        collection.dataSource = self
        
        collection.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        return collection
    }()
    var teamId: String = ""
    var teamNameStr: String = ""
    var dataArr: [TeamDetailMemberInfo] = [TeamDetailMemberInfo]() {
        didSet{
            self.collectionView.reloadData()
        }
    }
    var userMemberType: String = ""
    var data: TeamDetailModel<TeamDetailMemberInfo>?
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TeamDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestData()
    }
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
        if let paramete = self.userInfo as? [String: String] {
            self.teamId = paramete["id"] ?? ""
            self.teamNameStr = paramete["teamName"] ?? ""
        }
        
        
        
    }
    func requestData() {
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("sign/detail/\(self.teamId)", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let baseModel = BaseModel<TeamDetailModel<TeamDetailMemberInfo>>.deserialize(from: dict)
            if baseModel?.status == 200, let data = baseModel?.data {
                if let teamArr = data.members {
                    self.data = data
                    self.userMemberType = data.member_type ?? ""
                    self.dataArr = teamArr
                }
                
                
            }else {
                
            }
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamDetailcell", for: indexPath) as! TeamDetailcell
        let model = self.dataArr[indexPath.item]
        cell.teamModel = model
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TeamDetailCollectionHeader", for: indexPath) as! TeamDetailCollectionHeader
            header.teamModel = self.data
            header.tapBlock =  { [weak self] in
                self?.actionToChangeTeamName()
            }
            return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TeamDetailFooter", for: indexPath) as! TeamDetailFooter
            footer.teamID = self.teamId
            footer.switchBlick = { [weak self] in
                self?.requestData()
            }
            footer.isOn = (self.data?.sign_data_permission == "0") ? false : true
            return footer
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            //添加
            if self.userMemberType == "2" || self.userMemberType == "3" {
                self.pushVC(vcIdentifier: "AddTeamMemberVC", userInfo: self.teamId)
            }else {
                GDAlertView.alert("team_permission_no"|?|, image: nil, time: 1, complateBlock: nil)
            }
            
            
        }else if (indexPath.item == (self.dataArr.count - 1)) && (self.dataArr.count >= 2) {
            //移除
            if self.userMemberType == "2" || self.userMemberType == "3" {
                let targetVC = DeleteTemaMember()
                targetVC.teamID = self.teamId
                targetVC.userMemberID = self.data?.member_id ?? ""
                self.pushVC(vcIdentifier: "DeleteTemaMember", userInfo: self.teamId)
            }else {
                GDAlertView.alert("team_permission_no"|?|, image: nil, time: 1, complateBlock: nil)
            }
            
        }else {
            
            if self.data?.member_type == "3"{
                let model = self.dataArr[indexPath.item]
                
                var memberType = model.member_type ?? "1"
                if memberType == "3" {
                    GDAlertView.alert("team_noPermission_of_manager"|?|, image: nil, time: 1, complateBlock: nil)
                    return
                }
                if model.member_type == "1" {
                    memberType = "2"
                }else {
                    memberType = "1"
                }
                
                let paramete = ["token": DDAccount.share.token ?? "", "id": model.member_id ?? "", "team_id": self.teamId, "member_type": memberType]
                let router = Router.post("sign/set-principal", .api, paramete)
                let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                    let model = BaseModel<String>.deserialize(from: dict)
                    if model?.status == 200 {
                        self.requestData()
                        
                        GDAlertView.alert((memberType == "2") ? "team_set_manger"|?|: "team_cancle_manager"|?|, image: nil, time: 1, complateBlock: nil)
                    }else {
                        GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                    }
                    
                }, onError: { (error) in
                    
                }, onCompleted: {
                    mylog("结束")
                }) {
                    mylog("回收")
                }
            }else {
                GDAlertView.alert("team_nomanager_noPermission"|?|, image: nil, time: 1, complateBlock: nil)
            }
            
            
            
            
        
        }
        
        
        
    }
    func actionToChangeTeamName() {
        self.pushVC(vcIdentifier: "ChangeTeamName", userInfo: ["teamName": self.data?.team_name ?? "", "id": self.teamId])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREENWIDTH, height: 237)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREENWIDTH, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 2, left: 0, bottom: 10, right: 0)
    }
    
    
    
}
