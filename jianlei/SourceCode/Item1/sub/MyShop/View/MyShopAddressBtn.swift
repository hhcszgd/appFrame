//
//  MyShopAddressBtn.swift
//  Project
//
//  Created by 张凯强 on 2019/8/4.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class MyShopAddressBtn: UIControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.scrollView.backgroundColor = UIColor.clear
        self.titleLabel.backgroundColor = UIColor.clear
        self.addSubview(self.imageView)
        self.scrollView.addSubview(self.titleLabel)
        self.imageView.image = unSelectImage
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = frame.size.height / 2.0
        self.imageView.image = unSelectImage
        let imageX: CGFloat = frame.size.width - 25
        let imageY: CGFloat = 5
        let imageW: CGFloat = 20
        let ImageH: CGFloat = 20
        self.imageView.frame = CGRect.init(x: imageX, y: imageY, width: imageW, height: ImageH)
        self.scrollView.frame = CGRect.init(x: 12, y: 0, width: frame.size.width - 12 - 30, height: frame.size.height)
        
        self.scrollView.isUserInteractionEnabled = false
        self.titleLabel.text = title
        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.masksToBounds = true
        
    }
    var timer: Timer?
    
    @objc func left() {
        let size = title?.sizeSingleLine(font: self.titleLabel.font)
        let width = size?.width ?? 0
        let superWidth: CGFloat = self.scrollView.bounds.size.width
        let move = width - superWidth
        UIView.animate(withDuration: 1) {
            
        }
        self.scrollView.contentOffset = CGPoint.init(x: self.scrollView.contentOffset.x + 1, y: 0)
        if self.scrollView.contentOffset.x > (move + 10){
            self.scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        }
        
        
        
        
        
    }
    
    func invalidate() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init()
        scroll.isScrollEnabled = true
        
        self.addSubview(scroll)
        return scroll
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    var title: String? {
        didSet{
            
            
            
            self.titleLabel.text = title
            let size = title?.sizeSingleLine(font: self.titleLabel.font)
            let width = size?.width ?? self.scrollView.bounds.size.width
            let height = self.scrollView.bounds.size.height
            self.scrollView.contentSize = CGSize.init(width: width, height: height)
            if width >= self.scrollView.bounds.size.width {
                self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: width, height: self.scrollView.bounds.size.height)
            }else {
                self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: self.scrollView.bounds.size.width, height: self.scrollView.bounds.size.height)
            }
            let move: CGFloat = width - self.scrollView.bounds.size.width
            var timeInterval: CGFloat = 0
            if self.timer == nil {
                
                if move > 50 {
                    timeInterval = 0.05
                }else {
                    timeInterval = 0.1
                }
                self.timer = Timer.init(timeInterval: TimeInterval(timeInterval)
                    , target: self, selector: #selector(left), userInfo: nil, repeats: true)
            }
            
            
            if width <= self.scrollView.bounds.size.width {
                self.invalidate()
            }else {
                if let tt = self.timer {
                    RunLoop.current.add(tt, forMode: RunLoop.Mode.common)
                }
                
                
            }
        
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected {
                self.imageView.image = selectImage
            }else {
                self.imageView.image = unSelectImage
            }
        }
    }
    var selectImage: UIImage = UIImage.init(named: "pulluparrow")!
    var unSelectImage: UIImage = UIImage.init(named: "dropdownarrow")!
    lazy var imageView: UIImageView = {
        let image = UIImageView.init()
        image.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        image.contentMode = UIView.ContentMode.center
        
        return image
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = GDFont.systemFont(ofSize: 17)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        return label
    }()
    deinit {
        mylog("销毁")
    }
    
}
