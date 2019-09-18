//
//  HaveSelectCell.swift
//  Project
//
//  Created by 张凯强 on 2018/4/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
protocol HaveSelectCellDelegate: NSObjectProtocol {
    func cellIndexWithCell(cell: HaveSelectCell)
}
class HaveSelectCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Initialization code
    }
    var table: UITableView!
    @IBOutlet var areaName: UILabel!
    
    @IBAction func cancleAction(_ sender: UIButton) {
        self.delegate?.cellIndexWithCell(cell: self)
        
    }
    weak var delegate: HaveSelectCellDelegate?
    var model: ChaxunResultModel? {
        didSet{
            self.areaName.text = model?.buy_area_name
            self.area.text = model?.buy_parent_area_name
        }
    }
    @IBOutlet var area: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
