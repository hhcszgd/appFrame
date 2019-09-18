//
//  SignCollectionType1Header.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class SignCollectionType1Header: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.time)
        self.addSubview(self.bussiness)
        self.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        let width = frame.width
        self.time.frame = CGRect.init(x: 0, y: 0, width: width, height: 44)
        self.time.title.textColor = UIColor.colorWithHexStringSwift("999999")
        self.bussiness.title.textColor = UIColor.colorWithHexStringSwift("999999")
        self.bussiness.frame = CGRect.init(x: 0, y: self.time.max_Y, width: frame.width, height: 44)
        
        self.addSubview(self.count)
        self.count.frame = CGRect.init(x: 0, y: self.bussiness.max_Y + 10, width: width, height: 44)
    }
    let time: ShopInfoCell = ShopInfoCell.init(leftImage: "time", title: "", rightImage: "", isUserinteractionEnable: false)
    
    let bussiness: ShopInfoCell =           ShopInfoCell.init(leftImage: "team", title: "", rightImage: "", isUserinteractionEnable: false)
    
   let count = ShopInfoCell.init(frame: CGRect.zero, lefttitle: "")
    
    ///类型团队id和时间,团队姓名，时间不同样式, 总人数
    var value: (SignDataType, String, String, String, String, String)? {
        didSet{
            self.time.title.text = self.value?.4
            self.bussiness.title.text = self.value?.3
            switch (self.value?.0 ?? SignDataType.action1) {
            case .action1:
                self.count.title.text = "chaoshiSign"|?|
                self.count.subTitle.text = self.value?.5
            case .action2:
                self.count.title.text = "weidabiao"|?|
                self.count.subTitle.text = self.value?.5
            case .action3:
                self.count.title.text = "weiqiandao"|?|
                self.count.subTitle.text = self.value?.5
            case .action5:
                self.count.title.text = "zhongping"|?|
                self.count.subTitle.text = self.value?.5
            case .action6:
                self.count.title.text = "chaping"|?|
                self.count.subTitle.text = self.value?.5
            case .action4:
                self.count.title.text = "repeat_shop_num"|?|
                self.count.subTitle.text = self.value?.5
            case .leave_early_number:
                self.count.title.text = "zaotui"|?|
                self.count.subTitle.text = self.value?.5
            default:
                break
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
