//
//  TeamManagerModel.swift
//  Project
//
//  Created by 张凯强 on 2019/8/9.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class TeamManagerModel: GDModel {
    var items: [TeamSubModel]?
    var member_type: String?
}

class TeamSubModel: GDModel {
    var team: [TeamSubModel]?
    var id: String?
    var team_member_number: String?
    var team_name: String?
    var team_number: String?
    var title: String?
}
