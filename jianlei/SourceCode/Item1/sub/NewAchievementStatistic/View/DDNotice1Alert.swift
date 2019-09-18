//
//  DDNotice1Alert.swift
//  Project
//
//  Created by WY on 2019/8/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit


class DDNotice1Alert: DDAlertContainer {
    let coverImageView = UIImageView()
    lazy var subviewsContainer = UIView()
    lazy var subViewsContainerBackImageview = UIImageView()
    lazy var titleLabelBackview  = UIView()
    lazy var titleLabel  = UILabel()
    lazy var identifyImageView = UIImageView()
    
    private var title : String?
    private var subViewsContainerBackImage : UIImage?
    private var identifyImage : UIImage?
    
    open var preferredStyle: UIAlertController.Style = .alert
    
    public init( message: String? = nil ,backgroundImage:UIImage? = nil , image:UIImage? = nil , actions:[DDAlertAction]){
        super.init(frame: CGRect.zero)
        self.backgroundColorAlpha = 0.3
        self._actions = actions
        coverImageView.image = UIImage(named:"shadowmasklayer")
        self.addSubview(coverImageView)
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white
        if let backImg = backgroundImage{
            self.subViewsContainerBackImage = backImg
            subviewsContainer.addSubview(subViewsContainerBackImageview)
            subViewsContainerBackImageview.image = backImg
        }
        if let identifyImage = image{
            self.identifyImage = identifyImage
            subviewsContainer.addSubview(identifyImageView)
            identifyImageView.image = identifyImage
            identifyImageView.contentMode = .scaleAspectFit
        }
        if let title   = message{
            self.title = title
            self.titleLabel.text = title
            subviewsContainer.addSubview(titleLabel)
            titleLabel.font = GDFont.systemFont(ofSize: 18)
//            self.titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.darkGray
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = UIColor.clear
        }
        
        for (index , action ) in actions.enumerated() {
            if index < 2{
                let button = UIButton()
                subviewsContainer.addSubview(button)
                if index == 0{
                    button.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    button.setTitle(action._title, for: UIControl.State.normal)
                    button.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                }else{
                    button.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
                    button.setTitle(action._title, for: UIControl.State.normal)
                    button.backgroundColor = UIColor.colorWithHexStringSwift("f9a433")
                }
                
                button.tag = index
                actionButtons.append(button)
                button.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
                
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonAction(sender:UIButton) {
        self._actions[sender.tag].handler?(self._actions[sender.tag])
        if self._actions[sender.tag].isAutomaticDisappear{self.remove()}
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds
        
        var maxY : CGFloat = 0
        let subviewsContainerW : CGFloat = self.bounds.width - 50
        let rowH : CGFloat = 60
        let borderW : CGFloat = 10
        let margin : CGFloat = 20
        let titleLabelLeftMargin : CGFloat = 30
        let titleMaxW = subviewsContainerW - titleLabelLeftMargin  * 2
        
        if self.title != nil {
            var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
            titleLabelH = titleLabelH > 44 ? titleLabelH : 44
            self.titleLabel.frame = CGRect(x: titleLabelLeftMargin, y: borderW * 3, width: titleMaxW, height: titleLabelH)//高度是动态的
            maxY = self.titleLabel.frame.maxY
        }
        
        if self.identifyImage != nil {
            let w : CGFloat = 100
            self.identifyImageView.frame =  CGRect(x: subviewsContainerW/2 - w/2, y:  maxY, width: w, height: w)
            maxY = self.identifyImageView.frame.maxY
        }
        
        if subViewsContainerBackImage != nil {
            subViewsContainerBackImageview.frame = CGRect(x: 0, y:  0, width: subviewsContainerW, height: maxY)
            maxY = self.subViewsContainerBackImageview.frame.maxY
        }
        
        
        
        
        if _actions.count == 2{// action 横向排列
            if self.preferredStyle == .alert {
                let buttonY = maxY + margin
                for (index , button ) in actionButtons.enumerated(){
                    
                    if index == 0 {
                        button.frame = CGRect(x: 0, y: buttonY , width: (subviewsContainerW - 0 * 3 ) / 2, height: rowH)
                    }else{
                        button.frame = CGRect(x:  subviewsContainerW/2 + 0, y: buttonY , width:(subviewsContainerW - 0 * 3 ) / 2, height: rowH)
                    }
//                    button.embellishView(redius: 5)
                }
                maxY = buttonY + rowH
            }
        }else{// action 纵向排列
            for  button  in actionButtons{
                button.frame = CGRect(x: 0, y: maxY + margin , width: subviewsContainerW, height: rowH)
                maxY = button.frame.maxY
            }
        }
        subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: maxY)
        //        if self.preferredStyle == .alert {
        self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2 - 111)
        //        }else{
        //            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - self.subviewsContainer.bounds.height/2 - 20)
        //        }
        self.subviewsContainer.embellishView(redius: 10)
    }
    
    
    
    deinit {
        print("vvvvvvvv    container销毁了")
    }
    
    
}


/*
class DDNotice1Alert: DDAlertContainer {
    let coverImageView = UIImageView()
    lazy var subviewsContainer = UIView()
    lazy var subViewsContainerBackImageview = UIImageView()
    lazy var titleLabelBackview  = UIView()
    lazy var titleLabel  = UILabel()
    lazy var identifyImageView = UIImageView()
    
    private var title : String?
    private var subViewsContainerBackImage : UIImage?
    private var identifyImage : UIImage?
    
    open var preferredStyle: UIAlertController.Style = .alert
    
    public init( message: String? = nil ,backgroundImage:UIImage? = nil , image:UIImage? = nil , actions:[DDAlertAction]){
        super.init(frame: CGRect.zero)
        self.backgroundColorAlpha = 0.001
        self._actions = actions
        coverImageView.image = UIImage(named:"shadowmasklayer")
        self.addSubview(coverImageView)
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white
        if let backImg = backgroundImage{
            self.subViewsContainerBackImage = backImg
            subviewsContainer.addSubview(subViewsContainerBackImageview)
            subViewsContainerBackImageview.image = backImg
        }
        if let identifyImage = image{
            self.identifyImage = identifyImage
            subviewsContainer.addSubview(identifyImageView)
            identifyImageView.image = identifyImage
            identifyImageView.contentMode = .scaleAspectFit
        }
        if let title   = message{
            self.title = title
            self.titleLabel.text = title
            subviewsContainer.addSubview(titleLabel)
            
            self.titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.white
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = UIColor.clear
        }
        
        for (index , action ) in actions.enumerated() {
            if index < 2{
                let button = UIButton()
                subviewsContainer.addSubview(button)
                if index == 0{
                    button.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
                    button.setTitle(action._title, for: UIControl.State.normal)
                    button.backgroundColor = UIColor.white
                }else{
                    button.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    button.setTitle(action._title, for: UIControl.State.normal)
                    button.backgroundColor = UIColor.orange
                }

                button.tag = index
                actionButtons.append(button)
                button.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
                
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonAction(sender:UIButton) {
        self._actions[sender.tag].handler?(self._actions[sender.tag])
        if self._actions[sender.tag].isAutomaticDisappear{self.remove()}
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds
        
        var maxY : CGFloat = 0
        let subviewsContainerW : CGFloat = self.bounds.width - 50
        let rowH : CGFloat = 44
        let borderW : CGFloat = 10
        let margin : CGFloat = 10
        let titleLabelLeftMargin : CGFloat = 30
        let titleMaxW = subviewsContainerW - titleLabelLeftMargin  * 2
        
        if self.title != nil {
            var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
            titleLabelH = titleLabelH > 44 ? titleLabelH : 44
            self.titleLabel.frame = CGRect(x: titleLabelLeftMargin, y: borderW * 3, width: titleMaxW, height: titleLabelH)//高度是动态的
            maxY = self.titleLabel.frame.maxY
        }
        
        if self.identifyImage != nil {
            let w : CGFloat = 100
            self.identifyImageView.frame =  CGRect(x: subviewsContainerW/2 - w/2, y:  maxY, width: w, height: w)
            maxY = self.identifyImageView.frame.maxY
        }
        
        if subViewsContainerBackImage != nil {
            subViewsContainerBackImageview.frame = CGRect(x: 0, y:  0, width: subviewsContainerW, height: maxY)
            maxY = self.subViewsContainerBackImageview.frame.maxY
        }
        
        
        
        
        if _actions.count == 2{// action 横向排列
            if self.preferredStyle == .alert {
                let buttonY = maxY + margin
                for (index , button ) in actionButtons.enumerated(){
                    
                    if index == 0 {
                        button.frame = CGRect(x: margin, y: maxY + margin , width: (subviewsContainerW - margin * 3 ) / 2, height: rowH)
                        button.layer.borderWidth = 2
                        button.layer.borderColor = UIColor.DDLightGray.cgColor
                    }else{
                        button.frame = CGRect(x:  subviewsContainerW/2 + margin/2, y: maxY + margin , width:(subviewsContainerW - margin * 3 ) / 2, height: rowH)
                    }
                    button.embellishView(redius: 5)
                }
                maxY = buttonY + rowH + margin
            }
        }else{// action 纵向排列
            for  button  in actionButtons{
                button.frame = CGRect(x: 0, y: maxY + margin , width: subviewsContainerW, height: rowH)
                maxY = button.frame.maxY + margin
            }
        }
        subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: maxY)
//        if self.preferredStyle == .alert {
            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
//        }else{
//            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - self.subviewsContainer.bounds.height/2 - 20)
//        }
        self.subviewsContainer.embellishView(redius: 10)
    }
    
    
    
    deinit {
        print("vvvvvvvv    container销毁了")
    }
    
    
}
*/


class DDNotice2Alert: DDAlertContainer {
    let coverImageView = UIImageView()
    lazy var subviewsContainer = UIView()
    lazy var subViewsContainerBackImageview = UIImageView()
    lazy var titleLabelBackview  = UIView()
    lazy var titleLabel  = UILabel()
    lazy var identifyImageView = UIImageView()
    
