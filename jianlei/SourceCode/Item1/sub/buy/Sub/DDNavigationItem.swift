//
//  DDNavigationItem.swift
//  Project
//
//  Created by WY on 2018/3/6.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDNavigationItem: UICollectionViewCell {
    let label = UILabel()
    var selectedBackColor : UIColor = UIColor.orange
    
    var selectedStatus : Bool = false {
        didSet{
            if selectedStatus {
                self.backgroundColor = selectedBackColor
            }else{
                self.backgroundColor = UIColor.white

            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(label)
        label.backgroundColor = .clear
        self.backgroundColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth  = true 
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.contentView.bounds
    }
}
