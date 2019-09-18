//
//  DDActionSelectBar.swift
//  Project
//
//  Created by WY on 2018/3/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDActionSelectBar: UIView {
    var action : ((Int)->())?
    var colors : [UIColor] = [UIColor](){
        didSet{
            if actionTitleArr.count == colors.count{
                for (index ,subview)  in self.subviews.enumerated() {
                    subview.backgroundColor = colors[index]
                }
            }
        }
    }
    var actionTitleArr : [String] = [String](){
        didSet{
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
            for (index ,title)  in actionTitleArr.enumerated() {
                let button  = UIButton()
                button.tag = index + 1
                button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
                button.titleLabel?.adjustsFontSizeToFitWidth = true 
                if actionTitleArr.count == colors.count{
                    button.backgroundColor = colors[index]
                }
                self.addSubview(button)
                button.setTitle(title, for: UIControlState.normal)
            }
            layoutIfNeeded()
        }
    }
    
    var scaleArr : [CGFloat] = [CGFloat](){/// 元素相加之和等于1 //元素为空时 均分
        didSet{
            var num : CGFloat  = 0
            for (index ,element) in scaleArr.enumerated(){
                num += element
                if index == scaleArr.count - 1 && num != 1.0 {
                    scaleArr.removeAll()
                }
            }
            
        }
    }
    
    deinit {
        mylog("Dese it destroy ?")
    }
    @objc func buttonClick(sender:UIButton)  {
        self.action?(sender.tag)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin : CGFloat = 4
        let itemW = (self.bounds.width - margin * CGFloat(self.subviews.count - 1)) / CGFloat(actionTitleArr.count == 0 ? 1 : actionTitleArr.count)
        let totalItemW = (self.bounds.width - margin * CGFloat(self.subviews.count - 1))
        for (index ,subview) in self.subviews.enumerated() {
            if scaleArr.isEmpty || subviews.count != scaleArr.count{
                subview.frame = CGRect(x: (itemW + margin) * CGFloat(index), y: 0, width: itemW, height: self.bounds.height)
            }else{
                var previousW : CGFloat = 0
                for (scaleIndex , scale ) in scaleArr.enumerated(){
                    if scaleIndex == index{ break  }
                    previousW += (scale * totalItemW + margin)
                }
                subview.frame = CGRect(x: previousW * CGFloat(index), y: 0, width: scaleArr[index] * totalItemW , height: self.bounds.height)
            }
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
