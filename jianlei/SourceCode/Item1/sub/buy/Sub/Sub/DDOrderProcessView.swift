//
//  DDOrderProcessView.swift
//  Project
//
//  Created by WY on 2018/3/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
private let lableW : CGFloat = SCREENWIDTH / 4
private let lableH : CGFloat = 24
private let imageWH : CGFloat = 26
private let processLineW = lableW - imageWH - 10
private let processLineH : CGFloat = 2
class DDOrderProcessView: UIView {
    enum AddProcessType : Int {
        case type1//进度为0
        case type2
        case type3
        case type4
        case type5//进度为满
        case type6//订单完成
    }
    let cancleStatusLabel = UILabel()
    let imageView1 = DDImageView(frame: CGRect(x: 0, y: 0, width: imageWH, height: imageWH))
    let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: lableW, height: lableH))
    let imageView2 = DDImageView(frame: CGRect(x: 0, y: 0, width: imageWH, height: imageWH))
    let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: lableW, height: lableH))
    let imageView3 = DDImageView(frame: CGRect(x: 0, y: 0, width: imageWH, height: imageWH))
    let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: lableW, height: lableH))
    let imageView4 = DDImageView(frame: CGRect(x: 0, y: 0, width: imageWH, height: imageWH))
    let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: lableW, height: lableH))
    let statusBar1 = DDProcessLine(frame: CGRect(x: 0, y: 0, width: processLineW, height: processLineH))
    let statusBar2 = DDProcessLine(frame: CGRect(x: 0, y: 0, width: processLineW, height: processLineH))
    let statusBar3 = DDProcessLine(frame: CGRect(x: 0, y: 0, width: processLineW, height: processLineH))
    var process : AddProcessType = .type1{
        didSet{
            switch process {
            case .type1:
                
                break
            case .type2:
                self.imageView1.backgroundColor = UIColor.orange
                self.label1.textColor = UIColor.orange
                statusBar1.progress = 0.5
                break
            case .type3:
                self.imageView1.backgroundColor = UIColor.orange
                self.imageView2.backgroundColor = UIColor.orange
                self.label1.textColor = UIColor.orange
                self.label2.textColor = UIColor.orange
                statusBar1.progress = 1
                statusBar2.progress = 0.5
                break
            case .type4:
                self.imageView1.backgroundColor = UIColor.orange
                self.imageView2.backgroundColor = UIColor.orange
                self.imageView3.backgroundColor = UIColor.orange
                self.label1.textColor = UIColor.orange
                self.label2.textColor = UIColor.orange
                self.label3.textColor = UIColor.orange
                statusBar1.progress = 1
                statusBar2.progress = 1
                statusBar3.progress = 0.5
                
                break
            case .type5:
                self.imageView1.backgroundColor = UIColor.orange
                self.imageView2.backgroundColor = UIColor.orange
                self.imageView3.backgroundColor = UIColor.orange
                self.imageView4.backgroundColor = UIColor.orange
                self.label1.textColor = UIColor.orange
                self.label2.textColor = UIColor.orange
                self.label3.textColor = UIColor.orange
                self.label4.textColor = UIColor.orange
                statusBar1.progress = 1
                statusBar2.progress = 1
                statusBar3.progress = 1
                break
            case .type6:
//                layoutIfNeeded()
                setNeedsLayout()
                break
            }
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.addSubview(cancleStatusLabel)
        if let image = UIImage(named:"orderclosure"){
            let imgAttributeStr = image.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -4, width: 22, height: 20))
            var  mutableImgAttribute = NSMutableAttributedString(attributedString: imgAttributeStr)
            
            let attributeStr =     NSMutableAttributedString(string:  " 订单已关闭")
             mutableImgAttribute.append(attributeStr)
            cancleStatusLabel.attributedText = mutableImgAttribute
        }else{
            
            cancleStatusLabel.text = "订单已关闭"
        }
        cancleStatusLabel.backgroundColor = .lightGray
        cancleStatusLabel.textColor = .white
        cancleStatusLabel.textAlignment = .center 
        self.addSubview(imageView1)
        self.addSubview(imageView2)
        self.addSubview(imageView3)
        self.addSubview(imageView4)
        self.addSubview(label1)
        self.addSubview(label2)
        self.addSubview(label3)
        self.addSubview(label4)
        self.addSubview(statusBar1)
        self.addSubview(statusBar2)
        self.addSubview(statusBar3)
        imageView1.image = UIImage(named:"tobesubmitted")
        imageView2.image = UIImage(named:"tobeaudited")
        imageView3.image = UIImage(named:"tobeputon")
        imageView4.image = UIImage(named:"havebeenputin")
        label1.text = "素材待提交"
        label2.text = "素材待审核"
        label3.text = "广告待投放"
        label4.text = "广告已投放"
        
        label1.font = GDFont.systemFont(ofSize: 12)
        label2.font = GDFont.systemFont(ofSize: 12)
        label3.font = GDFont.systemFont(ofSize: 12)
        label4.font = GDFont.systemFont(ofSize: 12)
        label1.textAlignment = .center
        label2.textAlignment = .center
        label3.textAlignment = .center
        label4.textAlignment = .center
        
        label1.textColor =  UIColor.colorWithHexStringSwift("b4b4b4")
        label2.textColor =  UIColor.colorWithHexStringSwift("b4b4b4")
        label3.textColor =  UIColor.colorWithHexStringSwift("b4b4b4")
        label4.textColor =  UIColor.colorWithHexStringSwift("b4b4b4")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageCenterY : CGFloat = self.bounds.height * (4 / 10)
        imageView1.center = CGPoint(x: self.bounds.width/8, y: imageCenterY)
        imageView2.center = CGPoint(x: self.bounds.width/8 + self.bounds.width/4, y: imageCenterY)
        imageView3.center = CGPoint(x: self.bounds.width/8 + self.bounds.width/2, y: imageCenterY)
        imageView4.center = CGPoint(x: self.bounds.width - self.bounds.width/8, y: imageCenterY)
        statusBar1.center = CGPoint(x: self.bounds.width/4, y: imageCenterY)
        statusBar2.center = CGPoint(x: self.bounds.width/2, y: imageCenterY)
        statusBar3.center = CGPoint(x: self.bounds.width/4 * 3, y: imageCenterY)
        label1.center = CGPoint(x: imageView1.center.x, y: imageView1.frame.maxY + label1.bounds.height / 2)
        label2.center = CGPoint(x: imageView2.center.x, y: imageView2.frame.maxY + label2.bounds.height / 2)
        label3.center = CGPoint(x: imageView3.center.x, y: imageView3.frame.maxY + label3.bounds.height / 2)
        label4.center = CGPoint(x: imageView4.center.x, y: imageView3.frame.maxY + label4.bounds.height / 2)
        cancleStatusLabel.frame = self.bounds
        if self.process == .type6 {
            for subview in self.subviews{
                if subview == cancleStatusLabel{
                    subview.isHidden = false
                }else{
                    subview.isHidden = true
                }
            }
        }else{
            for subview in self.subviews{
                if subview == cancleStatusLabel{
                    subview.isHidden = true
                }else{
                    subview.isHidden = false
                }
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class DDImageView : UIView {
        let imageView = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame )
            self.addSubview(imageView)
            self.backgroundColor = UIColor.colorWithHexStringSwift("b4b4b4")
        }
//        var selectedBackColor = UIColor.colorWithHexStringSwift("b4b4b4")
        var image : UIImage?{
            didSet{
                self.imageView.image = image
            }
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.imageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.width - 12, height: self.bounds.height - 12)
            self.imageView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            self.layer.cornerRadius = self.bounds.width/2
            self.layer.masksToBounds = true
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
