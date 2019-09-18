//
//  DeleteTemaMember.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DeleteTemaMember: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = self.userInfo as? String {
            self.teamID = id
            

        }
        self.configUI()

        // Do any additional setup after loading the view.
    }
    var dataArr: [DeleteMemberModel] = [DeleteMemberModel](){
        didSet{
            self.tableView?.reloadData()
        }
    }
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.backBtn.setTitle("cancel"|?|, for: UIControl.State.normal)
        self.naviBar.backBtn.setImage(UIImage.init(), for: UIControl.State.normal)
        self.naviBar.backBtn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        
        self.deleteBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        
        self.naviBar.rightBarButtons = [self.deleteBtn]
        self.naviBar.title = "team_remove_title"|?|
        
    }
    var userMemberID: String = ""
    var teamID: String = ""
    var memeberIds: String = ""
    var userMemberType: String = ""
    var count:Int = 0
    lazy var deleteBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitleColor(UIColor.colorWithHexStringSwift("323232"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("remove"|?|, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(deleteMember(sender:)), for: UIControl.Event.touchUpInside)
        return btn
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
extension DeleteTemaMember: UITableViewDelegate, UITableViewDataSource {
    func configUI() {
       
        //uitableView
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight), style: UITableView.Style.grouped)
        self.view.addSubview(self.tableView!)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(AddTeamMemberView.self, forHeaderFooterViewReuseIdentifier: "AddTeamMemberView")
        self.tableView?.register(AddTeamMemberCell.self, forCellReuseIdentifier: "AddTeamMemberCell")
        self.tableView?.separatorColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.tableView?.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.requestData()
        
        
        
    }
    func requestData() {
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("sign/wait-delete-members/\(self.teamID)", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<DeleteMemberModel>.deserialize(from: dict)
            if let data = model?.data?.items {
                self.userMemberType = model?.data?.member_type ?? "1"
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
    @objc func deleteMember(sender: UIButton) {
        if self.memeberIds.count == 0 {
            GDAlertView.alert("team_select_remove_member"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        sender.isEnabled = false
    
        let sureAction = ZKAlertAction.init(title: "sure"|?|, style: UIAlertAction.Style.default) { [weak self] (action) in
            
            let paramete = ["token": DDAccount.share.token ?? "", "team_id": self?.teamID ?? "", "member_id": self?.memeberIds ?? ""]
            let router = Router.delete("sign/delete-members", DomainType.api, paramete)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                let model = BaseModel<String>.deserialize(from: dict)
                if model?.status == 200 {
                    GDAlertView.alert("  \("team_remove_success"|?|)  ", image: UIImage.init(named: "team_admin_success"), time: 1, complateBlock: {
                        self?.popToPreviousVC()
                    })
                }else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: {
                        
                    })
                }
                sender.isEnabled = true
            }, onError: { (error) in
                sender.isEnabled = true
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
        }
        let cancleAction = ZKAlertAction.init(title: "cancel"|?|, style: UIAlertAction.Style.cancel) { (_) in
            sender.isEnabled = true
        }
        let message = String.init(format: "team_remove_member_alter"|?|, String(self.count))
        let alertVc = MyAlertView.init(frame: CGRect.zero, title: nil, message: message, actions: [cancleAction, sureAction])
        
        UIApplication.shared.keyWindow?.alertZkq(alertVc)
        

        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTeamMemberCell", for: indexPath) as! AddTeamMemberCell
        let model = self.dataArr[indexPath.row]
        cell.teamDetailInfoModel = model
        if self.userMemberType == "2" {
            if model.member_type == "2" {
                if self.userMemberID == model.member_id {
                    cell.myImage2.isHidden = false
                }else {
                    cell.myImage2.isHidden = true
                }
            }else if model.member_type == "3" {
                cell.myImage2.isHidden = true
            }else if model.member_type == "1" {
                cell.myImage2.isHidden = false
            }
        }else if self.userMemberType == "3" {
            cell.myImage2.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row]
        if self.userMemberType == "3" {
            model.isSelected = !model.isSelected
            tableView.reloadData()
            self.configAddBtnTitle()
        } else if self.userMemberType == "2" {
            if model.member_type == "1" {
                model.isSelected = !model.isSelected
                tableView.reloadData()
                self.configAddBtnTitle()
            }
            if model.member_id == self.userMemberID {
                model.isSelected = !model.isSelected
                tableView.reloadData()
                self.configAddBtnTitle()
            }
        }
        
        
    }
    func configAddBtnTitle() {
        self.count = 0
        self.memeberIds = ""
        
        self.dataArr.forEach { (model) in
            if model.isSelected {
                self.memeberIds += (model.member_id ?? "") + ","
                self.count += 1
            }
        }
        if self.memeberIds.count != 0 {
            self.memeberIds.removeLast()
        }
        
        if count == 0 {
            self.deleteBtn.setTitle("remove"|?|, for: UIControl.State.normal)
        }else {
            self.deleteBtn.setTitle("\("remove"|?|)(\(count))", for: UIControl.State.normal)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddTeamMemberView") as! AddTeamMemberView
        header.myTitleLabel.text = ""
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddTeamMemberView") as! AddTeamMemberView
        header.myTitleLabel.text = ""
        return header
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
   
    
    
}
