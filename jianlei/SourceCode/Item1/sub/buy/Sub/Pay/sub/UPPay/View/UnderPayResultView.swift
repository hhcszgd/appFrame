//
//  UnderPayResultView.swift
//  Project
//
//  Created by 张凯强 on 2018/3/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class UnderPayResultView: UIView {

    var containerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("UnderPayResultView", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        
    }
    let checkOrderDetail: PublishSubject<String> = PublishSubject<String>.init()
    @IBAction func checkOrderDetailAction(_ sender: UIButton) {
        self.checkOrderDetail.onNext("success")
        self.checkOrderDetail.onCompleted()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.frame = self.bounds
    }
    
    
    
}
