//
//  DDNoShopVC.swift
//  Project
//
//  Created by WY on 2019/8/13.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDNoShopVC: DDNormalVC {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let function1 = UILabel()
    let function2 = UILabel()
    let function3 = UILabel()
    let tipsLabel = UILabel()
    let createButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的店铺"
        _addSubviews()
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        self.navigationController?.removeSpecifyVC(GDBaseWebVC.self )
//        self.navigationController?.removeSpecifyVC(DDSetWithGroupVC.self )
        
        //        }
        // Do any additional setup after loading the view.
    }
    func _addSubviews() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(function1)
        self.view.addSubview(function2)
        self.view.addSubview(function3)
        self.view.addSubview(tipsLabel)
        self.view.addSubview(createButton)
        self.setAttributeTitle(label: function1, title: "  安装屏幕，获得额外收益")
        self.setAttributeTitle(label: function2, title: "  增加店铺形象，提升档次")
        self.setAttributeTitle(label: function3, title: "  让客户理发过程不再无趣")
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.darkGray
        tipsLabel.textAlignment = .center
        tipsLabel.numberOfLines = 3
        tipsLabel.textColor = .red
        tipsLabel.font = UIFont.systemFont(ofSize: 13)
        imageView.image = UIImage(named:"createinstallationteam")
        imageView.contentMode = .scaleAspectFit
        tipsLabel.text = "注：申请需要您本人的身份证和店铺营业执照"
        titleLabel.text = "店铺屏幕申请"
        createButton.setTitle("申请安装", for: UIControl.State.normal)
//        createButton.backgroundColor = .orange
        createButton.setBackgroundImage(UIImage(named: "bottom_button_bg"), for: UIControl.State.normal)
        createButton.addTarget(self , action: #selector(createGroup(sender:)), for: UIControl.Event.touchUpInside)
        _layoutSubviews()
        //        ◼︎
    }
    @objc func createGroup(sender:UIButton) {
        let url = DomainType.wap.rawValue + "shop/choose-shop-type?dev=ios"
        let vc = GDBaseWebVC()
        vc.userInfo = url
        self.navigationController?.pushViewController(vc , animated: true )
        
//        let cancel = DDAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: { (action ) in
//            print(action._title)
//        })
//
//        let sure = DDAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: { (action ) in
//            self.pushVC(vcIdentifier: "DDCreateGroupVC")
//        })
//        let message1  = "创建安装小组后则不能以个人身份接受安装任务,是否确认创建小组"
//
//        let alert = DDNotice1Alert(message: message1, backgroundImage: UIImage(named:"pop-upbackground"), image: UIImage(named:"createagroupicon"), actions:  [sure,cancel])
//
//        alert.isHideWhenWhitespaceClick = false
//        UIApplication.shared.keyWindow?.alert( alert)
        
    }
    func setAttributeTitle(label:UILabel,title:String) {
        label.textColor = UIColor.lightGray
        let attributeTitle = NSMutableAttributedString()
        let header = NSMutableAttributedString(string: "■")//""
        //        let tangle = NSTextAttachment()
        //        tangle.image = UIImage(named:"")
        header.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: 1))
        let title = NSAttributedString(string: title)
        attributeTitle.append(header)
        attributeTitle.append(title)
        label.attributedText = attributeTitle
    }
    func _layoutSubviews() {
        let createButtonX : CGFloat = 72
        let createButtonW = SCREENWIDTH - createButtonX * 2
//        tipsLabel.frame = CGRect(x: createButtonX/2, y: self.view.bounds.height/2, width: createButtonW + createButtonX, height: 54)
        titleLabel.frame = CGRect(x: 0, y: self.view.bounds.height/2 - 64, width: SCREENWIDTH, height: 44)
        let imageX : CGFloat = 100
        let imageWH = SCREENWIDTH - imageX * 2
        imageView.frame = CGRect(x: imageX, y: titleLabel.frame.minY - imageWH , width: imageWH, height: imageWH)
        function1.sizeToFit()
        let functionW = function1.bounds.size.width
        let functionX = (SCREENWIDTH - functionW ) / 2
        function1.frame  = CGRect(x: functionX, y: titleLabel.frame.maxY + 30, width: functionW, height: 40)
        function2.frame  = CGRect(x: functionX, y: function1.frame.maxY , width: functionW, height: 40)
        function3.frame  = CGRect(x: functionX, y: function2.frame.maxY, width: functionW, height: 40)
        createButton.frame = CGRect(x: createButtonX, y: SCREENHEIGHT - DDSliderHeight - 100, width: createButtonW, height: 44)
        tipsLabel.frame = CGRect(x: 0, y: createButton.frame.minY - 24, width: SCREENWIDTH, height: 20)
        createButton.embellishView(redius: 5)
    }

}
