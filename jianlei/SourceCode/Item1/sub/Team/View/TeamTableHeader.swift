//
//  TeamTableHeader.swift
//  Project
//
//  Created by 张凯强 on 2019/8/9.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class TeamTableHeader: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        self.configTuPianGuiFan()
    }
    var myTitleLabel: UILabel?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var myTitleValue: String? {
        didSet{
            self.myTitleLabel?.text = myTitleValue
        }
    }
    
    func configTuPianGuiFan() {
        let imageView = UIView.init()
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
        imageView.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
        self.myTitleLabel = label
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.sizeToFit()
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        let lineView = UIView.init()
        self.contentView.addSubview(lineView)
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        
    }

}
