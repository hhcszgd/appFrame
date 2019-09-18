//
//  ZKQFile.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/9/9.
//  Copyright © 2019 WY. All rights reserved.
//

import Foundation
import UIKit

class ZkqAlert: NSObject {
    static let share = { () -> ZkqAlert in
        let object = ZkqAlert.init()
        return object
    }()
    lazy var activeAlert: UIActivityIndicatorView = {
        let alert = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
        alert.center = UIApplication.shared.keyWindow?.center ?? CGPoint.init(x: SCREENWIDTH / 2.0, y: SCREENHEIGHT / 2.0)
        alert.hidesWhenStopped = true
        alert.style = .whiteLarge
        alert.color = UIColor.black
        alert.transform = .init(scaleX: 1.3, y: 1.3)
        alert.startAnimating()
        UIApplication.shared.keyWindow?.addSubview(alert)
        return alert
    }()
    
}
