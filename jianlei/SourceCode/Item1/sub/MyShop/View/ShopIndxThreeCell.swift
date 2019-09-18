//
//  ShopIndxThreeCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
protocol ShopIndxThreeCellDelegate: NSObjectProtocol {
    func addFenDian()
    
}
class ShopIndxThreeCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = ShopFendianView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - DDSliderHeight - 44), style: UITableView.Style.plain)
        self.contentView.addSubview(view)
        self.targetView = view
        self.editBtn.frame = CGRect.init(x: 0, y: frame.height - 44 - DDSliderHeight, width: frame.width, height: 44 + DDSliderHeight)
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.contentView.addSubview(self.editBtn)
        
    }
    
    
    lazy var editBtn: UIButton = {
        let btn = UIButton.init()
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: DDSliderHeight + 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        btn.layer.addSublayer(gradientLayer)
        btn.setTitle("shop_add_fendian"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    weak var delegate: ShopIndxThreeCellDelegate?
    @objc func btnClick(btn: UIButton) {
        self.delegate?.addFenDian()
    }
    
    weak var targetView: ShopFendianView?
    var shopID: String = "" {
        didSet {
            self.targetView?.shopID = shopID
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
