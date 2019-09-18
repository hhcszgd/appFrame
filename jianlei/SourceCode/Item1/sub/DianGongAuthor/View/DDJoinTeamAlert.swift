//
//  DDJoinTeamAlert.swift
//  Project
//
//  Created by WY on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDJoinTeamAlert: DDAlertContainer {
    let coverImageView = UIImageView()
    lazy var subviewsContainer = UIView()
    lazy var subViewsContainerBackImageview = UIImageView()
    lazy var titleLabelBackview  = UIView()
    lazy var titleLabel  = UILabel()
    //return true means disAppear
    var confirmClick : ((String? , String? ) -> Bool )?
    
    private var subViewsContainerBackImage : UIImage?
    var noticeMessage = UILabel()
    
    
    var confirmButton = UIButton()
    var cancelButton = UIButton()
    var teamLeaderLabel = UILabel()
    var teamLeaderTextField = TempTextField()
    
    var contactTypeLabel = UILabel()
    var contactTypeTextField = TempTextField()
    var line1 = UIView()
    var line2 = UIView()
    public init( title: String? = nil ){
        super.init(frame: CGRect.zero)
        self.backgroundColorAlpha = 0.001
        coverImageView.image = UIImage(named:"shadowmasklayer")
        self.addSubview(coverImageView)
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.white
        let backgroundImage = UIImage(named:"pop-upbackground")
        if let backImg = backgroundImage{
            self.subViewsContainerBackImage = backImg
            subviewsContainer.addSubview(subViewsContainerBackImageview)
            subViewsContainerBackImageview.image = backImg
        }
        contactTypeTextField.delegate = self 
        
            self.titleLabel.text = title
            subviewsContainer.addSubview(titleLabel)
            
            self.titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.white
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = UIColor.clear
      
        
        subviewsContainer.addSubview(teamLeaderLabel)
        subviewsContainer.addSubview(teamLeaderTextField)
        subviewsContainer.addSubview(contactTypeLabel)
        subviewsContainer.addSubview(contactTypeTextField)
        subviewsContainer.addSubview(line1)
        subviewsContainer.addSubview(line2)
        line2.backgroundColor = UIColor.DDLightGray
        line1.backgroundColor = UIColor.DDLightGray
        
        teamLeaderLabel.text = "组长"
        contactTypeLabel.text = "联系方式"
        teamLeaderTextField.placeholder = "填入组长姓名"
        contactTypeTextField.placeholder = "填入组长联系方式"
        subviewsContainer.addSubview(noticeMessage)
        noticeMessage.font = UIFont.systemFont(ofSize: 13)
        noticeMessage.textColor  = UIColor.colorWithHexStringSwift("#ff3a00")
        noticeMessage.textAlignment = .center
        subviewsContainer.addSubview(confirmButton)
        confirmButton.setTitle("确认加入", for: UIControl.State.normal)
        cancelButton.setImage(UIImage(named:"close"), for: UIControl.State.normal)
        subviewsContainer.addSubview(cancelButton)
         confirmButton.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
        cancelButton.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
        
        confirmButton.backgroundColor = UIColor.orange
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonAction(sender:UIButton) {
        if sender == self.cancelButton{
            self.remove()
        }else if sender == self.confirmButton{
            if confirmClick?(self.teamLeaderTextField.text , self.contactTypeTextField.text) ?? false {
                self.remove()
            }else{
                
            }
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = self.bounds
        
        let subviewsContainerW : CGFloat = self.bounds.width - 50
        let margin : CGFloat = 10
//        let titleLabelLeftMargin : CGFloat = 30
        let titleLabelH : CGFloat =  44
        subViewsContainerBackImageview.frame = CGRect(x: 0, y:  0, width: subviewsContainerW, height: titleLabelH)
        
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: subviewsContainerW, height: titleLabelH)
        let btnWH  : CGFloat = 30
        let buttonY = (titleLabelH - btnWH ) / 2
        let buttonX = subviewsContainerW - btnWH - 10
        cancelButton.frame = CGRect(x: buttonX, y: buttonY , width: btnWH, height: btnWH)
        teamLeaderLabel.frame = CGRect(x: margin, y: self.titleLabel.frame.maxY, width: 88, height: 40)
        teamLeaderTextField.frame =  CGRect(x: teamLeaderLabel.frame.maxX, y: self.titleLabel.frame.maxY, width: subviewsContainerW - self.teamLeaderLabel.frame.maxX, height: 40)
        self.line1.frame = CGRect(x: margin, y: self.teamLeaderLabel.frame.maxY, width: subviewsContainerW - margin, height: 1)
        contactTypeLabel.frame = CGRect(x: margin, y: self.line1.frame.maxY, width: 88, height: 40)
        contactTypeTextField.frame =  CGRect(x: contactTypeLabel.frame.maxX, y: self.line1.frame.maxY, width: subviewsContainerW - self.teamLeaderLabel.frame.maxX, height: 40)
        self.line2.frame = CGRect(x: margin, y: self.contactTypeLabel.frame.maxY, width: subviewsContainerW - margin, height: 1)
        
        noticeMessage.frame = CGRect(x: 0, y: self.line2.frame.maxY, width: subviewsContainerW, height: 22)
        let confirmButtonW : CGFloat = 111
        confirmButton.frame = CGRect(x: (subviewsContainerW - confirmButtonW)/2, y: noticeMessage.frame.maxY, width: confirmButtonW, height: 40)
        subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: confirmButton.frame.maxY + margin)
        //        if self.preferredStyle == .alert {
        self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        //        }else{
        //            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - self.subviewsContainer.bounds.height/2 - 20)
        //        }
        self.confirmButton.embellishView(redius: 5)
        self.subviewsContainer.embellishView(redius: 10)
    }
    
    
    
    deinit {
        print("vvvvvvvv    container销毁了")
    }
    

}
extension DDJoinTeamAlert : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DDKeyBoardHandler.share.setViewToBeDealt(containerView: self.subviewsContainer, inPutView: contactTypeTextField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        UIApplication.shared.keyWindow?.endEditing(true)
        return true
    }
}




