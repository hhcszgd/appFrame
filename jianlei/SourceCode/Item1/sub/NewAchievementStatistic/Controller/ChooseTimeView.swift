//
//  ChooseTimeView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ChooseTimeView: UIView, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView.init(image: UIImage.init(named: "drop-downbackgroundorange"))
        imageView.frame = CGRect.init(x: frame.width - 24, y: 0, width: 14, height: 6)
        self.addSubview(imageView)
        self.backgroundColor = UIColor.clear
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 6, width: frame.width, height: frame.height), style: UITableView.Style.plain)
        self.addSubview(self.tableView)
        tableView.backgroundColor = UIColor.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 44
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.register(ChoseTimeCell.self, forCellReuseIdentifier: "ChoseTimeCell")

    }
    var arr: [NewAchienementTimeModel] = [NewAchienementTimeModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectStr: String = "" {
        didSet{
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoseTimeCell", for: indexPath) as! ChoseTimeCell
        cell.model = self.arr[indexPath.row]
        if self.arr[indexPath.row].create_at == self.selectStr {
            cell.contentView.backgroundColor = UIColor.colorWithHexStringSwift("ffd9b2")
        }else {
            cell.contentView.backgroundColor = UIColor.white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.arr[indexPath.row]
        self.finished?(model.create_at)
        
    }
    var finished: ((String) -> ())?
    
    deinit {
        mylog("chooseTimeView 销毁")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
class ChoseTimeCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.myTitleLabel)
        self.myTitleLabel.sizeToFit()
        self.myTitleLabel.textAlignment = .center
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.myTitleLabel.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    var model: NewAchienementTimeModel = NewAchienementTimeModel() {
        didSet{
            self.myTitleLabel.text = model.create_at
        
            
        }
    }
    
    var myTitleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

