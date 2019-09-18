//
//  MingXiHeader.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/8/30.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class MingXiHeader: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.timeTile)
        self.contentView.addSubview(self.subTitleLabel)
        self.timeTile.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(15)
        }
        self.subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(self.timeTile.snp.bottom).offset(13)
            
        }
        
        
        
    }
    var model: MingXiItem? {
        didSet{
            if let income = model?.zsr, let out = model?.zzc {
                let str: String = "MingXiVCIncome"|?| + income + "  " + "MingXiVCPay"|?| + out
                self.timeTile.text = model?.rq
                self.subTitleLabel.text = str
            }
            
        }
    }
    
    let timeTile: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    
    let subTitleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
