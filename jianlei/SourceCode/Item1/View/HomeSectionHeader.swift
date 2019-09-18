//
//  HomeSectionHeader.swift
//  YiLuMedia
//
//  Created by WY on 2019/9/9.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit


class HomeSectionHeader: UICollectionReusableView ,BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{
    func performMsgAction(indexPath: IndexPath) {
        self.msgActionDelegate?.performMsgAction(indexPath: indexPath)
    }
    func moreBtnClick() {
        self.msgActionDelegate?.moreBtnClick()
    }
    
    func performBannerAction(indexPath : IndexPath) {
        self.bannerActionDelegate?.performBannerAction(indexPath: indexPath)
    }
    
    var msgModels : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            message.models = msgModels
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    var bannerModels : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            banner.models = bannerModels
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    weak var bannerActionDelegate : BannerAutoScrollViewActionDelegate?
    
    weak var msgActionDelegate : DDMsgScrollViewActionDelegate?
    let banner = HomeBannerScrollView.init(frame: CGRect.zero)
    let message : HomeMessageScrollView = HomeMessageScrollView.init(frame: CGRect.zero)
    let bottomLine = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(message)
        self.addSubview(banner)
        self.addSubview(bottomLine)
        banner.delegate = self
        message.delegate = self
        bottomLine.backgroundColor = VIEW_BACK_COLOR
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 0
        var messageH : CGFloat = 44
//        if msgModels.count != 1 {messageH = 64}
        if msgModels.count == 1 {
            messageH = 44
        } else if msgModels.count == 2{
            messageH = 64
        }else {
            messageH = 0
        }
        let toBottomMargin = MARGIN * 2
        bottomLine.frame = CGRect(x:0 , y : self.bounds.height - toBottomMargin, width : self.bounds.width  , height : toBottomMargin/2 )
        message.frame = CGRect(x:toBorder , y : (self.bounds.height - messageH ) - toBottomMargin, width : self.bounds.width - toBorder * 2 , height : messageH )
        banner.frame = CGRect(x:0 , y : 0 , width : self.bounds.width  , height :  message.frame.minY )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HomeBannerScrollView : UIView , BannerAutoScrollViewActionDelegate{
    func performBannerAction(indexPath : IndexPath) {
        self.delegate?.performBannerAction(indexPath: indexPath)
    }
    
    var models : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            self.banner.models = models
        }
    }
    let banner = DDLeftRightAutoScroll.init(frame: CGRect.zero)
    weak var delegate : BannerAutoScrollViewActionDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(banner)
        banner.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        banner.frame = CGRect(x:0  , y: 0  , width : self.bounds.width , height : self.bounds.height)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol DDMsgScrollViewActionDelegate : NSObjectProtocol{
    func performMsgAction(indexPath : IndexPath)
    func moreBtnClick()
}
class HomeMessageScrollView : UIView , DDUpDownAutoScrollDelegate{
    var models : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            self.messageScrollView.models = models
        }
    }
    let messageScrollView : DDUpDownAutoScroll = DDUpDownAutoScroll.init(frame: CGRect.zero)
    weak var delegate : DDMsgScrollViewActionDelegate?
    let  leftBtn = UIButton()
    let  rightBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        self.addSubview(messageScrollView)
        messageScrollView.delegate = self
        //        leftBtn.setTitle("logo", for: UIControl.State.normal)
        leftBtn.setImage(UIImage(named:"notificationicon"), for: UIControl.State.normal)
        //        rightBtn.setTitle("更多", for: UIControl.State.normal)
        rightBtn.setImage(UIImage(named: "home_arrow"), for: UIControl.State.normal)
        rightBtn.titleLabel?.font = DDFont.systemFont(ofSize: 14)
        leftBtn.setTitleColor(UIColor.DDTitleColor, for: UIControl.State.normal)
        //        rightBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControl.State.normal)
        rightBtn.addTarget(self , action: #selector(moreBtnClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //        rightBtn.frame = CGRect(x:self.bounds.width - self.bounds.height  , y: self.bounds.height/5  , width : self.bounds.height , height : self.bounds.height/2.5)
        rightBtn.ddSizeToFit()
        rightBtn.bounds = CGRect(x: 0, y: 0, width: rightBtn.bounds.width + 8, height: (rightBtn.titleLabel?.font.lineHeight ?? 13 ) + 3)
        
        rightBtn.bounds = CGRect(x: 0, y: 0, width: self.bounds.height * 0.7, height: self.bounds.height)
        rightBtn.center = CGPoint(x: self.bounds.width - rightBtn.bounds.width/2  , y: self.bounds.height/2)
        //        rightBtn.layer.cornerRadius = rightBtn.bounds.height/2
        //        rightBtn.layer.masksToBounds = true
        //        rightBtn.backgroundColor = .orange
        leftBtn.frame = CGRect(x:0  , y: 0  , width : MARGIN, height : self.bounds.height)
        messageScrollView.frame = CGRect(x: leftBtn.frame.maxX    , y: 0 , width : rightBtn.frame.minX - leftBtn.frame.maxX, height : self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func performMsgAction(indexPath : IndexPath){
        self.delegate?.performMsgAction(indexPath: indexPath)
    }
    @objc func moreBtnClick(sender:UIButton)  {
        self.delegate?.moreBtnClick()
    }
    
    
}
