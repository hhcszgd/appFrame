//
//  HaveSelectView.swift
//  Project
//
//  Created by 张凯强 on 2018/4/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class HaveSelectView: UIView, UITableViewDelegate, UITableViewDataSource, HaveSelectCellDelegate {
    @IBOutlet weak var total_day_screenNumber: UILabel!
    ///屏幕数量
    @IBOutlet weak var totalNumber: UILabel!
    @IBOutlet weak var raceTitle: UILabel!
    ///频次数量
    @IBOutlet weak var receNumber: UILabel!
    ///镜面数量
    @IBOutlet weak var mirrorNumber: UILabel!
    ///影响范围
    @IBOutlet weak var influenceLabel: UILabel!
    ///店铺数量
    @IBOutlet weak var shopCount: UILabel!
    ///屏幕数量
    @IBOutlet weak var screenNumber: UILabel!
    ///观看人数
    @IBOutlet weak var seeNumber: UILabel!
    init(frame: CGRect, dataArr: [ChaxunResultModel], totalDay: Int = 0) {
        super.init(frame: frame)
        self.totalDay = totalDay
        if let subView = Bundle.main.loadNibNamed("HaveSelectView", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        self.tableView.register(UINib.init(nibName: "HaveSelectCell", bundle: Bundle.main), forCellReuseIdentifier: "HaveSelectCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 40
        self.totalNumber.text = String(self.dataArr.count)
        self.dataArr = dataArr
        
    }
    var totalDay: Int = 0
    var finished: ((ChaxunResultModel) -> ())?
    var dataArr: [ChaxunResultModel] = [ChaxunResultModel]() {
        didSet {
            self.totalNumber.text = "总计:" + String(dataArr.count)
            self.shopCount.text = String(dataArr.count) + "家"
            var screenNum: Int = 0
            var seeNum: Int = 0
            var shopNumber: Int = 0
            var coverNumber: Int = 0
            var mirror: Int = 0
            var race: Int = 0
            var total_screen_number: Int = 0
            self.dataArr.forEach { (model) in
                if let screenNumber = model.screen_number, let num = Int(screenNumber) {
                    screenNum += num
                }
                if let screenNumber = model.total_screen_number, let num = Int(screenNumber) {
                    total_screen_number += num
                }
                if let seeNumber = model.watch_number, let num = Int(seeNumber) {
                    seeNum += num
                }
                if let cover = model.covered_number, let num = Int(cover) {
                    coverNumber += num
                }
                if let shop = model.shop_number, let num = Int(shop) {
                    shopNumber += num
                }
                if let mir = model.mirror_number, let num = Int(mir) {
                    mirror += num
                }
                
                if let ra = model.max_covered_number, let num = Int(ra) {
                    race += num
                }
            }
            self.total_day_screenNumber.text = String.init(format: "%d", total_screen_number)
            
            self.shopCount.text = String(shopNumber) + "家"
            self.screenNumber.text = String(screenNum) + "块"
            self.seeNumber.text = String(seeNum) + "人"
            self.influenceLabel.text = String(coverNumber) + "人"
            self.mirrorNumber.text = String(mirror) + "面"
            self.receNumber.text = String(race) + "人"
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HaveSelectCell", for: indexPath) as! HaveSelectCell
        cell.table = tableView
        cell.delegate = self
   
        let model = self.dataArr[indexPath.row]
        cell.model = model
        return cell
    }
    func cellIndexWithCell(cell: HaveSelectCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let model = self.dataArr[indexPath.row]
            self.dataArr.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.finished?(model)
        }
    }
    var clean: (([ChaxunResultModel]) -> ())?
    @IBOutlet var tableView: UITableView!
    @IBAction func clearBtnAction(_ sender: UIButton) {
        self.totalNumber.text = ""
        self.clean?(self.dataArr)
    }
    
    var containerView: UIView!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
        
    }

}
