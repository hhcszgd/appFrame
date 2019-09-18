//
//  DDExceptionView.swift
//  YiLuMedia
//
//  Created by WY on 2019/8/21.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
struct DDExceptionModel {
    var title = ""
    var image = ""
}
class DDExceptionView: DDMaskBaseView {
    let reloadButton = UIButton()
    let errorMessage = UILabel()
    let errorImage = UIImageView()
    var manualRemoveAfterActionHandle  : (()-> ())?
    var automaticRemoveAfterActionHandle  : (()-> ())?
    var exception : DDExceptionModel = DDExceptionModel(title: "there_is_nothing_now"|?|, image: "notice_noinformation"){
        didSet{
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.isHideWhenWhitespaceClick = false 
        self.addSubview(reloadButton)
        self.backgroundColorAlpha = 1
        self.backgroundColor = UIColor.white
        reloadButton.backgroundColor = UIColor.orange
        reloadButton.setTitle("點擊刷新", for: UIControl.State.normal)
        reloadButton.addTarget(self , action: #selector(reloadAction(sender:)), for: UIControl.Event.touchUpInside)
        reloadButton.titleLabel?.font = DDFont.systemFont(ofSize: 15)
        errorMessage.font = DDFont.systemFont(ofSize: 14)
        self.addSubview(errorMessage)
        errorMessage.textAlignment = .center
        self.addSubview(errorImage)
        errorMessage.numberOfLines = 3
        //        errorImage.image = UIImage(named:"feedback_icon")
        errorMessage.textColor = UIColor.lightGray
        errorImage.contentMode = .scaleAspectFit
        self.addObserver()
    }
    
    func addObserver()  {
        NotificationCenter.default.addObserver(self , selector: #selector(netWordChanged), name: NSNotification.Name("DDNetworkChanged"), object: nil )
    }
    @objc func netWordChanged() {
        self.reloadAction(sender: self.reloadButton)
    }
    func removeObser() {
        NotificationCenter.default.removeObserver(self )
        /*
         self.performPost( NSNotification.Name("DDNetworkChanged"), ["userInfo" : networkStatus])
         */
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.errorMessage.text = exception.title
        let image = UIImage(named: exception.image)
        
        let errorImageMaxW : CGFloat = self.bounds.width/2
        let errorImageMaxH : CGFloat = self.bounds.width/2
        var errorImageW : CGFloat = self.bounds.width/2
        var errorImageH : CGFloat = self.bounds.width/2
        let size = image?.size ?? CGSize(width: errorImageW, height: errorImageH)
        if size.width > errorImageMaxW{
            errorImageW = errorImageMaxW
            errorImageH = errorImageW * size.height / size.width
        }else{
            errorImageW = size.width
            errorImageH = size.height
        }
        errorImage.image = image
        let offSet : CGFloat = 36
        self.reloadButton.bounds = CGRect(x: 0, y: 0, width: 110, height: 34)
        self.reloadButton.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height * 0.75 )
        self.errorMessage.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width, height: 88)
        self.errorImage.frame = CGRect(x: self.bounds.width / 2 - errorImageW / 2, y: self.bounds.height/2 - errorImageH - offSet, width: errorImageW, height: errorImageH )
        reloadButton.layer.cornerRadius = 5
        reloadButton.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func reloadAction(sender:UIButton) {
        if  self.automaticRemoveAfterActionHandle != nil {
            self.remove()
            self.automaticRemoveAfterActionHandle?()
        }else if self.manualRemoveAfterActionHandle != nil {
            self.manualRemoveAfterActionHandle?()
        }
    }
}
