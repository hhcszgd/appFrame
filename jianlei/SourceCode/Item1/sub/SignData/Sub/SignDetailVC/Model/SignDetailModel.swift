
//
//  SignDetailModel.swift
//  Project
//
//  Created by 张凯强 on 2019/8/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class SignDetailModel<T: HandyJSON>: GDModel {
    var items: [T]?
    var team_name: String?
    
}
class SignDetailSubModel: GDModel {
    var avatar: String?
    var member_id: String?
    var name: String?
    var team_id: String?
    var team_type: String?
}
