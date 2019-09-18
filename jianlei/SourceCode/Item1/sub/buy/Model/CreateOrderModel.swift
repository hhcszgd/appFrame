//
//  CreateOrderModel.swift
//  Project
//
//  Created by 张凯强 on 2018/3/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class CreateOrderModel: GDModel {
    ///业务员手机号
    var salesman_mobile: String = ""
    ///广告id
    var advert_id: String = ""
    ///播放频率
    var rate: String = ""
    ///广告时长
    var advert_time: String = ""
    ///支付方式
    var payment_type: String = ""
    ///总天数
    var toal_day: String = ""
    ///投放地区id
    var area: String = ""
    ///开始时间
    var start_at: String = ""
    ///结束时间
    var end_at: String = ""
}
