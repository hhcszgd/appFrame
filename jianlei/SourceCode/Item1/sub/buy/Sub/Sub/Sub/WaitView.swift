//
//  WaitView.swift
//  Project
//
//  Created by 张凯强 on 2018/5/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class WaitView: UIView {

    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.time = Int(title)!
        self.backgroundColor = UIColor.colorWithHexStringSwift("ffb053")
        self.addSubview(self.image)
        self.image.frame = CGRect.init(x: 15, y: (frame.height - 30) / 2.0, width: 30, height: 30)
        self.label.frame = CGRect.init(x: self.image.max_X + 15, y: 6, width: SCREENWIDTH - self.image.max_X - 25, height: 0)
        self.addSubview(self.label)
        self.addSubview(self.label2)
        self.label2.frame = CGRect.init(x: self.image.max_X + 15, y: self.label.max_Y, width: SCREENWIDTH - self.image.max_X - 25 - 10, height: frame.size.height - self.label.max_Y - 5)
        self.label2.numberOfLines = 0
        
        let day: Int = self.time / (24 * 3600)
        let h: Int = self.time % (24 * 3600) / 3600
        let m: Int = self.time % (24 * 3600) % 3600 / 60
        let s: Int = self.time % (24 * 3600) % 3600 % 60
        let timeStr = String.init(format: "%d天%02d小时%02d分%02d秒", day, h, m, s)
        let str = String.init(format: "请在%@内完成支付\n否则系统将自动取消交易", timeStr)
        let attribute = str.setColor(color: UIColor.colorWithHexStringSwift("5384ff"), keyWord: timeStr)
        self.label2.attributedText = attribute
        
    }
    func start() {
        if self.timer == nil {
            self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(cuntDown), userInfo: nil, repeats: true)
            if let t = self.timer {
                RunLoop.current.add(t, forMode: RunLoopMode.commonModes)
            }
        }
        
        
        
    }
    var finished: (() -> ())?
    @objc func cuntDown() {
        if self.time == 0 {
            self.timer?.invalidate()
            self.timer = nil
            self.finished?()
            return
        }
        let day: Int = self.time / (24 * 3600)
        let h: Int = self.time % (24 * 3600) / 3600
        let m: Int = self.time % (24 * 3600) % 3600 / 60
        let s: Int = self.time % (24 * 3600) % 3600 % 60
        let timeStr = String.init(format: "%d天%02d小时%02d分%02d秒", day, h, m, s)
        let str = String.init(format: "请在%@内完成支付\n否则系统将自动取消交易", timeStr)
        let attribute = str.setColor(color: UIColor.colorWithHexStringSwift("5384ff"), keyWord: timeStr)
        self.label2.attributedText = attribute
        self.time -= 1
        
        
        
        
        
    }
    var timer: Timer?
    var time: Int = 0
    let image = UIImageView.init(image: UIImage.init(named: "put_pigicon"))
    let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.white, text: "")
    let label2 = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.white, text: "")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
