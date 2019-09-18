//
//  AddTeamMemberView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class AddTeamMemberView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.myTitleLabel.sizeToFit()
        self.contentView.addSubview(self.myTitleLabel)
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
    }
    let myTitleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
