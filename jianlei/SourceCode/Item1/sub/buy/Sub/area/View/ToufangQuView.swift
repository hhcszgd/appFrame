//
//  ToufangQuView.swift
//  Project
//
//  Created by 张凯强 on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ToufangQuView: UIView, UITableViewDelegate, UITableViewDataSource {
    var leftSelectModel: AreaModel?
    var middleSelectModel: AreaModel?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTabel {
            return self.leftData.count
        }
        if tableView == self.middleTable {
            if let id = self.leftSelectModel?.id {
                if let arr = self.middleDataArr[id] {
                    return arr.count
                }else {
                    return 0
                }
            }else {
                return 0
            }
        }
        if tableView == self.rightTable {
            if let id = self.middleSelectModel?.id {
                if let arr = self.rightDataArr[id] {
                    return arr.count
                }else {
                    return 0
                }
            }else {
                return 0
            }
        }
        return 0
    }
    var parentID: Variable<String?> = Variable<String?>.init(nil)
    var leftData: [AreaModel] = []
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.leftTabel == tableView {
            
            let cell: QuProvinceCell = tableView.dequeueReusableCell(withIdentifier: "QuProvinceCell", for: indexPath) as! QuProvinceCell
            cell.quProvinceModel = self.leftData[indexPath.row]
            return cell
        }else if self.middleTable == tableView {
            
            let cell: QuCityCell = tableView.dequeueReusableCell(withIdentifier: "QuCityCell", for: indexPath) as! QuCityCell
            if let id = self.leftSelectModel?.id {
                if let arr = self.middleDataArr[id] {
                    cell.quCityModel = arr[indexPath.row]
                }
            }
            return cell
        }else {
            let cell: CityCell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
            if let id = self.middleSelectModel?.id {
                if let arr = self.rightDataArr[id] {
                    cell.model = arr[indexPath.row]
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTabel {
            self.leftData.forEach({ (model) in
                if model.isSelected{
                    model.isSelected = false
                }
            })
            
            let model = self.leftData[indexPath.row]
            model.isSelected = true
            self.leftSelectModel = model
            tableView.reloadData()
            
            
            parentID.value = model.id
            self.middleTable.reloadData()
            
        }
        if tableView == self.middleTable {
            if let id = self.leftSelectModel?.id {
                if let arr = self.middleDataArr[id] {
                    arr.forEach({ (model) in
                        if model.isSelected {
                            model.isSelected = false
                        }
                    })
                    let model = arr[indexPath.row]
                    model.isSelected = true
                    self.middleSelectModel = model
                    tableView.reloadData()
                    self.parentID.value = model.id
                }
            }
            tableView.reloadData()
            self.rightTable.reloadData()
        }
        if tableView == self.rightTable {
            if let id = self.middleSelectModel?.id {
                if let arr = self.rightDataArr[id] {
                    let model = arr[indexPath.row]
                    model.isSelected = !model.isSelected
                    
                }
            }
            tableView.reloadData()
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.leftTabel.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH / 3.0, height: frame.size.height)
        self.middleTable.frame = CGRect.init(x: self.leftTabel.max_X, y: 0, width: self.leftTabel.width, height: frame.size.height)
        self.rightTable.frame = CGRect.init(x: self.middleTable.max_X, y: 0, width: self.leftTabel.width, height: frame.height)
        
        let _ = parentID.asObservable().subscribe(onNext: { (id) in
            self.request(parentID: id)
        }, onError: nil, onCompleted: nil, onDisposed: {
            mylog("回收")
            }).disposed(by: bag)
        
    }
    let bag = DisposeBag()
    var middleDataArr: [String: [AreaModel]] = [String: [AreaModel]]()
    var rightDataArr: [String: [AreaModel]] = [String: [AreaModel]]()
    ///请求数据
    func request(parentID: String?) {
        let token = DDAccount.share.token ?? ""
        var paremete = ["token":token]
        if let parentID = parentID {
            paremete["parent_id"] = parentID
        }
        
        if parentID != nil {
            if (parentID?.count == 5) {
                mylog(parentID)
                //点击了省
                if self.middleDataArr.keys.contains(parentID!) {
                    let arr = self.middleDataArr[parentID!]
                    arr?.forEach({ (model) in
                        if model.isSelected {
                            self.middleSelectModel = model
                            self.request(parentID: model.id)
                        }
                    })
                    self.leftTabel.reloadData()
                    self.middleTable.reloadData()
                    self.rightTable.reloadData()
                    
                    
                }
            }
            
            if parentID?.count == 7 {
                mylog(parentID)
                //点击了市
                if self.rightDataArr.keys.contains(parentID!) {
                    
                    self.middleTable.reloadData()
                    self.rightTable.reloadData()
                    return
                }
            }
            
        }
        
        
        
        let _ = NetWork.manager.requestData(router: Router.get("area", .api, paremete)).subscribe(onNext: { (dict) in
            if parentID == nil {
                if let model = BaseModelForArr<AreaModel>.deserialize(from: dict), let arr = model.data {
                    self.leftData = arr
                    if let subModel = self.leftData.first {
                        subModel.isSelected = true
                        self.leftSelectModel = subModel
                        self.request(parentID: subModel.id)
                        
                    }
                    self.leftTabel.reloadData()
                }
            }else {
                if let model = BaseModelForArr<AreaModel>.deserialize(from: dict), let arr = model.data {
                    if parentID?.count == 5 {
                        //点击省
                        if self.middleDataArr.keys.contains(parentID!) {
                            let arr = self.middleDataArr[parentID!]
                            arr?.forEach({ (model) in
                                if model.isSelected {
                                    self.request(parentID: model.id)
                                }
                            })
                        }else {
                            self.middleDataArr[parentID!] = arr
                            let model = arr.first
                            model?.isSelected = true
                            self.middleSelectModel = model
                            self.request(parentID: model?.id)
                        }
                        
                        
                        self.middleTable.reloadData()
                        //获取市的列表
                    
                    }else if parentID?.count == 7 {
                        //点击市
                        
                        self.rightDataArr[parentID!] = arr
                        
                    }else if parentID?.count == 9{
                        //区县
                        
                    }else {
                        
                    }
                    
                    
                    
                    self.rightTable.reloadData()
                }
            }
            
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }

    //清空已经选择的数据
    func clearData() {
        for (_, arr) in self.rightDataArr.values.enumerated() {
            arr.forEach({ (model) in
                model.isSelected = false
            })
        }
        self.rightTable.reloadData()
    }
    //选定数据
    func selectFinished(success: @escaping (String, String) -> (), failure: @escaping () -> ()) {
        var area: String = ""
//        var areaName: String = ""
        for (_, arr) in self.rightDataArr.values.enumerated() {
            arr.forEach({ (model) in
                if model.isSelected {
                    area += model.id + ","
//                    areaName += model.name + ","
                }
            })
        }
        if area.hasSuffix(",") {
            area.removeLast()
//                area.substring(to: area.index(area.endIndex, offsetBy: -1))
//            areaName = areaName.substring(to: areaName.index(areaName.endIndex, offsetBy: -1))
        }
        
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": token, "area_id": area, "area_type": "3"]
        let _ = NetWork.manager.requestData(router: Router.post("member/\(id)/order/area", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<Area>.deserialize(from: dict)
            if model?.status == 200 {
                success(area, model?.data?.area_name ?? "")
            }else {
                failure()
            }
        }, onError: { (error) in
            failure()
        }, onCompleted: {
            mylog("结束")
        }, onDisposed: {
            mylog("回收")
        })
        
    }
    
    lazy var  leftTabel: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.register(QuProvinceCell.self, forCellReuseIdentifier: "QuProvinceCell")
        table.backgroundColor = UIColor.colorWithHexStringSwift("414141")
        self.addSubview(table)
        return table
    }()
    lazy var middleTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.register(QuCityCell.self, forCellReuseIdentifier: "QuCityCell")
        self.addSubview(table)
        table.backgroundColor = UIColor.lightGray
        return table
    }()
    lazy var rightTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.register(UINib.init(nibName: "CityCell", bundle: Bundle.main), forCellReuseIdentifier: "CityCell")
        self.addSubview(table)
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
