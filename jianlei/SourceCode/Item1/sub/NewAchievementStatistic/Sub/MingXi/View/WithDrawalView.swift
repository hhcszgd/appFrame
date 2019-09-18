//
//  WithDrawalView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class WithDrawalView: UIView {

    init(frame: CGRect, dataArr: [String], rect: CGRect) {
        super.init(frame: frame)
        self.triangle = rect
        self.dataArr = dataArr
        self.backgroundColor = UIColor.clear
        self.topView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: 120)
        self.bottomView.frame = CGRect.init(x: 0, y: self.topView.max_Y, width: frame.size.width, height: frame.size.height - self.topView.max_Y)
        
        self.topView.addSubview(self.incomeBtn)
        self.incomeBtn.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: 40)
        self.topView.addSubview(self.withDrawal)
        self.withDrawal.frame = CGRect.init(x: 0, y: 40, width: frame.size.width, height: 40)
        self.topView.addSubview(self.total)
        self.total.frame = CGRect.init(x: 0, y: self.withDrawal.max_Y, width: frame.size.width, height: 40)
    
    
    }
    var finished: PublishSubject<Int> = PublishSubject<Int>.init()
    @objc func hiddenFromSuperView(type: Int) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (finished) in
            self.finished.onNext(type)
            self.finished.onCompleted()
        }
    }
    @objc func incomAction(btn: UIButton) {
        btn.isSelected = true
        self.hiddenFromSuperView(type: 1)
        
    }
    @objc func withDrawalAction(btn: UIButton) {
        btn.isSelected = true
        self.hiddenFromSuperView(type: 2)
    }
    @objc func totalAction(btn: UIButton) {
        btn.isSelected = true
        self.hiddenFromSuperView(type: 0)
    }
    
    lazy var incomeBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("      收入", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .selected)
        btn.addTarget(self, action: #selector(incomAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return btn
    }()
    lazy var withDrawal: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("      提现", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .selected)
        btn.addTarget(self, action: #selector(withDrawalAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return btn
    }()
    lazy var total: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("      全部", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .selected)
        btn.addTarget(self, action: #selector(totalAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return btn
    }()
    
    
    lazy var topView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        return view
    }()
    lazy var bottomView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(view)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hiddenFromSuperView))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    var dataArr: [String] = []
    var triangle: CGRect = CGRect.zero
    
    
    override func draw(_ rect: CGRect) {
//        let color = UIColor.red
//        color.set()
//        let path = UIBezierPath.init()
//        path.lineWidth = 10
//        let height: CGFloat = self.triangle.size.height
//        //移动到开始的位置
//        let start: CGPoint = CGPoint.init(x: 0, y: height)
//        path.move(to: start)
//        let startTriangle: CGPoint = self.triangle.origin
//        path.addLine(to: startTriangle)
//        let secondPoint = CGPoint.init(x: startTriangle.x + self.triangle.size.width / 2.0, y: -self.triangle.size.height)
//        path.addLine(to: secondPoint)
//        let threePoint = CGPoint.init(x: secondPoint.x + self.triangle.size.width, y: 0)
//        path.addLine(to: threePoint)
//        let endPoint = CGPoint.init(x: self.frame.size.width, y: 0)
//        path.addLine(to: endPoint)
//
//        path.stroke()
        
        
        
        
        
    }
    deinit {
        mylog("下回建安费几率大是九分撒假两件付了款")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
