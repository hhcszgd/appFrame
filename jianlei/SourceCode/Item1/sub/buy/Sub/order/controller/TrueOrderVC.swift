//
//  TrueOrderVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
class TrueOrderVC: DDNormalVC {
    @IBOutlet var btnBottom: NSLayoutConstraint!
    
    @IBOutlet var payBottom: NSLayoutConstraint!
    @IBOutlet var scrollBottom: NSLayoutConstraint!
    @IBOutlet var top: NSLayoutConstraint!
    
    @IBOutlet var backScroll: UIScrollView!
    @IBOutlet var timeValue: UILabel!
    @IBOutlet var areaValue: UILabel!

    @IBOutlet var advertiseValue: UILabel!
    @IBOutlet var timeLengthValue: UILabel!
    @IBOutlet var rateValue: UILabel!
    @IBOutlet var partnerValue: UITextField!
    
    @IBOutlet var totalTime: UILabel!
    
    
    @IBAction func checkPhoneAction(_ sender: UIButton) {
        if self.phone.count < 1 {
            GDAlertView.alert("请填写业务合作人手机号", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.phone.mobileLawful() {
            GDAlertView.alert("业务人手机号码错误", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        
        let token = DDAccount.share.token ?? ""
        let paramete: [String: Any] = ["token": token, "member_type": "2" ]
        let id = self.phone
        let _ = NetWork.manager.requestData(router: Router.get("member/\(id)/parent", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    sender.setTitle(data.name, for: .normal)
                }
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
            }, onError: { (error) in
                
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        self.partnerValue.resignFirstResponder()
        
    }
    var areaid: String = ""
    var selectArea: AreaSelectView?
    
    @IBAction func selectAreaAction(_ sender: UIButton) {
        let vc = DDSelectedAreaVC()
        vc.userInfo = "0"
        vc.type = "1"
        self.navigationController?.pushViewController(vc, animated: true)
//        self.pushVC(vcIdentifier: "DDSelectedAreaVC", userInfo: "0")
    }
    var cover: DDCoverView?
    @IBAction func selectUsAreaAction(_ sender: UIButton) {
        sender.titleLabel?.numberOfLines = 0
        self.partnerValue.resignFirstResponder()
        let frame = CGRect.init(x: 0, y: SCREENHEIGHT - 400 - TabBarHeight, width: SCREENWIDTH, height: 400)
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {[weak self] in
            self?.conerClick()
            self?.selectArea = nil
        }
        
        self.selectArea = AreaSelectView.init(frame: frame, title: "jj", type: 100, url: "area", subFrame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.selectArea?.sureBtn.isHidden = true
        self.selectArea?.containerView.backgroundColor = lineColor
        self.cover?.addSubview(self.selectArea!)
        

        let _ = self.selectArea?.finished.subscribe(onNext: { [weak self](address, id) in
            sender.setTitle(address, for: .normal)
            self?.conerClick()
            self?.areaid = id
            self?.selectArea?.removeFromSuperview()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
    }
    @objc func conerClick()  {
        self.cover?.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        self.cover?.removeFromSuperview()
        self.cover = nil
//        self.selectArea = nil
//        //        self.levelSelectButton.isSelected = false
//        if let corverView = self.cover{
//            for (_ ,view) in corverView.subviews.enumerated(){
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//                    view.frame = CGRect(x: 0 , y: self.view.bounds.height, width: self.view.bounds.width , height: 250)
//                    corverView.alpha = 0
//                }, completion: { (bool ) in
//                    corverView.remove()
//                    self.cover = nil
//                })
//            }
//        }
    }

    
    
    
    

    var dict: [String: String] = [String: String]()
    @IBOutlet var sucaiValue: UILabel!
    @IBOutlet var dayCountValue: UILabel!
    @IBOutlet var priceValue: UILabel!
    @IBOutlet var totalPriceValue: UILabel!
    var memberName: String = ""
    @IBOutlet var payBtn: UIButton!
    
    @IBOutlet var payView: UIView!
    
    @IBOutlet var payViewHeight: NSLayoutConstraint!
    
    @IBOutlet var payBtnheight: NSLayoutConstraint!
    @IBOutlet weak var memberNameText: UITextField!
    @IBAction func payTypePromptAction(_ sender: UIButton) {
        self.payTypePromptView()
    }
    @IBOutlet var payTypeBtn: UIButton!
    @IBAction func payTypeBtnAction(_ sender: UIButton) {
        self.selectPayType()
    }
    @IBOutlet var truePayLabel: UILabel!
    @IBOutlet var backView: UIView!
    var hud: MBProgressHUD?
    func generalButtonAction()  {
        self.hud = MBProgressHUD.init(view: self.view)
        self.view.addSubview(self.hud!)
        self.hud?.label.text = "下单中"
        self.hud?.detailsLabel.text = "请耐心等待..."
        self.hud?.show(animated: true)
        
    }
    @IBAction func sureAction(_ sender: UIButton) {
        
        if self.phone.count == 0 {
            GDAlertView.alert("请填写客户手机号", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.memberName.count == 0 {
            GDAlertView.alert("请输入客户名称或者客户公司名称", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.phone.mobileLawful() {
            GDAlertView.alert("客户手机号错误", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !((self.payTypeBtn.currentTitle == "全额支付") || (self.payTypeBtn.currentTitle == "定金支付")) {
            GDAlertView.alert("请选择支付类型", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.areaid.count <= 0 {
            GDAlertView.alert("请选择客户所在地", image: nil, time: 1, complateBlock: nil)
            return
        }
        sender.isEnabled = false
        var payType: String = "1"
        if (self.payTypeBtn.currentTitle == "全额支付") {
            payType = "1"
        }else {
            payType = "2"
        }
        
        let truePrice = String.init(format: "%d", self.truePay)
        self.dict["truePrice"] = truePrice
        let salesman_mobile = self.phone
        let advert_id = self.dict["advert_id"] ?? ""
        let rate = self.dict["rate"] ?? ""
        let advert_time = self.dict["advert_time"] ?? ""
        let payment_type = payType
        let total_day = self.dict["total_day"] ?? ""
        let start_at = self.dict["start_at"] ?? ""
        let end_at = self.dict["end_at"] ?? ""
        let company_area_id = self.areaid
        let token = DDAccount.share.token ?? ""
        let paramete = ["member_mobile": salesman_mobile, "advert_id": advert_id, "rate": rate, "advert_time": advert_time, "payment_type": payment_type, "total_day": total_day, "start_at": start_at, "end_at": end_at, "company_area_id": company_area_id, "token": token, "member_name": self.memberName]
        let id = DDAccount.share.id ?? ""
        self.generalButtonAction()
        let _ = NetWork.manager.requestData(router: Router.post("member/\(id)/order", .api, paramete)).subscribe(onNext: { (dict) in
            sender.isEnabled = true
            self.hud?.removeFromSuperview()
            self.hud = nil
            if let model = BaseModel<OrderCodeModel>.deserialize(from: dict) {
                if model.status == 200 {
                    if let orderCode = model.data?.order_code, let orderID = model.data?.order_id {
                        let vc = UploadOrdreVc()
                        vc.orderID = orderID
                        vc.orderCode = orderCode
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        GDAlertView.alert("数据格式不对", image: nil, time: 1, complateBlock: nil)
                    }
                    
                }else {
                    if model.status == 603 {

                    }else {
                        GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                    }
                    
                }
            }else {
                
            }
            
        }, onError: { (error) in
            sender.isEnabled = true
            self.hud?.removeFromSuperview()
            self.hud = nil
            GDAlertView.alert("网络问题,请重试", image: nil, time: 1, complateBlock: nil)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    

    @IBOutlet weak var screenNumber: UILabel!

    var ration: Float = 0
    var totalPrice: Float = 0
    var truePay: Float = 0
    ///底层的阴影
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        self.btnBottom.constant = TabBarHeight
        self.payBottom.constant = TabBarHeight
        self.top.constant = DDNavigationBarHeight
        self.scrollBottom.constant = TabBarHeight + 40
        
        self.view.layoutIfNeeded()
        self.title = "确认订单"
        if var dict = self.userInfo as? [String: String] {
            let router = Router.post("advert", .api, dict)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (result) in
                let model = BaseModel<TrueOrderModel>.deserialize(from: result)
                if let data = model?.data {
                    self.timeValue.text = dict["start_at"]! + "到" + dict["end_at"]!
                    self.dict["start_at"] = dict["start_at"]!
                    self.dict["end_at"] = dict["end_at"]
                    if let areaName = data.area_name {
                        self.areaValue.text = areaName
                        self.dict["area_name"] = areaName
                    }
                    if let name = data.name {
                        self.advertiseValue.text = name
                        self.dict["name"] = name
                    }
                    
                    self.timeLengthValue.text = dict["time"]
                    self.dict["advert_time"] = dict["time"]
                    self.rateValue.text = dict["rate"]! + "次/天"
                    self.dict["rate"] = dict["rate"]!
                    self.dayCountValue.text = dict["total_day"]! + "天"
                    self.dict["total_day"] = dict["total_day"]!
                    self.priceValue.text = (dict["unit_price"] ?? "") + "元/天"
                    self.dict["advert_id"] = dict["advert_id"]!
                    if let orderPrice = data.order_price {
                        self.totalPriceValue.text = "￥" + orderPrice
                        self.truePayLabel.text = "￥" + orderPrice
                        self.dict["order_price"] = orderPrice
                    }
//                    if let specStr = data["spec"] as? String {
//                        self.size.text = "广告素材尺寸：" + specStr
//                        self.dict["spec"] = specStr
//                    }
//
//                    if let format = data["format"] as? String {
//                        self.format.text = "支持的广告素材格式：" + format
//                        self.dict["format"] = format
//                    }
//                    if let sizeStr = data["size"] as? String {
//                        self.sepc.text = "素材大小：" + sizeStr
//                        self.dict["size"] = sizeStr
//                    }
//
                    if let ration = data.prepayment_ratio , let ra = Float(ration) {
                        self.ration = ra / 100.0
                        self.dict["prepayment_ratio"] = ration
                    }
                    if let totalTime = data.total_time {
                        self.totalTime.text = totalTime
                        self.dict["total_time"] = totalTime
                    }
                    if let totalTime = data.total_time as? Int {
                        self.totalTime.text = "\(totalTime)"
                        self.dict["total_time"] = "\(totalTime)"
                    }
                    if let num = data.screen_number {
                        self.screenNumber.text = num
                    }
                    if let price = data.order_price, let priceFloat = Float(price) {
                        self.totalPrice = priceFloat
                        self.truePay = priceFloat
                        self.dict["order_price"] = price
                        
                        if  let priceValue = Float(price) {
                            if priceValue < 10000 {
                                self.payTypeBtn.setTitle("全额支付", for: .normal)
                            }
                            
                        }
                        
                    }
                    
                }else {
                    if let message = result["message"] as? String {
                        self.navigationController?.popViewController(animated: true)
                        GDAlertView.alert(message, image: nil, time: 1, complateBlock: nil)
                    }
                    
                }
            }, onError: { (error) in
                
            }, onCompleted: {
                mylog("结束")
            }, onDisposed: {
                mylog("回收")
            })
        }
        self.partnerValue.inputAccessoryView = self.addToolbar()
        let rxText = self.partnerValue.rx.text.orEmpty
        let _ = rxText.subscribe(onNext: { [weak self](value) in
            self?.phone = value
            if self?.selectArea != nil {
                self?.selectArea?.removeFromSuperview()
                self?.selectArea = nil
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let rxMemberName = self.memberNameText.rx.text.orEmpty
        let _ = rxMemberName.subscribe(onNext: { [weak self](value) in
            self?.memberName = value
            }, onError: { (error) in
                
        }, onCompleted: nil, onDisposed: nil)
        
        

        if #available(iOS 11.0, *) {
            self.backScroll.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
   
    
    var phone: String = ""
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



extension TrueOrderVC {
    
    func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 35))
        toolbar.tintColor = UIColor.colorWithHexStringSwift("5585f1")
        toolbar.backgroundColor = UIColor.white
        let bar = UIBarButtonItem.init(title: "确定", style: UIBarButtonItem.Style.plain, target: self, action: #selector(complete))
        
        toolbar.items = [bar]
        return toolbar
    }
    @objc func complete() {
        self.partnerValue.resignFirstResponder()
    }
    ///选择支付类型
    func selectPayType() {
        if let price = self.dict["order_price"], let priceValue = Float(price) {
            if priceValue < 10000 {
                return
            }
            
        }
        
        
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        let pickerContainer = PayTypeView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 80))
        self.cover?.addSubview(pickerContainer)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: SCREENHEIGHT - 80 - TabBarHeight, width: self.view.bounds.width, height: 80)
        }, completion: { (bool ) in
        })
        
        let _ = pickerContainer.type.subscribe(onNext: { [weak self](value) in
            self?.payTypeBtn.setTitle((value == "0") ? "定金支付":"全额支付", for: .normal)
            self?.configPickerContainer(value: value)
            self?.conerClick()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    ///设置是定金支付还是金额支付
    func configPickerContainer(value: String) {
        if value == "0" {
            self.truePay = self.totalPrice * self.ration
            self.truePayLabel.text = String.init(format: "￥%0.2f", self.truePay)
            
        }else {
            self.truePay = self.totalPrice
            self.truePayLabel.text = String.init(format: "￥%0.2f", self.totalPrice)
        }
        self.cover?.remove()
        self.conerClick()
    }
    ///定金支付和全额支付的解释
    func payTypePromptView() {
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        
        if let price = self.dict["order_price"], let priceValue = Float(price) {
            if priceValue < 10000 {
                let x: CGFloat = (SCREENWIDTH - 275) / 2.0
                let y: CGFloat = (SCREENHEIGHT - 100) / 2.0
                let pickerContainer = PayTypePromptView.init(frame: CGRect.init(x: x, y: 0, width: 275, height: 100))
                self.cover?.addSubview(pickerContainer)
                pickerContainer.titleLabel.text = "订单少于10000元只可选择全额支付。"
                pickerContainer.subTitle.text = ""
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    pickerContainer.frame = CGRect(x: x , y: y, width: 275, height: 100)
                }, completion: { (bool ) in
                })
                let _ = pickerContainer.action.subscribe(onNext: { [weak self](_) in
                    self?.conerClick()
                    
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
                
                return
            }
        }
        
        
        let x: CGFloat = (SCREENWIDTH - 275) / 2.0
        let y: CGFloat = (SCREENHEIGHT - 195) / 2.0
        let pickerContainer = PayTypePromptView.init(frame: CGRect.init(x: x, y: 0, width: 275, height: 195))
        self.cover?.addSubview(pickerContainer)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: x , y: y, width: 275, height: 195)
        }, completion: { (bool ) in
        })
        let _ = pickerContainer.action.subscribe(onNext: { [weak self](_) in
            self?.conerClick()
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
        
    }
    
    
    
}

class PayTypeView: UIView
{
    
    let type: PublishSubject<String> = PublishSubject<String>.init()
    ///定金支付
    @IBOutlet var btn1: UIButton!
    ///全额支付
    @IBOutlet var btn2: UIButton!
    ///定金支付action
    @IBAction func btn1Action(_ sender: UIButton) {
        self.type.onNext("0")
        self.type.onCompleted()
    }
    ///全额支付action
    @IBAction func btn2Action(_ sender: UIButton) {
        self.type.onNext("1")
        self.type.onCompleted()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let containerView = Bundle.main.loadNibNamed("PayTypeView", owner: self, options: nil)?.first as! UIView
        self.contentView = containerView
        self.addSubview(containerView)
    }
    var contentView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



