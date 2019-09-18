//
//  DDSignTabBarVC.swift
//  Project
//
//  Created by WY on 2019/8/9.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDSignTabBarVC: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBar.tintColor = UIColor.colorWithHexStringSwift("0357ba")//选中是,文字的颜色
        self.tabBar.barTintColor = UIColor.white //bar的背景
        //去黑线
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏2
    }
    deinit {
        self.navigationController?.setNavigationBarHidden(false , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏2
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
