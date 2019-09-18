//
//  DDMessageApiModel.swift
//  Project
//
//  Created by WY on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

//class DDMessageApiModel: DDActionModel , Codable{
//    var status:Int = -1
//    var message:String = ""
//    var data:[DDMessageModel]?
//}
class DDMessageModel : DDActionModel , Codable{
    var id:String = "3"
    /// 1公告 , 否則是系統消息
    var message_type:String? = ""
    var title:String = "this is title"
    /// 1 : 已读  , 0 : 未读
    var status : String? = "1"
    var create_at : String? = "2018-11-30"
//    var status : Int? = 0 
}
