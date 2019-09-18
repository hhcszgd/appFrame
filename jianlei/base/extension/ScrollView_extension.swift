//
//  ScrollView_extension.swift
//  Project
//
//  Created by 张凯强 on 2019/8/3.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

extension UIScrollView {
    ///移动输入框
    func configScrollViewContentOffSet(containerView: UIView, keyboardFrame: CGRect, duration: Float) {
        var resetKeyboardFrame: CGRect = keyboardFrame
        if keyboardFrame == CGRect.zero {
            //如果出现键盘的比较晚
            resetKeyboardFrame = CGRect.init(x: 0, y: SCREENHEIGHT - keyboardHeight, width: SCREENWIDTH, height: keyboardHeight)
        }
        
        let containerViewFrame = self.getFrameInWindow(containerView: containerView)
        let contentOffsetY: CGFloat = self.contentOffset.y
        if resetKeyboardFrame.minY >= SCREENHEIGHT {
            //如果键盘消失
            self.judgeIsDown(keyboardFrame: resetKeyboardFrame, containerViewFrame: containerViewFrame,isHidden: true)
            
        }else {
            //如果键盘出现
            //如果输入框的最低位置是x在键盘的下面的。
            if containerViewFrame.maxY > resetKeyboardFrame.minY {
                //取得输入框和键盘重叠的部分的高度
                let cha = containerViewFrame.maxY - resetKeyboardFrame.minY
                self.setContentOffset(CGPoint.init(x: 0, y: contentOffsetY + cha + 20), animated: true)
            }else {
                self.judgeIsDown(keyboardFrame: resetKeyboardFrame, containerViewFrame: containerViewFrame)
            }
        }
        
        
    }
    ///判断当键盘和输入框不重叠的时候并且contentoffset.y大于一定值的时候讲输入框下移一定位置
    func judgeIsDown(keyboardFrame: CGRect, containerViewFrame: CGRect, isHidden: Bool = false) {
        let cha = keyboardFrame.minY - containerViewFrame.maxY
        //看看键盘和输入框的差距有没有超过20
        let isDownOne = (cha - 20) > 0 ? true : false
        if isDownOne {
            //获取移动距离
            let move = isHidden ? (self.contentOffset.y - keyboardFrame.height + DDSliderHeight + 50) : (cha - 20)
            //判断scrollView 能不能滑动了,如果滑动之后又空余或者是正好在顶部可以滑动
            if (self.contentOffset.y - move) >= 0{
                self.setContentOffset(CGPoint.init(x: 0, y: self.contentOffset.y - move), animated: true)
                
            }else {
                //如果不在顶部那就不滑动
                
            }
        }
        
        
    }
    ///获取输入框在屏幕中的位置
    private func getFrameInWindow(containerView: UIView)  -> CGRect{
        if let window = UIApplication.shared.delegate?.window{
            let rect =  containerView.convert(containerView.bounds, to: window)
            return rect
        }
        return CGRect.zero
    }
    
}
