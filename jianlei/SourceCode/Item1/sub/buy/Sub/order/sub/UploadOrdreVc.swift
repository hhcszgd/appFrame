//
//  UploadOrdreVc.swift
//  Project
//
//  Created by 张凯强 on 2019/1/22.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
///提交订单成功
class UploadOrdreVc: GDNormalVC {
    var orderID: String = ""
    var orderCode: String = ""
    
    
    lazy var sureBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("查看订单详情", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.colorWithRGB(red: 255, green: 102, blue: 51)
        btn.addTarget(self, action: #selector(sureAction(sender:)), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    let resutlImage = UIImageView.init()
    let resultLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "广告订单提交成功!")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "提交成功"
        self.view.addSubview(self.resutlImage)
        self.resutlImage.image = UIImage.init(named: "successicon")
        self.resutlImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(DDNavigationBarHeight + 30)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.resutlImage.image?.size.width ?? 0)
            make.height.equalTo(self.resutlImage.image?.size.height ?? 0)
        }
        
        self.view.addSubview(self.resultLabel)
        self.resultLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.resutlImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            
        }
        
        self.view.addSubview(self.sureBtn)
        self.sureBtn.layer.cornerRadius = 6
        self.sureBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.top.equalTo(self.resultLabel.snp.bottom).offset(30)
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.navigationController?.removeSpecifyVC(ClaanderWebVC.self)
//            self.navigationController?.removeSpecifyVC(TrueOrderVC.self)
//            self.navigationController?.removeSpecifyVC(ChaXunResultVC.self)
//            
//        }
        
        // Do any additional setup after loading the view.
    }

    @objc func sureAction(sender: UIButton) {
        let vc = DDSalemanOrderDetailVC()
        vc.userInfo = self.orderID
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func popToPreviousVC() {
        self.navigationController?.popToRootViewController(animated: true)
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
