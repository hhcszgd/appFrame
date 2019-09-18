//
//  NewAchieveBtn.swift
//  Project
//
//  Created by 张凯强 on 2019/8/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class NewAchieveBtn: UIButton {

    var myTitleLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "myTitleLabel".hashValue)!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addSubview(newValue!)
        }
        get {
            return objc_getAssociatedObject(self, UnsafeRawPointer.init(bitPattern: "myTitleLabel".hashValue)!) as? UILabel
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleLabelRect = self.titleLabel?.frame
        self.myTitleLabel?.frame = CGRect.init(x: 0, y: (titleLabelRect?.maxY)! + 2, width: frame.width, height: 20)
    }
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        if let image = self.currentImage {
            let imagey = SCALE * 8
            let imageHeight = image.size.height
            
            let titleWidth = self.currentTitle?.sizeWith(font: GDFont.systemFont(ofSize: 13), maxSize: CGSize.init(width: 80, height: 20)) ?? CGSize.init(width: 80, height: 20)
            let titleY = imagey + imageHeight + 8 * SCALE
            let x = (contentRect.width - titleWidth.width) / 2.0
            
            return CGRect.init(x: x, y: titleY, width: titleWidth.width, height: titleWidth.height + 2)
            
            
        }else {
            return CGRect.zero
        }
        
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if let image = self.currentImage {
            
            let y = SCALE * 8
            let x = (contentRect.width - image.size.width) / 2.0
            let width = image.size.width
            let height = image.size.height
            return CGRect.init(x: x, y: y, width: width, height: height)
        }else {
            return CGRect.zero
        }
        
    }
    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }

}
