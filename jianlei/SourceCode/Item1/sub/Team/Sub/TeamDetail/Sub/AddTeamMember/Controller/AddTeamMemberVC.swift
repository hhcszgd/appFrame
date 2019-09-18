//
//  AddTeamMemberVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class AddTeamMemberVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.requestData()
    
        // Do any additional setup after loading the view.
    }
    override func _configNavBar() {
        super._configNavBar()
        self.naviBar.backBtn.setTitle("cancel"|?|, for: UIControl.State.normal)
        self.naviBar.backBtn.setImage(UIImage.init(), for: UIControl.State.normal)
        self.naviBar.backBtn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        
        self.addBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        self.addBtn.isEnabled = false
        self.naviBar.rightBarButtons = [self.addBtn]
        self.naviBar.title = "team_add_title"|?|
        
        
    }
    
    var memeberIds: String = ""
    var isSearchIng: Bool = false
    let search: UISearchBar = UISearchBar.init()
    var dataArr: [AddTeamModel<AddteamSubModel>] = [AddTeamModel<AddteamSubModel>]() {
        didSet{
            self.tableView?.reloadData()
        }
    }
    var searchDataArr: [AddteamSubModel] = [AddteamSubModel]() {
        didSet{
            self.tableView?.reloadData()
        }
    }
    lazy var addBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitleColor(UIColor.colorWithHexStringSwift("323232"), for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("cccccc"), for: UIControl.State.disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("add"|?|, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(addTeamMemberAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()

    var searchFieldWidth: CGFloat = 0
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddTeamMemberVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    func configUI() {
        self.view.addSubview(self.search)
        //设置searchBar
        self.search.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 44)
        self.search.placeholder = "search"|?|
        self.search.tintColor = UIColor.colorWithHexStringSwift("323232")
        self.search.barTintColor = UIColor.white
        self.search.delegate = self
        self.search.layer.borderColor = UIColor.clear.cgColor
        if let searchTextField = self.search.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
            searchTextField.layer.cornerRadius = 18
            searchTextField.layer.masksToBounds = true
            self.searchFieldWidth = SCREENWIDTH - 30
            
        }
        self.search.setPositionAdjustment(UIOffset.init(horizontal: (self.searchFieldWidth - 25.67) / 2.0, vertical: 0), for: UISearchBar.Icon.search)
        
        
        //uitableView
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.search.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.search.max_Y - DDSliderHeight), style: UITableView.Style.grouped)
        self.view.addSubview(self.tableView!)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(AddTeamMemberView.self, forHeaderFooterViewReuseIdentifier: "AddTeamMemberView")
        self.tableView?.register(AddTeamMemberCell.self, forCellReuseIdentifier: "AddTeamMemberCell")
        self.tableView?.separatorColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.tableView?.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView?.sectionIndexColor = UIColor.colorWithHexStringSwift("ffffff")
        self.tableView?.sectionIndexBackgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    
        self.requestData()
        
        
    }
    
    func requestData() {
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("sign/inside-members", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<AddTeamModel<AddteamSubModel>>.deserialize(from: dict)
            if let data = model?.data, model?.status == 200 {
                self.dataArr = data
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mylog(searchText)
        self.searchDataArr.removeAll()
        if searchText == "" {
            self.isSearchIng = false
            self.tableView?.reloadData()
        }else {
            self.isSearchIng = true
            var arr: [AddteamSubModel] = [AddteamSubModel]()
            self.dataArr.forEach { (model) in
                if let items = model.items {
                    items.forEach({ (subModel) in
                        if let name = subModel.name {
                            if name.contains(searchText) {
                                arr.append(subModel)
                            }
                        }
                        
                    })
                }
            }
            
            self.searchDataArr = arr
        }
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    @objc func addTeamMemberAction(sender: UIButton) {
        
        guard let teamID = self.userInfo as? String else{
            return
        }
        sender.isEnabled = true
        let paramete = ["token": DDAccount.share.token ?? "", "team_id": teamID, "member_id": self.memeberIds]
        let router = Router.post("sign/add-members", .api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<String>.deserialize(from: dict)
            if model?.status == 200 {
                GDAlertView.alert("  \("team_add_success"|?|)  ", image: UIImage.init(named: "team_admin_success"), time: 1, complateBlock: {
                    self.popToPreviousVC()
                })
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
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
}
extension AddTeamMemberVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchIng {
            if self.searchDataArr.count == 0 {
                return 0
            }else {
                return 1
            }
            
        }else {
            return self.dataArr.count
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchIng {
            return self.searchDataArr.count
        }else {
            let model = self.dataArr[section]
            return model.items?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTeamMemberCell", for: indexPath) as! AddTeamMemberCell
        
        if isSearchIng {
            let subModel = self.searchDataArr[indexPath.row]
            cell.model = subModel
        }else {
            let model = self.dataArr[indexPath.section]
            let subModel = model.items?[indexPath.row]
            cell.model = subModel
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchIng {
            let model = self.searchDataArr[indexPath.row]
            model.isSelected = !(model.isSelected)
        }else {
            let model = self.dataArr[indexPath.section]
            let subModel = model.items?[indexPath.row]
            subModel?.isSelected = !(subModel?.isSelected ?? false)
        }
        
        tableView.reloadData()
        
        self.configAddBtnTitle()
    }
    func configAddBtnTitle() {
        var count: Int = 0
        self.memeberIds = ""
        self.dataArr.forEach { (model) in
            if let items = model.items {
                items.forEach({ (a) in
                    if a.isSelected {
                        count += 1
                        self.memeberIds += (a.id ?? "") + ","
                    }
                })
            }
        }
        if self.memeberIds.count != 0 {
            self.memeberIds.removeLast()
        }
        
        if count == 0 {
            self.addBtn.setTitle("add"|?|, for: UIControl.State.normal)
            self.addBtn.isEnabled = false
        }else {
            self.addBtn.setTitle("\("add"|?|)(\(count))", for: UIControl.State.normal)
            self.addBtn.isEnabled = true
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddTeamMemberView") as! AddTeamMemberView
        let model = self.dataArr[section]
        header.myTitleLabel.text = self.isSearchIng ? "search_result"|?|:model.title
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
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.search.setPositionAdjustment(UIOffset.init(horizontal: 10, vertical: 0), for: UISearchBar.Icon.search)
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.search.setPositionAdjustment(UIOffset.init(horizontal: (self.searchFieldWidth - 25.67) / 2.0, vertical: 0), for: UISearchBar.Icon.search)
        return true
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if self.isSearchIng {
            return [String]()
        }else {
            return self.dataArr.map({ (model) -> String in
                return model.title ?? ""
            })
        }
        
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: index), at: UITableView.ScrollPosition.top, animated: true)
        return index
    }
    
}
