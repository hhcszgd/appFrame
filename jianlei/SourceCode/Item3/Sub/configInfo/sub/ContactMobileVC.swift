//
//  ContactMobileVC.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/8/27.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
import RxCocoa
class ContactMobileVC: DDInternalVC {
    var areaName: String = ""
    var address: String = ""
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var resetBtn: UIButton!
    var finishedConfigAddress: (((String, String)) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.constant = DDNavigationBarHeight + 15
        self.view.layoutIfNeeded()
        self.naviBar.title = "contactAddressTitle"|?|
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.resetBtn.setTitle("shopInfoSureChange"|?|, for: UIControl.State.normal)
        let resetBtnBackImage = UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffcd34"), UIColor.colorWithHexStringSwift("ffab34")], bound: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 60, height: 45))
        self.resetBtn.setBackgroundImage(resetBtnBackImage, for: UIControl.State.normal)
        self.resetBtn.layer.masksToBounds = true
        self.resetBtn.layer.cornerRadius = 22.5
        
        self.containerView.addSubview(self.selectAddress)
        self.selectAddress.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 45)
        self.containerView.addSubview(self.textView)
        self.textView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.selectAddress.snp.bottom).offset(1)
            make.bottom.equalToSuperview()
        }
        self.placeholder.numberOfLines = 0
        self.textView.addSubview(self.placeholder)
        self.textView.backgroundColor = UIColor.white
        self.placeholder.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-15)
        }
        let _ = self.textView.rx.text.orEmpty.subscribe(onNext: { [weak self](value) in
            if value.count > 0 {
                self?.placeholder.isHidden = true
            }else {
                self?.placeholder.isHidden = false
            }
            self?.detailSubAddress = value
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.selectAddress.shopInfoBtnClick = { [weak self] (bo) in
            self?.selectArea()
        }
        
        if areaName.count > 0 {
            self.selectAddress.subTitleValue = areaName
            self.detailAddress = self.areaName
        }
        if address.count > 0 {
            self.textView.text = address
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    var detailSubAddress: String = ""
    func selectArea() {
        let frame = CGRect.init(x: 0, y: SCREENHEIGHT - 400 - TabBarHeight, width: SCREENWIDTH, height: 400)
        let view = AreaSelectView.init(superView: self.view, areaType: GetAreaType.area, subFrame: frame)
        view.sureBtn.isHidden = true
        view.containerView.backgroundColor = lineColor
        self.view.addSubview(view)
        
        let _ = view.finished.subscribe(onNext: { [weak self](address, id) in
            self?.detailAddress = address
            self?.areaID = id
            
            self?.selectAddress.subTitleValue = address
            view.removeFromSuperview()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    var finished: (((areaid: String, areaName: String, address: String)) -> ())?
    
    let selectAddress = ShopInfoCell.init(title: "contactAddressTitle"|?|, rightImage: "home_arrow", subTitle: "")
    let textView = UITextView.init()
    let placeholder = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("cccccc"), text: "contactAddressDetailAddressPlaceholder"|?|)
    
    @IBAction func resetBtn(_ sender: Any) {
        if !juedgeAddressDetail(address: (self.detailAddress)) {
            GDAlertView.alert("地址限制在30字之内", image: nil, time: 1, complateBlock: nil)
            return
        }
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": DDAccount.share.token ?? "", "address": self.detailSubAddress, "area": self.areaID]
        let router = Router.put("member/\(id)", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response)
            
            if model?.status == 200 {
                DDAccount.share.address = self.detailAddress
                DDAccount.share.save()
                self.finished?((self.areaID, self.detailAddress, self.detailSubAddress))
                self.popToPreviousVC()
            }
        }) {
            
        }
    }
    var areaID: String = ""
    var detailAddress: String = ""
    func juedgeAddressDetail(address: String) -> Bool {
        let regex = "^[a-zA-Z0-9\\u4e00-\\u9fa5]{0,30}$"
        let regextext = NSPredicate.init(format: "SELF MATCHES %@", regex)
        let result: Bool = regextext.evaluate(with: address)
        if result {
            return true
        }else {
            return false
        }
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
