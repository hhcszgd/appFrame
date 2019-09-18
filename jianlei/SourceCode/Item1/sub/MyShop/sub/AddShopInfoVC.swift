//
//  AddShopInfoVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/18.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class AddShopInfoVC: DDInternalVC {
    ///add添加分店，delete，删除分店,edit，编辑分店
    var funcationType: String = ""
    @IBOutlet weak var top: NSLayoutConstraint!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var addShopNameTextField: UITextField!
    @IBOutlet var selectShopAddress: UITapGestureRecognizer!
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var shopDetailAddress: UITextField!
    var fendianModel: FendianList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")

        self.naviBar.title = "shop_sub_add_shopInfo"|?|
        self.configSaveBtn()
        self.configtextField()
        if let model = self.fendianModel {
            self.deleteBtn.isHidden = false
            self.addShopNameTextField.text = model.branch_shop_name
            self.areaLabel.text = model.branch_shop_area_name
            self.shopDetailAddress.text = model.branch_shop_address
            self.branchName = model.branch_shop_name ?? ""
            self.branchArea = model.branch_shop_area_id ?? ""
            self.branchAddress = model.branch_shop_address ?? ""
            self.naviBar.title = "shop_sub_edit_shopInfo"|?|
        }
    
        
        // Do any additional setup after loading the view.
    }
    @IBAction func saveAction(_ sender: UIButton) {
        if let shopID = self.userInfo as? String {
            let token = DDAccount.share.token ?? ""
            var paramete = ["token": token, "headquarters_id": shopID, "branchName": self.branchName, "branchArea": self.branchArea, "branchAddress": self.branchAddress]
            var router: Router!
            if self.fendianModel == nil {
                
                router = Router.post("my-shop/add-branch", DomainType.api, paramete)
            }else {
                
                paramete.removeAll()
                paramete["id"] = self.fendianModel?.id ?? ""
                paramete["token"] = DDAccount.share.token ?? ""
                paramete["headquarters_id"] = shopID
                paramete["branch_shop_name"] = self.branchName
                paramete["branch_shop_area_id"] = self.branchArea
                paramete["branch_shop_address"] = self.branchAddress
                router = Router.post("shop-head/edit-branch", DomainType.api, paramete)
            }
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                let model = BaseModel<GDModel>.deserialize(from: dict)
                if model?.status == 200 {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: {
                        self.popToPreviousVC()
                        //                        NotificationCenter.default.post(name: NSNotification.Name.init("AddShopInfoVC"), object: nil, userInfo: nil)
                    })
                }else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: {
                        
                        //                        NotificationCenter.default.post(name: NSNotification.Name.init("j"), object: nil, userInfo: nil)
                    })
                }
                
            }, onError: { (error) in
                
            }, onCompleted: {
                
            }) {
                
            }
        }
        
    }
    @IBAction func deleteShopAction(_ sender: UIButton) {
        if let shopID = self.userInfo as? String {
            let token = DDAccount.share.token ?? ""
            var paramete = ["token": token, "headquarters_id": shopID]
            
            paramete["id"] = self.fendianModel?.id ?? ""
            var router = Router.delete("shop-head/delete-branch",DomainType.api, paramete)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                let model = BaseModel<GDModel>.deserialize(from: dict)
                if model?.status == 200 {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: {
                        self.popToPreviousVC()
                        //                        NotificationCenter.default.post(name: NSNotification.Name.init("AddShopInfoVC"), object: nil, userInfo: nil)
                    })
                }
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: {
                    //                        NotificationCenter.default.post(name: NSNotification.Name.init("AddShopInfoVC"), object: nil, userInfo: nil)
                })
            }, onError: { (error) in
                
            }, onCompleted: {
                
            }) {
                
            }
        }
    }
    
    @IBAction func selectAddressTapAction(_ sender: UITapGestureRecognizer) {
        self.addShopNameTextField.resignFirstResponder()
        self.shopDetailAddress.resignFirstResponder()
        let frame = CGRect.init(x: 0, y: SCREENHEIGHT - 400 - TabBarHeight, width: SCREENWIDTH, height: 400)
        let view = AreaSelectView.init(superView: self.view, areaType: GetAreaType.area, subFrame: CGRect.init(x: 0, y: 200, width: SCREENWIDTH, height: SCREENHEIGHT - 200), parent_id: "199")
       
        view.sureBtn.isHidden = true
        view.containerView.backgroundColor = lineColor
        self.view.addSubview(view)
        
        //            self.address.textColor = UIColor.colorWithHexStringSwift("333333")
        let _ = view.finished.subscribe(onNext: { [weak self](address, id) in
            self?.branchArea = id
            
            self?.branchAddress = address
            if address.count > 0 {
                self?.areaLabel.text = address
            }
            
            view.removeFromSuperview()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
    }
    var headquarters_id: String = ""
    var branchAddress: String = ""
    var branchName: String = ""
    var branchArea: String = ""
    func configtextField() {
        self.addShopNameTextField.setValue(UIColor.colorWithHexStringSwift("999999"), forKeyPath: "_placeholderLabel.textColor")
//        self.shopDetailAddress.setValue(UIColor.colorWithHexStringSwift("999999"), forKeyPath: "_placeholderLabel.textColor")
        let _ = self.addShopNameTextField.rx.text.orEmpty.subscribe(onNext: { [weak self](value) in
            self?.branchName = value
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        let _ = self.shopDetailAddress.rx.text.orEmpty.subscribe(onNext: { [weak self](value) in
            self?.branchAddress = value
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.addShopNameTextField.returnKeyType = .done
        self.shopDetailAddress.returnKeyType = .done
        
        
    }
    
    func configSaveBtn() {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: DDSliderHeight + 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        self.saveBtn.layer.addSublayer(gradientLayer)
        self.saveBtn.layer.cornerRadius = 20
        self.saveBtn.layer.masksToBounds = true
        self.deleteBtn.layer.masksToBounds = true
        self.deleteBtn.layer.cornerRadius = 20
        
        self.top.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()
        
        
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
