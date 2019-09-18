
//
//  CustomShopInfoCell.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class CustomShopInfoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, type: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
