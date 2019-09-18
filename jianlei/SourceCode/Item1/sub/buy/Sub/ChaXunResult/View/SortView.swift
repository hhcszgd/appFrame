//
//  SortView.swift
//  Project
//
//  Created by 张凯强 on 2018/4/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
enum SortType: String {
    
    /// 升序
    case asec = "asc"
    ///降序
    case desc = "desc"
    
}
class SortView: UIView {

    @IBAction func descAction(_ sender: UIButton) {
        self.finished(.desc)
    }
    @IBAction func aescActin(_ sender: UIButton) {
        self.finished(.asec)
    }
    
    var finished: ((SortType) -> ())!
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("SortView", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var containerView: UIView!
    
    
}
