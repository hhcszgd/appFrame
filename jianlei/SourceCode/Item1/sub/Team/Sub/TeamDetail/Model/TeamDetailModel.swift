//
//  TeamDetailModel.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class TeamDetailModel<T: HandyJSON>: GDModel {
    var member_id: String?
    var team_member_num: String?
    var team_name: String?
    var member_type: String?
    var members: [T]?
    var title: String?
    var sign_data_permission: String?
    
}

class TeamDetailMemberInfo: GDModel {
    var id: String?
    var avatar: String?
    var name: String?
    var team_id: String?
    var member_id: String?
    var member_type: String?
    var isSelected: Bool = false
    
}
