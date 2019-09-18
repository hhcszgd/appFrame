//
//  ScreenInstallVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/8.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import WebKit
class ScreenInstallVC: LEDApplicationVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNa()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.reload()
    }
    func configNa() {
        let historyBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        historyBtn.setImage(UIImage.init(named: "installBussiness_history"), for: UIControl.State.normal)
        historyBtn.backgroundColor = UIColor.clear
        historyBtn.addTarget(self, action: #selector(actionToHistoryList(btn:)), for: UIControl.Event.touchUpInside)
        self.naviBar.rightBarButtons = [historyBtn]
        self.historyBtn = historyBtn;
        
    }
    var historyBtn: UIButton?

    
    override func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling , nil )
        hiddenRightBtn()
        dynamicHiddenBackButton()
    }
    override func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void){
        decisionHandler(WKNavigationResponsePolicy.allow)
        hiddenRightBtn()
        dynamicHiddenBackButton()

    }
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        self.naviBar.attributeTitle = NSAttributedString.init(string: webView.title ?? "")
        webView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            webView.alpha = 1
        }
        dynamicHiddenBackButton()
        hiddenRightBtn()
   
    }
    override func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        self.naviBar.attributeTitle = NSAttributedString.init(string: webView.title ?? "")
        hiddenRightBtn()
        mylog(webView.title)
    }
   
    func hiddenRightBtn() {
        mylog(self.webView.backForwardList.backList.count)
        if self.webView.url?.absoluteString.contains("install-list/list?") ?? false {
            self.historyBtn?.isHidden = false
        }else {
            self.historyBtn?.isHidden = true
        }
//        if self.webView.backForwardList.backList.count > 0 {
//            self.historyBtn?.isHidden = true
//        }else {
//            self.historyBtn?.isHidden = false
//        }
    }

    @objc func actionToHistoryList(btn: UIButton) {
        self.pushVC(vcIdentifier: "InstallHistoryVC", userInfo: nil)
    }
    
    override func dynamicHiddenBackButton() {
        self.naviBar.backBtn.isHidden = false
//        if self.webView.backForwardList.backList.count == 0 {
//            if self.isFirstVCInNavigationVC {
//                self.naviBar.backBtn.isHidden = true
//            }else{
//                self.naviBar.backBtn.isHidden = false
//            }
//        }else{
//            self.naviBar.backBtn.isHidden = false
//        }
    }

    override func popToPreviousVC (){
        mylog(self.webView.backForwardList.backList.count)
        self.naviBar.backBtn.isHidden = false
        self.webView.stopLoading()
        if (self.webView.canGoBack) {
            let count : Int = self.webView.backForwardList.backList.count
            for i in 0  ..< count {
                let   item :  WKBackForwardListItem = self.webView.backForwardList.backList[count - 1 - i]
                
                if (item.url.absoluteString.contains("nottaken")) {
                    if (i==count-1) {//如果栈底的还不需要在返回的时候显示,就直接pop到上一个控制器
                        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
                        _ =  self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.webView.go(to: item)
                    mylog(self.webView.backForwardList.backList.count)
                    if (item.url.absoluteString.contains("orderlist")) {//待评价页面返回时需要重新加载
                        self.webView.reload()
                    }
                    break
                }
            }
        }else{
            self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
            _ =  self.navigationController?.popViewController(animated: true)
            
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
