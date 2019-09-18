//
//  CalanderHeaderView.swift
//  Project
//
//  Created by 张凯强 on 2018/4/22.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class CalanderHeaderView: UICollectionReusableView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(myTitleLabel)
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        myTitleLabel.backgroundColor = UIColor.white
        self.myTitleLabel.textAlignment = NSTextAlignment.center
    }
    let myTitleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
