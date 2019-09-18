//
//  WeiHuListVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class WeiHuListVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let shopID = self.userInfo as? String {
            self.request(shopID: shopID)
        }
    }
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.title = "维护信息"
    }
    var dataArr: [WeiHuListModel] = [WeiHuListModel]() {
        didSet{
            self.tableView?.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WeiHuListVC: UITableViewDelegate, UITableViewDataSource {
    func configUI() {
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight + 15, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight - 15), style: UITableView.Style.grouped)
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        tableView.register(UINib.init(nibName: "WeiHuListCell", bundle: Bundle.main), forCellReuseIdentifier: "WeiHuListCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        self.view.addSubview(tableView)
        
    }
    
    func request(shopID: String) {
        let paramete = ["token": DDAccount.share.token ?? "", "shop_id": shopID]
        let router = Router.get("sign/maintain-history", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<WeiHuListModel>.deserialize(from: dict)
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
        let cell: WeiHuListCell = tableView.dequeueReusableCell(withIdentifier: "WeiHuListCell", for: indexPath) as! WeiHuListCell
        let model = self.dataArr[indexPath.row]
        cell.model = model
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
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
        self.pushVC(vcIdentifier: "FuwuPingJiaVC", userInfo: model.sign_id)
    }
    
    
}
