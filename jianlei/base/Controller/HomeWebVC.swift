//
//  HomeWebVC.swift
//  Project
//
//  Created by WY on 2019/8/30.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//



import UIKit
import WebKit

class BaseWebVC: DDInternalVC , WKScriptMessageHandler ,  WKNavigationDelegate,WKUIDelegate {
    
    let webView : WKWebView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    let progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 2))
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: [NSKeyValueObservingOptions.new], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.webView)
        self.layoutsubviews()
        self.view.addSubview(self.progressView)
        self.progressView.frame = CGRect.init(x: 0, y: self.webView.y, width: SCREENWIDTH, height: 2)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let web = object as? WKWebView, web == self.webView {
            if keyPath == "estimatedProgress" {
                self.progressView.alpha = 1.0
                self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
                if self.webView.estimatedProgress >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        self.progressView.alpha = 0.0
                    }) { (finished) in
                        self.progressView.setProgress(0.0, animated: false)
                    }
                }
                
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    deinit {
        mylog("HomeWebVC销毁销毁")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    var subUserInfo: Any?
    
    func layoutsubviews() {
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.configuration.preferences.javaScriptEnabled = true
        self.webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        //        self.webView.allowsBackForwardNavigationGestures = true //会出现不愿看到的返回列表
        //- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;
        self.webView.configuration.userContentController.add(self , name : "ylcm")//传值的关键 , 释放的时候记得移除
        
        
        var  webViewY = 64
//        if DDDevice.type == .iphoneX {webViewY = 88}
        if DDDevice.isFullScreen {webViewY = 88}
        var webViewH = UIScreen.main.bounds.height - DDNavigationBarHeight
        if self.isFirstVCInNavigationVC{

//            if DDDevice.type == .iphoneX {webViewH -= 83}else{
//                webViewH -= 44
//            }
            if DDDevice.isFullScreen {webViewH -= 83}else{
                webViewH -= 44
            }
        }else{
//            if DDDevice.type == .iphoneX {webViewH -= 34}
            if DDDevice.isFullScreen {webViewH -= 34}
        }
        
        self.webView.frame = CGRect(x: 0.0, y: DDNavigationBarHeight, width: UIScreen.main.bounds.width, height: webViewH)
        self.reload()
        
    }
    func reload() {
        guard let urlStr = self.userInfo as? String else {
            //            mylog("webViewController对应的url字符串不存在\(self.showParameter)")
            return
        }
        //        print(GDNetworkManager.shareManager.token)
        if let token = DDAccount.share.token {
            var urlStrAppendToken   = ""
            if (urlStr == (DomainType.wap.rawValue + "shop/create?type=yewu")) || ((DomainType.wap.rawValue + "shop/create?type=dianpu") == urlStr) {
                if let subStr = self.subUserInfo as? String {
                    // "&dev=ios"为了判断是什么设备
               
                    
                
                    urlStrAppendToken = urlStr.appending("&token=\(token)") + subStr

                }else {
                    urlStrAppendToken = urlStr.appending("&token=\(token)")

                }
            }else {
                if let subStr = self.subUserInfo as? String {
                    if urlStr.contains("token") {
                        urlStrAppendToken = urlStr + subStr
                    }else {
                        urlStrAppendToken = urlStr.appending("?token=\(token)") + subStr
                    }
                    

                }else {
                    if urlStr.contains("token") {
                        urlStrAppendToken = urlStr
                    }else {
                        urlStrAppendToken = urlStr.appending("?token=\(token)")
                    }
                }
                
            }
            if !urlStrAppendToken.contains("dev=ios") {
                urlStrAppendToken += "&dev=ios"
            }
            
            
            mylog(urlStrAppendToken)
            if  urlStrAppendToken.hasPrefix("https://") || urlStrAppendToken.hasPrefix("http://") {
                guard let url  = URL.init(string: urlStrAppendToken ) else {
                    mylog("webViewController的urlStr字符串转换成URL失败")
                    return
                }
                let urlRequest = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20)
                self.webView.load(urlRequest)
                
            }
        }else{
            if var  urlstring = self.userInfo as? String  {
                urlstring = urlstring + "?dev=ios"
                guard let url  = URL.init(string: urlstring  ) else {
                    mylog("webViewController的urlStr字符串转换成URL失败")
                    return
                }
                mylog(urlstring)
                let urlRequest = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20)
            
                self.webView.load(urlRequest)
                
            }
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
    
    func DDDecode<T>(_ type: T.Type, from data : Data)  -> T? where T : Decodable {
        let jsonDecoder = JSONDecoder.init()
        do{
            let t = try jsonDecoder.decode(T.self, from: data)
            return t
        }catch{
            mylog("jsonDecoderFailure:\(error)")
            return nil
        }
    }
    //MARK:接受js传过来的参数
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        mylog(message.body)
        mylog(message.name)
        self.analysisTheDateFromJS(message:message)
    }
    /// 解析一维json字典
    func getValueFromKey(key : String , beAnalysisJson : String) -> String?{
        do {
            let result = try JSONSerialization.jsonObject(with: beAnalysisJson.data(using: String.Encoding.utf8) ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers)
            if let dict  = result as? [String : Any] {
                if let action = dict[key] as? String{ return action  }
                if let shop = dict["shop_number"] as? String{
                    return shop
                }else if let shop = dict["shop_number"] as? Int {
                    return "\(shop)"
                } else{
                    return nil
                }
            }else{return nil }
        }catch{
            mylog(error)
            return nil
        }
    }
    //MARK:解析js传过来的数据 , 并执行相应的操作
    func analysisTheDateFromJS(message : WKScriptMessage)  {
        if (message.name == "ylcm") {
            guard let json  = message.body as? String else { return  }
            if let action = self.getValueFromKey(key: "action", beAnalysisJson: json){
                switch action  {
                case "closewebview" , "closewebviewbycreateshop"://关闭webView
                    if let shopCount = self.getValueFromKey(key: "shop_number", beAnalysisJson: json){
                        UserDefaults.standard.setValue(shopCount, forKey: "ShopCount")
                    }
//                    if self.webView.url?.absoluteString.contains("hk-shop/hk-modify") ?? false {
//                        self.navigationController?.popToSpecifyVC(InstallBusinessVC.self)
//                        return
//                    }
                    
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    
                case "call"://关闭webView
                    if let telNum = self.getValueFromKey(key: "number", beAnalysisJson: json){
                        UIApplication.shared.openURL(URL(string: "telprompt:\(telNum)")!)
                    }
                    
                case "selectareawebviewgoback":
                    self.popToPreviousVC()
                case "selectareawebview":
                    mylog("")
                case "scan"://分享操作
                    var id = ""
                    if let tempID = self.getValueFromKey(key: "scanid", beAnalysisJson: json) {id = tempID}
                    let vc = QRCodeScannerVC()
                    vc.complateHandle = {[weak self ] resultStr in
                        mylog(resultStr)
                        self?.navigationController?.popViewController(animated: true)
                        self?.webView.evaluateJavaScript("scan_end(\"\(id)\",\"\(resultStr)\")", completionHandler: { (result , error ) in
                            mylog(result)
                            mylog(error)
                        })
                    }
                    self.navigationController?.pushViewController(vc , animated: true )
                    //                            self.pushVC(vcIdentifier: "QRCodeScannerVC")
                //回调函数js : scan_end(id,value)
                default:
                    break
                }
            }
        }else{
            mylog("js的方法名未在本地注册")
        }
    }
    
    
    //MARK:弹框
    func performAlertWith(dictParamete : [String:String]) {
        mylog("执行弹框操作")
    }
    //MARK:确认收货
    func performConfirmWith(dictParamete : [String:String]) {
        mylog("执行确认收货操作")
    }
    //MARK:跳转
    func performJumpWith(dictParamete : [String:String]) {
        guard   let typeOption = dictParamete["type"] else {
            mylog("跳转类型为空")
            return
        }
        guard let type = typeOption as? String else {
            return
        }
        let model = DDShowModel()
        model.isNeedJudge = true
//        mylog("执行跳转 到 商品详情页")
//        if (type == "goods") {//商品详情页
//            if let goodsID = dictParamete["id"] {
//                model.keyParameter = goodsID as AnyObject
//                model.actionKey = "HGoodsVC"
//                DDShowManager.whow(currentVC: self , showParameter: model )
//            }
//
//        }else if(type == "coupon"){//优惠券详情页
//            mylog("执行跳转 到 优惠券详情页")
//            if let couponID = dictParamete["id"] {
//                model.keyParameter = couponID as AnyObject
//                model.actionKey = "CouponsDetailVC"
//                DDShowManager.whow(currentVC: self , showParameter: model )
//            }
//
//        }else if(type == "couponList"){//优惠券列表页
//            mylog("执行跳转 到 优惠券列表页")
//            //直接跳转到优惠券列表页面
//            //                if let couponID = dictParamete["id"] {
//            //                    model.keyparamete = couponID as AnyObject
//            model.actionKey = "HCouponsVC"
//            DDShowManager.whow(currentVC: self , showParameter: model )
//            //                }
//        }else if(type == "shop"){//店铺页
//            mylog("执行跳转 到 店铺页")
//            if let shopID = dictParamete["id"] {
//                model.keyParameter = shopID as AnyObject
//                model.actionKey = "HShopVC"
//                DDShowManager.whow(currentVC: self , showParameter: model )
//            }
//
//        }else if(type == "similarityGoods"){//相似商品列表也  , 记得取出id
//            mylog("执行跳转 到 相似商品列表页")
//            if let goodsID = dictParamete["id"] {
//                model.keyParameter = goodsID as AnyObject
//                model.actionKey = "xiangSiShangPinVC"//暂未实现
//                DDShowManager.whow(currentVC: self , showParameter: model )
//            }
//
//        }else if ( type == "url"){//web页面
//            mylog("执行跳转 到 web页")
//            if let url = dictParamete["url"] {
//                model.keyParameter = url as AnyObject
//                model.actionKey = "BaseWebVC"
//                DDShowManager.whow(currentVC: self , showParameter: model )
//            }
//        }else if ( type == "chat"){//聊天页面
//            mylog("执行跳转 到 聊天页")
//            if let userName = dictParamete["name"] {
//                model.keyParameter = userName as AnyObject
//                model.actionKey = "ChatVC"
//                DDShowManager.whow(currentVC: self , showParameter: model )
//            }
//        }
    }
    //MARK:支付
    func performPayWith(dictParamete : [String:String]) {
        mylog("执行支付操作")
        if let typeOption = dictParamete["type"] {
            if let type  = typeOption as? String {
                
                if type  == "order" {
                    if let orderID  = dictParamete["id"] {
                        let model  = DDShowModel()
                        model.actionKey = "支付控制器"
                        model.keyParameter = orderID as AnyObject
                        model.isNeedJudge = true
//                        DDShowManager.whow(currentVC: self , showParameter: model )
                        
                    }
                }else if (type == "check"){//wap页确认收货时验证支付密码,直接弹出输入框
                    
                }
            }
        }
    }
    //MARK:分享
    func performShareWith(dictParamete : [String:String]) {
        mylog("执行分享操作")
    }
    
    func smartGoBack()  {
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
    //MARK:返回上一页
    //继承自internalVC时实现
    override func popToPreviousVC (){
        if let url = self.webView.url {
            let urlstr = url.absoluteString
            if urlstr.contains("hk-choose") {
                self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
                _ =  self.navigationController?.popViewController(animated: true)
                return
            }
        }
        mylog(self.webView.backForwardList.backList.count)
        if self.webView.backForwardList.backList.count <= 1 {
            self.naviBar.backBtn.isHidden = true
        }else{self.naviBar.backBtn.isHidden = false}
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
                }else if (item.url.absoluteString.contains("hk-create")){
                    ///通过强制调用返显的js方法,来实现返显,但调用无效
                    self.webView.go(to: item)
                    
//                    self.webView.evaluateJavaScript("ler()") { (dict , error ) in
//                        mylog(dict)
//                        mylog(error)
//                        mylog(error?.localizedDescription)
//                    }
                    /// 通过刷新解决返显
//                    self.webView.go(to: item)
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.025) {
//                        self.webView.reload()
//                    }
                    break
                }else{
                    self.webView.go(to: item)
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
    
    
    /*
     -(void)navigationBack
     {
     
     NSLog(@"_%d_%@",__LINE__,self.webview.backForwardList.currentItem.URL.absoluteString );
     [self.webview stopLoading];
     if (self.webview.canGoBack) {
     NSUInteger count = self.webview.backForwardList.backList.count ;
     NSLog(@"_%d_%@,%lu",__LINE__,@"总个数",count);
     for (int i = 0 ; i < count; i++) {
     WKBackForwardListItem * item = self.webview.backForwardList.backList[count - 1 - i];
     NSLog(@"_%d_下标%d_%@",__LINE__,i,item.URL.absoluteString);
     if ([item.URL.absoluteString containsString:@"nottaken"]) {
     if (i==count-1) {//如果栈底的还不需要在返回的时候显示,就直接pop到上一个控制器
     
     [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"zjlao"];
     [self.navigationController popViewControllerAnimated:YES];
     
     }
     
     }else{
     [self.webview goToBackForwardListItem:item];
     if ([item.URL.absoluteString containsString:@"orderlist"]) {//待评价页面返回时需要重新加载
     [self.webview reload];
     }
     break ;
     }
     }
     
     }else{
     
     [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"zjlao"];
     [self.navigationController popViewControllerAnimated:YES];
     
     }
     }
     
     */
    
    //MARK:webViewDelegate
    
    //MARK:WKNavigationDelegate
    
    /*! @abstract Decides whether to allow or cancel a navigation.
     @param webView The web view invoking the delegate method.
     @param navigationAction Descriptive information about the action
     triggering the navigation request.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
     @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        decisionHandler(WKNavigationActionPolicy.allow)
        
        mylog(self.webView.backForwardList.backList.count)
    }
    /*! @abstract Decides whether to allow or cancel a navigation after its
     response is known.
     @param webView The web view invoking the delegate method.
     @param navigationResponse Descriptive information about the navigation
     response.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
     @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void){
        decisionHandler(WKNavigationResponsePolicy.allow)
        dynamicHiddenBackButton()
        mylog(self.webView.backForwardList.backList.count)
        mylog(self.webView.backForwardList.backList.count)
    }
    
    func dynamicHiddenBackButton() {

        if self.webView.backForwardList.backList.count == 0 {
            if self.isFirstVCInNavigationVC {
                self.naviBar.backBtn.isHidden = true
            }else{
                self.naviBar.backBtn.isHidden = false
            }
        }else{
            self.naviBar.backBtn.isHidden = false
        }
    }
    
    /*
     if  self.webView.backForwardList.backList.count == 0 {
     self.naviBar.backBtn.isHidden = true
     }else{self.naviBar.backBtn.isHidden = false }
     */
    /*! @abstract Invoked when a main frame navigation starts.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Invoked when a server redirect is received for the main
     frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!){
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Invoked when an error occurs while starting to load data for
     the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        let hemlSourcePath  = "Users/wy/desktop/testA.html"
        let urlrequest = URLRequest.init(url: URL(fileURLWithPath: hemlSourcePath))
//        webView.load(urlrequest)
//        let imgUrl = "file:///Users/wy/Pictures/70AC4E6452681F85C254555A06E4F3F8.jpg"
//        let img = "<img src=\"\(imgUrl)\">"
//        webView.loadHTMLString("<p font=100 color = \"#C0C0C0\" >阿福说我改不了,看来要让它失望了</p> \(img)", baseURL: nil )
        webView.evaluateJavaScript("alert(\"helloworld\")") { (any , error ) in
            mylog(any)
            mylog(error)
        }
        mylog(self.webView.backForwardList.backList.count)
        mylog(error)
    }
    
    
    /*! @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Invoked when a main frame navigation completes.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        self.naviBar.attributeTitle = NSAttributedString.init(string: webView.title ?? "")
    
        webView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            webView.alpha = 1
        }
        if (webView.url?.absoluteString.contains("hk-create") ?? false) {
            webView.evaluateJavaScript("reflush()") { (any , error ) in
                mylog(any)
                mylog(error)
            }
        }
        
        dynamicHiddenBackButton()
        mylog(self.webView.backForwardList.backList.count)
        mylog(self.webView.url)
        mylog(webView.title)
    }
    
    
    /*! @abstract Invoked when an error occurs during a committed main frame
     navigation.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        self.naviBar.attributeTitle = NSAttributedString.init(string: webView.title ?? "")
//        if self.webView.url?.absoluteString.contains("hk-create") ?? false {
//            self.webView.reload()
//        }
        mylog(webView.title)
    }
    
    
    /*! @abstract Invoked when the web view needs to respond to an authentication challenge.
     @param webView The web view that received the authentication challenge.
     @param challenge The authentication challenge.
     @param completionHandler The completion handler you must invoke to respond to the challenge. The
     disposition argument is one of the constants of the enumerated type
     NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
     the credential argument is the credential to use, or nil to indicate continuing without a
     credential.
     @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling , nil )
        
        dynamicHiddenBackButton()
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Invoked when the web view's web content process is terminated.
     @param webView The web view whose underlying web content process was terminated.
     @available(iOS 9.0, *)
     */
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    //MARK: WKUIDelegate
    
    
    /*! @abstract Creates a new web view.
     @param webView The web view invoking the delegate method.
     @param configuration The configuration to use when creating the new web
     view.
     @param navigationAction The navigation action causing the new web view to
     be created.
     @param windowFeatures Window features requested by the webpage.
     @result A new web view or nil.
     @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.
     
     If you do not implement this method, the web view will cancel the navigation.
     @available(iOS 8.0, *)
     */
    //     func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
    //        return nil
    //    }
    
    
    /*! @abstract Notifies your app that the DOM window object's close() method completed successfully.
     @param webView The web view invoking the delegate method.
     @discussion Your app should remove the web view from the view hierarchy and update
     the UI as needed, such as by closing the containing browser tab or window.
     @available(iOS 9.0, *)
     */
    func webViewDidClose(_ webView: WKWebView){
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Displays a JavaScript alert panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this
     call.
     @param completionHandler The completion handler to call after the alert
     panel has been dismissed.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have a single OK button.
     
     If you do not implement this method, the web view will behave as if the user selected the OK button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        completionHandler()
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Displays a JavaScript confirm panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this call.
     @param completionHandler The completion handler to call after the confirm
     panel has been dismissed. Pass YES if the user chose OK, NO if the user
     chose Cancel.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have two buttons, such as OK and Cancel.
     
     If you do not implement this method, the web view will behave as if the user selected the Cancel button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        completionHandler(true)
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Displays a JavaScript text input panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param defaultText The initial text to display in the text entry field.
     @param frame Information about the frame whose JavaScript initiated this call.
     @param completionHandler The completion handler to call after the text
     input panel has been dismissed. Pass the entered text if the user chose
     OK, otherwise nil.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have two buttons, such as OK and Cancel, and a field in
     which to enter text.
     
     If you do not implement this method, the web view will behave as if the user selected the Cancel button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void){
        completionHandler("提交已经输入的文字,如果没有输入的话就传nil")
        
        mylog(self.webView.backForwardList.backList.count)
    }
    
    
    /*! @abstract Allows your app to determine whether or not the given element should show a preview.
     @param webView The web view invoking the delegate method.
     @param elementInfo The elementInfo for the element the user has started touching.
     @discussion To disable previews entirely for the given element, return NO. Returning NO will prevent
     webView:previewingViewControllerForElement:defaultActions: and webView:commitPreviewingViewController:
     from being invoked.
     
     This method will only be invoked for elements that have default preview in WebKit, which is
     limited to links. In the future, it could be invoked for additional elements.
     @available(iOS 10.0, *)
     */
    //    @available(iOS 10.0, *)
    //    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool{
    //        return true
    //    }
    
    
    /*! @abstract Allows your app to provide a custom view controller to show when the given element is peeked.
     @param webView The web view invoking the delegate method.
     @param elementInfo The elementInfo for the element the user is peeking.
     @param defaultActions An array of the actions that WebKit would use as previewActionItems for this element by
     default. These actions would be used if allowsLinkPreview is YES but these delegate methods have not been
     implemented, or if this delegate method returns nil.
     @discussion Returning a view controller will result in that view controller being displayed as a peek preview.
     To use the defaultActions, your app is responsible for returning whichever of those actions it wants in your
     view controller's implementation of -previewActionItems.
     
     Returning nil will result in WebKit's default preview behavior. webView:commitPreviewingViewController: will only be invoked
     if a non-nil view controller was returned.
     @available(iOS 10.0, *)
     */
    //    @available(iOS 10.0, *)
    //    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController?{
    //        return nil
    //    }
    
    
    /*! @abstract Allows your app to pop to the view controller it created.
     @param webView The web view invoking the delegate method.
     @param previewingViewController The view controller that is being popped.
     @available(iOS 10.0, *)
     */
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        
        mylog(self.webView.backForwardList.backList.count)
        
    }
    
    
    
}

