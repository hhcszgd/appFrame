//
//  NewAchienementApiModel.swift
//  Project
//
//  Created by WY on 2019/8/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit


class NewAchienementDataModel: DDActionModel ,Codable {
    var order_number: String?
    ///0,是未认证，1是已认证
    /// -1:待提交 , 0:待审核 , 1:审核通过 , 2:审核不通过
    var id_card: String?
    var avatar : String?
    var count_price : CGFloat? = 0
    var create_at : Int? = -1
    var date_list : [NewAchienementTimeModel]?
    var lower_price: CGFloat? = 0
    var member_id : String? = ""
    var name : String?
    var number : String? = "" // 工号
    var price : CGFloat? = 0
    var screen_number : String?
    var shop_number: String?
    var message : [NewAchienementMsgModel]?
    var payment_password : String?
    var balance : String?
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        screen_number =  NewAchienementDataModel.decodeProterty(container: container, codingKey: CodingKeys.screen_number)
//        do {
//            screen_number = try container.decode(type(of: screen_number), forKey: CodingKeys.screen_number)//按String处理
//        } catch  {
//            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.screen_number)//再按Int处理
//            screen_number = "\(levelInt)"
//        }
        avatar = try container.decodeIfPresent(type(of: avatar), forKey: CodingKeys.avatar) as? String
        count_price = try container.decodeIfPresent(type(of: count_price), forKey: CodingKeys.count_price) as? CGFloat
        create_at = try container.decodeIfPresent(type(of: create_at), forKey: CodingKeys.create_at) as? Int
        date_list = try container.decodeIfPresent(type(of: date_list), forKey: CodingKeys.date_list) as? [NewAchienementTimeModel]
        
        lower_price = try container.decodeIfPresent(type(of: lower_price), forKey: CodingKeys.lower_price) as? CGFloat
        member_id = try container.decodeIfPresent(type(of: member_id), forKey: CodingKeys.member_id) as? String
        name = try container.decodeIfPresent(type(of: name), forKey: CodingKeys.name) as? String
        number = try container.decodeIfPresent(type(of: number), forKey: CodingKeys.number) as? String
        price = try container.decodeIfPresent(type(of: price), forKey: CodingKeys.price) as? CGFloat
        order_number = try container.decodeIfPresent(type(of: order_number), forKey: CodingKeys.order_number) as? String
        id_card = NewAchienementDataModel.decodeProterty(container: container, codingKey: CodingKeys.id_card)

        balance =  NewAchienementDataModel.decodeProterty(container: container, codingKey: CodingKeys.balance)
//        do {
//            balance = try container.decode(type(of: balance), forKey: CodingKeys.balance)//按String处理
//        } catch  {
//            let levelInt =  try container.decode(Float.self , forKey: CodingKeys.balance)//再按Int处理
//            balance = "\(levelInt)"
//        }
        shop_number = NewAchienementDataModel.decodeProterty(container: container, codingKey: CodingKeys.shop_number)
//        do {
//            shop_number = try container.decode(type(of: shop_number), forKey: CodingKeys.shop_number)//按String处理
//        } catch  {
//            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.shop_number)//再按Int处理
//            shop_number = "\(levelInt)"
//        }
        payment_password = NewAchienementDataModel.decodeProterty(container: container, codingKey: CodingKeys.payment_password)
//        do {
//            payment_password = try container.decode(type(of: payment_password), forKey: CodingKeys.payment_password)//按String处理
//        } catch  {
//            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.payment_password)//再按Int处理
//            payment_password = "\(levelInt)"
//        }
        
        message = try container.decodeIfPresent(type(of: message), forKey: CodingKeys.message) as? [NewAchienementMsgModel]
        
        
    }
    private enum CodingKeys: String, CodingKey  {
        case avatar
        case count_price
        case create_at
        case date_list
        case lower_price
        case member_id
        case name
        case number
        case price
        case screen_number
        case shop_number
        case message
        case payment_password
        case balance
        case order_number
        case id_card
    }
    
    
    
}

class NewAchienementTimeModel: DDActionModel ,Codable{
    var create_at : String = ""
}

class NewAchienementMsgModel: DDActionModel ,Codable{
    var create_at : String = ""
    var title : String = ""
}
