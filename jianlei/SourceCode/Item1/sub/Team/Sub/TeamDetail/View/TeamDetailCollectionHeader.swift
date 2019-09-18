//
//  TeamDetailCollectionHeader.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class TeamDetailCollectionHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.teamName)
        self.addSubview(self.teamType)
        self.addSubview(self.teamNumber)
        self.addSubview(self.teamMember)
        let width = frame.width
        self.teamName.frame = CGRect.init(x: 0, y: 0, width: width, height: 54)
        self.teamName.subTitle.textColor = UIColor.colorWithHexStringSwift("323232")
        self.teamType.frame = CGRect.init(x: 0, y: self.teamName.max_Y + 1, width: width, height: 54)
        self.teamNumber.frame = CGRect.init(x: 0, y: self.teamType.max_Y + 1, width: width, height: 54)
        self.teamMember.frame = CGRect.init(x: 0, y: self.teamNumber.max_Y + 20, width: width, height: 54)
        self.teamName.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        self.teamName.addGestureRecognizer(tap)
        
    }
    @objc func tapAction(tap: UITapGestureRecognizer) {
        self.tapBlock?()
    }
    var tapBlock: (() -> ())?
    
    let teamName = ShopInfoCell.init(frame: CGRect.zero, rightImage: "edit", title: "team_name"|?|)
    let teamType = ShopInfoCell.init(frame: CGRect.zero, title: "team_type"|?|)
    let teamNumber = ShopInfoCell.init(frame: CGRect.zero, title: "team_number"|?|)
    let teamMember = ShopInfoCell.init(frame: CGRect.zero, title: "team_member"|?|)
    var teamModel: TeamDetailModel<TeamDetailMemberInfo>?{
        didSet{
            self.teamName.subTitleValue = teamModel?.team_name
            self.teamNumber.subTitleValue = (teamModel?.team_member_num ?? "") + "人"
            self.teamType.subTitleValue = teamModel?.title
            if teamModel?.member_type !=  "3" {
                self.teamName.rightImageHidden = true
                self.teamName.isUserInteractionEnabled = false
            }else {
                self.teamName.rightImageHidden = false
                self.teamName.isUserInteractionEnabled = true
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
