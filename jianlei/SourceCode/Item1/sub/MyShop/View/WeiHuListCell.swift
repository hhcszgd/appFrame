//
//  WeiHuListCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class WeiHuListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.evealuteLabel.layer.masksToBounds = true
        self.evealuteLabel.layer.cornerRadius = 10
        self.evealuteLabel.layer.borderWidth = 1
        self.selectionStyle = .none
        // Initialization code
    }
    @IBOutlet weak var timeAndContent: UILabel!
    
    @IBOutlet weak var evealuteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    var model: WeiHuListModel? {
        didSet{
            self.nameLabel.text = model?.member_name
            self.timeAndContent.text = (model?.rq ?? "") + "   " + (model?.content ?? "")
            switch model?.evaluate {
            case "0":
                self.evealuteLabel.layer.borderColor = UIColor.colorWithHexStringSwift("cccccc").cgColor
                self.evealuteLabel.textColor = UIColor.colorWithHexStringSwift("cccccc")
                self.evealuteLabel.text = "未评价"
            case "3":
                self.evealuteLabel.layer.borderColor = UIColor.colorWithHexStringSwift("cccccc").cgColor
                self.evealuteLabel.textColor = UIColor.colorWithHexStringSwift("cccccc")
                self.evealuteLabel.text = "差评"
                
            case "1":
                self.evealuteLabel.layer.borderColor = UIColor.colorWithHexStringSwift("ff7d09").cgColor
                self.evealuteLabel.textColor = UIColor.colorWithHexStringSwift("ff7d09")
                self.evealuteLabel.text = "好评"
                
            case "2":
                self.evealuteLabel.layer.borderColor = UIColor.colorWithHexStringSwift("ffbd83").cgColor
                self.evealuteLabel.textColor = UIColor.colorWithHexStringSwift("ffbd83")
                self.evealuteLabel.text = "中评"
            default:
                break
            }
        }
    }
    
    
    
}
