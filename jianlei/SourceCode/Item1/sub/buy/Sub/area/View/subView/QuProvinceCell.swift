//
//  QuProvinceCell.swift
//  Project
//
//  Created by 张凯强 on 2018/3/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class QuProvinceCell: ProvinceCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    var quProvinceModel: AreaModel? {
        didSet{
            if quProvinceModel?.isSelected ?? false {
                self.contentView.backgroundColor = secondSelectedBackColor
                self.myTitleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
            }else {
                self.myTitleLabel.textColor = UIColor.white
                self.contentView.backgroundColor = unSelectBackColor
            }
            if let mo = quProvinceModel {
                self.rightBtn.isHidden = mo.rightBtnIsHidden
                self.rightBtn.isSelected = mo.rightBtnIsSelect
            }
            self.myTitleLabel.text = quProvinceModel?.name
        }
    }
    let secondSelectedBackColor: UIColor = UIColor.lightGray
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
