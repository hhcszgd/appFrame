//
//  TeamControllerVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/9.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class TeamControllerVC: DDInternalVC {
    var dataArr: [TeamSubModel] = [] {
        didSet{
            self.tableView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "team_manager"|?|
        self.naviBar.rightBarButtons = [self.addBtn]
        
        
    }
    @objc func addTeamAction(sender: UIButton) {
        self.pushVC(vcIdentifier: "CreateTeamVC", userInfo: nil)
    }
    
    lazy var addBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "team_admin_establish"), for: UIControl.State.normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        btn.addTarget(self, action: #selector(addTeamAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var userMemberType: String = ""
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TeamControllerVC: UITableViewDelegate, UITableViewDataSource {
    func configUI() {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), style: UITableView.Style.grouped)
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        tableView.register(TeamTableCell.self, forCellReuseIdentifier: "TeamTableCell")
        tableView.register(TeamTableHeader.self, forHeaderFooterViewReuseIdentifier: "TeamTableHeader")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(tableView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestData()
    }
    func requestData() {
        let token = DDAccount.share.token ?? ""
        let router = Router.get("sign/team", .api, ["token": token])
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let baseModel = BaseModel<TeamManagerModel>.deserialize(from: dict)
            if let data = baseModel?.data?.items, baseModel?.status == 200, data.count > 0 {
                mylog(data)
                self.dataArr = data
                ///只有管理员权限才能创建店铺，添加按钮才会显示
                if let memberType = baseModel?.data?.member_type {
                    self.userMemberType = memberType
                    if memberType == "3" {
                        self.addBtn.isHidden = false
                    }else {
                        self.addBtn.isHidden = true
                    }
                }else {
                    self.addBtn.isHidden = true
                }
                self.zkqMaskView.isHidden = true
            }else {
                
            }
            
        }, onError: { (error) in
            self.zkqMaskView.isHidden = false
            self.zkqMaskView.clickBlock = { [weak self] in
                self?.requestData()
            }
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }   
    ///delegate
    
    ///dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subModel = self.dataArr[section]
        return subModel.team?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TeamTableCell = tableView.dequeueReusableCell(withIdentifier: "TeamTableCell", for: indexPath) as! TeamTableCell
        let subModel = self.dataArr[indexPath.section]
        let team = subModel.team
        cell.teamModel = team?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TeamTableHeader") as! TeamTableHeader
        let subModel = self.dataArr[section]
        header.myTitleValue = (subModel.title ?? "") + "(\(subModel.team_number ?? "")支)"
        return header
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subModel = self.dataArr[indexPath.section]
        let team = subModel.team
        let model = team?[indexPath.row]
        let paramete = ["id": model?.id ?? "", "teamName": model?.team_name ?? ""]
        self.pushVC(vcIdentifier: "TeamDetailVC", userInfo: paramete)
        
    }
    
    
    
}
