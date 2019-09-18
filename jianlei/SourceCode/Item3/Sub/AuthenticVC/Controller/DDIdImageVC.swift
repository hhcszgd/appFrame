//
//  DDIdImageVC.swift
//  YiLuMedia
//
//  Created by WY on 2019/9/10.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
class DDIdImageVC: DDNormalVC {
    let backView = UIView()
    let line1 = UIView()
    let frontSideLabel = UILabel()
    let backSideLabel = UILabel()
    let frontSideButton = UIButton()
    let backSideButton = UIButton()
    let bottomButton = UIButton()
    var baseInfo : (name:String ,gender: String , idNum:String) = ("","","")
    let frontProcess : UIProgressView = UIProgressView()
    let backProcess : UIProgressView = UIProgressView()
    var frontImage = ""
    var backImage = ""
    var personalInfo : DDAuthenticateInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "authenticate_idimage_navi_title"|?|
        // Do any additional setup after loading the view.
        _addSubviews()
        _layoutSubviews()
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



///actions
extension DDIdImageVC{
    @objc func action(sender:UIButton){
        if sender == frontSideButton{
            SystemMediaPicker.share.selectImage().pickImageCompletedHandler = {[weak self] image in
                if let image = image{
                    TencentYunUploader.uploadMediaToTencentYun(image: image, progressHandler: { (_, hasReceived, total) in
                        let process = CGFloat(hasReceived)/CGFloat(total)
                        self?.frontProcess.progress = Float(process)
                    }, compateHandler: { (imgUrl) in
                        self?.frontProcess.progress = 0
                            self?.frontImage  = imgUrl
                            self?.personalInfo?.id_front_image = imgUrl
                            self?.frontSideButton.setImage(image , for: UIControl.State.normal)
                    })
                }
            }
        }else if sender == backSideButton{
            SystemMediaPicker.share.selectImage().pickImageCompletedHandler = {[weak self] image in
                if let image = image{
                    TencentYunUploader.uploadMediaToTencentYun(image: image, progressHandler: { (_, hasReceived, total) in
                        let process = CGFloat(hasReceived)/CGFloat(total)
                        self?.backProcess.progress = Float(process)
                    }, compateHandler: { (imgUrl) in
                        self?.backProcess.progress = 0
                            self?.backImage  = imgUrl
                            self?.personalInfo?.id_back_image = imgUrl
                            self?.backSideButton.setImage(image , for: UIControl.State.normal)
                        
                    })
                }
            }
        }else if sender == bottomButton{
            mylog("next")
            if self.frontImage.count == 0 {
                GDAlertView.alert("authenticate_idimage_front_title"|?|, image: nil, time: 2, complateBlock: nil)
                return
            }else if self.backImage.count == 0 {
                GDAlertView.alert("authenticate_idimage_back_title"|?|, image: nil, time: 2, complateBlock: nil)
                return
            }
//            let info = (name:baseInfo.name,gender:baseInfo.gender,idNum:baseInfo.idNum , frontImg:frontImage , backImg:backImage)
            let info = (name:personalInfo?.name ?? "",gender:personalInfo?.sex ?? "",idNum:personalInfo?.id_number ?? "", frontImg:frontImage , backImg:backImage)
            DDRequestManager.share.performAuthenticate(type: ApiModel<String>.self, info: info, success: { (result ) in
                self.navigationController?.popToSpecifyVC(DDAuthenticatedVC.self , animate: true )
            }, failure: { (error ) in
                
            })
        }
    }
}
/// UI
extension DDIdImageVC{
    func _addSubviews() {
        self.view.addSubview(backView)
        self.view.addSubview(frontSideLabel)
        self.view.addSubview(backSideLabel)
        self.view.addSubview(frontSideButton)
        self.view.addSubview(backSideButton)
        self.view.addSubview(frontProcess)
        self.view.addSubview(backProcess)
        self.view.addSubview(line1)
        self.view.addSubview(bottomButton)
        frontSideLabel.text = "authenticate_idimage_front_title"|?|
        backSideLabel.text = "authenticate_idimage_back_title"|?|
        if let frontImg = personalInfo?.id_front_image ,let backImg = personalInfo?.id_back_image{
            self.frontSideButton.setImageUrl(url: frontImg)
            self.backSideButton.setImageUrl(url: backImg)
            self.frontImage = frontImg
            self.backImage = backImg
        }
        frontSideButton.setBackgroundImage(UIImage(named: "profile_addphoto"), for: UIControl.State.normal)
        backSideButton.setBackgroundImage(UIImage(named: "profile_addphoto"), for: UIControl.State.normal)
        
        backView.backgroundColor = UIColor.white
        bottomButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        bottomButton.setTitle("authenticate_idimage_done"|?|, for: UIControl.State.normal)
        let immg =  UIImage.getImage(startColor: UIColor.colorWithHexStringSwift("fbce35"), endColor: UIColor.colorWithHexStringSwift("f9ac35"), startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5), size: CGSize(width: SCREENWIDTH, height: 50))
        bottomButton.setBackgroundImage(immg, for: UIControl.State.normal)
        frontSideLabel.textColor = UIColor.darkGray
        frontSideLabel.font = DDFont.systemFont(ofSize: 15)
        backSideLabel.textColor = UIColor.darkGray
        backSideLabel.font = DDFont.systemFont(ofSize: 15)
       
