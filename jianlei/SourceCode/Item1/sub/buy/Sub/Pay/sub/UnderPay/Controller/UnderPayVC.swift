//
//  UnderPayVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import Photos
class UnderPayVC: DDNormalVC {
    @IBOutlet var topView: NSLayoutConstraint!
    @IBOutlet var bottomView: NSLayoutConstraint!
    
    @IBOutlet var companyAddress: UILabel!
    @IBOutlet var companyName: UILabel!
    
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var beizhu: UILabel!
    @IBOutlet var bank: UILabel!
    @IBOutlet var account: UILabel!
    @IBOutlet var scroll: UIScrollView!
    var orderID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        self.view.backgroundColor = lineColor
        self.topView.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()
        if let dict = self.userInfo as? [String: String], let orderCode = dict["orderCode"], let orderID = dict["orderID"] {
            self.orderID = orderID
            
            let token = DDAccount.share.token ?? ""
            let paramete = ["token": token, "order_code": orderCode]
            let _ = NetWork.manager.requestData(router: Router.post("payment/line", .api, paramete)).subscribe(onNext: { (dict) in
                let model = BaseModel<UnderZhiFuModel>.deserialize(from: dict)
                if model?.status == 200 {
                    self.companyName.text = model?.data?.system_receiver_name
                    self.companyAddress.text = model?.data?.system_receiver_address
                    self.totalPrice.text = "￥" + (model?.data?.order_price)!
                    self.beizhu.text = model?.data?.payment_code
                    self.bank.text = model?.data?.system_receiver_bank_name
                    self.account.text = model?.data?.system_receiver_bank_number
                    
                }else {
                    
                }
                
            }, onError: { (error) in
                
            }, onCompleted: {
                mylog("结束")
            }, onDisposed: {
                mylog("回收")
            })
        }
        if let orderCode = self.userInfo as? String {
            let token = DDAccount.share.token ?? ""
            let paramete = ["token": token, "order_code": orderCode]
            let _ = NetWork.manager.requestData(router: Router.post("payment/line", .api, paramete)).subscribe(onNext: { (dict) in
                let model = BaseModel<UnderZhiFuModel>.deserialize(from: dict)
                if model?.status == 200 {
                    self.companyName.text = model?.data?.system_receiver_name
                    self.companyAddress.text = model?.data?.system_receiver_address
                    self.totalPrice.text = "￥" + (model?.data?.order_price)!
                    self.beizhu.text = model?.data?.payment_code
                    self.bank.text = model?.data?.system_receiver_bank_name
                    self.account.text = model?.data?.system_receiver_bank_number
                    
                }else {
                    
                }
                
            }, onError: { (error) in
                
            }, onCompleted: {
                mylog("结束")
            }, onDisposed: {
                mylog("回收")
            })
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///出现之后删除前面一个支付页面的控制器
        ///判断前一个控制器是什么类型，如果是订单详情那么就征程返回
        
        
        
        
        let count = self.navigationController?.childViewControllers.count
        
        
        let vc = self.navigationController?.childViewControllers[count! - 2]
        if let _ = vc as? DDOrderDetailVC {
            
        }else {
            let target = self.navigationController?.viewControllers.index(of: vc!)
            
            self.navigationController?.viewControllers.remove(at: target!)
        }
        
    
    }
    
    
    @IBOutlet var payBtn: UIButton!
    

    
    @IBAction func saveAction(_ sender: UIButton) {
        self.scroll.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        self.screenSnapshot(save: true)
        
    }
    func screenSnapshot(save: Bool) {
        
        guard let window = UIApplication.shared.keyWindow else { return  }
        
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if save {
            if image != nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image!)
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess {
                        DispatchQueue.main.async {
                            
                            self.pushVC(vcIdentifier: "UpPayVC", userInfo: ["order": self.orderID, "result": "underSuccess"])
                        }
                        
                        
                        
    
                    }else {
                        GDAlertView.alert("保存失败", image: nil, time: 1, complateBlock: nil)
                    }
                })
            }
            
            
        }
        
    
    }
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class UnderZhiFuModel: GDModel {
        ///收款人地址
        var system_receiver_address: String = ""
        ///收款银行
        var system_receiver_bank_name: String = ""
        ///收款账号
        var system_receiver_bank_number: String = ""
        ///收款姓名
        var system_receiver_name: String = ""
        ///付款随机码
        var payment_code: String = ""
        ///价格
        var order_price: String = ""
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
