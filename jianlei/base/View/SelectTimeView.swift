//
//  SelectTimeView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/5.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class SignSelectTimeView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    var currentMonthCount: Int = 0
    func request() {
        let date = Date.init(timeInterval: -24 * 3600, since: Date.init())
        
        self.yearNow = String(self.calendar.getCurrentYear(date: date))
        let currentYear = self.calendar.getCurrentYear(date: date)
        self.choseYear = currentYear
        var arr: [Int] = []
        for i in 0...10 {
            arr.append(currentYear - i)
        }
        arr.forEach { (num) in
            let numstr = String(num)
            self.yearArr.append(numstr)
        }
        self.monthNow = String.init(format: "%02d", self.calendar.getMonth(date: date))
        self.choseMonth = self.calendar.getMonth(date: date)
        self.dayNow = String.init(format: "%02d", self.calendar.getDay(date: date))
        self.choseDay = self.calendar.getDay(date: date)
        self.pickerView.reloadAllComponents()
        self.defaultDisplay()
        
    }
    var calendar: Calendar {
        get{
            if #available(iOS 9.0, *) {
                return Calendar.init(identifier: Calendar.Identifier.gregorian)
            } else {
                return Calendar.current
                // Fallback on earlier versions
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.request()
        self.pickerView.backgroundColor = UIColor.white
        self.addSubview(self.backView)
        self.backView.addSubview(self.cancleBtn)
        self.backView.addSubview(self.trueBtn)
        self.backView.backgroundColor = UIColor.white
        
        
        self.addSubview(self.pickerView)
        self.request()
        
    }
    
    func defaultDisplay() {
        self.rowLeft = self.yearArr.index(of: self.yearNow) ?? 0
        self.rowMiddle = self.monthARr.index(of: self.monthNow) ?? 0
        self.rowRight = self.dayArr.index(of: self.dayNow) ?? 0
        
        self.pickerView.selectRow(self.rowLeft, inComponent: 0, animated: false)
        self.pickerView.selectRow(self.rowMiddle, inComponent: 1, animated: false)
        self.pickerView.selectRow(self.rowRight, inComponent: 2, animated: false)
        
    }
    var rowLeft = 0
    var rowMiddle = 0
    var rowRight = 0
    var dayArr: [String] = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    var monthARr: [String] = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var yearArr: [String] = []
    var yearNow: String = ""
    var choseYear: Int = 2018
    var monthNow: String = ""
    var choseMonth: Int = 02
    var dayNow: String = ""
    var choseDay: Int = 28
    
    
    
    @objc func cancleAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            
            self.sender.onCompleted()
            self.removeFromSuperview()
        }
    }
    @objc func trueAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            let year = self.yearArr[self.rowLeft]
            let month = self.monthARr[self.rowMiddle]
            let day = self.dayArr[self.rowRight]
            let time: String = year + "-" + month + "-" + day
            let time2: String = year + "年" + month + "月" + day + "日"
            self.sender.onNext(["time": time, "time2": time2])
            self.sender.onCompleted()
            self.removeFromSuperview()
        }
    }
    var sender: PublishSubject<[String: String]> = PublishSubject<[String: String]>.init()
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 15, y: 0, width: 50, height: 50))
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        return btn
    }()
    lazy var trueBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 50 - 15, y: 0, width: 50, height: 40))
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
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.yearArr.count
        }else if component == 1 {
            return self.monthARr.count
        }else {
            switch self.choseMonth {
            case 1, 3, 5, 7, 8, 10, 12:
                return 31
            case 4, 6, 9, 11:
                return 30
            default:
                if ((self.choseYear % 100 != 0)&&(self.choseYear % 4 == 0)) {
                    return 29;
                }
                if ((self.choseYear % 400 == 0)) {
                    return 29;
                }
                return 28;
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREENWIDTH / 3.0
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.rowLeft = row
            self.commonYearOrLeapYear()
        }
        if component == 1 {
            self.rowMiddle = row
            self.commonMonthLenderMonth()
        }
        if component == 2 {
            self.rowRight = row
            self.commonDayLenderDay()
        }
        
    }
    
    func judgeLeapYear() -> Bool {
        if ((self.choseYear % 100 != 0)&&(self.choseYear % 4 == 0)) {
            return true
        }
        if ((self.choseYear % 400 == 0)) {
            return true
        }
        return false
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var label = view as? UILabel
        if label == nil {
            label = UILabel.init()
            label?.textColor = UIColor.colorWithHexStringSwift("333333")
            label?.font = GDFont.systemFont(ofSize: 14)
            label?.textAlignment = .center
        }
        label?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        return label!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            
            return self.yearArr[row] + "年"
        }else if component == 1 {
            return self.monthARr[row] + "月"
        }else {
            return self.dayArr[row] + "日"
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
extension SignSelectTimeView {
    func commonYearOrLeapYear() {
        let year = self.yearArr[self.rowLeft]
        self.choseYear = Int(year)!
        //判断是否是当年
        if self.yearNow == year {
            //如果是当年,月，日一定是小于或者等于当前的日期，着重判断是天数
            let nowMonthIndex: Int = self.monthARr.index(of: self.monthNow) ?? 0
            //2判断选择的月是否是小于当月
            if self.rowMiddle > nowMonthIndex {
                self.rowMiddle = nowMonthIndex
                
                let nowDayIndex: Int = self.dayArr.index(of: self.dayNow) ?? 0
                self.rowRight = nowDayIndex
            }else if self.rowMiddle == nowMonthIndex {
                let nowDayIndex: Int = self.dayArr.index(of: self.dayNow) ?? 0
                self.rowRight = nowDayIndex
                self.choseDay = nowDayIndex + 1
            }else {
                //所选月份大于当前月份的话, 不对当前月份做处理
                self.rowRight = 0
                self.choseDay = 1
            }
            
            
        }else {
            self.rowRight = 0
            self.rowMiddle = 0
        }
        self.pickerView.reloadComponent(2)
        self.pickerView.selectRow(self.rowMiddle, inComponent: 1, animated: true)
        self.pickerView.selectRow(self.rowRight, inComponent: 2, animated: true)
        
        
        
        
        
    }
    
    func commonMonthLenderMonth() {
        let year = self.yearArr[self.rowLeft]
        self.choseYear = Int(year)!
        let month = self.monthARr[self.rowMiddle]
        self.choseMonth = Int(month)!
        //判断是否是当年
        if self.yearNow == year {
            //如果是当年,月，日一定是大于或者等于当前的日期，着重判断是天数
            let nowMonthIndex: Int = self.monthARr.index(of: self.monthNow) ?? 0
            //2判断选择的月是否是小于当月
            if self.rowMiddle > nowMonthIndex {
                self.rowMiddle = nowMonthIndex
                
                let nowDayIndex: Int = self.dayArr.index(of: self.dayNow) ?? 0
                self.rowRight = nowDayIndex
            }else if self.rowMiddle == nowMonthIndex {
                let nowDayIndex: Int = self.dayArr.index(of: self.dayNow) ?? 0
                self.rowRight = nowDayIndex
                self.choseDay = nowDayIndex + 1
            }else {
                //所选月份大于当前月份的话, 不对当前月份做处理
                
                self.rowRight = 0
                self.choseDay = 1
            }
            
            
        }else {
            self.rowRight = 0
            
        }
        self.pickerView.reloadComponent(2)
        self.pickerView.selectRow(self.rowMiddle, inComponent: 1, animated: true)
        self.pickerView.selectRow(self.rowRight, inComponent: 2, animated: true)
        
    }
    func commonDayLenderDay() {
        let year = self.yearArr[self.rowLeft]
        self.choseYear = Int(year)!
        let month = self.monthARr[self.rowMiddle]
        self.choseMonth = Int(month)!
        //判断是否是当年
        if self.yearNow == year {
            //如果是当年,月，日一定是大于或者等于当前的日期，着重判断是天数
            let nowMonthIndex: Int = self.monthARr.index(of: self.monthNow) ?? 0
            //2判断选择的月是否是小于当月
            if self.rowMiddle == nowMonthIndex {
                let nowDayIndex: Int = self.dayArr.index(of: self.dayNow) ?? 0
                if self.rowRight >= nowDayIndex {
                    self.rowRight = nowDayIndex
                    self.choseDay = nowDayIndex + 1
                    self.pickerView.selectRow(self.rowRight, inComponent: 2, animated: true)
                }
            }else {
                //所选月份大于当前月份的话, 不对当前月份做处理
                self.choseDay = Int(self.dayArr[self.rowRight])!
                
            }
            
            
        }
        
        
    }
    
    
}


