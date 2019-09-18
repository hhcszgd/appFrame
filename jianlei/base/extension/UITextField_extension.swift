//
//  UITextField_extension.swift
//  Project
//
//  Created by 张凯强 on 2019/8/4.
//  Copyright © 2018 HHCSZGD. All rights reserved/Users/zhangkaiqiang/Desktop/LEDSUB/Project.
//

import UIKit
extension UITextField {

    func adLeftView(leftView: UIView) {
        self.leftView = leftView
        self.leftViewMode = .always
    }
    func adRightView(rightView: UIView) {
        self.rightView = rightView
        self.rightViewMode = .always
    }
    ///添加下划线,只能添加一次
    func addBottomLine(lineView: UIView) {
        self.insertSubview(lineView, at: 0)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        
    }
}

class MYTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    var myProperty: String?
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    override var keyboardType: UIKeyboardType {
        set {
            super.keyboardType = newValue
            if keyboardType == .numberPad {
                let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44))
                backView.backgroundColor = UIColor.white
                let cancle = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 100, y: 7, width: 80, height: 30))
                cancle.setTitle("完成", for: UIControl.State.normal)
                cancle.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                cancle.setTitleColor(UIColor.white, for: UIControl.State.normal)
                cancle.backgroundColor = UIColor.colorWithRGB(red: 0, green: 119, blue: 250)
                cancle.layer.masksToBounds = true
                cancle.layer.cornerRadius = 6
                cancle.addTarget(self, action: #selector(changeTextfieldFirstResponder), for: UIControl.Event.touchUpInside)
                backView.addSubview(cancle)
                self.inputAccessoryView = backView
            }
        }
        get {
            return super.keyboardType
        }
    }
    
    @objc func changeTextfieldFirstResponder() {
        self.resignFirstResponder()
    }
    
    
}
