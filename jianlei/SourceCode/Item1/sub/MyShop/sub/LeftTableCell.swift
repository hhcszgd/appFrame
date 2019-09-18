//
//  LeftTableCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class LeftTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    @IBOutlet var title: UILabel!
    
    var model: TimeModel? {
        didSet{
            guard let myModel = self.model else {
                return
            }
            
            self.title.text = myModel.title + "年"
            if myModel.isSelected {
                self.title.textColor = UIColor.colorWithHexStringSwift("ea9061")
                self.contentView.backgroundColor = UIColor.colorWithRGB(red: 255, green: 255, blue: 255)
                
            }else {
                self.title.textColor = UIColor.colorWithHexStringSwift("333333")
                self.contentView.backgroundColor = UIColor.colorWithRGB(red: 242, green: 242, blue: 242)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
