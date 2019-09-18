//
//  ShopIndexFenThreeCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ShopIndexFenThreeCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = ShopInfoView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        self.contentView.addSubview(view)
        self.targetView = view
    }
    weak var targetView: ShopInfoView?
    var model: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>? {
        didSet{
            self.targetView?.model = model
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
