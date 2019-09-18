//
//  CityCell.swift
//  Project
//
//  Created by 张凯强 on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        // Initialization code
    }
    @IBOutlet var myTitlelabel: UILabel!
    @IBOutlet var rightImageView: UIImageView!
    var model: AreaModel? {
        didSet{
            self.myTitlelabel.text = model?.name
            if model?.isSelected ?? false {
                self.rightImageView.image = UIImage.init(named: "multiselectselected")
            }else {
                self.rightImageView.image = UIImage.init(named: "checkboxisnotselected")
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
