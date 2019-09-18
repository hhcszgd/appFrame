//
//  UpPaySuccessView.swift
//  Project
//
//  Created by 张凯强 on 2018/3/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class UpPaySuccessView: UIView {
    var orderID: String?
    var orderCode: String?
    
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet var label: UILabel!
    var containerView: UIView!
    init(frame: CGRect, orderId: String? = nil) {
        super.init(frame: frame)
        if let subView = Bundle.main.loadNibNamed("UpPaySuccessView", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        if orderId == nil {
            return
        }
        self.label.attributedText = NSAttributedString.init()
        self.request(orderId: orderId!)
        
    }
    func request(orderId: String) {
        
        let memberId = DDAccount.share.id ?? ""
        let token = DDAccount.share.token ?? ""
        let router = Router.get("member/\(memberId)/prevorder/\(orderId)", .api, ["token": token])
        
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<PrivateModel>.deserialize(from: dict)
            if model?.status == 200 {
                let dealPrice = model?.data?.deal_price ?? ""
                let orderPrice = model?.data?.order_price ?? ""
                let phone = model?.data?.service_phone ?? ""
                
               
                if dealPrice == orderPrice {
                    self.label.attributedText = NSMutableAttributedString.init()
                    return
                }else {
                    
                    if dealPrice != "0" {
                        let str = "\n   由于在您付款期间，选择广告档期部分被他人抢先购买。您实付\(orderPrice)元，购买的实际广告总额价值为\(dealPrice)元。\n   我们会按照您购买的档期播出，对于您的损失我们将会按照增加档期的方式进行补播。\n     若您不同意我们的补播方案，或者有任何意见请联系客服：\n   \(phone)\n"
                        let attributeText = NSMutableAttributedString.init(string: str)
                        let paragraphStyle = NSMutableParagraphStyle.init()
                        paragraphStyle.lineSpacing = 3
                        paragraphStyle.firstLineHeadIndent = 30
                        attributeText.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange.init(location: 0, length: str.count))
                        self.label.attributedText = attributeText
                        self.statusTitle.text = "您的广告订单已购买成功"
                    }else {
                        let str = "\n  很抱歉，由于在您付款期间，选择广告档期全部被他人抢先购买，因此未能成功购买对应广告档期。\n  我们建议您可以在订单详情页重新选择投放时间。\n  若您不同意修改投放时间，或有任何意见\n  请联系客服：400-073-6688\n"
                        self.statusTitle.text = "您的广告订单购买失败"
                        
                        let attributeText = NSMutableAttributedString.init(string: str)
                        let paragraphStyle = NSMutableParagraphStyle.init()
                        paragraphStyle.lineSpacing = 3
                        paragraphStyle.firstLineHeadIndent = 30
                        attributeText.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange.init(location: 0, length: str.count))
                        self.label.attributedText = attributeText
                    }
                    
                    
                    self.label.layer.borderColor = UIColor.colorWithHexStringSwift("ed8210").cgColor
                    self.label.layer.borderWidth = 1
                    self.label.layer.cornerRadius = 3
                    self.label.layer.masksToBounds = true
                    
                }
                
                

            }else {
                self.label.attributedText = NSAttributedString.init()
            }
        }, onError: { (_) in
            self.label.attributedText = NSAttributedString.init()
        }, onCompleted: {
            
        }) {
            
        }
    }
    class PrivateModel: GDModel {
        var deal_price: String?
        var order_price: String?
        var service_phone: String?
    }
    let checkOrderDetail: PublishSubject<String> = PublishSubject<String>.init()
    @IBAction func checkOrderDetailAction(_ sender: UIButton) {
        self.checkOrderDetail.onNext("success")
        self.checkOrderDetail.onCompleted()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.frame = self.bounds
    }
    

}
