//
//  ToufangCity.swift
//  Project
//
//  Created by 张凯强 on 2019/1/20.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class ToufangCity: DDCoverView, UITableViewDelegate, UITableViewDataSource {
    init(superView: UIView, isFirst: Bool = false, router: Router? = nil) {
        super.init(superView: superView)
        self.addSubview(self.containerTable)
        self.router = router
        if router == nil {
            self.request()
        }else {
            
        }
        
        containerTable.frame = CGRect.init(x: 0, y: SCREENHEIGHT - 300 - TabBarHeight - (isFirst ? 49:0) - 40, width: SCREENWIDTH, height: 300)
        containerTable.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        containerTable.separatorColor = UIColor.clear
        self.addSubview(self.sureBtn)
        self.sureBtn.frame = CGRect.init(x: 0, y: self.containerTable.max_Y, width: SCREENWIDTH, height: 40)
        
    }
    deinit {
        mylog("ToufangCity销毁****************")
    }
    ///请求数据
    func request() {
        let token = DDAccount.share.token ?? ""
        var paremete = ["token":token]
        paremete["is_buy"] = "1"
        let _ = NetWork.manager.requestData(router: Router.get("area", .api, paremete)).subscribe(onNext: { (dict) in
            if let model = BaseModelForArr<AreaModel>.deserialize(from: dict), let arr = model.data {
                self.dataArr = arr
                
                
            }
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    var router: Router?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dataArr: [AreaModel] = [] {
        didSet{
            self.containerTable.reloadData()
        }
    }
    lazy var sureBtn : UIButton = {
        let btn = UIButton.init()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("ed8102")
        btn.addTarget(self, action: #selector(sureAction(sender:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var containerTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        table.register(ToufangCityCell.self, forCellReuseIdentifier: "ToufangCityCell")
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.white
        self.addSubview(table)
        return table
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ToufangCityCell = tableView.dequeueReusableCell(withIdentifier: "ToufangCityCell", for: indexPath) as! ToufangCityCell
       
        cell.model = self.dataArr[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.router != nil {
            self.dataArr.forEach { (model) in
                model.isSelected = false
            }
            let model = self.dataArr[indexPath.row]
            model.isSelected = !model.isSelected
        }else {
            let model = self.dataArr[indexPath.row]
            model.isSelected = !model.isSelected
        }
        
        tableView.reloadData()
    }
    @objc func sureAction(sender: UIButton) {
        if self.router != nil {
            var name: String = ""
            self.dataArr.forEach { (model) in
                if model.isSelected {
                    name = model.name
                }
            }
            self.selectFinished?(("", name))
            self.remove()
            return
            
        }
        
        
        var area: String = ""
        //        var areaName: String = ""
        self.dataArr.forEach({ (model) in
            if (model.id.count > 0) && (model.isSelected) {
                area += model.id + ","
            }
        })
        if area.hasSuffix(",") {
            area.removeLast()
        }
         if area.count == 0 {
            GDAlertView.alert("请选择地区", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": token, "area_id": area, "area_type": "2"]
        let _ = NetWork.manager.requestData(router: Router.post("member/\(id)/order/area", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<Area>.deserialize(from: dict)
            if model?.status == 200 {
                if let areaName = model?.data?.area_name {
                    self.selectFinished?((area, areaName))
                }
                self.remove()
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
        }, onCompleted: {
            mylog("结束")
        }, onDisposed: {
            mylog("回收")
        })
    }
    
    var selectFinished: (((String, String)) -> ())?
    //选定数据
    
    
    
    
    
}
//class ToufangCityCell: UITableViewCell {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = UITableViewCellSelectionStyle.none
//        self.myTitleLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(13)
//            
//        }
//        self.contentView.addSubview(self.rightBtn)
//        self.rightBtn.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview()
//            make.width.equalTo(35)
//            make.height.equalTo(35)
//        }
//    
//    }
//
//    var model: AreaModel? {
//        didSet{
//            if model?.isSelected ?? false {
//                self.rightBtn.isSelected = true
//            }else {
//                self.rightBtn.isSelected = false
//            }
//          
//            
//            
//            self.myTitleLabel.text = model?.name
//        }
//    }
//    @objc func configBtn(sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        self.model?.isSelected = sender.isSelected
////        guard let mo = self.model else { return }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    lazy var myTitleLabel: UILabel = {
//        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "北京市")
//        label.textAlignment = NSTextAlignment.center
//        self.contentView.addSubview(label)
//        return label
//    }()
//    lazy var rightBtn: UIButton = {
//        let btn = UIButton.init()
//        btn.setImage(UIImage.init(named: "0117_select"), for: .selected)
//        btn.setImage(UIImage.init(), for: .normal)
//        btn.addTarget(self, action: #selector(configBtn(sender:)), for: .touchUpInside)
//        return btn
//    }()
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//    }
//
//}
