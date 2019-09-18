//
//  ZKQCustomCell.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/9/8.
//  Copyright © 2019 WY. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class ShopInfoCell: UIView {
    ///列表類型的cell
    init(frame: CGRect, title: String?, subTitle: String?) {
        super.init(frame: frame)
        let backView = UIView.init()
        backView.layer.cornerRadius = 8
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowRadius = 3
        backView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        backView.backgroundColor = UIColor.white
        self.addSubview(backView)
        
        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-13)
        }
        self.backgroundColor = UIColor.white
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.title.snp.makeConstraints { (make) in
            make.left.equalTo(backView.snp.left).offset(13)
            make.top.equalTo(backView.snp.top).offset(8)
        }
        self.subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(backView.snp.left).offset(13)
            make.top.equalTo(self.title.snp.bottom).offset(8)
            make.right.equalTo(backView.snp.right).offset(-13)
        }
        self.title.text = title
        self.subTitle.text = subTitle
    }
    
    
    //左边图片右边图片，只有一个标题
    init(leftImage: String, title: String, rightImage: String, isUserinteractionEnable: Bool) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.title.textColor = UIColor.colorWithHexStringSwift("999999")
        self.isUserInteractionEnabled = isUserinteractionEnable
        self.addSubview(self.imageView)
        self.addSubview(self.imageView2)
        self.addSubview(self.title)
        self.imageView.image = UIImage.init(named: leftImage)
        self.imageView2.image = UIImage.init(named: rightImage)
        self.title.text = title
        self.title.sizeToFit()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        self.addGestureRecognizer(tap)
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.width.equalTo(self.imageView.image?.size.width ?? 0)
            make.height.equalTo(self.imageView.image?.size.height ?? 0)
        }
        self.title.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        self.imageView2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
            make.width.equalTo(self.imageView2.image?.size.width ?? 0)
            make.height.equalTo(self.imageView2.image?.size.height ?? 0)
        }
        let lineView = UIView.init()
        self.addSubview(lineView)
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        self.lineView = lineView
        
    }
    ///最多有五张图片的cell
    init(frame: CGRect, title: String, images: [String]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.title)
        self.addSubview(self.imageView)
        self.addSubview(self.imageView2)
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(15)
        }
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-13)
            make.width.height.equalTo(66)
        }
        self.imageView2.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(self.imageView.snp.left).offset(-13)
            make.width.height.equalTo(66)
        }
        self.title.text = title
        self.addSubview(imageview3)
        imageview3.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView2.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-13)
            make.width.height.equalTo(66)
        }
        self.addSubview(self.imageView4)
        self.imageView4.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView2.snp.bottom).offset(10)
            make.right.equalTo(self.imageview3.snp.left).offset(-13)
            make.width.height.equalTo(66)
            
        }
        self.addSubview(self.imageView5)
        self.imageView5.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView2.snp.bottom).offset(10)
            make.right.equalTo(self.imageView4.snp.left).offset(-13)
            make.width.height.equalTo(66)
        }
        
        
        
        
    }
    var images: [String] = [] {
        didSet{
            for (index, url) in images.enumerated() {
                switch index {
                case 0:
                    self.imageView.sd_setImage(with: imgStrConvertToUrl(url), placeholderImage: defaultImage, options: [SDWebImageOptions.cacheMemoryOnly, .retryFailed], completed: nil)
                case 1:
                    self.imageView2.sd_setImage(with: imgStrConvertToUrl(url), placeholderImage: defaultImage, options: [SDWebImageOptions.cacheMemoryOnly, .retryFailed], completed: nil)
                case 2:
                    self.imageview3.sd_setImage(with: imgStrConvertToUrl(url), placeholderImage: defaultImage, options: [SDWebImageOptions.cacheMemoryOnly, .retryFailed], completed: nil)
                case 3:
                    self.imageView4.sd_setImage(with: imgStrConvertToUrl(url), placeholderImage: defaultImage, options: [SDWebImageOptions.cacheMemoryOnly, .retryFailed], completed: nil)
                case 4:
                    self.imageView5.sd_setImage(with: imgStrConvertToUrl(url), placeholderImage: defaultImage, options: [SDWebImageOptions.cacheMemoryOnly, .retryFailed], completed: nil)
                default:
                    break
                }
            }
        }
    }
    let defaultImage = UIImage.init(named: "media16")
    let imageview3 = UIImageView.init()
    let imageView4 = UIImageView.init()
    let imageView5 = UIImageView.init()

    let rightBtn2: PrivateBtnInShopCell = PrivateBtnInShopCell()
    init(frame: CGRect, title: String, btnTitle: String = "", btnImage: String, btnSelectImage: String) {
        super.init(frame: frame)
        let leftView = UIView.init()
        leftView.backgroundColor = UIColor.colorWithHexStringSwift("ef4e07")
        self.addSubview(leftView)
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.addSubview(self.rightBtn2)
        self.backgroundColor = UIColor.white
        self.title.sizeToFit()
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(3)
        }
        self.title.snp.makeConstraints { (make) in
            make.left.equalTo(leftView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        self.rightBtn2.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(44)
        }
        self.rightBtn2.setTitle(btnTitle, for: UIControl.State.normal)
        
        self.rightBtn2.setImage(UIImage.init(named: btnImage), for: UIControl.State.normal)
        self.rightBtn2.setImage(UIImage.init(named: btnSelectImage), for: UIControl.State.selected)
        
        self.title.text = title
        
    }
    var lineView: UIView?
    ///左边是橘黄色的竖杠的带有标题的和按钮的header
    init(frame: CGRect, title: String, rightImage: String, subTitle: String? = nil) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.leftView)
        self.leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
        self.leftView.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        self.addSubview(self.title)
        
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        self.title.font = UIFont.boldSystemFont(ofSize: 15)
        self.title.text = title
        if rightImage.count > 0 {
            self.imageView.image = UIImage.init(named: rightImage)
        }
        
        self.addSubview(self.imageView)
        self.imageView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
            make.width.equalTo(self.imageView.image?.size.width ?? 0)
            make.height.equalTo(self.imageView.image?.size.height ?? 0)
        }
        self.addSubview(self.subTitle)
        self.subTitle.textColor = UIColor.colorWithHexStringSwift("ff7d09")
        self.subTitle.sizeToFit()
        self.subTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.imageView.snp.left).offset(10)
        }
        self.subTitle.text = subTitle
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        self.addGestureRecognizer(tap)
    }
    var rightImageHidden: Bool = true {
        didSet{
            if rightImageHidden {
                self.imageView.snp.updateConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-3)
                    make.width.equalTo(0)
                    make.height.equalTo(0)
                }
            }else {
                self.imageView.snp.updateConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-13)
                    make.width.equalTo(self.imageView.image?.size.width ?? 0)
                    make.height.equalTo(self.imageView.image?.size.height ?? 0)
                }
            }
            self.layoutIfNeeded()
        }
    }
    
    ///右邊有照片和subtitle。且有回調芳芳shopInfoBtnClick
    init(title: String, rightImage: String, subTitle: String? = nil) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.title)
        
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
        }
        self.title.font = UIFont.systemFont(ofSize: 14)
        self.title.text = title
        if rightImage.count > 0 {
            self.imageView.image = UIImage.init(named: rightImage)
        }
        
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
            make.width.equalTo(self.imageView.image?.size.width ?? 0)
            make.height.equalTo(self.imageView.image?.size.height ?? 0)
        }
        self.addSubview(self.subTitle)
        self.subTitle.textColor = UIColor.colorWithHexStringSwift("999999")
        self.subTitle.sizeToFit()
        self.subTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.imageView.snp.left).offset(-10)
        }
        self.subTitle.text = subTitle
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        self.addGestureRecognizer(tap)
    }
    
    
    @objc func tapAction(tap: UITapGestureRecognizer) {
        self.shopInfoBtnClick?(true)
    }
    
    
    let leftView = UIView.init()
    ///添加了textfield
    init(frame: CGRect, title: String?, image: String, subTitle: String, placeholder: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.title)
        self.addSubview(self.imageView)
        self.addSubview(self.textfield)
        self.addSubview(self.subTitle)
        self.imageView.image = UIImage.init(named: image)
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.width.equalTo(self.imageView.image?.size.width ?? 0).multipliedBy(1.1)
            make.height.equalTo(self.imageView.image?.size.height ?? 0).multipliedBy(1.1)
        }
        self.title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imageView.snp.right).offset(6)
            make.width.equalTo(100)
        }
        
        
        self.title.text = title
        self.subTitle.text = subTitle
        self.textfield.placeholder = placeholder
        self.textfield.setValue(UIColor.colorWithHexStringSwift("999999"), forKeyPath: "_placeholderLabel.textColor")
        self.textfield.font = UIFont.systemFont(ofSize: 14)
        self.textfield.textColor = UIColor.colorWithHexStringSwift("323232")
        self.subTitle.textColor = UIColor.colorWithHexStringSwift("323232")
        self.subTitle.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
        }
        self.subTitle.textAlignment = .right
        self.textfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.title.snp.right).offset(15)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(self.subTitle.snp.left).offset(-10)
        }
        self.backgroundColor = UIColor.white
        self.title.font = UIFont.systemFont(ofSize: 14)
        self.subTitle.font = UIFont.systemFont(ofSize: 14)
    }
    let textfield: MYTextField = MYTextField.init()
    
    
    
    ///左边图片只有只有一个标题
    init(frame: CGRect, leftImage: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.imageView)
        self.addSubview(self.title)
        self.imageView.image = UIImage.init(named: leftImage)
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.width.equalTo(self.imageView.image?.size.width ?? 0).multipliedBy(1.1)
            make.height.equalTo(self.imageView.image?.size.height ?? 0).multipliedBy(1.1)
        }
        self.title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        self.title.textColor = UIColor.colorWithHexStringSwift("999999")
        self.title.font = UIFont.systemFont(ofSize: 14)
        
    }
    ///左边的title后面紧跟着detailTitle
    init(frame: CGRect, lefttitle: String) {
        super.init(frame: frame)
        
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.title.sizeToFit()
        self.subTitle.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
        }
        self.subTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.title.snp.right).offset(5)
        }
        self.subTitle.textColor = UIColor.colorWithHexStringSwift("ff7d09")
        self.subTitle.numberOfLines = 0
        self.title.text = lefttitle
        self.backgroundColor = UIColor.white
    }
    
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.title.sizeToFit()
        self.subTitle.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
        }
        self.subTitle.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
        }
        self.subTitle.textAlignment = .right
        self.subTitle.numberOfLines = 0
        self.title.text = title
        self.backgroundColor = UIColor.white
    }
    ///上下结构的title， subtitle.
    init(frame: CGRect, titleValue: String, subTitleValue: String) {
        super.init(frame: frame)
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.title.sizeToFit()
        self.subTitle.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        self.subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom).offset(13)
            make.right.equalToSuperview().offset(-13)
            make.left.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-10)
        }
        self.subTitle.textAlignment = .left
        self.subTitle.numberOfLines = 0
        self.title.text = titleValue
        self.subTitle.text = subTitleValue
        self.backgroundColor = UIColor.white
    }
    let title: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    let subTitle: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    
    var subTitleValue: String? {
        didSet{
            self.subTitle.text = subTitleValue
        }
    }
    init(frame: CGRect, image: String, title: String) {
        super.init(frame: frame)
        self.addSubview(self.title)
        self.addSubview(self.imageView)
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(15)
        }
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
            make.width.height.equalTo(66)
        }
        //        self.imageView.sd_setImage(with: imgStrConvertToUrl(image), placeholderImage: UIImage.init(), options: SDWebImageOptions.cacheMemoryOnly)
        self.title.text = title
        self.backgroundColor = UIColor.white
        
    }
    init(frame: CGRect, title: String, subTitle: String, btnTitle: String = "", btnImage: String, btnSelectImage: String) {
        super.init(frame: frame)
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.addSubview(self.rightBtn)
        self.backgroundColor = UIColor.white
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(15)
        }
        self.rightBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(44)
        }
        self.rightBtn.setImage(UIImage.init(named: btnImage), for: UIControl.State.normal)
        self.rightBtn.setImage(UIImage.init(named: btnSelectImage), for: UIControl.State.selected)
        self.rightBtn.addTarget(self, action: #selector(btnAction(sender:)), for: UIControl.Event.touchUpInside)
        self.subTitle.snp.makeConstraints { (make) in
            make.right.equalTo(self.rightBtn.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        self.subTitle.sizeToFit()
        self.subTitle.text = subTitle
        self.title.text = title
        //        self.rightBtn.isSelected = true
        
    }
//    let rightBtn2: PrivateBtnInShopCell = PrivateBtnInShopCell()
//    init(frame: CGRect, title: String, btnTitle: String = "", btnImage: String, btnSelectImage: String) {
//        super.init(frame: frame)
//        let leftView = UIView.init()
//        leftView.backgroundColor = UIColor.colorWithHexStringSwift("ef4e07")
//        self.addSubview(leftView)
//        self.addSubview(self.title)
//        self.addSubview(self.subTitle)
//        self.addSubview(self.rightBtn2)
//        self.backgroundColor = UIColor.white
//        self.title.sizeToFit()
//        leftView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(13)
//            make.centerY.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.4)
//            make.width.equalTo(3)
//        }
//        self.title.snp.makeConstraints { (make) in
//            make.left.equalTo(leftView.snp.right).offset(10)
//            make.centerY.equalToSuperview()
//        }
//        self.rightBtn2.snp.makeConstraints { (make) in
//            make.top.bottom.equalToSuperview()
//            make.right.equalToSuperview().offset(-20)
//            make.width.equalTo(44)
//        }
//        self.rightBtn2.setTitle(btnTitle, for: UIControl.State.normal)
//
//        self.rightBtn2.setImage(UIImage.init(named: btnImage), for: UIControl.State.normal)
//        self.rightBtn2.setImage(UIImage.init(named: btnSelectImage), for: UIControl.State.selected)
//
//        self.title.text = title
//
//    }
//
    init(leftImage: String, title: String, subTitle: String, btnTitle: String = "", btnImage: String, btnSelectImage: String) {
        super.init(frame: CGRect.zero)
        self.addSubview(self.imageView)
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.addSubview(self.rightBtn)
        self.imageView.image = UIImage.init(named: leftImage)
        self.backgroundColor = UIColor.white
        self.title.sizeToFit()
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            make.width.equalTo(self.imageView.image?.size.width ?? 0)
            make.height.equalTo(self.imageView.image?.size.height ?? 0)
        }
        
        
        self.title.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(13)
            make.centerY.equalToSuperview()
        }
        self.rightBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(44)
        }
        self.rightBtn.setImage(UIImage.init(named: btnImage), for: UIControl.State.normal)
        self.rightBtn.setImage(UIImage.init(named: btnSelectImage), for: UIControl.State.selected)
        self.rightBtn.addTarget(self, action: #selector(btnAction(sender:)), for: UIControl.Event.touchUpInside)
        self.subTitle.snp.makeConstraints { (make) in
            make.right.equalTo(self.rightBtn.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        self.subTitle.sizeToFit()
        self.subTitle.text = subTitle
        self.title.text = title
        
    }
    
    @objc func btnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.shopInfoBtnClick?(sender.isSelected)
        self.rightshopInfoBtnClick?(sender)
    }
    var rightshopInfoBtnClick: ((UIButton) -> ())?
    var shopInfoBtnClick: ((Bool) -> ())?
    lazy var rightBtn: UIButton = {
        let btn = UIButton.init()
        return btn
    }()
    init(frame: CGRect, rightImage: String, title: String) {
        super.init(frame: frame)
        self.addSubview(self.title)
        self.addSubview(self.subTitle)
        self.addSubview(self.imageView)
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(15)
        }
        let image = UIImage.init(named: rightImage)
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
            make.width.equalTo(image?.size.width ?? 0)
            make.height.equalTo(image?.size.height ?? 0)
        }
        self.subTitle.snp.makeConstraints { (make) in
            make.right.equalTo(self.imageView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            
        }
        self.imageView.image = UIImage.init(named: rightImage)
        self.title.text = title
        self.backgroundColor = UIColor.white
        
    }
    init(frame: CGRect, title: String, image: String, image2: String) {
        super.init(frame: frame)
        self.addSubview(self.title)
        self.addSubview(self.imageView)
        self.addSubview(self.imageView2)
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(15)
        }
        self.imageView2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
            make.width.height.equalTo(66)
        }
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.imageView2.snp.left).offset(-13)
            make.width.height.equalTo(66)
        }
        self.title.text = title
        self.backgroundColor = UIColor.white
        
    }
    ///左边是图片，title，右边是图片
    init(title: String, leftImage: String, rightIMage: String) {
        super.init(frame: CGRect.zero)
        self.addSubview(self.title)
        self.addSubview(self.imageView)
        self.addSubview(self.imageView2)
        
    }
    
    
