//
//  PayTypePromptView.swift
//  Project
//
//  Created by 张凯强 on 2018/3/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class PayTypePromptView: UIView {

    let action: PublishSubject<String> = PublishSubject<String>.init()
    @IBAction func sureAction(_ sender: UIButton) {
        self.action.onNext("")
        self.action.onCompleted()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let containerView = Bundle.main.loadNibNamed("PayTypePromptView", owner: self, options: nil)?.first as! UIView
        self.contentView = containerView
        self.addSubview(containerView)
    }
    var contentView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
