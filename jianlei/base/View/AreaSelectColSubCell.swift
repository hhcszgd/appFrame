//
//  AreaSelectColSubCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class AreaSelectColSubCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    @IBOutlet var areaLabel: UILabel!
    
    var model: AreaModel? {
        didSet{
            if let myModel: AreaModel = model {
                self.areaLabel.text = myModel.name
                if myModel.isSelected ?? false {
                    self.areaLabel.textColor = UIColor.colorWithHexStringSwift("ea9061")
                    self.contentView.backgroundColor = UIColor.white
                    
                }else {
                    self.areaLabel.textColor = UIColor.colorWithHexStringSwift("333333")
                    self.contentView.backgroundColor = lineColor
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