    private var title : String?
    private var subViewsContainerBackImage : UIImage?
    private var identifyImage : UIImage?
    
    open var preferredStyle: UIAlertController.Style = .alert
    
    public init( message: String? = nil ,backgroundImage:UIImage? = nil , image:UIImage? = nil , actions:[DDAlertAction]){
        super.init(frame: CGRect.zero)
        self.backgroundColorAlpha = 0.001
        self._actions = actions
        coverImageView.image = UIImage(named:"shadowmasklayer")
        self.addSubview(coverImageView)
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white
        if let backImg = backgroundImage{
            self.subViewsContainerBackImage = backImg
            subviewsContainer.addSubview(subViewsContainerBackImageview)
            subViewsContainerBackImageview.image = backImg
        }
        if let identifyImage = image{
            self.identifyImage = identifyImage
            subviewsContainer.addSubview(identifyImageView)
            identifyImageView.image = identifyImage
            identifyImageView.contentMode = .scaleAspectFit
        }
        if let title   = message{
            self.title = title
            self.titleLabel.text = title
            subviewsContainer.addSubview(titleLabel)
            
            self.titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.white
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = UIColor.clear
        }
        
        for (index , action ) in actions.enumerated() {
            if index < 1{
                let button = UIButton()
                subviewsContainer.addSubview(button)
                if index == 0{
                    button.setImage(UIImage(named:"close"), for: UIControl.State.normal)
                }
                button.tag = index
                actionButtons.append(button)
                button.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
                
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonAction(sender:UIButton) {
        self._actions[sender.tag].handler?(self._actions[sender.tag])
        if self._actions[sender.tag].isAutomaticDisappear{self.remove()}
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds
        
        var maxY : CGFloat = 0
        let subviewsContainerW : CGFloat = self.bounds.width - 50
        let rowH : CGFloat = 44
        let borderW : CGFloat = 10
        let margin : CGFloat = 10
        let titleLabelLeftMargin : CGFloat = 30
        let titleMaxW = subviewsContainerW - titleLabelLeftMargin  * 2
        
        if self.title != nil {
            var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
            titleLabelH = titleLabelH > 44 ? titleLabelH : 44
            self.titleLabel.frame = CGRect(x: titleLabelLeftMargin, y: borderW * 4, width: titleMaxW, height: titleLabelH)//高度是动态的
            maxY = self.titleLabel.frame.maxY
        }
        
        if subViewsContainerBackImage != nil {
            subViewsContainerBackImageview.frame = CGRect(x: 0, y:  0, width: subviewsContainerW, height: maxY + borderW * 3)
            maxY = self.subViewsContainerBackImageview.frame.maxY
        }
        
        if self.identifyImage != nil {
            let w : CGFloat = 100
            self.identifyImageView.frame =  CGRect(x: subviewsContainerW/2 - w/2, y:  maxY, width: w, height: w)
        }
        
        
        
        
        if _actions.count == 1{// action 横向排列
            if self.preferredStyle == .alert {
                let btnWH  : CGFloat = 30
                let buttonY = borderW
                let buttonX = subviewsContainerW - btnWH - borderW
                for (index , button ) in actionButtons.enumerated(){
                    
                    if index == 0 {
                        button.frame = CGRect(x: buttonX, y: buttonY , width: btnWH, height: btnWH)
                    }
                }
            }
        }
        subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: maxY)
        //        if self.preferredStyle == .alert {
        self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        //        }else{
        //            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - self.subviewsContainer.bounds.height/2 - 20)
        //        }
        self.subviewsContainer.embellishView(redius: 10)
    }
    
    
    
    deinit {
        print("vvvvvvvv    container销毁了")
    }
    
    
}



/// 设置属性字符串
class DDNotice3Alert: DDAlertContainer {
    let coverImageView = UIImageView()
    lazy var subviewsContainer = UIView()
    lazy var subViewsContainerBackImageview = UIImageView()
    lazy var titleLabelBackview  = UIView()
    lazy var titleLabel  = UILabel()
    lazy var identifyImageView = UIImageView()
    
    private var title : NSAttributedString?
    private var subViewsContainerBackImage : UIImage?
    private var identifyImage : UIImage?
    
    open var preferredStyle: UIAlertController.Style = .alert
    
    public init( message: NSAttributedString? = nil ,backgroundImage:UIImage? = nil , image:UIImage? = nil , actions:[DDAlertAction]){
        super.init(frame: CGRect.zero)
        self.backgroundColorAlpha = 0.001
        self._actions = actions
        coverImageView.image = UIImage(named:"shadowmasklayer")
        self.addSubview(coverImageView)
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white
        if let backImg = backgroundImage{
            self.subViewsContainerBackImage = backImg
            subviewsContainer.addSubview(subViewsContainerBackImageview)
            subViewsContainerBackImageview.image = backImg
        }
        if let identifyImage = image{
            self.identifyImage = identifyImage
            subviewsContainer.addSubview(identifyImageView)
            identifyImageView.image = identifyImage
            identifyImageView.contentMode = .scaleAspectFit
        }
        if let title   = message{
            titleLabel.textColor = UIColor.white
            self.title = title
            self.titleLabel.attributedText = title
            subviewsContainer.addSubview(titleLabel)
            
            self.titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = UIColor.clear
        }
        
        for (index , action ) in actions.enumerated() {
            if index < 2{
                let button = UIButton()
                subviewsContainer.addSubview(button)
                if index == 0{
                    button.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
                    button.setTitle(action._title, for: UIControl.State.normal)
                    button.backgroundColor = UIColor.white
                }else{
                    button.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    button.setTitle(action._title, for: UIControl.State.normal)
                    button.backgroundColor = UIColor.orange
                }
                
                button.tag = index
                actionButtons.append(button)
                button.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
                
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonAction(sender:UIButton) {
        self._actions[sender.tag].handler?(self._actions[sender.tag])
        if self._actions[sender.tag].isAutomaticDisappear{self.remove()}
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds
        
        var maxY : CGFloat = 0
        let subviewsContainerW : CGFloat = self.bounds.width - 50
        let rowH : CGFloat = 44
        let borderW : CGFloat = 10
        let margin : CGFloat = 10
        let titleLabelLeftMargin : CGFloat = 30
        let titleMaxW = subviewsContainerW - titleLabelLeftMargin  * 2
        
        if self.title != nil {
            var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
            titleLabelH = titleLabelH > 44 ? titleLabelH : 44
            self.titleLabel.frame = CGRect(x: titleLabelLeftMargin, y: borderW * 3, width: titleMaxW, height: titleLabelH)//高度是动态的
            maxY = self.titleLabel.frame.maxY
        }
        
        if self.identifyImage != nil {
            let w : CGFloat = 100
            self.identifyImageView.frame =  CGRect(x: subviewsContainerW/2 - w/2, y:  maxY, width: w, height: w)
            maxY = self.identifyImageView.frame.maxY
        }
        
        if subViewsContainerBackImage != nil {
            subViewsContainerBackImageview.frame = CGRect(x: 0, y:  0, width: subviewsContainerW, height: maxY)
            maxY = self.subViewsContainerBackImageview.frame.maxY
        }
        
        
        
        
        if _actions.count == 2{// action 横向排列
            if self.preferredStyle == .alert {
                let buttonY = maxY + margin
                for (index , button ) in actionButtons.enumerated(){
                    
                    if index == 0 {
                        button.frame = CGRect(x: margin, y: maxY + margin , width: (subviewsContainerW - margin * 3 ) / 2, height: rowH)
                        button.layer.borderWidth = 2
                        button.layer.borderColor = UIColor.DDLightGray.cgColor
                    }else{
                        button.frame = CGRect(x:  subviewsContainerW/2 + margin/2, y: maxY + margin , width:(subviewsContainerW - margin * 3 ) / 2, height: rowH)
                    }
                    button.embellishView(redius: 5)
                }
                maxY = buttonY + rowH + margin
            }
        }else{// action 纵向排列
            for  button  in actionButtons{
                button.frame = CGRect(x: 0, y: maxY + margin , width: subviewsContainerW, height: rowH)
                maxY = button.frame.maxY + margin
            }
        }
        subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: maxY)
        //        if self.preferredStyle == .alert {
        self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        //        }else{
        //            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - self.subviewsContainer.bounds.height/2 - 20)
        //        }
        self.subviewsContainer.embellishView(redius: 10)
    }
    
    
    
    deinit {
        print("vvvvvvvv    container销毁了")
    }
    
    
}









class DDAlertContainer: DDMaskBaseView {
    lazy var _actions = [DDAlertAction]()
    lazy var actionButtons = [UIButton]()
}
