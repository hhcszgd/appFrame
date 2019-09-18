//
//  DealPriceChangedAlert.swift
//  Project
//
//  Created by WY on 2018/6/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//


import UIKit
class DealPriceChangedAlert: DDCoverView  {
    let container = UIView()
    let title = UILabel()
    let accept = UIButton()
    let cancel = UIButton()
    var money : (orderPrice : String , dealPrice : String) =  (orderPrice : "" , dealPrice : "")
    override init(superView : UIView) {
        super.init(superView:superView)
        self.addSubview(container)
        self.isHideWhenWhitespaceClick = false
        container.addSubview(title)
        container.addSubview(accept)
        container.addSubview(cancel)
//        title.textAlignment = .center
        title.textColor = UIColor.gray
        title.numberOfLines = 0
        container.backgroundColor = UIColor.white
        accept.backgroundColor = UIColor.orange
        cancel.setTitle("联系客服", for: UIControlState.normal)
        accept.setTitle("确认", for: UIControlState.normal)
        cancel.setTitleColor(UIColor.orange, for: UIControlState.normal)
        
        cancel.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        
        accept.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    @objc func buttonClick(sender:UIButton) {
         if sender == cancel{
            self.actionHandle?("")
            self.remove()
        }else if sender == accept{
            self.remove()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let containerW : CGFloat = self.bounds.width - 66
        var containerH : CGFloat = 0
        container.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let rowH : CGFloat = 40
        let marginToBorder : CGFloat = 30
        var  titleString = ""
        if  let dealPrice = Double.init(money.dealPrice){
            if dealPrice == 0 || dealPrice == 0.0 {
                titleString = "   很抱歉,由于在您付款期间,选择广告档期全部被他人抢先购买,因此未能成功购买广告档期.\n    我们建议您可以在订单详情页重新选择投放时间.\n    若您不同意修改投放时间或有任何意见,请联系客服"
            }else{
                titleString = "   由于您在付款期间,选择的广告档期部分被他人抢先购买.您实付\(money.orderPrice)元,购买的实际广告总额价值为\(money.dealPrice)元.\n    我们会按照您购买的档期播出,对于您的损失我们将会按照增加档期的方式进行补播."
            }
        }else{
            titleString = "   很抱歉,由于在您付款期间,选择广告档期全部被他人抢先购买,因此未能成功购买广告档期.\n    我们建议您可以在订单详情页重新选择投放时间.\n    若您不同意修改投放时间或有任何意见,请联系客服"
        }
        let titleH  = titleString.sizeWith(font: title.font, maxWidth: containerW - marginToBorder * 2).height
        title.text = titleString
        title.frame = CGRect(x: marginToBorder, y: marginToBorder, width: containerW - marginToBorder * 2, height: titleH)
        let bottomButtonW: CGFloat = 111
        accept.frame = CGRect(x: containerW / 2 - bottomButtonW / 2, y: title.frame.maxY + 10, width: bottomButtonW, height: rowH )
        cancel.frame = CGRect(x:containerW / 2 - bottomButtonW / 2, y: accept.frame.maxY , width: bottomButtonW, height: rowH)
        containerH = cancel.frame.maxY + marginToBorder /  3
        container.bounds = CGRect(x: 0, y: 0, width: containerW, height: containerH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
