//
//  ZChangeTimeAlert.swift
//  Project
//
//  Created by 张凯强 on 2018/5/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ZChangeTimeAlert: UIView {

    init(frame: CGRect, startDay: String, endDay: String, superView: UIView, count: String) {
        super.init(frame: frame)
        superView.addSubview(self)
        self.backgroundColor = UIColor.white
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        self.titleLabel.sizeToFit()
        
        self.addSubview(self.detailLabel)
        
        self.detailLabel.sizeToFit()
        self.detailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
//        let start = String.init(format: "%d-%02d-%02d", startDay.year ?? 2018, startDay.month ?? 0, startDay.day ?? 0)
//        let end = String.init(format: "%d-%02d-%02d", endDay.year ?? 2018, endDay.month ?? 0, endDay.day ?? 0)
        self.detailLabel.attributedText = String.init(format: "%@ 到 %@\n地区若无余量则不播放，损失将由您承担\n是否确认修改？", startDay, endDay).setColor(color: UIColor.red, keyWords: [startDay, endDay])
        self.detailLabel.numberOfLines = 0
        self.detailLabel.textAlignment = .center
        
        
        self.addSubview(self.sureBtn)
        self.sureBtn.setTitle(String.init(format: "确定修改(%@)", count), for: .normal)
        self.sureBtn.setTitleColor(UIColor.white, for: .normal)
        self.sureBtn.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        self.sureBtn.backgroundColor = UIColor.colorWithHexStringSwift("ea9680")
        self.sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
    }
    
    
    
    deinit {
        mylog("销毁")
    }
//    func start() {
//        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(cuntDown), userInfo: nil, repeats: true)
//        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
//    }
//    var leftTime: Int = 3
//    @objc func cuntDown() {
//        if self.leftTime == 0 {
//            self.sureBtn.isUserInteractionEnabled = true
//            self.sureBtn.setTitle( "确认修改", for: .normal)
//            self.sureBtn.backgroundColor = UIColor.red
//            self.timer?.invalidate()
//            self.timer = nil
//            return
//        }
//        self.sureBtn.setTitle(String.init(format: "确认修改(%d)", self.leftTime), for: .normal)
//        self.leftTime -= 1
//
//    }
//    var timer: Timer?
    let titleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("333333"), text: "您申请修改广告投放时间为")
    let detailLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    let sureBtn = UIButton.init()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
