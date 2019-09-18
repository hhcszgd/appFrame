//
//  AddTeamModel.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class AddTeamModel<T: HandyJSON>: GDModel {
    var title: String?
    var items: [T]?
}
class AddteamSubModel: GDModel {
    var avatar: String?
    var id: String?
    var mobile: String?
    var name: String?
    var name_prefix: String?
    var isSelected: Bool = false
    
    
}
