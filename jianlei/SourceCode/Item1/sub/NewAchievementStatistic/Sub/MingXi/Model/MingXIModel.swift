//
//  MingXIModel.swift
//  Project
//
//  Created by 张凯强 on 2019/8/25.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class MingXIModel<T: HandyJSON, Q: HandyJSON>: GDModel {
    var income: String?
    var date_list: [T]?
    var item: [Q]?
    var pay: String?
    
}

class MingXiTimeListModel: GDModel {
    var createAt: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.createAt <-- "create_at"
    }
}
class MingXiItem: GDModel {
    var account_type: String?
    var account_desc: String?
    var detail_time: String?
    var detail_title: String?
    var reciprocal_account: String?
    
    var id: String?
    var createAt: String?
    var hm: String?
    var rq: String?
    var price: String?
    var status: String?
    var mingxiType: String?
    var title: String?
    var desc: String?
    var zsr: String?
    var zzc: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.createAt <-- "create_at"
        mapper <<<
            self.mingxiType <-- "type"
    }
}


