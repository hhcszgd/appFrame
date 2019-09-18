//
//  DDTimeSelectView.swift
//  Project
//
//  Created by WY on 2019/8/20.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDTimeSelectView: DDMaskBaseView {
    let sure = UIButton()
    let cancle = UIButton()
    let timePicker : UIDatePicker = UIDatePicker()
    var done : ((Date) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(timePicker)
        self.addSubview(sure)
        self.addSubview(cancle)
        sure.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitle("cancel"|?|, for: UIControl.State.normal)
        sure.setTitle("sure"|?|, for: UIControl.State.normal)
        timePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormater:  DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        let s = dateFormater.date(from: "2019/8/01")
        timePicker.maximumDate =  Date()
        timePicker.minimumDate = s
        timePicker.backgroundColor = UIColor.white
        sure.addTarget(self, action: #selector(sureClick(sender:)), for: UIControl.Event.touchUpInside)
        cancle.addTarget(self, action: #selector(cancleClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func sureClick(sender:UIButton)  {
        mylog("确定")
        self.done?(self.timePicker.date)
        self.remove()
        
        
    }
    @objc func cancleClick(sender:UIButton)  {
        mylog("取消")
        self.remove()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let timePickerH : CGFloat = SCREENWIDTH
        timePicker.frame = CGRect(x: 0, y: self.bounds.height - timePickerH, width: self.bounds.width, height: timePickerH)
        sure.frame = CGRect(x:self.bounds.width - 64, y: timePicker.frame.minY , width: 64, height: 44)
        cancle.frame = CGRect(x: 0, y: timePicker.frame.minY , width: 64, height: 44)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DDMonthSelectView: DDMaskBaseView {
    let sure = UIButton()
    let cancle = UIButton()
    let timePicker : UIPickerView = UIPickerView()
    var done : ((String,String) -> ())?
    var selectYearRow = 0
    var selectMonthRow = 0
    override init(frame: CGRect) {

        super.init(frame: frame)
        self.addSubview(timePicker)
        self.addSubview(sure)
        self.addSubview(cancle)
        sure.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitle("cancel"|?|, for: UIControl.State.normal)
        sure.setTitle("sure"|?|, for: UIControl.State.normal)
        timePicker.delegate = self
        timePicker.dataSource = self
        
        
        
//        timePicker.datePickerMode = UIDatePicker.Mode.date
//        let dateFormater:  DateFormatter = DateFormatter()
//        dateFormater.dateFormat = "yyyy/MM/dd"
//        let s = dateFormater.date(from: "201901/01")
//        timePicker.maximumDate =  Date()
//        timePicker.minimumDate = s
        timePicker.backgroundColor = UIColor.white
        sure.addTarget(self, action: #selector(sureClick(sender:)), for: UIControl.Event.touchUpInside)
        cancle.addTarget(self, action: #selector(cancleClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func sureClick(sender:UIButton)  {
        mylog("确定")
//        let selectedYear = self.years[self.selectYearRow]
//        let selectedMonth = self.months[self.selectMonthRow]
//        self.done?("\(selectedYear)","\(selectedMonth)")
//        self.remove()
        let selectedYear = self.models[self.selectYearRow].year
        let selectedMonth = self.models[self.selectYearRow].months[self.selectMonthRow]
        self.done?("\(selectedYear)","\(selectedMonth)")
        self.remove()
        
    }
    @objc func cancleClick(sender:UIButton)  {
        mylog("取消")
        self.remove()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let timePickerH : CGFloat = SCREENWIDTH
        timePicker.frame = CGRect(x: 0, y: self.bounds.height - timePickerH, width: self.bounds.width, height: timePickerH)
        sure.frame = CGRect(x:self.bounds.width - 64, y: timePicker.frame.minY , width: 64, height: 44)
        cancle.frame = CGRect(x: 0, y: timePicker.frame.minY , width: 64, height: 44)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    var models : [YearMonthModel] = {
        var tempModels = [YearMonthModel]()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy"
        let currentYear = dateFormater.string(from: Date())
        if let currentYearInt = Int(currentYear){
            for year in 2018...currentYearInt {
                var model = YearMonthModel()
                model.year = "\(year)"
//                if "\(year)" == "2018"{
//                    dateFormater.dateFormat = "MM"
//                    let currentMonth = dateFormater.string(from: Date())
//                    var months = [String]()
//                    if let currentMonthInt = Int(currentMonth){
//                        for mo in 10...currentMonthInt{
//                            months.append("\(mo)")
//                        }
//                    }
//                    model.months = months
//                }
                if "\(year)" == "2018"{
                    dateFormater.dateFormat = "MM"
                    let currentMonth = dateFormater.string(from: Date())
                    var months = [String]()
                    if let currentMonthInt = Int(currentMonth) , currentMonthInt >= 10{
                        for mo in 10...currentMonthInt{
                            months.append("\(mo)")
                        }
                    }else {
                        for mo in 10...12{
                            months.append("\(mo)")
                        }
                    }
                    model.months = months
                }
                else if "\(year)" == currentYear{
                    dateFormater.dateFormat = "MM"
                    let currentMonth = dateFormater.string(from: Date())
                    var months = [String]()
                    if let currentMonthInt = Int(currentMonth){
                        for mo in 1...currentMonthInt{
                            months.append("\(mo)")
                        }
                    }
                    model.months = months
                }else{
                    model.months = ["1","2","3","4","5","6","7","8","9","10","11","12"]
                }
                tempModels.append(model)
            }
        }
        return tempModels
        
    }()
    struct YearMonthModel {
        var year : String =   ""
        var months :[ String] = [ String]()
    }
}

extension DDMonthSelectView : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0  {
            return models.count
        }else{
            return models[selectYearRow].months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if component == 0 {
            return models[row].year + "date_year"|?|
        }else{
            return models[selectYearRow].months[row] + "date_month"|?|
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            self.selectYearRow = row
            self.selectMonthRow = 0
            pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }else{
            self.selectMonthRow = row
        }
    }
    
}
