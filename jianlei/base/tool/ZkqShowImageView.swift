//
//  ZkqShowImageView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/8.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class ZkqShowImageView: UIView {
    
    let myImageView = UIImageView.init()
    ///重拍
    let repeatedShooting = UIButton.init()
    ///使用
    let userImageBtn = UIButton.init()
    
    init(frame: CGRect = CGRect.init(x: CGFloat(0), y: CGFloat(0), width: SCREENWIDTH, height: SCREENHEIGHT), backImage: UIImage, shopName: String, name: String, mysuperView: UIView, time1: String, time2: String) {
        super.init(frame: frame)
        mysuperView.addSubview(self)
        self.addSubview(self.myImageView)
        self.backgroundColor = UIColor.black
        self.myImageView.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        self.myImageView.contentMode = .scaleAspectFit
        self.myImageView.image = backImage
        self.addSubview(self.repeatedShooting)
        self.addSubview(self.userImageBtn)
        self.repeatedShooting.setTitle("重拍", for: UIControl.State.normal)
        self.repeatedShooting.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.repeatedShooting.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.repeatedShooting.addTarget(self, action: #selector(repeatedShootAction(sender:)), for: UIControl.Event.touchUpInside)
        
        self.userImageBtn.setTitle("使用", for: UIControl.State.normal)
        self.userImageBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.userImageBtn.backgroundColor = UIColor.white
        self.userImageBtn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.userImageBtn.addTarget(self, action: #selector(userImageAction(sender:)), for: UIControl.Event.touchUpInside)
        
        self.repeatedShooting.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-DDSliderHeight - 20)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        self.userImageBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-DDSliderHeight - 20)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        self.userImageBtn.layer.masksToBounds = true
        self.userImageBtn.layer.cornerRadius = 22
        let timeLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 24), textColor: UIColor.white, text: "")
        timeLabel.sizeToFit()
        let time = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.white, text: "")
        time.sizeToFit()
        
        let locationImage = UIImageView.init(image: UIImage.init(named: "loction"))
        let memberImage = UIImageView.init(image: UIImage.init(named: "name"))
        
        let locationLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("c3c2c2"), text: "")
        let nameLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("c3c2c2"), text: "")
        locationLabel.sizeToFit()
        nameLabel.sizeToFit()
        
        self.addSubview(timeLabel)
        self.addSubview(time)
        self.addSubview(locationImage)
        self.addSubview(memberImage)
        self.addSubview(locationLabel)
        self.addSubview(nameLabel)
        let lineView = UIView.init()
        self.addSubview(lineView)
        lineView.backgroundColor = UIColor.white
        lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(33)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(2)
            make.height.equalTo(SCALE * 50)
        }
        time.text = "cccccc"
        timeLabel.text = "cccccc"
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(33)
            make.left.equalTo(lineView.snp.right).offset(13)
            
        }
        time.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.left.equalTo(lineView.snp.right).offset(13)
        }
        locationImage.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalTo(lineView.snp.right).offset(-5)
            make.width.equalTo(locationImage.image?.size.width ?? 0)
            make.height.equalTo(locationImage.image?.size.height ?? 0)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(locationImage)
            make.left.equalTo(locationImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        locationLabel.numberOfLines = 0
        
        memberImage.snp.makeConstraints { (make) in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.left.equalTo(lineView.snp.right).offset(-5)
            make.width.equalTo(memberImage.image?.size.width ?? 0)
            make.height.equalTo(memberImage.image?.size.height ?? 0)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(memberImage)
            make.left.equalTo(memberImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        timeLabel.text = time2
        time.text = time1
        locationLabel.text = shopName
        nameLabel.text = name
        
        
        
    }
    var calendar: Calendar {
        get{
            if #available(iOS 9.0, *) {
                return Calendar.init(identifier: Calendar.Identifier.gregorian)
            } else {
                return Calendar.current
                // Fallback on earlier versions
            }
        }
    }
    
    var finishedAction: ((UIImage?) -> ())?
    ///重拍action
    @objc func repeatedShootAction(sender: UIButton) {
        self.finishedAction?(nil)
        self.removeFromSuperview()
    }
    ///使用
    @objc func userImageAction(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        self.repeatedShooting.isHidden = true
        self.userImageBtn.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: SCREENWIDTH, height: SCREENHEIGHT), false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let finfishImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        self.finishedAction?(finfishImage)
        self.removeFromSuperview()
    }
    deinit {
        mylog("销毁ZkqShowImageViewZkqShowImageViewZkqShowImageViewZkqShowImageView")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