        backProcess.trackTintColor = UIColor.clear
        backProcess.progressTintColor = UIColor.orange.withAlphaComponent(0.5)
        
        frontProcess.trackTintColor = UIColor.clear
        frontProcess.progressTintColor = UIColor.orange.withAlphaComponent(0.5)
        line1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        frontSideButton.isSelected = true
        self.frontSideButton.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
        self.backSideButton.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
        bottomButton.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
    }
    func _layoutSubviews() {
        let rowH : CGFloat = 100 * SCALE
        let backViewH = rowH * 2
        let backViewY = DDNavigationBarHeight + 22
        backView.frame = CGRect(x: 0, y: backViewY, width: view.bounds.width, height: backViewH)
        bottomButton.frame = CGRect(x: 15, y: backView.frame.maxY + 30, width: view.bounds.width - 30, height: 50)
        let imageButtonUpDownMargin : CGFloat = 15
        let imageButtonWH : CGFloat = rowH - imageButtonUpDownMargin * 2
        backSideLabel.sizeToFit()
        frontSideLabel.sizeToFit()
        let titleX : CGFloat = 10
        frontSideLabel.frame = CGRect(x: titleX, y: backView.frame.minY + imageButtonUpDownMargin, width: frontSideLabel.bounds.width + 5, height: 30)
        backSideLabel.frame = CGRect(x: titleX, y: backView.frame.midY + imageButtonUpDownMargin, width: backSideLabel.bounds.width + 5, height: 30)
        let imageButtonX : CGFloat = self.view.bounds.width - imageButtonWH - 20
        
        frontSideButton.frame = CGRect(x: imageButtonX, y: frontSideLabel.frame.minY, width: imageButtonWH, height: imageButtonWH)
        backSideButton.frame = CGRect(x: imageButtonX, y: backSideLabel.frame.minY, width: imageButtonWH, height: imageButtonWH)
        frontProcess.frame  = CGRect(x: imageButtonX, y: frontSideButton.frame.midY, width: imageButtonWH, height: 1)
        backProcess.frame   = CGRect(x: imageButtonX, y: backSideButton.frame.midY, width: imageButtonWH, height: 1)
        frontSideButton.layer.cornerRadius = 6
        frontSideButton.clipsToBounds = true
        backSideButton.layer.cornerRadius = 6
        backSideButton.clipsToBounds = true
        
        let lineH : CGFloat = 1
        line1.frame =  CGRect(x: 0, y: backView.frame.midY , width: view.bounds.width, height: lineH)
        bottomButton.layer.cornerRadius = bottomButton.bounds.height/2
        bottomButton.clipsToBounds = true
        
    }
}
