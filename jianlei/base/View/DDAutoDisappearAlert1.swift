//
//  DDAutoDisappearAlert1.swift
//  Project
//
//  Created by WY on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
// there are upper image and down title show , and auto hide in 3 seconds

import UIKit

class DDAutoDisappearAlert1: DDMaskBaseView {

    var timer : Timer?
    let coverImageView = UIImageView()
    lazy var subviewsContainer = UIView()
    lazy var imageView = UIImageView()
    lazy var titleLabel  = UILabel()
    var timeInterval : Int = 5
    var image : UIImage?
    
    public init( message: String? = nil ,image : UIImage? ){
        super.init(frame: CGRect.zero)
        self.backgroundColorAlpha = 0.001
        coverImageView.image = UIImage(named:"shadowmasklayer")
        self.addSubview(coverImageView)
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white

        if let identifyImage = image{
            self.image = identifyImage
            subviewsContainer.addSubview(imageView)
            imageView.image = identifyImage
            imageView.contentMode = .scaleAspectFit
        }
        
        self.subviewsContainer.backgroundColor = .white
        self.titleLabel.text = message
        subviewsContainer.addSubview(titleLabel)
        
        self.titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.lightGray
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds

        let subviewsContainerW : CGFloat = self.bounds.width - 50
        let borderW : CGFloat = 10
        var maxY : CGFloat = 10
        if self.image != nil {
            let w : CGFloat = 100
            self.imageView.frame =  CGRect(x: subviewsContainerW/2 - w/2, y:  maxY, width: w, height: w)
            maxY = self.imageView.frame.maxY
        }
        
        let titleLabelLeftMargin : CGFloat = 30
        let titleMaxW = subviewsContainerW - titleLabelLeftMargin  * 2
        
        var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
        titleLabelH = titleLabelH > 44 ? titleLabelH : 44
        self.titleLabel.frame = CGRect(x: titleLabelLeftMargin, y: maxY, width: titleMaxW, height: titleLabelH)
        subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: self.titleLabel.frame.maxY + 10)
        self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)

        self.subviewsContainer.embellishView(redius: 6)
        self.addTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTimer() {
        self.removeTimer()
//        self.sendCodeBtn.isEnabled = false
        self.timeInterval -= 1
//        self.sendCodeBtn.setTitle("\(self.timeInterval)秒后重发", for: UIControl.State.disabled)
        timer = Timer.init(timeInterval: 1, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func daojishi() {
        self.timeInterval -= 1
       
        if self.timeInterval <= 0 {
            self.removeTimer()
            self.remove()
        }else{
            
        }
    }
    deinit {
        self.removeTimer()
    }
}








class DDAutoDisappearAlert2: DDMaskBaseView {
        var action : (() -> Void )?
    var timer : Timer?
    let coverImageView = UIImageView()
    lazy var subviewsContainer = UIView()
    lazy var imageView = UIImageView()
    lazy var titleLabel  = UILabel()
    var timeInterval : Int = 5
    var image : UIImage?
    
    let bottomButton = UIButton(type: UIButton.ButtonType.custom)
    public init( message: String? = nil ,image : UIImage? ){
        super.init(frame: CGRect.zero)
        self.addSubview(coverImageView)
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white
        
        if let identifyImage = image{
            self.image = identifyImage
            subviewsContainer.addSubview(imageView)
            imageView.image = identifyImage
            imageView.contentMode = .scaleAspectFit
        }
        
        self.subviewsContainer.backgroundColor = .white
        self.titleLabel.text = message
        subviewsContainer.addSubview(titleLabel)
        
        self.titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.lightGray
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        
        subviewsContainer.addSubview(bottomButton)
        bottomButton.setTitle("返回我的界面(5)", for: UIControl.State.normal)
        bottomButton.backgroundColor = .orange
        bottomButton.addTarget(self , action: #selector(bottomAction(sender:)), for: UIControl.Event.touchUpInside)
        
    }
    @objc func bottomAction(sender:UIButton) {
        self.removeTimer()
        self.action?()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds
        
        let subviewsContainerW : CGFloat = self.bounds.width
        subviewsContainer.frame = self.bounds
        let borderW : CGFloat = 10
            let w : CGFloat = 150
            self.imageView.frame =  CGRect(x: subviewsContainerW/2 - w/2, y:  subviewsContainer.bounds.height/2 - w, width: w, height: w)
        
        let titleLabelLeftMargin : CGFloat = 30
        let titleMaxW = subviewsContainerW - titleLabelLeftMargin  * 2
        
        var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
        titleLabelH = titleLabelH > 44 ? titleLabelH : 44
        self.titleLabel.frame = CGRect(x: titleLabelLeftMargin, y: subviewsContainer.bounds.height/2 + 20, width: titleMaxW, height: titleLabelH)
        let bottomButtonX : CGFloat = 50
        let bottomButtonW : CGFloat = subviewsContainer.bounds.width - bottomButtonX * 2

            self.bottomButton.frame = CGRect(x: bottomButtonX, y: subviewsContainer.bounds.height - 100, width: bottomButtonW, height: 40)
        self.bottomButton.embellishView(redius: 6)
        self.addTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTimer() {
        self.removeTimer()
        //        self.sendCodeBtn.isEnabled = false
//        self.timeInterval -= 1
        //        self.sendCodeBtn.setTitle("\(self.timeInterval)秒后重发", for: UIControl.State.disabled)
        timer = Timer.init(timeInterval: 1, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func daojishi() {
        self.timeInterval -= 1
        bottomButton.setTitle("返回我的界面(\(self.timeInterval))", for: UIControl.State.normal)
        if self.timeInterval <= 0 {
            self.removeTimer()
            self.bottomAction(sender: self.bottomButton)

            self.remove()
        }else{
            
        }
    }
    deinit {
        self.removeTimer()
    }
}









