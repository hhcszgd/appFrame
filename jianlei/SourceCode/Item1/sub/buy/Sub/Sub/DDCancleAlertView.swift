//
//  DDCancleAlertView.swift
//  Project
//
//  Created by WY on 2018/3/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCanclePayAlertView: DDCoverView {
    let contentView = UIView()
    let titleLable = UILabel()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let cancle = UIButton()
    let confirm = UIButton()
    /// para1 : rease type 1 , 2 , 3
    var action : ((Int  )->())?
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(contentView)
        contentView.backgroundColor = .white
        self.contentView.addSubview(titleLable)
        titleLable.textAlignment = .center
        titleLable.text = "请选择取消订单原因"
        self.contentView.addSubview(button1)
        self.configButton(sender: button1, title: " 信息错误重新购买")
        
        self.contentView.addSubview(button2)
        self.configButton(sender: button2, title: " 放弃购买")
        
        self.contentView.addSubview(button3)
        self.configButton(sender: button3, title: " 其他")
        button3.isSelected = true
        
        self.contentView.addSubview(cancle)
        self.contentView.addSubview(confirm)
        cancle.setTitle("取消", for: UIControlState.normal)
        cancle.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        cancle.backgroundColor = .white
        confirm.setTitle("确定", for: UIControlState.normal)
        confirm.backgroundColor = .orange
        cancle.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        confirm.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    func configButton(sender:UIButton,title : String) {
        sender.setTitle(title, for: UIControlState.normal)
        sender.setTitle(title, for: UIControlState.selected)
        sender.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        sender.setImage(UIImage(named:"selected"), for: UIControlState.selected)
        sender.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sender.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        sender.contentHorizontalAlignment = .left
        sender.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        sender.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        sender.adjustsImageWhenHighlighted = false
    }
    @objc func buttonClick(sender:UIButton)  {
        if sender.isSelected {return}else{
            sender.isSelected = !sender.isSelected
            if sender == button1 {
                button2.isSelected = false
                button3.isSelected = false
            }else if sender == button2 {
                button1.isSelected = false
                button3.isSelected = false
            }else if sender == button3 {
                button2.isSelected = false
                button1.isSelected = false
            }else if sender == cancle{
                self.remove()
            }else if sender == confirm{
                self.remove()
                if button1.isSelected{self.action?(1)} else
                if button2.isSelected{self.action?(2)} else
                if button3.isSelected{self.action?(3)}
                
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 40
        let contentViewW = self.bounds.width - toBorder * 2
        let contentViewH = contentViewW * 0.75
//        contentView.frame = CGRect(x: toBorder, y: self.bounds.height / 2 - contentViewH, width: contentViewW, height: contentViewH)
        titleLable.frame =  CGRect(x: 0, y: 10, width: contentViewW, height: 40)
        button1.frame = CGRect(x: 30, y: titleLable.frame.maxY + 5, width: contentViewW - 20, height: 30)
        button2.frame = CGRect(x: 30, y: button1.frame.maxY , width: contentViewW - 20, height: 30)
        button3.frame = CGRect(x: 30, y: button2.frame.maxY , width: contentViewW - 20, height: 30)
        let W = (contentViewW - toBorder * 2 - 10) / 2
        cancle.frame = CGRect(x: toBorder, y: button3.frame.maxY + 20, width: W, height: 40)
        confirm.frame = CGRect(x: cancle.frame.maxX + 10, y: button3.frame.maxY + 20 , width: W, height: 40)
        
        contentView.frame = CGRect(x: toBorder, y: self.bounds.height / 2 - contentViewH, width: contentViewW, height: confirm.frame.maxY + 20 )
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
