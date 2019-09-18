//
//  DDItem3NaviVC.swift
//  ENWay
//
//  Created by WY on 2019/82/13.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit

class DDItem3NaviVC: DDBaseNavVC {

    convenience init(){
        //        let rootVC = DDItem2VC()
        let rootVC = DDItem3VC()
        //        rootVC.title = DDLanguageManager.text("tabbar_item2_title")
        self.init(rootViewController: rootVC)
        self.title =  "tabbar_item3_title"|?|
        
//        self.navigationBar.shadowImage = UIImage()
        //
        //        self.tabBarItem.image = UIImage(named:"messageuncheckedIcon")
        //        self.tabBarItem.selectedImage = UIImage(named:"messageselectionicon")
        self.tabBarItem.image = UIImage(named:"JL_personal")
        self.tabBarItem.selectedImage = UIImage(named:"JL_personal_sel")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        
    }

}
