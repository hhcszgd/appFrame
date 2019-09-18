//
//  DDChangeTimeAlert.swift
//  Project
//
//  Created by WY on 2018/3/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
//import Calendar

/// get year , month and day from time string
///
/// - Parameter timeString: time string  eg://2018-01-01
/// - Returns: turple you want
private func getYMD(timeString:String)->(time : Date , year:Int , month:Int , day:Int )?{
    let formate = DateFormatter()
    formate.timeZone = TimeZone(identifier: "Chinese")
    let calender = Calendar.current
    formate.dateFormat = "yyyy-MM-dd"
    if let originStartTime = formate.date(from: timeString){//self.start_time
        let year = calender.component(Calendar.Component.year, from: originStartTime)
        let month  = calender.component(Calendar.Component.month, from: originStartTime)
        let day    = calender.component(Calendar.Component.day, from: originStartTime)
        return (originStartTime ,year , month , day )
    }else{return nil }
}
private func daysAMonth(year:Int , month : Int)->Int{
    if month > 12 || month <= 0 {
        return 0
    }
    switch month{
    case  2 :
        if year % 100 == 0 {
            return  year % 400 == 0 ? 29 : 28
        }else if year % 4 == 0{
            return 29
        }else{
            return 28
        }
    case  1,3,5,7,8,10,12 :
        return 31
    case  4,6,9,11  :
        return 30
    default:
        return 0
    }
}
class DDChangeTimeAlert: DDCoverView {
    private let contentView = UIView()
    private let titleLable = UILabel()
    private let confirm = UIButton()
    private let datePicker : UIPickerView = UIPickerView.init()
    
