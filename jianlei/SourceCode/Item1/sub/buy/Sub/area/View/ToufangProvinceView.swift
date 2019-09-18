//
//  ToufangProvinceView.swift
//  Project
//
//  Created by 张凯强 on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift

class ToufangProvinceView: UIView, UITableViewDelegate, UITableViewDataSource {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.leftTableview.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH * 0.4, height: frame.size.height)
        self.rightTable.frame = CGRect.init(x: SCREENWIDTH * 0.4, y: 0, width: SCREENWIDTH * 0.6, height: frame.size.height)
        
        
        self.interactive()
        
        
    }
    func interactive() {
        let _ = parentID.asObservable().subscribe(onNext: { (parentID) in
            self.request(parentID: parentID)
        }, onError: nil, onCompleted: nil, onDisposed: {
            mylog("回收")
        }).disposed(by: bag)
    }
    let bag = DisposeBag.init()
    
    var leftDataArr: [AreaModel] = []
    var rightDataArr: [String: [AreaModel]] = [String: [AreaModel]]()
    let parentID: Variable<String?> = Variable<String?>.init(nil)
    ///请求数据
    func request(parentID: String?) {
        let token = DDAccount.share.token ?? ""
        var paremete = ["token":token]
        if let parentID = parentID {
            paremete["parent_id"] = parentID
        }
        paremete["is_buy"] = "1"

        if parentID != nil {
            if self.rightDataArr.keys.contains(parentID!) {
                self.rightTable.reloadData()
            }
        }
        let _ = NetWork.manager.requestData(router: Router.get("area", .api, paremete)).subscribe(onNext: { (dict) in
            if parentID == nil {
                if let model = BaseModelForArr<AreaModel>.deserialize(from: dict), let arr = model.data {
                    self.leftDataArr = arr
                    if let subModel = self.leftDataArr.first {
                        subModel.isSelected = true
                        self.parentID.value = subModel.id
                        
                    }
                    self.leftTableview.reloadData()
                    self.rightTable.reloadData()
                    self.leftDataArr.forEach({ (model) in
                        self.request(parentID: model.id)
                    })
                    
                }
            }else {
                if let model = BaseModelForArr<AreaModel>.deserialize(from: dict) {
                    if let arr = model.data {
                        if !self.rightDataArr.keys.contains(parentID!) {
                            self.rightDataArr[parentID!] = arr
                        }
                        self.rightTable.reloadData()
                    }else {
                        if !self.rightDataArr.keys.contains(parentID!) {
                            self.rightDataArr[parentID!] = [AreaModel]()
                        }
                        self.rightTable.reloadData()
                    }
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.leftTableview == tableView {
            return self.leftDataArr.count
        }else {
            if parentID.value == nil {
                return 0
            }else {
                if let arr = self.rightDataArr[parentID.value!] {
                    return arr.count
                }else {
                    return 0
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.leftTableview == tableView {
            let cell: ProvinceCell = tableView.dequeueReusableCell(withIdentifier: "ProvinceCell", for: indexPath) as! ProvinceCell
            cell.model = self.leftDataArr[indexPath.row]
            return cell
        }else {
            let cell: CityCell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
            if let arr = self.rightDataArr[parentID.value!] {
                cell.model = arr[indexPath.row]
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.leftTableview == tableView {
            self.leftDataArr.forEach({ (model) in
                if model.isSelected ?? false{
                    model.isSelected = false
                }
            })
            
            let model = self.leftDataArr[indexPath.row]
            model.isSelected = true
            tableView.reloadData()
            parentID.value = model.id
        }else {
            if self.parentID.value != nil {
                if let arr = self.rightDataArr[self.parentID.value!] {
                    let model: AreaModel = arr[indexPath.row]
                    model.isSelected = !model.isSelected ?? false
                }
            }
            self.rightTable.reloadData()
        }
    }
    
    //选定数据
    func selectFinished(success: @escaping (String, String) -> (), failure: @escaping () -> ()) {
        
        
        
        
        //判断有没有选中全国
        var area: String = ""
//        var areaName: String = ""
        

        
        for (_, arr) in self.rightDataArr.values.enumerated() {
            for (_, model) in arr.enumerated() {
                if model.isSelected ?? false {
                    area += model.id ?? "" + ","
//                    areaName += model.name + ","
                }
            }
            
        }
        if area.hasSuffix(",") {
            area.removeLast()
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
    
    
    
    
    lazy var leftTableview: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.register(ProvinceCell.self, forCellReuseIdentifier: "ProvinceCell")
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.colorWithHexStringSwift("414141")
        self.addSubview(table)
        return table
    }()
    lazy var rightTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.showsVerticalScrollIndicator = false
        table.register(UINib.init(nibName: "CityCell", bundle: Bundle.main), forCellReuseIdentifier: "CityCell")
        self.addSubview(table)
        return table
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
        /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension ToufangProvinceView {
    //清空已经选择的数据
    func clearData() {
        for (_, arr) in self.rightDataArr.values.enumerated() {
            arr.forEach({ (model) in
                model.isSelected = false
            })
        }
        self.rightTable.reloadData()
    }
}
class Area: GDModel {
    var area_name: String?
}


