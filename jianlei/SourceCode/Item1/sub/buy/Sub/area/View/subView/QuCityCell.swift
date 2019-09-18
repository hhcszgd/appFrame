//
//  QuCityCell.swift
//  Project
//
//  Created by 张凯强 on 2018/3/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class QuCityCell: ProvinceCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = selectBackColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    
    var quCityModel: AreaModel? {
        didSet{
            if quCityModel?.isSelected ?? false {
                self.contentView.backgroundColor = UIColor.white
                self.myTitleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
            }else {
                self.myTitleLabel.textColor = UIColor.white
                self.contentView.backgroundColor = UIColor.lightGray
            }
            if let mo = quCityModel {
                self.rightBtn.isHidden = mo.rightBtnIsHidden ?? true
                self.rightBtn.isSelected = mo.rightBtnIsSelect ?? false
            }
            self.myTitleLabel.text = quCityModel?.name
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
