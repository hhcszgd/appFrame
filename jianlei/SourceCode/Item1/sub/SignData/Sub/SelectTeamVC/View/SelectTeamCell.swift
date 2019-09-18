//
//  SelectTeamCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class SelectTeamCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
        // Initialization code
    }
    var model: SelectTeamModel? {
        didSet {
            self.myTItleLabel.text = model?.team_name
            if let number = model?.team_member_number {
                if number == "" {
                    self.subTitleLabel.text = ""
                }else {
                    self.subTitleLabel.text = String.init(format: "(%@)", model?.team_member_number ?? "0")
                }
            }else {
                self.subTitleLabel.text = ""
            }
            
            if (model?.isSelected ?? false) {
                self.rightImage.image = UIImage.init(named: "select")
            }else {
                self.rightImage.image = UIImage.init(named: "normal")
            }
        }
    }
    @IBOutlet weak var myTItleLabel: UILabel!
    
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
