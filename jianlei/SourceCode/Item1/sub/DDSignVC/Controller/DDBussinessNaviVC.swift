//
//  DDBussinessNaviVC.swift
//  Project
//
//  Created by WY on 2019/8/9.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDBussinessNaviVC: UINavigationController {
    enum SignType {
        case bussiness
        case maintain
    }
    var signType : SignType  = .maintain
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "xxxx"
        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
