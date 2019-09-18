//
//  AreaSelectColCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class AreaSelectColCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "AreaSelectColSubCell", bundle: Bundle.main), forCellReuseIdentifier: "AreaSelectColSubCell")
       
        self.tableView.backgroundColor = lineColor
        
        // Initialization code
    }
    var dataArr: [AreaModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AreaSelectColSubCell = tableView.dequeueReusableCell(withIdentifier: "AreaSelectColSubCell", for: indexPath) as! AreaSelectColSubCell
        cell.model = self.dataArr[indexPath.row]
        
        return cell
    }
    var selectedIndexPath: IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = nil
        for (index, model) in self.dataArr.enumerated() {
            if model.isSelected ?? false {
                self.selectedIndexPath = IndexPath.init(row: index, section: 0)
            }
        }
        
        if selectedIndexPath != nil {
            let model = self.dataArr[(selectedIndexPath?.row)!]
            model.isSelected = false
        }
        selectedIndexPath = indexPath
        let model = self.dataArr[indexPath.row]
        model.isSelected = true
        self.cellBlock!(model)
        self.tableView.reloadData()
    }
    var cellBlock: ((AreaModel) -> ())?

}
