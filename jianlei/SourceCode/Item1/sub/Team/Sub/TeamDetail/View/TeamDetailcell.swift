//
//  TeamDetailcell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class TeamDetailcell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.avtureImage)
        self.contentView.addSubview(self.memberName)
        self.contentView.addSubview(self.subImageView)
        self.avtureImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(self.avtureImage.snp.width)
        }
        self.subImageView.image = UIImage.init(named: "leader")
        self.avtureImage.layer.masksToBounds = true
        self.avtureImage.layer.cornerRadius = frame.width * 0.3
        self.subImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.avtureImage.snp.right).offset(5)
            make.bottom.equalTo(self.avtureImage.snp.bottom)
            make.width.equalTo(self.avtureImage.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.avtureImage.snp.height).multipliedBy(0.5)
        }
        self.memberName.snp.makeConstraints { (make) in
            make.top.equalTo(self.avtureImage.snp.bottom).offset(3)
            make.left.right.equalToSuperview()
        }
        self.memberName.textAlignment = .center
        
    }
    let subImageView = UIImageView.init()
    let avtureImage: UIImageView = UIImageView.init()
    let memberName: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    var teamModel: TeamDetailMemberInfo? {
        didSet{
            self.memberName.text = teamModel?.name
            self.avtureImage.sd_setImage(with: imgStrConvertToUrl(teamModel?.avatar ?? ""), placeholderImage: UIImage.init(named: "defaultheadimage"), options: SDWebImageOptions.cacheMemoryOnly)
            
            if teamModel?.member_type == "1" || teamModel?.member_type == nil || teamModel?.member_type == ""{
                self.subImageView.isHidden = true
            }else if teamModel?.member_type == "2" {
                self.subImageView.isHidden = false
                self.subImageView.image = UIImage.init(named: "leader")
            }else if teamModel?.member_type == "3" {
                self.subImageView.isHidden = false
                self.subImageView.image = UIImage.init(named: "admin")
            }
            
            
        }
    }
    var model: SignDetailSubModel? {
        didSet{
            self.memberName.text = model?.name
            self.avtureImage.sd_setImage(with: imgStrConvertToUrl(model?.avatar ?? ""), placeholderImage: UIImage.init(named: "defaultheadimage"), options: SDWebImageOptions.cacheMemoryOnly)
            self.subImageView.isHidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