class DDKeyBoardHandler: NSObject {
    private weak var containerView : UIView?
    private weak var inPutView : UIView?
    private var originalFrame : CGRect = CGRect.zero
    private var isKeyboardShowing = false
    ///can move dynamicly when keyboard keep showing
    var canMoveWhileKeyboardShowing = true
    private var notificationWhileShowing : Notification?
    static let share = { () -> DDKeyBoardHandler in
        let temp = DDKeyBoardHandler()
        temp.prepare()
        return temp
    }()
    
    
    /// setViewToBeDeal , invoke this method after setting inputView's frame and inputViewContainer's frame
    ///
    /// - Parameters:
    ///   - containerView: inputView's container , it will be move while keyboard hide or show
    ///   - inPutView: inPutView
    /// for example :
    /*
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     DDKeyBoardHandler.share.setViewToBeDealt(containerView: getCashContainer, inPutView: textField)
     return true
     }
     */
    func setViewToBeDealt(containerView:UIView , inPutView : UIView) {
        if inPutView.frame == CGRect.zero {
            self.containerView = nil
            self.inPutView = nil
            originalFrame = CGRect.zero
            return
        }
        self.inPutView = inPutView
        guard  let  tempContainerView = self.containerView , tempContainerView == containerView else{
            self.containerView = containerView
            originalFrame = containerView.frame
            return
        }
        if isKeyboardShowing && canMoveWhileKeyboardShowing{
            self.actionWhileShowing(notification: self.notificationWhileShowing)
        }
    }
    
    var y: CGFloat = 0
    var zkqInputView: UIScrollView?
    
    
    
    private func getInputViewFrameInWindow()  -> CGRect{
        if let window = UIApplication.shared.delegate?.window  , let input = self.inPutView{
            let rect =  input.convert(input.bounds, to: window)
            return rect
        }
        return CGRect.zero
    }
    
    
    private func getScrollViewFrameInWindow()  -> CGRect{
        if let window = UIApplication.shared.delegate?.window  , let input = self.containerView{
            let rect =  input.convert(input.bounds, to: window)
            return rect
        }
        return CGRect.zero
    }
    
    private func prepare()  {
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil  , queue: OperationQueue.main) { (notification) in
            self.isKeyboardShowing = true
            self.notificationWhileShowing = notification
            self.actionWhileShowing(notification : notification)
        }
        NotificationCenter.default.addObserver(forName:UIResponder.keyboardWillHideNotification, object: nil  , queue: OperationQueue.main) { (notification) in
            self.isKeyboardShowing = true
            self.actionWhileHiding(notification:notification)
            self.notificationWhileShowing = nil
        }
    }
    
    private func actionWhileShowing(notification:Notification?){
        if self.containerView != nil {
            if let notification = notification {
                let keyboardFrame = self.getKeyboardFrameFromNotification(notification: notification)
                let viewFrame = self.getInputViewFrameInWindow()
                
                let keyboardToInputViewMargin : CGFloat = 28
                if viewFrame.maxY > keyboardFrame.origin.y {
                    UIView.animate(withDuration: 0.25, animations: {
                        let cha = viewFrame.maxY - keyboardFrame.origin.y
                        self.containerView!.frame.origin.y -= cha
                        self.containerView!.frame.origin.y -= keyboardToInputViewMargin
                    })
                }
            }
        }
    }
    
    private func actionWhileHiding(notification:Notification){
        if self.containerView != nil {
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView!.frame = self.originalFrame
            })
        }
    }
    private func getKeyboardFrameFromNotification(notification : Notification) -> CGRect {
        if let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
            return rect
        }
        return CGRect.zero
    }
    
}


