//
//  DDAddressModel.swift
//  Project
//
//  Created by WY on 2018/3/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

//class DDSelectedAreaApiModel: DDActionModel ,Codable {
//    var message = ""
//    var status : Int  = 0
//    var data : [DDSelectedAddressModel]?
//}
class DDSelectedAddressModel: DDActionModel,Codable {
    var id : String  = "0"
    var name = ""
    var isSelected: Bool? = false
    enum CodingKeys: String, CodingKey {
        case isSelected
        case id
        case name
    }
}
