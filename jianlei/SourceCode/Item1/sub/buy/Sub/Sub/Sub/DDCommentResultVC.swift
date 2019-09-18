
//
//  DDCommentResultVC.swift
//  Project
//
//  Created by WY on 2018/3/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCommentResultVC: DDNormalVC {
    let imageView = UIImageView()
    let label = UILabel()
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configSubviews()
//        self.navigationItem.backBarButtonItem?.isEnabled = false
//        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
//        self.navigationController?.navigationItem.hidesBackButton = true
//        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
//        self.navigationController?.navigationItem.setHidesBackButton(true , animated: true )
        self.navigationItem.setHidesBackButton(true , animated: true )
        // Do any additional setup after loading the view.
    }
    func configSubviews() {
        self.view.addSubview(imageView )
        self.view.addSubview(label )
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.font = GDFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        self.view.addSubview(button )
        let imageWH : CGFloat = 88
        label.frame = CGRect(x:0 ,y:self.view.bounds.height/2 , width : self.view.bounds.width , height : 44)
        imageView.frame = CGRect(x: self.view.bounds.width/2 - imageWH/2, y: label.frame.minY - imageWH - 38, width: imageWH, height: imageWH)
        let buttonToBorder : CGFloat = 64
        button.frame = CGRect(x: buttonToBorder, y: label.frame.maxY + 64, width: self.view.bounds.width - buttonToBorder * 2, height: 44)
        
        button.addTarget(self , action: #selector(confirmClick(sender:)), for: UIControlEvents.touchUpInside)
       
        if let type = self.userInfo as? String , type == "1"{
            //success
            self.title = "提交成功"
            self.imageView.image = UIImage(named:"successicon")
            self.label.text = "感谢您的宝贵意见,我们会采纳\n您的合理建议来进行改进"
            button.backgroundColor  = .orange
            button.setTitle("确定", for: UIControlState.normal)
//            if let vc  = dict["key2"] as? DDCommentPersonVC{
//                vc.removeFromParentViewController()
//                if let index = self.navigationController?.childViewControllers.index(of: vc){
//                    vc.removeFromParentViewController()
//                    self.navigationController?.viewControllers.remove(at: index)
////                        self.navigationController?.childViewControllers.remove(at: index)
//
//                }
//            }
        }else{//failure
            self.title = "提交失败"
            button.backgroundColor  = .lightGray
            button.setTitle("重新提交", for: UIControlState.normal)
            self.imageView.image = UIImage(named:"failurebutton")
            self.label.text = "意见提交失败,请重新提交"
        }
//        self.userInfo = nil
    }
    @objc func confirmClick(sender:UIButton){
        if let type = self.userInfo as? String , type == "1"{
            //success
            if let result = self.navigationController?.popToSpecifyVC(DDOrderDetailVC.self) as? DDOrderDetailVC {
                result.viewDidLoad()
            }else if let result = self.navigationController?.popToSpecifyVC(DDSalemanOrderDetailVC.self) as? DDSalemanOrderDetailVC{
                result.viewDidLoad()
            }
        }else{//failure
            self.navigationController?.popToSpecifyVC(DDCommentPersonVC.self)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
