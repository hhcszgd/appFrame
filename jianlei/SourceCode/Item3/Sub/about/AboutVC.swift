//
//  AboutVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class AboutVC: DDInternalVC {

   
    @IBOutlet weak var top: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = lineColor
        self.gdAddSubViews()
        // Do any additional setup after loading the view.
    }
    func gdAddSubViews() {
        self.naviBar.title = "profile_about"|?|
        self.top.constant = DDNavigationBarHeight + 10
        self.checkVersion()
        
    }
    

    @IBOutlet var version: UILabel!
    @IBAction func jianchaAction(_ sender: UITapGestureRecognizer) {
        if let url = self.url, let type = self.type, let version = self.versionValue {
            self.updateVerson(url: url, type: type, version: version)
        }else {
            GDAlertView.alert("没有新版本", image: nil, time: 1, complateBlock: nil)
        }
        
    }
    @IBAction func fuwuAction(_ sender: UITapGestureRecognizer) {
        self.pushVC(vcIdentifier: "BaseWebVC", userInfo: DomainType.wap.rawValue + "agreement/member_agreement")
    }
    @IBAction func jianzhiAction(_ sender: UITapGestureRecognizer) {

        self.pushVC(vcIdentifier: "BaseWebVC", userInfo: DomainType.wap.rawValue + "agreement/concurrent_post_agreement")
        
        
    }
    
    @IBOutlet var versionStatus: UILabel!
    
    
    @IBAction func pribateAction(_ sender: UITapGestureRecognizer) {
        self.pushVC(vcIdentifier: "BaseWebVC", userInfo: DomainType.wap.rawValue + "agreement/privacy_agreement")
        
    }
    
    var url: URL?
    var type: String?
    var versionValue: String?
    func checkVersion() {
        guard let ion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String  else {
            return
            
        }
        self.version.text = "V" + ion
        let paramete = ["app_type": 2] as [String: Any]
        let router = Router.get("version", .api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<VersionModel>.self, from: response)
            if model?.status == 200 {
                if ((model?.data?.version ?? "") > ion) {
                    self.versionValue = model?.data?.version
                    guard let url = URL.init(string: "https://itunes.apple.com/us/app/%e4%b8%80%e8%b7%af%e5%82%b3%e5%aa%92/id1455308781?l=zh&ls=1&mt=8") else {
                        return
                    }
                    self.url = url
                    if let type = model?.data?.upgrade_type {
                        self.type = type
                    }
                    self.versionStatus.text = "有新版本可用"
                    
                }else {
                    self.versionStatus.text = "版本不需要更新"
                }
            }else {
                self.versionStatus.text = "版本不需要更新"
            }
            
        }) {
            
        }
    
       
    }
    func updateVerson(url: URL, type: String, version: String) {
        if let ion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, ion == version {
            return
           
        }
        let title = "\n 更新新版本\(version) \n"
        let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        let trueAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default) { (action) in
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        if type == "2"{
            alertVC.addAction(cancleAction)
        }
        
        alertVC.addAction(trueAction)
        self.present(alertVC, animated: true, completion: nil)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
class VersionModel: Codable {
    var version: String?
    var desc: String?
    var upgrade_type: String?
    
    
}
