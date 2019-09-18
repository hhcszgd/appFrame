//
//  DDChangeTimeLimitAlert.swift
//  Project
//
//  Created by WY on 2018/3/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDChangeTimeLimitAlert: DDCoverView {

    let contentView = UIView()
    let titleLable = UILabel()
    let confirm = UIButton()
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(contentView)
        contentView.backgroundColor = .black
        self.contentView.addSubview(titleLable)
        titleLable.textAlignment = .center
        titleLable.numberOfLines = 2
        titleLable.textColor = .white
        titleLable.font = GDFont.systemFont(ofSize: 14)
        titleLable.text = "修改投放时间失败\n您的修改次数已用完"
        self.contentView.addSubview(confirm)
        confirm.setTitle("确认", for: UIControlState.normal)
        confirm.setTitleColor(UIColor.orange, for: UIControlState.normal )
        confirm.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    @objc func buttonClick(sender:UIButton)  {
        self.remove()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 40
        let contentViewW = self.bounds.width - toBorder * 2
        let contentViewH = contentViewW * 0.42
        contentView.frame = CGRect(x: toBorder, y: self.bounds.height / 2 - contentViewH, width: contentViewW, height: contentViewH)
        titleLable.frame =  CGRect(x: 0, y: 10, width: contentViewW, height:64)
        confirm.frame = CGRect(x: 0, y: titleLable.frame.maxY  , width: self.contentView.bounds.width, height: 40)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
