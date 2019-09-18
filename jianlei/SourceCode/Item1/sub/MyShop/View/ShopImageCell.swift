//
//  ShopImageCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class ShopImageCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var model: ShopImagesModel? {
        didSet{
            if let imgStr = model?.image {
                let str = imgStr + "?imageView2/0/h/400"
                self.imageView.sd_setImage(with: imgStrConvertToUrl(str                                                                                                     ), placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])

                
            }
        }
    }

}
