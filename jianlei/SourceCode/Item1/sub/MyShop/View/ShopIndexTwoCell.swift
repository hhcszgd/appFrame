//
//  ShopIndexTwoCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ShopIndexTwoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView = ShopQianYueView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        self.contentView.addSubview(subView)
        self.targetView = subView
        
    }
    weak var targetView: ShopQianYueView?
    
    var zongDianData: ShopZongDianInfo<ShopInfoModel, FendianList>? {
        didSet{
            self.targetView?.zongDianData = zongDianData
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
