//
//  SignDataVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/14.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class SignDataVC: DDInternalVC, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let paramete = self.userInfo as? [String: String], let teamID = paramete["teamID"], let memberType = paramete["memberType"], let teamType = paramete["teamType"]  {
            //如果是管理员则正常显示
            self.teamID = teamID;
            self.memberType = memberType
            self.teamType = teamType
            //如果是负责人则只显示对应的团队
        }
        
        self.configUI()
        // Do any additional setup after loading the view.
    }
    var teamID: String = ""
    var teamType: String = ""
    var memberType: String = ""
    
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "signData"|?|
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight + 44, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight - 44), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.itemSize = CGSize.init(width: collection.width, height: collection.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collection.register(SignBussinessCell.self, forCellWithReuseIdentifier: "SignBussinessCell")
        collection.register(SignRepairCell.self, forCellWithReuseIdentifier: "SignRepairCell")
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.delegate = self
        return collection
    }()
    lazy var bussinessBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("business"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var repairBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("repaire"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.selected)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: UIControl.Event.touchUpInside)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        mylog("销毁、、、、、")
    }

}
extension SignDataVC {
    func configUI() {
        
        self.view.addSubview(self.bussinessBtn)
        self.view.addSubview(self.repairBtn)
        self.bussinessBtn.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH / 2.0, height: 44)
        self.repairBtn.frame = CGRect.init(x: self.bussinessBtn.max_X, y: DDNavigationBarHeight, width: SCREENWIDTH / 2.0, height: 44)
        
        
        
        
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.lineView2)
        self.lineView.snp.updateConstraints { (make) in
            make.width.equalTo(75)
            make.height.equalTo(3.5)
            make.centerX.equalTo(self.bussinessBtn.snp.centerX)
            make.bottom.equalTo(self.bussinessBtn.snp.bottom)
        }
        self.lineView2.snp.updateConstraints { (make) in
            make.width.equalTo(75)
            make.height.equalTo(3.5)
            make.centerX.equalTo(self.repairBtn.snp.centerX)
            make.bottom.equalTo(self.repairBtn.snp.bottom)
        }
        self.repairBtn.isSelected = false
        self.lineView2.isHidden = true
        self.collectionView.backgroundColor = UIColor.white
        if #available(iOS 10.0, *) {
            self.collectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        if self.memberType == "3" {
            
        }else if self.memberType == "2" {
            
            if teamType == "1" {
                self.repairBtn.removeFromSuperview()
                self.bussinessBtn.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 44)
                self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: false)
                self.bussinessBtn.isEnabled = false
                
            }else if teamType == "2" {
                self.bussinessBtn.removeFromSuperview()
                self.repairBtn.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 44)
                self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: false)
                self.repairBtn.isEnabled = false
                
            }
            self.collectionView.isScrollEnabled = false
        }
        
        
    }
    @objc func btnClick(sender: UIButton) {
        sender.isSelected = true
        
        if sender == self.bussinessBtn {
            self.repairBtn.isSelected = false
            self.lineView.isHidden = false
            self.lineView2.isHidden = true
            self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        }else {
            self.bussinessBtn.isSelected = false
            self.lineView2.isHidden = false
            self.lineView.isHidden = true
            self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignBussinessCell", for: indexPath) as! SignBussinessCell
            cell.selectTeam = { [weak self] in
                self?.bussinessSelectTeam()
//                let vc = SelelctTeamVC()
//                vc.userInfo = "business"
//                self?.navigationController?.pushViewController(vc, animated: true)
//
//                vc.selectTeamID = { [weak self] (id) in
//                    cell.teamID = id
//                }


            }
            if self.memberType == "2" {
                cell.teamID = self.teamID
                cell.bussiness.isUserInteractionEnabled = false
            }
            
            
            
            
            cell.detailClick = { [weak self] (value) in

                self?.bussinessdetailClick(value: value)

            }
            return cell
            
        }else{
            let cell: SignRepairCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignRepairCell", for: indexPath) as! SignRepairCell
            cell.selectTeam = { [weak self] in
                self?.repairSelectTeam()
            }
            cell.detailClick = { [weak self] (value) in
                self?.repairdetailClick(value: value)
            }
            if self.memberType == "2" {
                cell.teamID = self.teamID
                cell.bussiness.isUserInteractionEnabled = false
            }
            return cell
        }
    }
    func bussinessdetailClick(value: (SignDataType, String, String, String, String, String)) {
        //1、超时签到人数 2、未达标人数 3、未签到人数 4、中评人数 5、差评人数
//        var paramete = ["team_id": value.1, "create_at": value.2, "token": DDAccount.share.token ?? ""]
        switch value.0 {
            
        case .action1, .action2, .action3, .leave_early_number:
//            paramete["member_type"] = "1"
            let signVC = SignDetailVC()
            signVC.value = value
            signVC.signType = .bussiness
            self.navigationController?.pushViewController(signVC, animated: true)
//        case .action2:
//            paramete["member_type"] = "2"
//            self.pushVC(vcIdentifier: "SignDetailVC", userInfo: value)
//        case .action3:
//            paramete["member_type"] = "3"
//
//            self.pushVC(vcIdentifier: "SignDetailVC", userInfo: value)
        case .action4:
            
            self.pushVC(vcIdentifier: "RepeatShopVC", userInfo: value)
        default:
            mylog("结束")
        }
    }
    func repairdetailClick(value: (SignDataType, String, String, String, String, String)) {
        //1、超时签到人数 2、未达标人数 3、未签到人数 4、中评人数 5、差评人数
        //        var paramete = ["team_id": value.1, "create_at": value.2, "token": DDAccount.share.token ?? ""]
        switch value.0 {
        case .action1, .action2, .action3, .action5, .action6, .leave_early_number:
            let signVC = SignDetailVC()
            signVC.value = value
            signVC.signType = .maintain
            self.navigationController?.pushViewController(signVC, animated: true)

        default:
            mylog("结束")
        }
    }
    func bussinessSelectTeam() {
        let vc = SelelctTeamVC()
        vc.userInfo = "business"
        self.navigationController?.pushViewController(vc, animated: true)
        let cell = self.collectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as! SignBussinessCell
        vc.selectTeamID = { (value) in
            cell.teamID = value.0
            cell.teamName = value.1
        }
    }
    func repairSelectTeam() {
        let vc = SelelctTeamVC()
        vc.userInfo = "maintain"
        self.navigationController?.pushViewController(vc, animated: true)
        let cell = self.collectionView.cellForItem(at: IndexPath.init(item: 1, section: 0)) as! SignRepairCell
        vc.selectTeamID = {  (value) in
            cell.teamID = value.0
            cell.teamName = value.1
        }
    }
    
    
    
    
}
