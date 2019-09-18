//
//  DDBlankView.swift
//  Project
//
//  Created by WY on 2019/8/17.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDBlankView: DDMaskBaseView {
    var action : (() -> Void )?
    lazy var imageView = UIImageView()
    lazy var titleLabel  = UILabel()
    private var image : UIImage?
    
    public init( message: String? = nil ,image : UIImage? ){
        super.init(frame: CGRect.zero)
       self.backgroundColor  = UIColor.white
        backgroundColorAlpha = 1
        if let identifyImage = image{
            self.image = identifyImage
            self.addSubview(imageView)
            imageView.image = identifyImage
            imageView.contentMode = .scaleAspectFit
        }
        
        self.titleLabel.text = message
        self.addSubview(titleLabel)
        
        self.titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.gray
        titleLabel.font = GDFont.systemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        
       
    }
    override func corverViewPart() {
        self.action?()
    }
    override func whiteSpaceAction(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action?()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWH : CGFloat = 100
        self.imageView.frame =  CGRect(x: self.bounds.width/2 - imageWH/2, y:  self.bounds.height/2 - imageWH, width: imageWH, height: imageWH)
        
        let titleLabelLeftMargin : CGFloat = 10
        let titleMaxW = self.bounds.width - titleLabelLeftMargin  * 2
        
        var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
        titleLabelH = titleLabelH > 44 ? titleLabelH : 44
        self.titleLabel.frame = CGRect(x: titleLabelLeftMargin, y: self.imageView.frame.maxY + 20, width: titleMaxW, height: titleLabelH)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


