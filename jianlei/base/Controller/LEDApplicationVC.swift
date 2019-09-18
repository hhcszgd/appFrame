//
//  LEDApplicationVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/26.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import WebKit

///有子类不能随便修改
class LEDApplicationVC: BaseWebVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func analysisTheDateFromJS(message: WKScriptMessage) {
        if (message.name == "ylcm") {
            guard let json  = message.body as? String else { return  }
            if let action = self.getValueFromKey(key: "action", beAnalysisJson: json){
                switch action  {
                case "closewebview" , "closewebviewbycreateshop"://关闭webView
                    if let shopCount = self.getValueFromKey(key: "shop_number", beAnalysisJson: json){
                        UserDefaults.standard.setValue(shopCount, forKey: "ShopCount")
                    }
                    if action == "closewebview" {
                        let count = self.navigationController?.viewControllers.count ?? 0
                        if count > 2 {
                            if let presentVC = self.navigationController?.viewControllers[count - 2], presentVC.isKind(of: ShopInfoVC.self) {
                                self.navigationController?.popToSpecifyVC(InstallBusinessVC.self)
                                return
                            }
                        }
                        
                    }
                    
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
                    let bo = action.contains("id_card1") || action.contains("id_card2") || action.contains("biz_img") || action.contains("panorama_img") || action.contains("shop_img") || action.contains("agent_identity_card1") || action.contains("agent_identity_card2")
                    if action.contains("screen") || action.contains("upload") || bo {
                        self.uploadImage1(imageid: action)
                    }
                }
            }
        }else{
            mylog("js的方法名未在本地注册")
        }
        
    }
    
    
    
    func uploadImage1(imageid: String) {
        SystemMediaPicker.share.selectImage().pickImageCompletedHandler = {[weak self] (image) in
            if let img = image {
                
                DispatchQueue.global().async(execute: {
                    
               
                    let totalImage = img.addWaterImage()
                    let date = totalImage.jpegData(compressionQuality: 1)
                    let imagebaseStr = date?.base64EncodedString() ?? ""
                    DispatchQueue.main.async {
                        self?.webView.evaluateJavaScript("upload_start(\"\(imageid)\", \"\(imagebaseStr)\")", completionHandler: { (result, error) in
                            mylog(result)
                        })
                        self?.webView.evaluateJavaScript("upimg_progress(\"\(imageid)\", \"\(3)\")", completionHandler: { (result, error) in
                            
                        })
                    }
                    
                    TencentYunUploader.uploadMediaToTencentYun(image: totalImage ?? UIImage.init(), progressHandler: { (a, b, c) in
                        let propert: String = String.init(format: "%0.0f", Float(b) / Float(c) * 100)
                        DispatchQueue.main.async {
                            self?.webView.evaluateJavaScript("upimg_progress(\"\(imageid)\", \"\(propert)\")", completionHandler: { (result, error) in
                                
                            })
                        }
                        
                    }, compateHandler: { (imageStr) in
//                        if imageStr == "failure" {
//                            DispatchQueue.main.async {
//                                self?.webView.evaluateJavaScript("upload_fail(\"\(imageid)\")", completionHandler: { (reslut , error) in
//                                    mylog(reslut)
//                                    mylog(error)
//                                })
//                            }
//                            return
//                        }
                        DispatchQueue.main.async {
                                self?.webView.evaluateJavaScript("upload_end(\"\(imageid)\", \"\(imageStr)\")", completionHandler: { (reslut , error) in
                                    mylog(reslut)
                                    mylog(error)
                                })
                            
                        }
                    },errorHandler: {errorMsg in
                            DispatchQueue.main.async {
                                self?.webView.evaluateJavaScript("upload_fail(\"\(imageid)\")", completionHandler: { (reslut , error) in
                                    mylog(reslut)
                                    mylog(error)
                                })
                            }
                    })
                    
                })
                
            }
            
        }
        
        
        
        
    }
    override func popToPreviousVC() {
        super.popToPreviousVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
