//
//  PersonalOrCompanySheet.swift
//  Project
//
//  Created by WY on 2019/8/12.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class PersonalOrCompanySheet: DDAlertContainer {

    lazy var subviewsContainer = UIView()
    lazy var subViewsContainerBackImageview = UIImageView()
    lazy var titleIcon  = UIView()
    lazy var titleLabel  = UILabel()
    //选择结果1:个人  , 2:公司
    var selectedCompleted : ((Int) -> Void )?
    
    let cancel = UIButton()
    
    let personalContainer = UIView()
    let personalButton = UIButton()
    let personalTips = UILabel()
    
    let companyContainer = UIView()
    let companyButton = UIButton()
    let companyTips = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColorAlpha = 0.6
//        self.
        self.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white
        subviewsContainer.addSubview(titleIcon)
        titleIcon.backgroundColor = .orange
        subviewsContainer.addSubview(titleLabel)
        titleLabel.text = "accountType"|?|
        subviewsContainer.addSubview(cancel)
        
        subviewsContainer.addSubview(personalContainer)
        
        personalContainer.addSubview(personalTips)
        personalContainer.addSubview(personalButton)
//        personalTips.textAlignment = .center
        personalTips.font = UIFont.systemFont(ofSize: 13)
        personalTips.textColor = UIColor.lightGray
        subviewsContainer.addSubview(companyContainer)
//        companyTips.textAlignment = .center
        companyContainer.addSubview(companyButton)
        companyContainer.addSubview(companyTips)
        companyTips.font = UIFont.systemFont(ofSize: 13)
        companyTips.textColor = UIColor.lightGray
        
        cancel.setImage(UIImage(named:"closethesmallicons"), for: UIControl.State.normal)
        personalButton.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
        companyButton.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
        cancel.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
        
        personalButton.setImage(UIImage(named:"individualaccount_bg"), for: UIControl.State.normal)
        companyButton.setImage(UIImage(named:"companyaccount_bg"), for: UIControl.State.normal)
        personalTips.text = "personalAccountDescribe"|?|
        companyTips.text = "companyAccountDecribe"|?|
        personalTips.adjustsFontSizeToFitWidth = true
        companyTips.adjustsFontSizeToFitWidth = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonAction(sender:UIButton) {
        if sender == self.personalButton{
         
            self.selectedCompleted?(1)
        }else if sender == self.companyButton{
            self.selectedCompleted?(2)
        }
        remove()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subviewsContainerW : CGFloat = self.bounds.width
        let margin : CGFloat = 10
        let cancelBtnWH  : CGFloat = 30
        
        let buttonY = margin
        let buttonX = subviewsContainerW - cancelBtnWH - 10
        cancel.frame = CGRect(x: buttonX, y: buttonY , width: cancelBtnWH, height: cancelBtnWH)
        
//        let titleLabelH : CGFloat =  44
        self.titleIcon.frame = CGRect(x: margin, y: margin, width: 3, height: 30)
        self.titleLabel.frame = CGRect(x: self.titleIcon.frame.maxX + 10, y: margin, width: cancel.frame.minX - titleIcon.frame.maxX, height: 30)
        
        self.personalContainer.frame = CGRect(x: margin, y: titleLabel.frame.maxY + margin, width: subviewsContainerW - margin * 2, height: 159)
        self.personalButton.frame = CGRect(x: 0, y: 0, width: self.personalContainer.bounds.width, height: personalContainer.bounds.height - 44)
        personalTips.frame = CGRect(x: 0, y: self.personalButton.frame.maxY, width: personalContainer.bounds.width, height: 44)
        
        
        self.companyContainer.frame = CGRect(x: margin, y: personalContainer.frame.maxY + margin, width: subviewsContainerW - margin * 2, height: 159)
        self.companyButton.frame = CGRect(x: 0, y: 0, width: self.companyContainer.bounds.width, height: companyContainer.bounds.height - 44)
        companyTips.frame = CGRect(x: 0, y: self.companyButton.frame.maxY, width: companyContainer.bounds.width, height: 44)
        
        subviewsContainer.frame = CGRect(x: 0, y: self.bounds.height - companyContainer.frame.maxY - 22, width: self.bounds.width, height: companyContainer.frame.maxY + 22)
        self.personalContainer.embellishView(redius: 10)
        self.companyContainer.embellishView(redius: 10)
    }
    
    
    
    deinit {
        print("vvvvvvvv    container销毁了")
    }
    

}
