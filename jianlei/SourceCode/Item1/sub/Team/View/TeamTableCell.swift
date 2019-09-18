//
//  TeamTableCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/9.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class TeamTableCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
        self.configUI()
        
    }
    var teamModel: TeamSubModel?{
        didSet{
            self.myTitleLabel?.text = (teamModel?.team_name ?? "") + "(\(teamModel?.team_member_number ?? "")人)"
        }
    }
    var myTitleLabel: UILabel?
    func configUI() {
        let imageView = UIImageView.init()
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(7.5)
            make.height.equalTo(13)
        }
        imageView.image = UIImage.init(named: "returnhsk")
        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
        self.myTitleLabel = label
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(15)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