    private let contentView2 = UIView()
    private let titleLabel2 = UILabel()
    private let confirm2 = UIButton()
    private let cancle2 = UIButton()
    var arr : [(month:Int , days:[Int])] = [(month:Int , days:[Int])]()
    var times : String  = "0"
    var action : ((String , String)->())?
    var timeRange : (start_time : String , end_time : String) = ("" , ""){
        didSet{
            self.setMonthsArray()
            datePicker.reloadAllComponents()
            datePicker.selectRow(0, inComponent: 0, animated: false )
            datePicker.selectRow(0, inComponent: 1, animated: false )
        }
        
    }
    
//    var start_time = ""
//    var end_time = ""
    
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(contentView)
        contentView.backgroundColor = .white
        self.contentView.addSubview(titleLable)
        titleLable.numberOfLines = 3
        titleLable.textColor = .gray
        titleLable.font = GDFont.systemFont(ofSize: 16)
        titleLable.text = "请选择起始时间"
        self.contentView.addSubview(confirm)
        confirm.setTitle("确认", for: UIControlState.normal)
        confirm.titleLabel?.font = GDFont.systemFont(ofSize: 16)
        confirm.setTitleColor(UIColor.orange, for: UIControlState.normal )
        confirm.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        contentView.addSubview(datePicker)
        datePicker.delegate = self
        datePicker.dataSource = self
    }
    private func configContentView2(timeRange : (startTime:String , endTime:String )){
        if contentView2.superview == nil && contentView2.subviews.isEmpty {
            self.addSubview(contentView2)
            contentView2.backgroundColor = .white
            contentView2.addSubview(titleLabel2)
            titleLabel2.numberOfLines = 4
            titleLabel2.textAlignment = .center
            contentView2.addSubview(confirm2)
            contentView2.addSubview(cancle2)
            confirm2.backgroundColor = .orange
            cancle2.backgroundColor = .orange
            confirm2.addTarget(self , action: #selector(sureModify(sender:)), for: UIControlEvents.touchUpInside)
            cancle2.addTarget(self , action: #selector(sureModify(sender:)), for: UIControlEvents.touchUpInside)
        }
        contentView2.isHidden = false
        titleLabel2.attributedText = ["您申请修改广告投放时间为\n" , timeRange.startTime , " 到 " , timeRange.endTime ,"\n您还有\(times)次修改机会",  "\n是否确认修改?"].setColor(colors: [UIColor.gray , .orange , .gray , .orange, . gray , . gray])
        let toBorderMargin : CGFloat = 30
        let contentView2H : CGFloat = 186
        contentView2.frame = CGRect(x: toBorderMargin, y: self.bounds.height/2 - contentView2H , width: self.bounds.width - toBorderMargin * 2, height: contentView2H)
        let buttonToBorder : CGFloat = 20
        let buttonMargin : CGFloat = 10
        let buttonW = (contentView2.bounds.width - buttonToBorder * 2 - buttonMargin) / 2
        cancle2.frame = CGRect(x: buttonToBorder, y: contentView2H - 44 - 20, width: buttonW, height: 44)
        confirm2.frame = CGRect(x: cancle2.frame.maxX + buttonMargin, y: contentView2H - 44 - 20, width: buttonW, height: 44)
        titleLabel2.frame = CGRect(x: 0, y: 10, width: contentView2.bounds.width, height: confirm2.frame.minY - 10)
        confirm2.setTitle("确认修改(\(times))", for: UIControlState.normal)
        cancle2.setTitle("取消", for: UIControlState.normal)
    }
    private func caculateEndTime(startTimeStr : String) -> (date : Date ,year: Int , month:Int , day:Int )? {
        let calender = Calendar.current
        if let startTime = getYMD(timeString: self.timeRange.start_time) ,let endTime = getYMD(timeString: self.timeRange.end_time) , let selectedStartTime = getYMD(timeString: startTimeStr) {
            let timeinterval = endTime.time.timeIntervalSince(startTime.time)
            let targetEndTime = selectedStartTime.time.addingTimeInterval(timeinterval)
            var  targetDay = calender.component(Calendar.Component.day, from: targetEndTime)
            var targetMonth = calender.component(Calendar.Component.month, from: targetEndTime)
            let targetYear = calender.component(Calendar.Component.year, from: targetEndTime)
            if targetDay <= 3 {
                targetMonth = targetMonth - 1
                targetDay = daysAMonth(year: targetYear, month: targetMonth)
            }else if ( targetDay <= 16){
               targetDay = 15
            }else if (targetDay >= 28){
               targetDay = daysAMonth(year: targetYear, month: targetMonth)
            }
            return (targetEndTime , targetYear , targetMonth , targetDay)
        }
        return nil
    }
     private func getChangedTimeRange() -> (startTime:String,endTIme:String)? {
        let startMonthRow = datePicker.selectedRow(inComponent: 0)
        let startDayRow = datePicker.selectedRow(inComponent: 1)
        let calender = Calendar.current
        let year = calender.component(Calendar.Component.year, from: Date())
        
        if arr.count > 0 {
            let monthTurple = arr[startMonthRow]
            if  monthTurple.days.count > 0{
                let day = monthTurple.days[startDayRow]
                let targetStartTimeStr = "\(year)-\(monthTurple.month)-\(day)"
                if let targetEndTimeTurple = caculateEndTime(startTimeStr: targetStartTimeStr){
                    if targetEndTimeTurple.year > year{//跨年了
                        GDAlertView.alert("超出本年,请重新选择开始时间", image: nil, time: 2, complateBlock: nil )
                        return nil
                    }else{
                        return  (targetStartTimeStr , "\(targetEndTimeTurple.year)-\(targetEndTimeTurple.month)-\(targetEndTimeTurple.day)")
                    }
                }
            }
            
        }
        return nil
    }
    @objc  private  func sureModify(sender:UIButton){
        if sender == confirm2{
            if let turple = getChangedTimeRange(){
                self.remove()
                action?(turple.startTime , turple.endTIme)
            }
        }else{
            self.remove()
//            self.contentView2.isHidden = true
//            self.contentView.isHidden = false
        }
        
    }
    @objc  private func buttonClick(sender:UIButton)  {
        if self.times == "0"{
            GDAlertView.alert("", image: nil, time: 2, complateBlock: nil)
            return
        }
        if let turple = getChangedTimeRange(){
            self.contentView.isHidden = true
            self.configContentView2(timeRange: (turple.startTime,turple.endTIme ))
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 0
        let contentViewW = self.bounds.width - toBorder * 2
        let contentViewH : CGFloat = 300
        contentView.frame = CGRect(x: toBorder, y: self.bounds.height  - contentViewH, width: contentViewW, height: contentViewH)
        titleLable.frame =  CGRect(x: 10, y: 0, width: contentViewW/2, height:44)
        confirm.frame = CGRect(x: contentViewW - 64, y: 0  , width: 64, height: 44)
        datePicker.frame = CGRect(x: 10, y: titleLable.frame.maxY + 10, width: contentViewW - 20, height: contentViewH - titleLable.bounds.height - 30 )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDChangeTimeAlert : UIPickerViewDelegate , UIPickerViewDataSource{
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
     private func setMonthsArray(){
        mylog(self.timeRange.start_time)
        mylog(self.timeRange.end_time)
        let currentTime = Date()
        let calender = Calendar.current
        let currentMonth = calender.component(Calendar.Component.month, from: currentTime)
//        let currentDay = calender.component(Calendar.Component.day, from: currentTime)
        if let startTime = getYMD(timeString: self.timeRange.start_time) ,let endTime = getYMD(timeString: self.timeRange.end_time){
            arr.removeAll()
            for month in 1...12{
                if month >= currentMonth{
                    let minCanSelectDate = currentTime.addingTimeInterval(7*24*60*60)
                    let minCanSelectMonth = calender.component(Calendar.Component.month, from: minCanSelectDate)
                    let minCanSelectDay = calender.component(Calendar.Component.day, from: minCanSelectDate)
                    if currentMonth == month{//遍历到当月时
                        if minCanSelectMonth == currentMonth{//如果可选日期为当月
                            if minCanSelectDay <= 15 {
                                 arr.append((month, days: [16]))
                            }//否则当月不可选
                        }
                    }else if currentMonth + 1 == month{//遍历到次月时
                        if minCanSelectMonth == currentMonth + 1{//如果可选日期为遍历到的第二个月 , 就不能选择第一天
                            arr.append((month, days: [16]))
                        }else {//其他情况可以选1 , 16 两天
                            arr.append((month, days: [1,16]))
                        }
                    }else{
                        arr.append((month, days: [1,16]))
                    }
                    
           
//                    if currentDay + 7 < 16 { //第一个月 可以选16 , 不能选1
//
//                        if month == currentMonth {//当前月份只有后半月
//
//                            arr.append((month, days: [16]))
//                        }else{
//                            arr.append((month, days: [1,16]))
//                        }
//                    }else { // 能选16 和 1
//                        if month == currentMonth {//当前月份就不出现了
//                        }else{
//                                arr.append((month, days: [1,16]))
//                        }
//                    }
                }
            }
            
//            for month in 1...12{
//                if month >= startTime.month{
//                    if startTime.day > 15 && month == startTime.month{
////                        months.append(month)
//                    }else{
//                        months.append(month)
//                    }
//                }
//            }
            let timeinterval = endTime.time.timeIntervalSince(startTime.time)
            mylog(timeinterval)
            let dayCount = Int(timeinterval / (24 * 60 * 60 ))
            mylog(dayCount)
        }
    }
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
//            let formate = DateFormatter()
//            formate.timeZone = TimeZone(identifier: "Chinese")
//            let calender = Calendar.current
//            formate.dateFormat = "yyyy-MM-dd"
//            mylog(self.start_time)
//            if let originStartTime = formate.date(from: self.start_time){//self.start_time
//                let year = calender.component(Calendar.Component.year, from: originStartTime)
//                let month  = calender.component(Calendar.Component.month, from: originStartTime)
//                let day    = calender.component(Calendar.Component.day, from: originStartTime)
//                mylog("\ntime:\(originStartTime)\n year:\(year)\n month:\(month)\n day:\(day)")
//            }
            
            return arr.count
        }else if component == 1{
            let selectRow = pickerView.selectedRow(inComponent: 0)
            if arr.count > 0 && arr[selectRow].days.count > 0{
                return arr[selectRow].days.count
            }
            return 0
            
        }else{return 0 }
    }
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if component == 0  {
            return "\(arr[row].month)月"
        }else if component == 1{
            return "\(arr[pickerView.selectedRow(inComponent: 0)].days[row])日"
        }
        return "\(row)"
    }
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        mylog("\(row)")
        pickerView.reloadComponent(1)
        if component == 0{pickerView.selectRow(0, inComponent: 1, animated: true)}
        
    }
    
}
