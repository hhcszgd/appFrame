//
//  DDNoticeBaseView.swift
//  YiLuMedia
//
//  Created by WY on 2019/8/21.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class DDMaskBaseView: UIView {
    var isHideWhenWhitespaceClick = true
    var deinitHandle : (()-> ())?
    var backgroundColorAlpha : CGFloat = 0.3
//    convenience init(superView:UIView){
//        self.init(frame: superView.bounds)
//        superView.addSubview(self)
//    }
    override func didMoveToWindow(){
        super.didMoveToWindow()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    /// being override to custom animate
    @objc func remove() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (bool ) in
            self.subviews.forEach({ (subview) in
                subview.removeFromSuperview()
            })
            self.removeFromSuperview()
            self.deinitHandle?()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstView = self.subviews.first{
            if let point = touches.first?.location(in: self){
                if firstView.frame.contains(point){
                    self.corverViewPart()//点击子视图
                    return
                }
                ///有子视图,但点击空白
                if isHideWhenWhitespaceClick {self.remove()}
                self.whiteSpaceAction(touches, with: event)
            }
        }else{//没有子视图
            if isHideWhenWhitespaceClick {self.remove()}
            self.whiteSpaceAction(touches, with: event)
        }
    }
    /// to be override
    func corverViewPart() {
        mylog("corver view part touch")
    }
    /// to be override
    func whiteSpaceAction(_ touches: Set<UITouch>, with event: UIEvent?) {
        mylog("touch begain")
    }
    deinit {
        self.deinitHandle?()
        print("cover destroyed")
    }
}





extension  UIView {
    /// alert exceptionView or remove all exceptionView
    ///
    /// - Parameters:
    ///   - cover: exceptionView .
    ///   - switch: if false ,just remove existed exceptionView ,  if true show exceptionView
    ///   - frame: exceptionView's frame
    ///   - animate: custom animation
    /// - Returns: the exceptionView
    @discardableResult
    func alert<T : DDMaskBaseView>(_ cover:T , _ alertSwitch : Bool = true  ,frame:CGRect = CGRect.zero, animate:((T) -> ())? = nil )  -> T{
        for subview in self.subviews{
            if subview.isKind(of: T.self) {
                subview.removeFromSuperview()
            }
        }
        if !alertSwitch {
            return cover
        }
        self.addSubview(cover)
        if frame == CGRect.zero{
            cover.frame = self.bounds
        }else{
            cover.frame = frame
        }
        
        if animate != nil {
            animate!(cover)
        }else{
//            cover.alpha = 0
            let tempColor = cover.backgroundColor ?? UIColor.black
            cover.backgroundColor = tempColor.withAlphaComponent(cover.backgroundColorAlpha)
//            UIView.animate(withDuration: 0.3) {
//                cover.alpha = 1
//            }
        }
        return cover
    }
    func removeAllMaskView<T : DDMaskBaseView>(maskClass:T.Type) {
        for subview in self.subviews{
            if subview.isKind(of: T.self) {
                subview.removeFromSuperview()
            }
        }
    }
}
