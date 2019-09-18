//
//  UIVIew_extention.swift
//  zjlao
//
//  Created by WY on 2019/8/16.
//  Copyright ©2019年 WY. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    ///在有返回值并且不处理的情况下，不会报警告
    @discardableResult
    func alertZkq<T: MyAlertView>(_ cover: T, animate: ((T) -> ())? = nil) -> T {
        self.addSubview(cover)
        cover.frame = self.bounds
        if animate != nil {
            animate?(cover)
        }else {
            cover.alpha = 0
            let tempColor = cover.backgroundColor ?? UIColor.black
            cover.backgroundColor = tempColor.withAlphaComponent(0.3)
            UIView.animate(withDuration: 0.3) {
                cover.alpha = 1
            }
        }
        return cover
    }
    
    
    func setSpecifyCornerRound(byRoundingCorners:UIRectCorner,cornerRadius:CGFloat)  {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:byRoundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.bounds = self.bounds
        maskLayer.position = CGPoint(x: self.bounds.width/2 , y: self.bounds.height/2 )
        self.layer.mask = maskLayer
    }
   public func embellishView(redius : CGFloat)  {
        self.layer.cornerRadius = redius
        self.layer.masksToBounds = true
    }
   public func ddSizeToFit( contentInset : UIEdgeInsets = UIEdgeInsets.zero) {
        self.sizeToFit()
        let frame = self.bounds
    self.contentMode = UIView.ContentMode.center
        self.bounds = CGRect(x: 0, y: 0, width: frame.width + (contentInset.left + contentInset.right), height: frame.height + (contentInset.top + contentInset.bottom))
    }
    var x: CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    var y: CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    var width: CGFloat {
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
            
        }
        get{
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
            
        }
        get{
            return self.frame.size.height
        }
    }
    var origin: CGPoint {
        set{
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin
        }
    }
    var size: CGSize {
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get{
            return self.frame.size
        }
    }
    var centerX: CGFloat {
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    var centerY: CGFloat {
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get{
            return self.center.y
        }
    }
    var max_X: CGFloat {
        set{
            
        }
        get{
            return self.frame.maxX
        }
    }
    var max_Y: CGFloat{
        set{
            
        }
        get{
            return self.frame.maxY
        }
    }
    
    
    
    
}
