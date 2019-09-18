//
//  StreetCell.swift
//  Project
//
//  Created by 张凯强 on 2018/5/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class StreetCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        // Initialization code
    }
    
    @IBOutlet var label: UILabel!
    var model: DDSelectedAddressModel? {
        didSet {
            self.label.text = "   \(model?.name ?? "")"
            if (model?.isSelected) ?? false {
                self.label.backgroundColor = UIColor.colorWithHexStringSwift("ea9202")
            }else {
                self.label.backgroundColor = UIColor.clear
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
