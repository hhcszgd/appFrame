//
//  UpPayFailureVIew.swift
//  Project
//
//  Created by 张凯强 on 2018/3/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class UpPayFailureVIew: UIView {

    var containerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("UpPayFailureVIew", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        
    }
    let placeAnOrder: PublishSubject<String> = PublishSubject<String>.init()
    @IBAction func againOrder(_ sender: UIButton) {
        self.placeAnOrder.onNext("success")
        self.placeAnOrder.onCompleted()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.frame = self.bounds
    }
    

}
