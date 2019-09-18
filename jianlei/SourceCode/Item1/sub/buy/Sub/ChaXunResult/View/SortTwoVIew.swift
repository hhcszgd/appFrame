//
//  SortTwoVIew.swift
//  Project
//
//  Created by 张凯强 on 2018/4/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class SortTwoVIew: UIView, UITableViewDelegate, UITableViewDataSource {

    init(frame: CGRect, leftArr: [AreaModel], rightArr: [String: [AreaModel]]) {
        super.init(frame: frame)
        self.leftTableview.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH * 0.4, height: frame.size.height - 40)
        if #available(iOS 11.0, *) {
            self.rightTable.contentInsetAdjustmentBehavior = .never
            self.leftTableview.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.rightTable.frame = CGRect.init(x: SCREENWIDTH * 0.4, y: 0, width: SCREENWIDTH * 0.6, height: frame.size.height - 40)
        self.addSubview(self.cancleBtn)
        self.addSubview(self.sureBtn)
        self.cancleBtn.frame = CGRect.init(x: 0, y: self.leftTableview.max_Y, width: 100, height: 40)
        self.sureBtn.frame = CGRect.init(x: self.cancleBtn.max_X, y: self.leftTableview.max_Y, width: frame.size.width - self.cancleBtn.width, height: 40)
//        if leftArr.count == 0 && rightArr.count == 0 {
//            
//        }else {
//            self.leftDataArr = leftArr
//            self.parentID.value = self.leftDataArr.first?.id
//            self.leftDataArr.first?.isSelected = true
//            self.rightDataArr = rightArr
//            self.leftTableview.reloadData()
//            self.rightTable.reloadData()
//        }
        self.interactive()
        self.cancleBtn.setTitle("取 消", for: .normal)
        self.cancleBtn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.cancleBtn.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        self.cancleBtn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        
        self.sureBtn.setTitleColor(UIColor.white, for: .normal)
        self.sureBtn.setTitle("确  定", for: .normal)
        self.sureBtn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.sureBtn.backgroundColor = UIColor.colorWithHexStringSwift("ea9265")
        self.cancleBtn.addTarget(self, action: #selector(actionBtn(sender:)), for: .touchUpInside)
        self.sureBtn.addTarget(self, action: #selector(actionBtn(sender:)), for: .touchUpInside)
    }
    let cancleBtn: UIButton = UIButton.init()
    let sureBtn: UIButton = UIButton.init()
    var finished: ((String, [AreaModel], [String: [AreaModel]]) -> ())?
    @objc func actionBtn(sender: UIButton) {
        switch sender {
        case self.cancleBtn:
            self.finished?("", [AreaModel](), [String: [AreaModel]]())
        case self.sureBtn:
            //判断有没有选中全国
            var area: String = ""
            var areaName: String = ""
            
            self.leftDataArr.forEach { (model) in
                if !model.rightBtnIsSelect {
                    area += model.id + ","
                    areaName += model.name + ","
                }
            }
            
            for (_, arr) in self.rightDataArr.values.enumerated() {
                for (_, model) in arr.enumerated() {
                    if !model.isSelected {
                        area += model.id + ","
                        areaName += model.name + ","
                    }
                }
                
            }
            if area.hasSuffix(",") {
                area = String(area.prefix(area.count - 1))
                areaName = String(areaName.prefix(areaName.count - 1))
            }
            self.finished?(area, self.leftDataArr, self.rightDataArr)
            
        default:
            break
        }
        
        
        
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
        paremete["show_self"] = "1"
        
        if parentID != nil {
            if self.rightDataArr.keys.contains(parentID!) {
                self.rightTable.reloadData()
                
                return
            }
        }
        let id = DDAccount.share.id ?? ""
        let _ = NetWork.manager.requestData(router: Router.get("member/\(id)/order/0/area", .api, paremete)).subscribe(onNext: { (dict) in
            if parentID == nil {
                if let model = BaseModelForArr<AreaModel>.deserialize(from: dict), let arr = model.data {
                    arr.forEach({ (mo) in
                        mo.rightBtnIsSelect = true
                        mo.rightBtnIsHidden = false
                    })
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
                        arr.forEach({ (mo) in
                            mo.isSelected = true
                        })
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
            cell.finished = {[weak self] (model) in
                if let arr = self?.rightDataArr[model.id] {
                    arr.forEach({ (subModel) in
                        subModel.isSelected = model.rightBtnIsSelect
                    })
                }
                self?.rightTable.reloadData()
            }
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
                if model.isSelected{
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
                    model.isSelected = !model.isSelected
                    
                    let count = arr.filter({ (model) -> Bool in
                        return !model.isSelected
                    }).count
                    if count == 0 {
                        self.leftDataArr.forEach({ (superModel) in
                            if superModel.id == self.parentID.value! {
                                superModel.rightBtnIsSelect = true
                            }
                        })
                        self.leftTableview.reloadData()
                    }
                    if count == arr.count {
                        self.leftDataArr.forEach({ (superModel) in
                            if superModel.id == self.parentID.value! {
                                superModel.rightBtnIsSelect = false
                            }
                        })
                        self.leftTableview.reloadData()
                    }
                }
            }
            self.rightTable.reloadData()
        }
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
    
}
