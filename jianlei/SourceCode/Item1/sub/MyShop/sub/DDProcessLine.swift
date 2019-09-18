//
//  DDProcessLine.swift
//  Project
//
//  Created by WY on 2019/8/7.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDProcessLine: UIView {
    /// 0 ~ 1
    var progress : CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    var indicaterColor = UIColor.orange
    var embelishCorner = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if embelishCorner{
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.bounds.height/2            
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        path.lineWidth = self.bounds.height
        indicaterColor.setStroke()
        if embelishCorner{
            path.lineCapStyle = .round            
        }
        if progress > 0  {
            if embelishCorner{
                
                path.move(to: CGPoint(x:self.bounds.height / 2 , y: self.bounds.height / 2   ))
                path.addLine(to: CGPoint(x: (self.bounds.width -  self.bounds.height/2 ) * self.progress, y: self.bounds.height / 2))
            }else{
                path.move(to: CGPoint(x:0 , y: self.bounds.height / 2   ))
                path.addLine(to: CGPoint(x: (self.bounds.width ) * self.progress, y: self.bounds.height / 2))
            }
            
        }
        path.fill()
        path.stroke()
    }
}
