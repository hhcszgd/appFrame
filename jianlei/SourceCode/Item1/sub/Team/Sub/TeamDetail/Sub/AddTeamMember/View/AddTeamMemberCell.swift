//
//  AddTeamMemberCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class AddTeamMemberCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(myImage)
        self.contentView.addSubview(self.myImage2)
        self.myImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        self.myImage.layer.masksToBounds = true
        self.myImage.layer.cornerRadius = 20
        self.title.sizeToFit()
        self.title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.myImage.snp.right).offset(10)
        }
        self.contentView.addSubview(self.subTitle)
        self.subTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.title.snp.right).offset(10)
        }
        self.myImage2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-13)
            make.width.height.equalTo(24)
        }
    }
    let title: UILabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    let myImage = UIImageView.init()
    let myImage2 = UIImageView.init()
    let subTitle: UILabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: AddteamSubModel? {
        didSet {
            if model?.isSelected ?? false {
                self.myImage2.image = UIImage.init(named: "team_admin_select")
            }else {
                self.myImage2.image = UIImage.init(named: "team_admin_select_no")
            }
            self.myImage.sd_setImage(with: imgStrConvertToUrl(model?.avatar ?? ""), placeholderImage: DDPlaceholderImage, options: SDWebImageOptions.cacheMemoryOnly)
            self.title.text = model?.name
        }
    }
    var teamDetailInfoModel: DeleteMemberModel? {
        didSet{
            if teamDetailInfoModel?.isSelected ?? false {
                self.myImage2.image = UIImage.init(named: "team_admin_select")
            }else {
                self.myImage2.image = UIImage.init(named: "team_admin_select_no")
            }
            self.myImage.sd_setImage(with: imgStrConvertToUrl(teamDetailInfoModel?.member_tx ?? ""), placeholderImage: DDPlaceholderImage, options: SDWebImageOptions.cacheMemoryOnly)
            self.title.text = teamDetailInfoModel?.member_name
//            self.subTitle.text = teamDetailInfoModel?.member_mobile
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
