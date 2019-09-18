//
//  ClaanderWebVC.swift
//  Project
//
//  Created by 张凯强 on 2018/4/27.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD
class ClaanderWebVC: HomeWebVC {
    var paramete: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.naviBar.isHidden = true
        self.webView.frame = CGRect.init(x: 0, y: StatusBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - StatusBarHeight)
        self.progressView.frame = CGRect.init(x: 0, y: webView.y, width: SCREENWIDTH, height: 2)
        // Do any additional setup after loading the view.
    }

    override func reload() {
        guard let urlStr = self.userInfo as? String else {
            //            mylog("webViewController对应的url字符串不存在\(self.showParameter)")
            return
        }
        //        print(GDNetworkManager.shareManager.token)
        if let token = DDAccount.share.token {
            var urlStrAppendToken   = ""
            if (urlStr == (DomainType.wap.rawValue + "shop/create?type=yewu")) || ((DomainType.wap.rawValue + "shop/create?type=dianpu") == urlStr) {
                if let subStr = self.subUserInfo as? String {
                    urlStrAppendToken = urlStr.appending("&token=\(token)") + subStr
                }else {
                    urlStrAppendToken = urlStr.appending("&token=\(token)")
                }
            }else {
                if let subStr = self.subUserInfo as? String {
                    urlStrAppendToken = urlStr.appending("?token=\(token)") + subStr
                }else {
                    urlStrAppendToken = urlStr.appending("?token=\(token)")
                }
                
            }
            
            mylog(urlStrAppendToken)
            if  urlStrAppendToken.hasPrefix("https://") || urlStrAppendToken.hasPrefix("http://") {
                if let urlStr = urlStrAppendToken.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    guard let url  = URL.init(string: urlStr ) else {
                        mylog("webViewController的urlStr字符串转换成URL失败")
                        return
                    }
                    let urlRequest = URLRequest.init(url: url)
                    self.webView.load(urlRequest)
                }
                
                
            }
        }else{
            
            
            
            if let  urlstring = self.userInfo as? String  {
                if let urlStr = urlstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    guard let url  = URL.init(string: urlStr) else {
                        mylog("webViewController的urlStr字符串转换成URL失败")
                        return
                    }
                    
                    let urlRequest = URLRequest.init(url: url)
                    
                    self.webView.load(urlRequest)
                }
                
                
            }
        }
    }
    
    
    override func analysisTheDateFromJS(message : WKScriptMessage)  {
        if (message.name == "ylcm") {
            guard let json  = message.body as? String else { return  }
            if let action = self.getValueFromKey(key: "action", beAnalysisJson: json){
                switch action  {
                case "closewebview" , "closewebviewbycreateshop"://关闭webView
                    if let shopCount = self.getValueFromKey(key: "shop_number", beAnalysisJson: json){
                        UserDefaults.standard.setValue(shopCount, forKey: "ShopCount")
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                    
                case "call"://关闭webView
                    if let telNum = self.getValueFromKey(key: "number", beAnalysisJson: json){
                        UIApplication.shared.openURL(URL(string: "telprompt:\(telNum)")!)
                    }
                    
                case "selectareawebviewgoback":
                    self.popToPreviousVC()
                case "selectareawebview":
                    if let dict = paramete as? [String: String] {
                        let order = TrueOrderVC()
                        mylog(dict)
                        order.userInfo = dict
                        self.navigationController?.pushViewController(order, animated: true)
                    }
                    
                
                case "clickconfirmmodifyorder":
                    trueAction()
                    
                default:
                    break
                }
            }
        }else{
            mylog("js的方法名未在本地注册")
        }
    }
    var start: String = ""
    var end: String = ""
    weak var cover: DDCoverView?
    @objc func trueAction() {
        if let window = self.view.window {
            let view = DDCoverView.init(superView: window)
            self.cover = view
            self.cover?.deinitHandle = { [weak self] in
                self?.cover?.removeFromSuperview()
                self?.cover = nil
                
            }
            
            let y: CGFloat = (SCREENHEIGHT - 180) / 2.0
            
            let containerView = ZChangeTimeAlert.init(frame: CGRect.init(x: 30, y: y , width: SCREENWIDTH - 60, height: 180), startDay: start, endDay: end, superView: view, count: self.is_update ?? "0")
            
            containerView.sureBtn.addTarget(self, action: #selector(sureChangeAction(sender:)), for: .touchUpInside)
        }
        
        
        
        
    }
    var is_update: String?
    @objc func sureChangeAction(sender: UIButton) {
        sender.isEnabled = false
        self.requestData {
            sender.isEnabled = true
            
        }
        
        
    }
    var hud: MBProgressHUD?
    func generalButtonAction()  {
        self.hud = MBProgressHUD.init(view: self.view.window!)
        self.view.window!.addSubview(self.hud!)
        self.hud?.label.text = "修改中"
        self.hud?.detailsLabel.text = "请耐心等待..."
        self.hud?.show(animated: true)
        
    }
    var orderID: String?
    func requestData(success: (() -> ())?) {
        let orderid = self.orderID ?? ""
        let memberid = DDAccount.share.id ?? ""
        let paramete = ["start_at": self.start, "end_at": self.end, "token": DDAccount.share.token ?? ""]
        let router = Router.put("member/\(memberid)/orderdate/\(orderid)", .api, paramete)
        self.generalButtonAction()
        
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            self.hud?.removeFromSuperview()
            self.hud = nil
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                self.cover?.removeFromSuperview()
                self.cover = nil
                
                NotificationCenter.default.post(name: NSNotification.Name.init("changeSelectTime"), object: nil, userInfo: ["start": self.start, "end": self.end])
                self.navigationController?.popToSpecifyVC(DDOrderDetailVC.self)
                success?()
            }else {
                success?()
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: {
                    
                })
            }
            
            
        }, onError: { (error) in
            self.hud?.removeFromSuperview()
            self.hud = nil
            success?()
        }, onCompleted: {
            success?()
            mylog("结束")
            self.hud?.removeFromSuperview()
            self.hud = nil
        }) {
            mylog("回收")
        }
    }
    override func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        super.webView(webView, didFailProvisionalNavigation: navigation, withError: error)
        GDAlertView.alert("加载失败请检查网络", image: nil, time: 1) {
            self.popToPreviousVC()
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
