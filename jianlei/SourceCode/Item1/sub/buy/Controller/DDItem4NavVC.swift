//
//  DDItem4NavVC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDItem4NavVC: DDBaseNavVC {
    convenience init(){
        let rootVC = DDItem4VC()
        rootVC.title = DDLanguageManager.text("tabbar_item4_title")
        self.init(rootViewController: rootVC)
        
        self.navigationBar.shadowImage = UIImage()
//        self.tabBarItem.image = UIImage(named:"unclickiconforadvertising")
//        self.tabBarItem.selectedImage = UIImage(named:"adselectedicon")
        self.tabBarItem.image = UIImage(named:"advertisement")
        self.tabBarItem.selectedImage = UIImage(named:"advertisementicon")
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
        if self.childViewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
