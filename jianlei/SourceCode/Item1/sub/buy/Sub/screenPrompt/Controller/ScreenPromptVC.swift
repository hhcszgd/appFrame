//
//  ScreenPromptVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
class PromptModel: GDModel {
    var key: String?
    var name: String?
    var time: String?
    var rate: String?
    var spec: String?
    var format: String?
    var describe: String?
}
class ScreenPromptVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.table)
        self.configHeaderAndFooter()
        
        self.title = "广告位预览"
        self.table.rowHeight = UITableView.automaticDimension
        self.table.estimatedRowHeight = 100
        let paramete = ["token": DDAccount.share.token ?? ""]
        let router = Router.get("advert/get-pos", DomainType.api, paramete)
        NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let data = BaseModelForArr<PromptModel>.deserialize(from: dict)
            if let arr = data?.data {
                self.dataArr = arr
            }
            self.table.reloadData()
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        

        // Do any additional setup after loading the view.
    }
    var dataArr: [PromptModel] = []
    
    ///设置头和尾视图
    func configHeaderAndFooter() {
        
        let tableHeaderView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 225.5 + 30))
        tableHeaderView.image = UIImage.init(named: "screen0129")
        tableHeaderView.contentMode = .scaleAspectFit
        
        let tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 80))
        let titleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("333333"), text: "广告说明")
        titleLabel.textAlignment = NSTextAlignment.center
    
        let detailLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("b3b3b3"), text: "最终解释权在北京玉龙腾飞影视有限公司")
        detailLabel.textAlignment = NSTextAlignment.center
        
        tableFooterView.addSubview(titleLabel)
        tableFooterView.addSubview(detailLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        titleLabel.sizeToFit()
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            
        }
        self.table.tableHeaderView = tableHeaderView
        self.table.tableFooterView = tableFooterView
        
    }
    var items: [AdvertisModel] = [AdvertisModel]() {
        didSet{
            items.forEach({ (model) in
                var rateStr: String = ""
                model.rate_list?.forEach({ (rate) in
                    rateStr += rate + "次/每天、"
                })
                rateStr.removeLast()
                model.rateStr = rateStr
            })
            var superIndex: Int?
            for (index, model) in items.enumerated() {
                if model.key == "CD" {
                    superIndex = index
                }
            }
            if superIndex != nil {
                items.remove(at: superIndex!)
            }
            
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScreentPromptCell = tableView.dequeueReusableCell(withIdentifier: "ScreentPromptCell", for: indexPath) as! ScreentPromptCell
        cell.propmtModel = self.dataArr[indexPath.row]
        if (cell.propmtModel?.key == "A1") || (cell.propmtModel?.key == "A2") || (cell.propmtModel?.key == "A") {
            cell.backView.backgroundColor = UIColor.colorWithHexStringSwift("ffb9a9")
        }
        if (cell.propmtModel?.key == "B") {
            cell.backView.backgroundColor = UIColor.colorWithHexStringSwift("b9eff6")
        }
        if (cell.propmtModel?.key == "D") || (cell.propmtModel?.key == "C") || (cell.propmtModel?.key == "CD") {
            cell.backView.backgroundColor = UIColor.colorWithHexStringSwift("f6e7b0")
        }
        
        
        return cell
    }
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight ), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.register(UINib.init(nibName: "ScreentPromptCell", bundle: Bundle.main), forCellReuseIdentifier: "ScreentPromptCell")
        
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