//    init(frame: CGRect, title: String?, image: String, subTitle: String, placeholder: String) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.white
//        self.addSubview(self.title)
//        self.addSubview(self.imageView)
//        self.addSubview(self.textfield)
//        self.addSubview(self.subTitle)
//        self.imageView.image = UIImage.init(named: image)
//        self.imageView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(13)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(self.imageView.image?.size.width ?? 0).multipliedBy(1.1)
//            make.height.equalTo(self.imageView.image?.size.height ?? 0).multipliedBy(1.1)
//        }
//        self.title.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(self.imageView.snp.right).offset(6)
//            make.width.equalTo(85)
//        }
//        self.title.text = title
//        self.subTitle.text = subTitle
//        self.textfield.placeholder = placeholder
//        self.textfield.setValue(UIColor.colorWithHexStringSwift("999999"), forKeyPath: "_placeholderLabel.textColor")
//        self.textfield.font = UIFont.systemFont(ofSize: 14)
//        self.textfield.textColor = UIColor.colorWithHexStringSwift("323232")
//        self.subTitle.textColor = UIColor.colorWithHexStringSwift("323232")
//        self.subTitle.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-13)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(44)
//        }
//        self.subTitle.textAlignment = .right
//        self.textfield.snp.makeConstraints { (make) in
//            make.left.equalTo(self.title.snp.right).offset(15)
//            make.top.bottom.equalToSuperview()
//            make.right.equalTo(self.subTitle.snp.left).offset(-10)
//        }
//        self.backgroundColor = UIColor.white
//        self.title.font = UIFont.systemFont(ofSize: 14)
//        self.subTitle.font = UIFont.systemFont(ofSize: 14)
//    }
//    let textfield: MYTextField = MYTextField.init()
    
    
    
    
    var image1Str: String? {
        didSet{
            self.imageView.sd_setImage(with: imgStrConvertToUrl(image1Str ?? ""), placeholderImage: defaultImage, options: SDWebImageOptions.cacheMemoryOnly)
        }
    }
    var image2Str: String? {
        didSet{
            self.imageView2.sd_setImage(with: imgStrConvertToUrl(image2Str ?? ""), placeholderImage: defaultImage, options: SDWebImageOptions.cacheMemoryOnly)
        }
    }
    let imageView = UIImageView.init()
    let imageView2 = UIImageView.init()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
