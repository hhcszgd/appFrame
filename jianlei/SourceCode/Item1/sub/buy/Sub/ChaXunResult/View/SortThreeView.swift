//
//  SortThreeView.swift
//  Project
//
//  Created by 张凯强 on 2018/4/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
///筛选
class SortThreeView: UIView {

    @IBOutlet var btn1: UIButton!
    
    @IBOutlet var btn2: UIButton!
    
    @IBOutlet var btn3: UIButton!
    
    @IBOutlet var btn4: UIButton!
    
    @IBOutlet var btn5: UIButton!
    
    @IBOutlet var btn6: UIButton!
    
    
    @IBOutlet var time1: UIButton!
    @IBOutlet var time2: UIButton!
    @IBOutlet var time3: UIButton!
    @IBOutlet var time4: UIButton!
    @IBOutlet var time5: UIButton!
    @IBOutlet var time6: UIButton!
    
    @IBOutlet var time7: UIButton!
    
    @IBOutlet var time8: UIButton!
    @IBOutlet var time9: UIButton!
    
    @IBOutlet var time10: UIButton!
    @IBOutlet var slider: UISlider!
    var paramete: [String: String]!
    var rate: String!
    var time: String!
    var advertID: String!
    init(frame: CGRect, model: DDItem4Model<AdvertisModel, AdvertiseBannerModel>!, rate: String, advertID: String, time: String) {
        super.init(frame: frame)
        self.rate = rate
        self.time = time
        self.advertID = advertID
        if let subView = Bundle.main.loadNibNamed("SortThreeView", owner: self, options: nil)?.last as? UIView{
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        
        self.btnArr = [btn1, btn2, btn3, btn4, btn5, btn6]
        self.timeArr = [time1, time2, time3, time4, time5, time6, time7, time8, time9, time10]
        for (index, btn) in self.timeArr.enumerated() {
            btn.tag = index
            btn.addTarget(self, action: #selector(timeAction(btn:)), for: .touchUpInside)
        }
        guard let arr = model.advert_position else {
            return
        }
        self.dataArr = arr
        
        for (index, btn) in self.btnArr.enumerated() {
            btn.layer.cornerRadius = 3
            btn.layer.masksToBounds = true
            btn.layer.borderColor = lineColor.cgColor
            btn.layer.borderWidth = 1
            btn.tag = index
            btn.addTarget(self, action: #selector(screenAction(btn:)), for: .touchUpInside)
            if (index + 1) <= self.dataArr.count {
                let advertise = self.dataArr[index]
                if advertID == advertise.id {
                    screenAction(btn: btn)
                    if let arr = self.selectModel?.time_list {
                        for (index, timeBtn) in self.timeArr.enumerated() {
                            if index < arr.count {
                                
                                timeBtn.setTitle(arr[index], for: .normal)
                                timeBtn.isHidden = false
                                if time == arr[index] {
                                    timeAction(btn: timeBtn)
                                }
                            }else {
                                timeBtn.isHidden = true
                            }
                        }
                    }
                    
                }
                btn.setTitle(advertise.name, for: .normal)
            }else {
                btn.isHidden = true
            }
            
        }
        
        let leftTrack = UIImage.init(named: "slider")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 14, 0, 14))
        self.slider.setMinimumTrackImage(leftTrack, for: .normal)
        self.slider.setMaximumTrackImage(leftTrack, for: .normal)
        self.slider.setThumbImage(UIImage.init(named: "slidingcircle"), for: .normal)
        self.slider.setThumbImage(UIImage.init(named: "slidingcircle"), for: .highlighted)
        self.slider.addTarget(self, action: #selector(sliderChange(slider:)), for: UIControlEvents.valueChanged)
        if let rateValue = Float(self.rate) {
            self.slider.setValue(rateValue, animated: false)
            self.sliderChange(slider: self.slider)
        }
        
        
    }
    @objc func sliderChange(slider: UISlider) {
        
        let value = slider.value
        mylog(value)
        let porpert = CGFloat(value / 100) - 0.1
        self.rateLeft.constant = 25 + porpert * (SCREENWIDTH - 50) - 10
        self.layoutIfNeeded()
        var sliderrate: String = ""
        if value < 20 {
            sliderrate = String(10)
        }else if (value >= 20) && (value < 30) {
            sliderrate = String(20)
            
        }else if (value >= 30) && (value < 40) {
            sliderrate = String(30)
        }else if (value >= 40) && (value < 50) {
            sliderrate = String(40)
        }else if (value >= 50) && (value < 60) {
            sliderrate = String(50)
        }else if (value >= 60) && (value < 70) {
            sliderrate = String(60)
        }else if (value >= 70) && (value < 80) {
            sliderrate = String(70)
        }else if (value >= 80) && (value < 90) {
            sliderrate = String(80)
        }else if (value >= 90) && (value < 100) {
            sliderrate = String(90)
        }else {
            sliderrate = String(100)
        }
        self.rate = sliderrate
        self.rateLabel.text = sliderrate + "次/天"
        
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
        if self.selectTime == nil {
            GDAlertView.alert("请选择广告时长", image: nil, time: 1, complateBlock: nil)
            return
        }
        self.paramete["rate"] = self.rate
        self.paramete["advert_id"] = self.advertID
        self.paramete["advert_time"] = self.selectTime!
        self.paramete["time"] = self.selectTime!
        self.finished(self.paramete)
        
    }
    var finished: (([String: String]) -> ())!
    @IBOutlet var rateLabel: UILabel!
    
    @IBOutlet var rateLeft: NSLayoutConstraint!
    
    var dataArr: [AdvertisModel] = [AdvertisModel]()
    var selectModel: AdvertisModel?
    var timeArr: [UIButton] = [UIButton]()
    @objc func screenAction(btn: UIButton) {
        self.btnArr.forEach { (otherBtn) in
            if otherBtn == btn {
                otherBtn.isSelected = true
                otherBtn.backgroundColor = selectBackColor
                self.selectModel = self.dataArr[otherBtn.tag]
                self.advertID = self.selectModel?.id
                if let arr = self.selectModel?.time_list {
                    for (index, timeBtn) in self.timeArr.enumerated() {
                        if index < arr.count {
                            timeBtn.setTitle(arr[index], for: .normal)
                            timeBtn.isHidden = false
                            timeBtn.isSelected = false
                            self.selectTime = nil
                        }else {
                            timeBtn.isHidden = true
                        }
                    }
                }
                
                
            }else {
                otherBtn.isSelected = false
                otherBtn.backgroundColor = UIColor.white
            }
        }
        
    }
    var selectTime: String?
    @objc func timeAction(btn: UIButton) {
        self.timeArr.forEach { (otherBtn) in
            if btn == otherBtn {
                otherBtn.isSelected = true
                if let arr = self.selectModel?.time_list {
                    self.selectTime = arr[otherBtn.tag]
                }
            }else {
                otherBtn.isSelected = false
            }
        }
    }
    
    
    
    let selectBackColor = UIColor.colorWithHexStringSwift("ea9265")
    var btnArr: [UIButton]!
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
    var containerView: UIView!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomSlider: UISlider {
    
    //设置轨道的坐标及尺寸
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: 0, width: bounds.size.width, height: 20)
        
    }

   
}

