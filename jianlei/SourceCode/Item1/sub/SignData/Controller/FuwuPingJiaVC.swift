//
//  FuwuPingJiaVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class FuwuPingJiaVC: DDInternalVC, UITextViewDelegate {
//15552751836
    
    @IBOutlet weak var scrllViewTop: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "service_evaluation"|?|
        self.scrollview.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.scrollview.isScrollEnabled = true
        self.textView.placeholderLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: "repari_other_enter"|?|)
        self.textView.placeholder(placeholder: "repari_other_enter"|?|)
        let textRx = self.textView.rx.text.orEmpty
        let _ = textRx.subscribe(onNext: { [weak self](title) in
            if title.count > 0 {
                self?.textView.placeholderLabel?.isHidden = true
            }else {
                self?.textView.placeholderLabel?.isHidden = false
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("")
        }) {
            mylog("结束")
        }
        self.scrllViewTop.constant = DDNavigationBarHeight
        self.textView.delegate = self
        self.view.layoutIfNeeded()
        if #available(iOS 11.0, *) {
            self.scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.sureBtn.frame = CGRect.init(x: 0, y: SCREENHEIGHT - 44 - DDSliderHeight, width: SCREENWIDTH, height: DDSliderHeight + 44     )
        self.view.addSubview(self.sureBtn)
        
        self.requestData()
        
        KeyboardManager.share.keyboardWillChangeFrameBlock = { [weak self] (keyboardFrame, duration) in
            
            if let textView =  self?.textView {
                self?.scrollview.configScrollViewContentOffSet(containerView: textView, keyboardFrame: keyboardFrame, duration: duration)
            }
            
            
        }
        // Do any additional setup after loading the view.
    }
    var id: String = ""
    var model: FuweiPingjiaModel?
    
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    func requestData() {
        guard let id = self.userInfo as? String else { return }
        self.id = id
        let paramete = ["token": DDAccount.share.token ?? "", "id": id]
        let router = Router.get("sign/comment-detail", .api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<FuweiPingjiaModel>.deserialize(from: dict)
            if let data = model?.data {
                self.model = data
                self.timeLabel.text = data.create_at
                self.locationLabel.text = data.shop_address
                self.weiHuMember.text = data.member_name
                self.weihuContect.text = data.content
                if let des = data.evaluate_description {
                    self.textView.text = des
                }else {
                    self.textView.text = ""
                }
                
                let contentHeight = (data.content ?? "").sizeWith(font: self.weihuContect.font , maxWidth: SCREENWIDTH - 90).height
                if contentHeight > 44 {
                    self.contentHeight.constant = contentHeight
                }else {
                    
                }
                self.view.layoutIfNeeded()
                
                
                if data.evaluate == "0" {
                    
                }else if data.evaluate == "1" {
                    self.goodEvealteAction(self.goodBtn)
                }else if data.evaluate == "2" {
                    self.midEveate(self.midBtn)
                }else if data.evaluate == "3" {
                    self.badAction(self.badBtn)
                }
                self.huiFangValue.text = data.shop_name
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    
    lazy var sureBtn: UIButton = {
        let btn = UIButton.init()
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: DDSliderHeight + 44)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        btn.layer.addSublayer(gradientLayer)
        btn.setTitle("submit"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    var evaluate: String = "0"
    @objc func btnClick(btn: UIButton) {
        if self.evaluate.count == 0 && self.textView.text.count == 0 {
            GDAlertView.alert("please_evaluate"|?|, image: nil, time: 1, complateBlock: nil)
            return
        }
        var des: String = ""
        if let dess = self.textView.text {
            des = dess
        }
        let paramete = ["token": DDAccount.share.token ?? "", "evaluate": self.evaluate, "id": self.id, "evaluate_description": des] as [String : Any]
        let router = Router.post("sign/evaluate", .api, paramete)
        btn.isEnabled = false
        
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<String>.deserialize(from: dict)
            if model?.status == 200 {
                self.isUpLoadEvealate = true
                let sure = ZKAlertAction.init(title: "sure"|?|, style: UIAlertAction.Style.default) { (action) in
                    self.model?.evaluate = self.evaluate
                    self.popToPreviousVC()
                }
                let alertView = MyAlertView.init(frame: CGRect.zero, title: "submit_success"|?|, message: "thank_you_support"|?|, actions: [sure])
                UIApplication.shared.keyWindow?.alertZkq(alertView)
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
            btn.isEnabled = true
        }, onError: { (error) in
            btn.isEnabled = true
        }, onCompleted: {
            
        }) {
            
        }
        
        
        
        
    }
    var isUpLoadEvealate: Bool = false
    override func popToPreviousVC() {
        if self.model?.evaluate == "0" {
            let sure = ZKAlertAction.init(title: "continue_evaluate"|?|, style: UIAlertAction.Style.default) { (action) in
                
            }
            let cancle = ZKAlertAction.init(title: "close"|?|, style: UIAlertAction.Style.cancel) { [weak self](action) in
                let paramete = ["token": DDAccount.share.token ?? "", "id": self?.id ?? ""]
                let router = Router.post("sign/close-evaluate", DomainType.api, paramete)
                let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                    let model = BaseModel<GDModel>.deserialize(from: dict)
                    if model?.status == 200 {
                        self?.navigationController?.popViewController(animated: true)
                    }else {
                        GDAlertView.alert("close_fail_alter"|?|, image: nil, time: 1, complateBlock: nil)
                    }
                }, onError: { (error) in
                    GDAlertView.alert("close_fail_alter"|?|, image: nil, time: 1, complateBlock: nil)
                }, onCompleted: {
                    mylog("结束")
                }, onDisposed: {
                    mylog("回收")
                })
                
            }
            let alertView = MyAlertView.init(frame: CGRect.zero, title: "close_evaluate_viewTitle"|?|, message: "close_evaluate_viewmessage"|?|, actions: [cancle, sure])
            UIApplication.shared.keyWindow?.alertZkq(alertView)
            
        }else {
            super.popToPreviousVC()
        }
        
        
        
    }
    
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
  
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var midBtn: UIButton!
    @IBOutlet weak var badBtn: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weihuContect: UILabel!
    @IBOutlet weak var huiFangValue: UILabel!
    @IBOutlet weak var weiHuMember: UILabel!
    @IBOutlet weak var badLabel: UILabel!
    @IBAction func badAction(_ sender: UIButton) {
        self.configBtn(sender: sender)
        
        
        
        
        
        
        
        
    }
    @IBAction func midEveate(_ sender: UIButton) {
        self.configBtn(sender: sender)
        
        
        
        
    }
    
    @IBOutlet weak var middleEvealtelabel: UILabel!
    
    @IBAction func goodEvealteAction(_ sender: UIButton) {
        self.configBtn(sender: sender)
        
        
    }
    func configBtn(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender {
        case self.badBtn:
            self.badLabel.textColor = UIColor.colorWithHexStringSwift(sender.isSelected ? "ff7d09" : "999999")
            self.evaluate = sender.isSelected ? "3": "0"
            self.midBtn.isSelected = false
            self.goodBtn.isSelected = false
            self.middleEvealtelabel.textColor = UIColor.colorWithHexStringSwift("999999")
            self.goodEvalTelabel.textColor = UIColor.colorWithHexStringSwift("999999")
        case self.midBtn:
            self.evaluate = sender.isSelected ? "2": "0"
            self.badBtn.isSelected = false
            self.goodBtn.isSelected = false
                self.middleEvealtelabel.textColor = UIColor.colorWithHexStringSwift(sender.isSelected ? "ff7d09" : "999999")
            self.badLabel.textColor = UIColor.colorWithHexStringSwift("999999")
            self.goodEvalTelabel.textColor = UIColor.colorWithHexStringSwift("999999")
            
        case self.goodBtn:
            self.goodEvalTelabel.textColor = UIColor.colorWithHexStringSwift(sender.isSelected ? "ff7d09" : "999999")
            self.evaluate = sender.isSelected ? "1": "0"
            self.midBtn.isSelected = false
            self.badBtn.isSelected = false
            self.badLabel.textColor = UIColor.colorWithHexStringSwift("999999")
            self.middleEvealtelabel.textColor = UIColor.colorWithHexStringSwift("999999")
        default:
            break
        }
    }
    
    @IBOutlet weak var goodEvalTelabel: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class FuweiPingjiaModel: GDModel {
    var content: String?
    var create_at: String?
    var evaluate: String?
    var maintain_content: String?
    var member_name: String?
    var shop_address: String?
    var desc: String?
    var shop_name: String?
    var evaluate_description: String?
    
}
