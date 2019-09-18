//
//  AdvertisModel.swift
//  Project
//
//  Created by 张凯强 on 2018/3/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class DDItem4Model<T: HandyJSON, H: HandyJSON>: GDModel {
    var advert_position: [T]?
    var banner: [H]?
}



class AdvertisModel: GDModel {
    var format: String?
    var id: String?
    var name: String?
    var rate_list: [String]?
    var size: String?
    var spec: String?
    var time: String?
    var time_list: [String]?
    var key: String?
    var describe: String?
    var rateStr: String?
    
}
class AdvertiseBannerModel: GDModel {
    var image_url : String = ""
    var link_url : String = ""
}
