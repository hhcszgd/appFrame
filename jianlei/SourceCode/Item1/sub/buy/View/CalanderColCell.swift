//
//  CalanderColCell.swift
//  Project
//
//  Created by 张凯强 on 2018/4/21.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class CalanderColCell: UICollectionViewCell {

    @IBOutlet var leftView: UIView!
    @IBOutlet var rightView: UIView!
    @IBOutlet var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var dayModel: DayModel? {
        didSet{

            
            switch dayModel?.dayState ?? .DayModelStateNormal {
            case .DayModelStateNormal:
                self.dayLabel.text = String.init(format: "%d", dayModel?.day ?? 0)
                self.dayLabel.backgroundColor = UIColor.white
                self.dayLabel.textColor = UIColor.colorWithHexStringSwift("000000")
                self.normalView.backgroundColor = UIColor.white
                self.leftView.backgroundColor = UIColor.white
                self.rightView.backgroundColor = UIColor.white
            case .DayModelSelected:
                if dayModel?.week == 1 {
                    self.leftView.backgroundColor = UIColor.clear
                    self.normalView.backgroundColor = UIColor.white
                    self.rightView.backgroundColor = selectColor
                    self.dayLabel.backgroundColor = UIColor.clear
                    self.dayLabel.textColor = selectTextColor
                    
                }else if dayModel?.week == 7 {
                    self.leftView.backgroundColor = selectColor
                    self.normalView.backgroundColor = UIColor.white
                    self.rightView.backgroundColor = UIColor.clear
                    self.dayLabel.backgroundColor = UIColor.clear
                    self.dayLabel.textColor = selectTextColor
                }else {
                    self.leftView.backgroundColor = UIColor.clear
                    self.rightView.backgroundColor = UIColor.clear
                    self.normalView.backgroundColor = selectColor
                    self.dayLabel.textColor = selectTextColor
                    self.dayLabel.backgroundColor = UIColor.clear
                }
                self.dayLabel.text = String.init(format: "%d", dayModel?.day ?? 0)

            case .DayModelStart, .DayModelEnd:
                if dayModel?.week == 1 {
                    if dayModel?.dayState == DayModelState.DayModelStart {
                        self.leftView.backgroundColor = UIColor.clear
                        self.rightView.backgroundColor = selectColor
                        self.normalView.backgroundColor = UIColor.clear
                        self.dayLabel.textColor = startOrEndTextColor
                        self.dayLabel.backgroundColor = startOrEndColor
                    }else {
                        self.leftView.backgroundColor = selectColor
                        self.rightView.backgroundColor = UIColor.clear
                        self.normalView.backgroundColor = UIColor.white
                        self.dayLabel.textColor = startOrEndTextColor
                        self.dayLabel.backgroundColor = startOrEndColor
                    }
                    
                    
                }else if dayModel?.week == 7 {
                    if dayModel?.dayState == DayModelState.DayModelStart {
                        self.leftView.backgroundColor = UIColor.clear
                        self.rightView.backgroundColor = UIColor.clear
                        self.normalView.backgroundColor = UIColor.clear
                        self.dayLabel.textColor = startOrEndTextColor
                        self.dayLabel.backgroundColor = startOrEndColor
                    }else {
                        self.leftView.backgroundColor = selectColor
                        self.rightView.backgroundColor = UIColor.clear
                        self.normalView.backgroundColor = UIColor.white
                        self.dayLabel.textColor = startOrEndTextColor
                        self.dayLabel.backgroundColor = startOrEndColor
                    }
                }else {
                    if dayModel?.dayState == DayModelState.DayModelStart {
                        self.leftView.backgroundColor = UIColor.clear
                        self.rightView.backgroundColor = selectColor
                        self.normalView.backgroundColor = UIColor.clear
                        self.dayLabel.textColor = startOrEndTextColor
                        self.dayLabel.backgroundColor = startOrEndColor
                    }else {
                        self.leftView.backgroundColor = selectColor
                        self.rightView.backgroundColor = UIColor.clear
                        self.normalView.backgroundColor = UIColor.white
                        self.dayLabel.textColor = startOrEndTextColor
                        self.dayLabel.backgroundColor = startOrEndColor
                    }
                    
                }
                
                self.dayLabel.text = String.init(format: "%d", dayModel?.day ?? 0)
            case .DayModelNoSelect:
                if let day = dayModel?.day {
                    self.dayLabel.text = String(day)
                    self.dayLabel.textColor = UIColor.colorWithHexStringSwift("999999")
                }else {
                    self.dayLabel.text = ""
                    self.dayLabel.textColor = UIColor.white
                }
                self.dayLabel.backgroundColor = UIColor.clear
                
                self.leftView.backgroundColor = UIColor.clear
                self.rightView.backgroundColor = UIColor.clear
                self.normalView.backgroundColor = normalColor
            case .DayModelStartAndEnd:
                if dayModel?.week == 1 {
                    self.leftView.backgroundColor = UIColor.clear
                    self.normalView.backgroundColor = UIColor.white
                    self.rightView.backgroundColor = selectColor
                    self.dayLabel.backgroundColor = UIColor.clear
                    self.dayLabel.textColor = selectTextColor
                    
                }else if dayModel?.week == 7 {
                    self.leftView.backgroundColor = selectColor
                    self.normalView.backgroundColor = UIColor.white
                    self.rightView.backgroundColor = UIColor.clear
                    self.dayLabel.backgroundColor = UIColor.clear
                    self.dayLabel.textColor = selectTextColor
                }else {
                    self.leftView.backgroundColor = UIColor.clear
                    self.rightView.backgroundColor = UIColor.clear
                    self.normalView.backgroundColor = selectColor
                    self.dayLabel.textColor = selectTextColor
                    self.dayLabel.backgroundColor = UIColor.clear
                }
                self.dayLabel.text = String.init(format: "%d", dayModel?.day ?? 0)
                
            
            }
            
            
        
            
           
        }
    }
    let selectColor = UIColor.colorWithHexStringSwift("ffe6d5")
    let selectTextColor = UIColor.colorWithHexStringSwift("000000")
    let startOrEndTextColor = UIColor.colorWithHexStringSwift("ffffff")
    let startOrEndColor = UIColor.colorWithHexStringSwift("fbb17e")

    let normalColor = UIColor.white
    @IBOutlet var normalView: UIView!
    
}
