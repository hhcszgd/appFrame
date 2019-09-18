//
//  WeiHuListModel.swift
//  Project
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class WeiHuListModel: GDModel {
    var content: String?
    var create_at: String?
    var id: String?
    var maintain_content: String?
    var rq: String?
    var member_name: String?
    var evaluate: String?
    var sign_id: String?
    

    
}
class FendianList: GDModel {
    var branch_shop_address: String?
    var branch_shop_area_id: String?
    var branch_shop_area_name: String?
    var branch_shop_name: String?
    var headquarters_id: String?
    var id: String?
    var shop_id: String?
    var status: String?
    var shop_image: String?
}



class ShopDetailModel<T: HandyJSON, K: HandyJSON, Q: HandyJSON>: GDModel {
    var shop: T?
    var imageArr: [K]?
    var screens: [Q]?
    var item: [Q]?
    var shopImage: String?
    
    
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.imageArr <-- "shop_images"
        mapper <<<
            self.shopImage <-- "shop_image"
    }
}
class ShopZongDianInfo<T: HandyJSON, K: HandyJSON>: GDModel {
    var shop_info: T?
    
    var headList: [K]?
    
}
class ShopImagesModel: GDModel {
    var image: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.image <-- "image_url"
    }
}

class MaintainModel: GDModel {
    var content: String?
    var create_at: String?
    ///签到id
    var id: String?
    var maintain_content: String?
    var member_name: String?
    var sign_id: String?
    
    
    
}
class ShopInfoModel: GDModel {
    ///是否统一
    var agreed: String?
    var adminMemberID: String?
    var applyScreenNumber: String?
    var areaName: String?
    var auditingTime: String?
    var auditingUser: String?
    var createAt: String?
    var failReasion: String?
    var memberId: String?
    var memberName: String?
    var mobile: String?
    var name: String?
    var screenNumber: String?
    var screenStatus: String?
    var status: String?
    var applyName: String?
    var address: String?
    var number: String?
    var screens: [ScreensModel]?
    var shopImage: String = ""
    ///电费补贴
    var electric_charge: String?
    //协议
    var agreement_name: String?
    var screen_start_at: String?
    ///是否同意协议0不同意，1同意
    var reward_agreed: String?
    //管理人电话
    var adminMobile: String?
    //管理人姓名
    var adminMemberName: String?
    //申请人
    var applyMobile: String?
    
    var business_licence: String?
    var company_address: String?
    var company_area_id: String?
    var company_area_name: String?
    var company_name: String?
    var corporation_member_id: String?
    var examine_status: String?
    var id: String?
    var identity_card_back: String?
    var identity_card_front: String?
    var identity_card_num: String?
    var member_id: String?
    var registration_mark: String?
    var head_image: String?
    var other_image: [String]?
    var image_num: String?
    var loop_time: String?
    var apply_brokerage: String?
    var apply_brokerage_by_month: String?
    var month_price: String?
    ///是否有维修信息
    var maintain: MaintainModel?
    
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.adminMemberID <-- "admin_member_id"
        mapper <<<
            self.applyScreenNumber <-- "apply_screen_number"
        mapper <<<
            self.areaName <-- "area_name"
        mapper <<<
            self.auditingTime <-- "auditing_time"
        mapper <<<
            self.auditingUser <-- "auditing_user"
        mapper <<<
            self.createAt <-- "create_at"
        mapper <<<
            self.failReasion <-- "fail_reason"
        mapper <<<
            self.memberId <-- "member_id"
        mapper <<<
            self.memberName <-- "member_name"
        mapper <<<
            self.screenNumber <-- "screen_number"
        mapper <<<
            self.screenStatus <-- "screen_status"
        mapper <<<
            self.applyName <-- "apply_name"
        mapper <<<
            self.adminMobile <-- "admin_mobile"
        mapper <<<
            self.adminMemberName <-- "admin_member_name"
        mapper <<<
            self.applyMobile <-- "apply_mobile"
        mapper <<<
            self.shopImage <-- "shop_image"
    }
}

class ScreensModel: GDModel {
    var name: String?
    var status: String?
    var id: String?
    var isSelected: Bool = false
}
