//
//  UpPayVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class UpPayVC: DDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dict = self.userInfo as? [String: String], let result = dict["result"] {
            switch result {
                ///线下支付成功
            case "underSuccess":
                guard let order = dict["order"] else {
                    return
                }
                let containerView = UnderPayResultView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight))
                self.view.addSubview(containerView)
                let _ = containerView.checkOrderDetail.subscribe(onNext: { (result) in
                    if let vc  =  self.navigationController?.popToSpecifyVC(DDOrderDetailVC.self , animate: true ){
                        vc.viewDidLoad()
                    }else{
                        let temp  =  DDOrderListVC()
                        let temp2 = DDOrderDetailVC()
                        temp2.userInfo = order
                        if let _ = self.navigationController?.children.first as? DDItem4VC{
                            self.navigationController?.pushViewController(temp , animated: false    )
                        }
                        self.navigationController?.pushViewController(temp2     , animated: false )
                        
                    }
                    
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                self.title = "支付成功"
            case "upSuccess":
                guard let order = dict["orderID"] else {
                    return
                }
                let containerView = UpPaySuccessView.init(frame:  CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight), orderId: order)
                self.view.addSubview(containerView)
                let _ = containerView.checkOrderDetail.subscribe(onNext: { (result) in
                    self.pushVC(vcIdentifier: "DDOrderDetailVC", userInfo: order)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                self.title = "支付成功"
            case "upFailure":
                let containerView = UpPayFailureVIew.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight))
                self.view.addSubview(containerView)
                let _ = containerView.placeAnOrder.subscribe(onNext: { [weak self](result) in
                    self?.navigationController?.popToRootViewController(animated: false)
                    rootNaviVC?.selectChildViewControllerIndex(index: 2)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                self.title = "支付失败"
            default:
                break
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///出现之后删除前面一个支付页面的控制器
        
        if let count = self.navigationController?.children.count {
            let vc = self.navigationController?.children[count - 2]
            if let before = self.navigationController?.children[count - 3] {
                if before.isKind(of: DDOrderDetailVC.self) {
                    
                }
            }
            
            let target = self.navigationController?.viewControllers.index(of: vc!)
            self.navigationController?.viewControllers.remove(at: target!)
        }
        
        
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
