//
//  BillDetailVC.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/8/31.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class BillDetailVC: DDInternalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topViewTop.constant = DDNavigationBarHeight + 10
        self.view.backgroundColor = UIColor.colorWithRGB(red: 240, green: 240, blue: 240)
        self.price.font = UIFont.boldSystemFont(ofSize: 30)
        self.naviBar.title = "MingXiSubBillTitle"|?|
        self.view.addSubview(self.billDesc)
        self.view.addSubview(self.counterAccount)
        self.view.addSubview(self.billType)
        self.view.addSubview(self.billQuestion)
        self.view.addSubview(self.phone)
        self.phone.numberOfLines = 0
        self.phone.textAlignment = .center
        self.billDesc.title.textColor = UIColor.colorWithHexStringSwift("999999")
        self.counterAccount.title.textColor = UIColor.colorWithHexStringSwift("999999")
        self.billType.title.textColor = UIColor.colorWithHexStringSwift("999999")
        self.billQuestion.title.textColor = UIColor.colorWithHexStringSwift("999999")
        // Do any additional setup after loading the view.
        
        self.billDesc.subTitle.textColor = UIColor.colorWithHexStringSwift("323232")
        self.counterAccount.subTitle.textColor = UIColor.colorWithHexStringSwift("323232")
        self.billQuestion.subTitle.textColor = UIColor.colorWithHexStringSwift("323232")
        self.billType.subTitle.textColor = UIColor.colorWithHexStringSwift("323232")
        if let model = self.model {
            self.status.text = (model.type == "1") ? "MingXiSubBillTradeSuccess"|?| : "MingXiSubBillWithDrawalSuccess"|?|
            self.counterAccount.title.text = (model.type == "1") ? "MingXiSubCounterAccount"|?| : "MingXiSubWithdrawalsAccout"|?|
            self.topViewTItle.text = model.detail_title
            self.price.text = model.price
            self.status.text = "MingXiSubBillTradeSuccess"|?|
            self.billDesc.subTitleValue = model.account_desc
            self.counterAccount.subTitleValue = model.reciprocal_account
            var accountType: String = ""
            switch model.account_type ?? "1" {
            case "-1":
                accountType = "MingXiSubBillType_1"|?|
                if self.model?.status == "1" {
                    self.status.text = "MingXisubBillSubmitSuccess"|?|
                }
            case "1":
                accountType = "MingXiSubBillType1"|?|
            case "2":
                accountType = "MingXiSubBillType2"|?|
            case "3":
                accountType = "MingXiSubBillType3"|?|
            case "4":
                accountType = "MingXiSubBillType4"|?|
            case "5":
                accountType = "MingXiSubBillType5"|?|
            default:
                accountType = "MingXiSubBillType_1"|?|
            }
             
            self.billType.subTitleValue = model.title
            self.billQuestion.subTitleValue = model.detail_time
        }
        
        
        
        
        
    }
    var type: String = "1"
    var model: MingXiItem?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mylog(self.topView.frame)
        self.billDesc.frame = CGRect.init(x: 0, y: self.topView.max_Y + 1, width: SCREENWIDTH, height: 45)
        self.counterAccount.frame = CGRect.init(x: 0, y: self.billDesc.max_Y, width: SCREENWIDTH, height: 45)
        self.billType.frame = CGRect.init(x: 0, y: self.counterAccount.max_Y, width: SCREENWIDTH, height: 45)
        self.billQuestion.frame = CGRect.init(x: 0, y: self.billType.max_Y, width: SCREENWIDTH, height: 45)
        self.phone.frame = CGRect.init(x: 15, y: self.billQuestion.max_Y + 10, width: SCREENWIDTH - 30, height: 40)
    }
    @IBOutlet weak var topViewTop: NSLayoutConstraint!
    @IBOutlet weak var topViewTItle: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var status: UILabel!
    let billDesc = ShopInfoCell.init(frame: CGRect.zero, title: "MingXiSubBillDesc"|?|)
    let counterAccount = ShopInfoCell.init(frame: CGRect.zero, title: "MingXiSubBillDesc"|?|)
    let billType = ShopInfoCell.init(frame: CGRect.zero, title: "MingXiSubBillType"|?|)
    let billQuestion = ShopInfoCell.init(frame: CGRect.zero, title: "MingXiSubBillCreateTime"|?|)

    let phone = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "MingXiSubBillQuestions"|?|)
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
