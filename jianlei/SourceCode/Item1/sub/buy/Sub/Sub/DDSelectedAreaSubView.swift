//
//  DDSelectedAreaSubView.swift
//  Project
//
//  Created by 张凯强 on 2018/5/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSelectedAreaSubView: UIView, UITableViewDataSource, UITableViewDelegate {

    init(frame: CGRect, title: String, dataArr: [DDSelectedAddressModel]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        if let subView = Bundle.main.loadNibNamed("DDSelectedAreaSubView", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        self.table.register(UINib.init(nibName: "StreetCell", bundle: Bundle.main), forCellReuseIdentifier: "StreetCell")
        self.titleLabel.text = title
        self.table.separatorStyle = .none
        
        
    }
    var dataArr: [DDSelectedAddressModel] = [DDSelectedAddressModel]() {
        didSet{
            
            dataArr.first?.isSelected = true
            self.table.reloadData()
        }
    }
    
    
    @IBOutlet var table: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StreetCell = tableView.dequeueReusableCell(withIdentifier: "StreetCell", for: indexPath) as! StreetCell
        cell.model = self.dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataArr.forEach { (model) in
            model.isSelected = false
        }
        let model = self.dataArr[indexPath.row]
        model.isSelected = !model.isSelected!
        self.table.reloadData()
    }
    var containerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cancleBtn: UIButton!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
