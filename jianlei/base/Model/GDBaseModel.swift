//
//  GDBaseModel.swift
//  zjlao
//
//  Created by WY on 2019/8/15.
//  Copyright © 2019年 jianlei. All rights reserved.
//

import UIKit
import HandyJSON

//处理数据的模型
class BaseModel<T: HandyJSON>: HandyJSON {
    var status: Int = -1
    var message: String = ""
    var data: T?
    required init() {
        
    }
    func mapping(mapper: HelpingMapper) {
        
    }
}
class BaseModelForArr<T: HandyJSON>: HandyJSON {
    var status: Int = -1
    var message: String = ""
    var data: [T]?
    required init() {
        
    }
    func mapping(mapper: HelpingMapper) {
        
    }
}
class GDModel: NSObject,  HandyJSON {
    
    //跳转之前是否需要判断登录状态 , 默认为否
  
    var navTitle : String?//控制器标题
    ///如果是相同的页面构造，用来区分
    var type: String = ""
    var isNeedJudge : Bool = false
    var actionKey : Actionkey = Actionkey.空
    var step: String = ""
    @objc var keyParameter : Any? = nil
    
    var attributeTitle : NSAttributedString?//控制器标题
    override required init() {
        
    }
    func mapping(mapper: HelpingMapper) {
        
    }
}


class TimeModel: GDModel {
    var isSelected: Bool = false
    var title: String = ""
    var days: [TimeModel] = []
}
