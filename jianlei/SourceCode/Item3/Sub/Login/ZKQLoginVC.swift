//
//  ZKQLoginVC.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/1/7.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class LoginModel : Codable {
    var token: String?
    var id: String?
}
class ZKQLoginVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        self.view.addSubview(self.backScroll)
        self.backScroll.backgroundColor = UIColor.white
        self.backScroll.contentSize = CGSize.init(width: SCREENWIDTH, height: SCREENHEIGHT)
        self.backScroll.showsVerticalScrollIndicator = false
        let logoImage = UIImageView.init(image: UIImage.init(named: "login_applogo"))
        self.backScroll.addSubview(logoImage)
        
        if let image = logoImage.image {
            logoImage.frame = CGRect.init(x: (SCREENWIDTH - image.size.width) / 2.0, y: 63 * SCALE, width: image.size.width, height: image.size.height)
            
        }
        
        self.backScroll.addSubview(self.userNameTextField)
        self.backScroll.addSubview(self.passwordTextField)
        self.userNameTextField.frame = CGRect.init(x: 30, y: logoImage.max_Y + 40 * SCALE, width: SCREENWIDTH - 60, height: 50)
        self.passwordTextField.frame = CGRect.init(x: 30, y: self.userNameTextField.max_Y + 20, width: SCREENWIDTH - 60, height: 50)
        
        let numberImage = UIImageView.init(image: UIImage.init(named: "login_number"))
        
    }
    
//    登录
    func login() {
        let router = Router.post("member/login", DomainType.api, nil)
        
    }
    
    let backScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
    ///登录用户名
    let userNameTextField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 60, height: 50))
    let passwordTextField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 60, height: 50))

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
