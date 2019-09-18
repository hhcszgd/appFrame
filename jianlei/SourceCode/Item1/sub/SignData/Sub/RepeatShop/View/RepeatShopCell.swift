//
//  RepeatShopCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/16.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class RepeatShopCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.avture.layer.masksToBounds = true
        self.avture.layer.cornerRadius = 20
        // Initialization code
    }
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var avture: UIImageView!
    var model: ReapeatSubSubModel? {
        didSet {
            self.avture.sd_setImage(with: imgStrConvertToUrl(model?.member_avatar ?? ""), placeholderImage: DDPlaceholderImage, options: SDWebImageOptions.cacheMemoryOnly)
            self.title.text = model?.member_name
            self.time.text = model?.tm
            self.shopName.text = model?.shop_name
            self.shopAddress.text = model?.shop_address
        }
    }

}
