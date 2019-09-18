//
//  BoundtySortView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/22.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class BoundtySortView: UIView, UITableViewDelegate, UITableViewDataSource {

    init(frame: CGRect, dataList: [SortModel]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.dataArr = dataList
        
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: Int(SCREENWIDTH), height: dataList.count * 50), style: UITableView.Style.plain)
        tableView.rowHeight = 50
        tableView.separatorColor = UIColor.colorWithHexStringSwift("f0f0f0")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SortCell.self, forCellReuseIdentifier: "SortCell")
        self.addSubview(tableView)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortCell
        
        cell.model = self.dataArr[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataArr.forEach { (model) in
            model.isSelected = false
        }
        let model = self.dataArr[indexPath.row]
        model.isSelected = true
        tableView.reloadData()
        self.removeFromSuperview()
        self.finishedClick?(model.id)
    }
    
    var finishedClick:((String) -> ())?
    
    
    var dataArr: [SortModel] = [SortModel]()
    
    deinit {
        mylog("xiaohu")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class SortCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.myView)
        self.contentView.backgroundColor = UIColor.white
        self.myView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.myView.isUserInteractionEnabled = false
    }
    var model: SortModel? {
        didSet{
            self.myView.title.text = model?.title
            if model?.isSelected ?? false {
                self.myView.imageView.isHidden = false
            }else {
                self.myView.imageView.isHidden = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let myView = ShopInfoCell.init(title: "", rightImage: "select")
}
