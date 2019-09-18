//
//  MingXiCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class MingXiCell: UITableViewCell {
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var bussinessTitle: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var timelabel: UILabel!
    @IBOutlet var money: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Initialization code
    }
    @IBOutlet weak var lineView: UIView!
    var model: MingXiItem? {
        didSet{
            self.timelabel.text = model?.createAt ?? ""
            var price: String = ""
            if model?.type == "1" {
                self.money.textColor = UIColor.colorWithHexStringSwift("ffab34")
                price = (model?.price ?? "")
            }
            if model?.type == "2" {
                self.money.textColor = UIColor.colorWithHexStringSwift("323232")
                price = (model?.price ?? "")
                
            }
            var imageStr: String = ""
            switch model?.account_type {
            case "-1":
                imageStr = "money_cashwithdrawal"
            case "4":
                imageStr = "money_electricity"
            case "1","2", "3":
                imageStr = "money_bonus"
            default:
                imageStr = "money_electricity"
            }
            self.myImageView.image = UIImage.init(named: imageStr)
            self.address.text = model?.hm
            self.money.text = price
            self.bussinessTitle.text = model?.title
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
