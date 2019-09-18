//
//  PayVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class PayVC: DDNormalVC {

    @IBOutlet var top: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()
        self.imageViewS = [weChatImage,aliPayImage, uniconImage, underImage]
        self.view.backgroundColor = lineColor
        self.title = "支付"
        if let dict = self.userInfo as? [String: String] {
            if let payType = dict["payType"] {
                if payType != "1" {
                    self.underView.isHidden = true
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }
    var imageViewS:[UIImageView] = [UIImageView]()
    @IBOutlet var weChatImage: UIImageView!
    @IBOutlet var aliPayImage: UIImageView!
    @IBOutlet var uniconImage: UIImageView!
    @IBOutlet var underImage: UIImageView!
    
    @IBOutlet var sureBtn: UIButton!
    @IBAction func sureBtnAction(_ sender: UIButton) {
        //开始支付的时候禁止点击确定按钮
        sender.isEnabled = false
        guard var dict = self.userInfo as? [String: String], let orderID = dict["orderID"], let orderCode = dict["orderCode"]  else {
            sender.isEnabled = true
            return
        }
        var dealPrice: String?
        var orderPrice: String?
        if let price = dict["dealPrice"] {
            dealPrice = price
        }
        if let price = dict["orderPrice"] {
            orderPrice = price
        }
        
        if self.selectImageView == nil {
            GDAlertView.alert("请先选择支付方式", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        
        switch self.selectImageView! {
        case self.weChatImage:
            let token = DDAccount.share.token ?? ""
            let paramete = ["token": token, "order_code": orderCode]
            let router = Router.post("payment/wechat", .api, paramete)
            PayManager.share.performWeiChatPayWithParamete(paramete: router as AnyObject)
            PayManager.share.weixinResult = { [weak self] (result) in
                if let result = result["result"] as? String {
                    if result == "success" {
                        dict["result"] = "upSuccess"
                        self?.pushVC(vcIdentifier: "UpPayVC", userInfo: dict)
                    }else {
                        dict["result"] = "upFailure"
                        self?.navigationController?.popViewController(animated: true)
//                        self?.pushVC(vcIdentifier: "UpPayVC", userInfo: dict)
                    }
                }
                sender.isEnabled = true
                
            }
            
            
            
            
            
            break
        case self.aliPayImage:
            
            PayManager.share.performAliPayWithParamete(paramete: orderCode as AnyObject)
            
            PayManager.share.alipaySuccess = { [weak self] (result) in
                sender.isEnabled = true
                guard let subDict = result as? [String: AnyObject] else {
                    return
                }
                if let resultStatus = subDict["resultStatus"] as? String {
                    
                    if resultStatus == "9000" {
                        dict["result"] = "upSuccess"
                        self?.pushVC(vcIdentifier: "UpPayVC", userInfo: dict)
                    }else {
                        
                        dict["result"] = "upFailure"
                        self?.navigationController?.popViewController(animated: true)
//                        self?.pushVC(vcIdentifier: "UpPayVC", userInfo: dict)
                    }
                }else {
                    dict["result"] = "upFailure"
                    self?.navigationController?.popViewController(animated: true)
//                    self?.pushVC(vcIdentifier: "UpPayVC", userInfo: dict)
                }
  
            }
            
            
        case self.uniconImage:
            break
        case self.underImage:
            sender.isEnabled = true
            self.pushVC(vcIdentifier: "UnderPayVC", userInfo: dict)
        default:
            break
        }
        
        
        
        
    
    }
    @IBOutlet var trueBtn: UIButton!
    let selectImage: UIImage = UIImage.init(named: "selected")!
    let unselectImage: UIImage = UIImage.init(named: "unchecked")!
    func configCell(selectImageView: UIImageView) {
        self.imageViewS.forEach { (imageView) in
            if imageView == selectImageView {
                imageView.image = self.selectImage
                self.selectImageView = imageView
                self.trueBtn.isEnabled = true
            }else {
                imageView.image = self.unselectImage
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "支付"
    }
    var selectImageView: UIImageView?
    @IBAction func weChatAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.weChatImage)
        
    }
    @IBAction func aliPayAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.aliPayImage)
    }
    @IBAction func unionPayAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.uniconImage)
    }
    @IBAction func underAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.underImage)
    }
    @IBOutlet var underView: UIView!
    
    
    
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
