//
//  SimpleHeaderView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/4.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class SimpleHeaderView: UIView {
    init(frame: CGRect, model: ScreensModel) {
        super.init(frame: frame)
        self.addSubview(self.addressBtn)
        self.addressBtn.title = model.name
        self.addressBtn.isSelected = true
        self.addSubview(self.lineView)
        lineView.backgroundColor = lineColor
        self.lineView.frame = CGRect.init(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
        self.backgroundColor = UIColor.white
    }
    lazy var addressBtn: MyShopAddressBtn = {
        let btn = MyShopAddressBtn.init(frame: CGRect.init(x: 0, y: 0, width: 140, height: 30), title: "")
        btn.titleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
        btn.addTarget(self, action: #selector(changeAddress(btn:)), for: .touchUpInside)
        return btn
    }()
    let lineView = UIView.init()
    @objc func changeAddress(btn: MyShopAddressBtn) {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
