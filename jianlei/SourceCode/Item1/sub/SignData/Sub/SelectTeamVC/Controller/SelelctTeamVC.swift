//
//  SelelctTeamVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class SelelctTeamVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let type = self.userInfo as? String {
            self.request(type: type)
        }
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "selct_team"|?|
    }
    
    var dataArr: [SelectTeamModel] = [SelectTeamModel]() {
        didSet{
            self.tableView?.reloadData()
        }
    }
    var selectTeamID: (((String, String)) -> ())?
   

}
extension SelelctTeamVC: UITableViewDelegate, UITableViewDataSource {
    func configUI() {
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight + 15, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight - 15), style: UITableView.Style.grouped)
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        tableView.register(UINib.init(nibName: "SelectTeamCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectTeamCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
        
    }
    
    func request(type: String) {
        let paramete = ["token": DDAccount.share.token ?? "", "type": type]
        let router = Router.get("sign/choose-team", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<SelectTeamModel>.deserialize(from: dict)
            if let data = model?.data {
                self.dataArr = data
            }
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectTeamCell = tableView.dequeueReusableCell(withIdentifier: "SelectTeamCell", for: indexPath) as! SelectTeamCell
        cell.model = self.dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row]
        model.isSelected = !model.isSelected
        
        tableView.reloadData()
        self.selectTeamID?((model.id ?? "", model.team_name ?? ""))
        self.popToPreviousVC()
    }
    
    
}
