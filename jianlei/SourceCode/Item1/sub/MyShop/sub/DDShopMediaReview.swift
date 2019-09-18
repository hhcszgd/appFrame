//
//  DDShopMediaReview.swift
//  Project
//
//  Created by WY on 2019/8/21.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDShopMediaReview: DDAlertContainer {
    lazy var imageview = UIButton()
    let cancel = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageview)
        imageview.addTarget(self , action: #selector(imageClick(sender:)), for: UIControl.Event.touchUpInside)
        imageview.adjustsImageWhenHighlighted  = false 
    }
    @objc  func imageClick(sender:UIButton) {
        self.remove()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let x : CGFloat = 44
        let w : CGFloat = self.bounds.width - x * 2
        let h = w * 2
        let y = (self.bounds.height - h)/2
        imageview.frame = CGRect(x:x, y:y, width: w, height: h )
        
    }
    
    
    
    deinit {
        print("vvvvvvvv    container销毁了")
    }
    
}
