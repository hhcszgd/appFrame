
//
//  ReapeatModel.swift
//  Project
//
//  Created by 张凯强 on 2019/8/23.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class ReapeatModel<T: HandyJSON>: GDModel {
    var item: [T]?
    var team_name: String?
}
class ReapeatSubModel<T: HandyJSON>: GDModel {
    var shop_name: String?
    var items: [T]?
}
class ReapeatSubSubModel: GDModel {
    var id: String?
    var member_avatar: String?
    var member_name: String?
    var shop_address: String?
    var shop_name: String?
    var tm: String?
    var member_id: String?
}


