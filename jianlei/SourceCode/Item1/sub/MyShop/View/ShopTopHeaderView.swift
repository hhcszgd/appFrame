//
//  ShopTopHeaderView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
protocol ShopTopHeaderViewDelegate: NSObjectProtocol {
    func xiyiAction()
}
class ShopTopHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let shopImageView = UIImageView.init()
        let shopNameLabel = UILabel.init()
        let shopStatusLabel = UILabel.init()
        self.shopImageView = shopImageView
        self.shopNameLabel = shopNameLabel
        self.shopStatusLabel = shopStatusLabel
        self.shopNameLabel.textColor = UIColor.colorWithHexStringSwift("cdb27d")
        let lineView = UIView.init()
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
         let statusBackImage = UIImageView.init(image: UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("cdb27d"), UIColor.colorWithHexStringSwift("7b623b")], bound: CGRect.init(x: 0, y: 0, width: 80, height: 28)))
        
        self.addSubview(statusBackImage)
        self.addSubview(shopImageView)
        self.addSubview(shopNameLabel)
        self.addSubview(shopStatusLabel)
        self.addSubview(lineView)
        self.addSubview(self.buttton)
        self.buttton.setImage(UIImage.init(named: "Viewprotocol"), for: UIControl.State.normal)
        shopImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
            make.height.equalTo(shopImageView.snp.width)
        }
        self.buttton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-14)
            make.top.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(44)
        }
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopImageView.snp.right).offset(14)
            make.top.equalToSuperview()
            make.height.equalTo(44 * SCALE)
            make.right.equalTo(self.buttton.snp.left)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(shopImageView.snp.right).offset(14)
            make.right.equalToSuperview().offset(-14)
            make.top.equalTo(shopNameLabel.snp.bottom)
            make.height.equalTo(1)
        }
//        lineView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        
        
        statusBackImage.snp.makeConstraints { (make) in
            make.left.equalTo(shopImageView.snp.right).offset(14)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        statusBackImage.layer.masksToBounds = true
        statusBackImage.layer.cornerRadius = 14
        shopStatusLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(statusBackImage.snp.centerX)
            make.centerY.equalTo(statusBackImage.snp.centerY)
        }
        shopStatusLabel.textColor = UIColor.colorWithHexStringSwift("323232")
        shopStatusLabel.font = GDFont.systemFont(ofSize: 10)
//        shopStatusLabel.layer.cornerRadius = 14 * SCALE
//        shopStatusLabel.layer.masksToBounds = true
//        shopStatusLabel.layer.borderColor = UIColor.colorWithHexStringSwift("ff7d09").cgColor
//        shopStatusLabel.layer.borderWidth = 1
//        shopStatusLabel.textAlignment = .center
        self.buttton.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        
        //改版隐藏查看协议按钮
        self.buttton.isHidden = true
        
        
        
    }
    weak var delegate: ShopTopHeaderViewDelegate?
    @objc func btnClick(btn: UIButton) {
        self.delegate?.xiyiAction()
    }
    //1,总店，2分店
    var tyep: String = "2"
    
    let buttton: UIButton = UIButton.init()
    ///设置店铺的信息
    func configWithInfo(image: String, name: String, status: String, screenStatus: String) {
        self.shopImageView.sd_setImage(with: imgStrConvertToUrl(image), placeholderImage: UIImage.init(named: "generalstorephoto"), options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
        self.shopNameLabel.text = name
        var statusStr: String = ""
        if self.tyep == "1" {
            switch status {
            case "0":
                statusStr = "willAduit"|?|
            case "1":
                statusStr = "aduitPass"|?|
  
            case "2":
                statusStr = "aduitFailure"|?|
         
                
            default:
                break
            }
        }else {
            switch status {
            case "0":
                statusStr = "applyWillAduit"|?|
            case "1":
                statusStr = "applyFailure"|?|
            case "3":
                statusStr = "installAduit"|?|
            case "2":
                statusStr = "willInstall"|?|
            case "4":
                statusStr = "installFailure"|?|
            case "5":
                if screenStatus == "1" {
                    statusStr = "screenStatusNormal"|?|
                }else {
                    statusStr = "screenStatusUnNormal"|?|
                }
            case "6":
                statusStr = "shopClose"|?|
                
            default:
                break
            }
        }

        let statusSize = statusStr.sizeWith(font: GDFont.systemFont(ofSize: 12), maxSize: CGSize.init(width: self.frame.width - 100, height: 32))
        
        self.shopStatusLabel.text = statusStr
        
    }
    var shopImageView: UIImageView!
    var shopNameLabel: UILabel!
    var shopStatusLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
