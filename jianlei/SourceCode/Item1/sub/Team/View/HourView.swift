//
//  HourView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/7.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class HourView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    var hourNowRow: Int = 0
    var choseHoursRow: Int = 0
    init(frame: CGRect, type: /** 区分开机时间和关机时间*/ String = "open", limitTime: String) {
        super.init(frame: frame)
        if limitTime.contains(":") {
            
            let strArr = limitTime.components(separatedBy: ":")
            self.limtiHour = strArr.first ?? "08"
            self.limitMin = strArr.last ?? "00"
        }
        self.type = type
        if type == "open" {
            self.hourArr = ["08","09", "10","11","12","13"]
//            let startHour = String(Int(self.limtiHour)! - 10)
//            self.limitHourRow = self.hourArr.firstIndex(of: startHour) ?? 0
//            self.limitMinRow = self.minArr.firstIndex(of: self.limitMin) ?? 0
            
            
            
        }else {
            self.hourArr = ["16","17","18","19","20","21","22","23"]
            let startHour = String(Int(self.limtiHour)! + 8)
            self.limitHourRow = self.hourArr.firstIndex(of: startHour) ?? 0
            self.limitMinRow = self.minArr.firstIndex(of: self.limitMin) ?? 0
            self.pickerView.selectRow(self.limitHourRow, inComponent: 0, animated: true)
            self.pickerView.selectRow(self.limitMinRow, inComponent: 1, animated: true)
            self.rowLeft = self.limitHourRow
            self.rowRight = self.limitMinRow
        }
        
        
        self.pickerView.backgroundColor = UIColor.white
        self.addSubview(self.backView)
        self.backView.addSubview(self.cancleBtn)
        self.backView.addSubview(self.trueBtn)
        self.backView.backgroundColor = UIColor.white
        self.addSubview(self.pickerView)
        self.backgroundColor = UIColor.white
        
        
        
        
    }
    var limtiHour: String = ""
    var limitMin: String = ""
    var limitHourRow: Int = 0
    var limitMinRow: Int = 0
    var type: String = ""
    
    func defaultDisplay() {
 
        
    }
    var rowLeft = 0
    var rowRight = 0
    var hourArr: [String]!
    var minArr: [String] = ["00","10","20","30","40","50"]
   
    
    
    @objc func cancleAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            self.removeFromSuperview()
            self.sender.onCompleted()
            
        }
    }
    @objc func trueAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
      
            
            let hour = self.hourArr[self.rowLeft]
            let min = self.minArr[self.rowRight]
            self.sender.onNext(hour + ":" + min)
            self.sender.onCompleted()
            self.removeFromSuperview()
        }
    }
    var sender: PublishSubject<String> = PublishSubject<String>.init()
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 15, y: 0, width: 50, height: 50))
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        return btn
    }()
    lazy var trueBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 80, y: 0, width: 50, height: 50))
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(trueAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        return btn
    }()
    let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 50))
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss(tap:)))
        
        return tap
    }()
    @objc func dismiss(tap: UITapGestureRecognizer) {
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.hourArr.count
        }else  {
            return self.minArr.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREENWIDTH / 2.0
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.rowLeft = row
            if self.type == "open" {
//                if self.rowLeft >= self.limitHourRow {
//                    pickerView.selectRow(self.limitHourRow, inComponent: 0, animated: true)
//                    pickerView.selectRow(self.limitMinRow, inComponent: 1, animated: true)
//                    self.rowLeft = self.limitHourRow
//                }else {
//
//                }
            }else {
                if self.rowLeft <= self.limitHourRow {
                    pickerView.selectRow(self.limitHourRow, inComponent: 0, animated: true)
                    pickerView.selectRow(self.limitMinRow, inComponent: 1, animated: true)
                    self.rowLeft = self.limitHourRow
                }else {
                    
                }
            }
            
        }else {
            self.rowRight = row
        
            if self.type == "open" {
//                if self.rowLeft == self.limitHourRow {
//                    if self.rowRight > self.limitMinRow {
//                        pickerView.selectRow(self.limitMinRow, inComponent: 1, animated: true)
//                        self.rowRight = self.limitMinRow
//                    }
//                }
            }else {
                if self.rowLeft == self.limitHourRow {
                    if self.rowRight < self.limitMinRow {
                        pickerView.selectRow(self.limitMinRow, inComponent: 1, animated: true)
                        self.rowRight = self.limitMinRow
                    }
                    
                    
                }else {
                    
                }
            }
            
        }
        
    }
  
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as? UILabel
        if label == nil {
            label = UILabel.init()
            label?.textColor = UIColor.colorWithHexStringSwift("323232")
            label?.font = GDFont.systemFont(ofSize: 14)
            label?.textAlignment = .center
        }
        label?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        return label!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.hourArr[row]
        }else {
            return self.minArr[row]
        }
    }
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView.init(frame: CGRect.init(x: 0, y: 50, width: SCREENWIDTH, height: 150))
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    deinit {
        mylog("销毁")
    }

   
}
