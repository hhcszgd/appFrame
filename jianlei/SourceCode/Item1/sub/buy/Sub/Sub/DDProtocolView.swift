//
//  DDProtocolView.swift
//  Project
//
//  Created by WY on 2019/1/28.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class DDProtocolView: UIView {

    private let iconButton = UIButton()
    private let label1 = UILabel()
    private let textButton = UIButton()
    ///0 点击选中按钮 且选中 , 1 点击选中按钮 且未选中 2 点击查看协议
    var protocolAction  : ((Int)->())?
    var selectStatus : Bool = false {
        didSet{
            self.iconButton.isSelected = selectStatus
        }
    }
    var model : (text1:String,text2:String) = (text1:"同意并已阅读",text2:"<<广告购买协议>>"){
        didSet{
            label1.text = model.text1
            textButton.setTitle(model.text2, for: UIControlState.normal)
            _layoutUI()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        iconButton.setImage(UIImage(named: "protocol_noselect"), for: UIControlState.normal)
        iconButton.setImage(UIImage(named: "protocol_select"), for: UIControlState.selected)
        iconButton.addTarget(self , action: #selector(action(sender:)), for: UIControlEvents.touchUpInside)
        textButton.addTarget(self , action: #selector(action(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(iconButton)
        self.addSubview(label1)
        self.addSubview(textButton)
        textButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
        label1.text = model.text1
        textButton.setTitle(model.text2, for: UIControlState.normal)
        label1.textColor = UIColor.gray
        label1.font = GDFont.systemFont(ofSize: 13)
        textButton.titleLabel?.font = GDFont.systemFont(ofSize: 13)
    }
    @objc func action(sender:UIButton)  {
        if sender == iconButton {
            sender.isSelected = !sender.isSelected
            if sender.isSelected{
                selectStatus = true
                    self.protocolAction?(0)
            }else{
                selectStatus = false
                self.protocolAction?(1)
            }
            
        }else{
            self.protocolAction?(2)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func _layoutUI() {
//        iconButton.sizeToFit()
        iconButton.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        label1.sizeToFit()
        textButton.sizeToFit()
        let margin: CGFloat = 3
        let totalWidth : CGFloat = iconButton.bounds.width + label1.bounds.width + textButton.bounds.width + margin
        iconButton.frame = CGRect(x: (self.bounds.width - totalWidth) / 2, y: (self.bounds.height - iconButton.bounds.height) / 2, width: iconButton.bounds.width, height: iconButton.bounds.height)
        label1.frame = CGRect(x: iconButton.frame.maxX, y: (self.bounds.height - label1.bounds.height) / 2, width: label1.bounds.width, height: label1.bounds.height)
        textButton.frame = CGRect(x: label1.frame.maxX + margin, y: (self.bounds.height - textButton.bounds.height) / 2, width:  textButton.bounds.width, height:  textButton.bounds.height)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        _layoutUI()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
