//
//  ResultView.swift
//  Project
//
//  Created by 张凯强 on 2018/3/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ResultView: UIView {

    var resultView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("ResultView", owner: self, options: nil)?.first as? UIView {
            self.resultView = subView
            self.addSubview(self.resultView)
        }
        
    }
    let cancel: PublishSubject<String> = PublishSubject<String>.init()
    let sureAction: PublishSubject<[String: String]> = PublishSubject<[String: String]>.init()
    @IBAction func cancleBtnAction(_ sender: UIButton) {
        self.cancel.onNext("cancle")
        self.cancel.onCompleted()
    }
    
    
    
    @IBOutlet var timeLabel: UILabel!
  
    @IBOutlet var areaLabel: UILabel!

    @IBOutlet var advertisLabel: UILabel!

    @IBOutlet var timeLengthLabel: UILabel!
    
    @IBOutlet var ratelabel: UILabel!
    @IBOutlet var dayCout: UILabel!
    
    @IBOutlet var pricelabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
    @IBAction func sureAction(_ sender: UIButton) {
        self.sureAction.onNext([String: String]())
        self.sureAction.onCompleted()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var contentView: ResultView!
    
    
    deinit {
        mylog("销毁")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.resultView.frame = self.bounds
    }
    
}
