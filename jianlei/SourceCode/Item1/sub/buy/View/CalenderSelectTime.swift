//
//  CalenderSelectTime.swift
//  Project
//
//  Created by 张凯强 on 2019/1/25.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class CalenderSelectTime: DDCoverView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var finished: PublishSubject<(DayModel, DayModel)> = PublishSubject<(DayModel, DayModel)>.init()
    convenience init(superView: UIView, isFirstVC: Bool) {
        self.init(superView: superView)
        self.configContainerViewUI(isFirstVC: isFirstVC)
    }
    func configContainerViewUI(isFirstVC: Bool) {
        self.addSubview(self.containerView)
        
        let height: CGFloat = SCREENHEIGHT * 0.65
        self.containerView.frame = CGRect.init(x: 0, y: SCREENHEIGHT - height - TabBarHeight - (isFirstVC ? 49:0), width: SCREENWIDTH, height: height)
        self.containerView.backgroundColor = UIColor.white
        self.containerView.addSubview(self.trueBtn)
        self.containerView.addSubview(self.cancleBtn)
        self.containerView.addSubview(self.titleLabel)
        self.cancleBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 35)
        self.trueBtn.frame = CGRect.init(x: SCREENWIDTH - 50, y: 0, width: 50, height: 35)
        self.titleLabel.frame = CGRect.init(x: self.cancleBtn.max_X, y: 0, width: SCREENWIDTH - 100, height: 35)
        self.titleLabel.textAlignment = .center
        let weekWidth = SCREENWIDTH / 7.0
        let weekHeight: CGFloat = 30
        for (index, title) in ["日", "一", "二", "三", "四", "五", "六"].enumerated() {
            let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
            label.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
            label.textAlignment = .center
            label.text = title
            label.frame = CGRect.init(x: CGFloat(index) * weekWidth, y: self.titleLabel.max_Y, width: weekWidth, height: weekHeight)
            self.containerView.addSubview(label)
        }
        let collectionY = self.titleLabel.max_Y + weekHeight
        let collectionHeight = height - self.titleLabel.max_Y - weekHeight
    
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: collectionY, width: SCREENWIDTH, height: collectionHeight), collectionViewLayout: self.flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.flowLayout.minimumLineSpacing = 2.5
        self.flowLayout.minimumInteritemSpacing = 0
        
        let itemHeight: CGFloat = 33
        let itemWidth: CGFloat = SCREENWIDTH / 7.0
        self.flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        self.collectionView.register(UINib.init(nibName: "CalanderColCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalanderColCell")
        self.collectionView.register(CalanderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "CalanderHeaderView")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        self.flowLayout.sectionHeadersPinToVisibleBounds = true
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.containerView.addSubview(self.collectionView)
        configDataArr()
        
        
    }
    @objc func btnAction(sender: UIButton) {
        switch sender {
        case self.cancleBtn:
            mylog("取消")
            self.finished.onCompleted()
            self.remove()
        case self.trueBtn:
            if let model1 = self.startModel, let model2 = self.endModel {
                self.finished.onNext((model1, model2))
                self.finished.onCompleted()
            }else if let model1 = self.startModel {
                self.finished.onNext((model1, model1))
                self.finished.onCompleted()
                
            }
            if self.startModel == nil {
                GDAlertView.alert("请选择开始时间", image: nil, time: 1, complateBlock: nil)
            }
            self.remove()
            mylog("确定")
        default:
            break
        }
    }
    
    var dataArr: [MonthModel] = [MonthModel]()
    var startYear: Int?
    var startMonth: Int?
    var startDay: Int?
    var endYear: Int?
    var endMonth: Int?
    var endDay: Int?
    var startModel: DayModel?
    var endModel: DayModel?
    //NARK:订单生成完成，天数不可修改。
    var dayCount: Int = 0
    var calander: Calendar {
        get{
            if #available(iOS 9.0, *) {
                return Calendar.init(identifier: Calendar.Identifier.gregorian)
            } else {
                return Calendar.current
                // Fallback on earlier versions
            }
        }
    }
    //MARK:数据源
    func configDataArr() {
        let yearGlobal = self.calander.getyear()
        let globalMonth = self.calander.getMonth()
        let globalDay = self.calander.getDay()
        let date = self.calander.getDate(year: yearGlobal, month: globalMonth, day: globalDay, h: 0, m: 0, s: 15)
        let targetDate = Date.init(timeInterval: 60 * 60 * 24 * 15, since: date)
        let targetDay = self.calander.getDay(date: targetDate)
        let targetMonth = self.calander.getMonth(date: targetDate)
        let fatureDate = Date.init(timeInterval: 60 * 60 * 24 * 105, since: date)
        ///四个月的时间
        for i in 0...4 {
            let monthModel = MonthModel.init()
            var month = i + globalMonth
            var year = yearGlobal
            if month <= 12 {
                
            }else {
                month = i - 8
                year = yearGlobal + 1
            }
            
            monthModel.year = year
            monthModel.month = month
            let currnetMonthDays = self.calander.getTargetMonthDays(year: year, month: month, day: 1)
            var days = [DayModel]()
            for j in 1...currnetMonthDays {
                let dayModel = DayModel.init()
                dayModel.day = j
                dayModel.month = month
                dayModel.year = year
                
                let dayDate = self.calander.getDate(year: year, month: month, day: j)
                let result = self.calander.comparDate(date1: dayDate, date2: targetDate)
                let fatureResult = self.calander.comparDate(date1: dayDate, date2: fatureDate)
                if ((result == 1) || (result == 0)) && (fatureResult == 0 || fatureResult == -1) {
                    dayModel.dayState = .DayModelStateNormal
                }else {
                    dayModel.dayState = .DayModelNoSelect
                }
                if let startDay = self.startDay, let startM = self.startMonth, let startYear = self.startYear, let endDay = self.endDay, let endM = self.endMonth, let endYear = self.endYear {
                    
                    
                    let startDate = self.calander.getDate(year: startYear, month: startM, day: startDay)
                    let endDate = self.calander.getDate(year: endYear, month: endM, day: endDay)
                    let result1 = self.calander.comparDate(date1: dayDate, date2: startDate)
                    let result2 = self.calander.comparDate(date1: dayDate, date2: endDate)
                    
                    if (result1 == 1) && (result2 == -1) {
                        dayModel.dayState = .DayModelSelected
                    }else {
                        if dayModel.dayState != .DayModelNoSelect {
                            dayModel.dayState = .DayModelStateNormal
                        }
                        
                    }
                    
                    if endDay == j && endM == month && endYear == year {
                        dayModel.dayState = .DayModelEnd
                        self.endModel = dayModel
                    }
                    if (startDay == j) && (startM == month) && (startYear == year) {
                        dayModel.dayState = .DayModelStart
                        self.startModel = dayModel
                    }
                    
                }else {
                    
                    if self.dayCount > 0 {
                        
                        
                        
                        
                    }else {
                        if targetMonth == month && targetDay == j {
                            dayModel.dayState = .DayModelStart
                            self.startModel = dayModel
                        }
                    }
                    
                }
                
                
                
                dayModel.dayDate = dayDate
                
                
                
                dayModel.week = self.calander.getWeakDay(date: dayDate)
                
                days.append(dayModel)
            }
            let firstDay = days.first!
            let profixInt = firstDay.week! % 7
            if profixInt == 0 {
                for _ in 1...6 {
                    let model = DayModel.init()
                    model.dayState = .DayModelNoSelect
                    days.insert(model, at: 0)
                }
            }else {
                for _ in 1..<profixInt {
                    let model = DayModel.init()
                    model.dayState = .DayModelNoSelect
                    days.insert(model, at: 0)
                }
            }
            monthModel.days = days
            self.dataArr.append(monthModel)
            
            
        }
        self.collectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let monthModel = self.dataArr[section]
        let days = monthModel.days
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CalanderColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalanderColCell", for: indexPath) as! CalanderColCell
        let monthModel = self.dataArr[indexPath.section]
        cell.dayModel = monthModel.days[indexPath.item]
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellClick(indexPath: indexPath)
        collectionView.reloadData()
    }
    
    func isCanclehaveSelect(startModel: DayModel) -> Bool {
        var isCancleHaveSelect = true
        let date = self.calander.getDate(year: startModel.year!, month: startModel.month!, day: startModel.day!, h: 0, m: 0, s: 1)
        let endDate = self.calander.getDate(year: startModel.year!, month: startModel.month!, day: startModel.day!, h: 23, m: 59, s: 59).addingTimeInterval(TimeInterval((self.dayCount - 1) * 24 * 3600))
        //        let endyear = self.calander.getyear(date: endDate)
        //        let endMonth =  self.calander.getMonth(date: endDate)
        //        let endDay = self.calander.getDay(date: endDate)
        self.dataArr.forEach { (monthModel) in
            let days = monthModel.days
            days.forEach({ (day) in
                /// c1=1，现在的时间在开始时间的右边 。
                let c1 = self.calander.comparDate(date1: day.dayDate , date2: date)
                
                let c2 = self.calander.comparDate(date1: day.dayDate , date2: endDate)
                if (c1 == 1 && c2 == -1) {
                    if !(day.dayState == .DayModelNoSelect) {
                        
                    }else {
                        
                        isCancleHaveSelect = false
                        
                    }
                    
                }
                
            })
        }
        return isCancleHaveSelect
    }
    
    
    func configCountSelect() {
        let date = self.calander.getDate(year: self.startModel?.year!, month: self.startModel?.month!, day: self.startModel?.day!, h: 0, m: 0, s: 1)
        let endDate = self.calander.getDate(year: self.startModel?.year!, month: self.startModel?.month!, day: self.startModel?.day!, h: 23, m: 59, s: 59).addingTimeInterval(TimeInterval((self.dayCount - 1) * 24 * 3600))
        let endyear = self.calander.getyear(date: endDate)
        let endMonth =  self.calander.getMonth(date: endDate)
        let endDay = self.calander.getDay(date: endDate)
        
        
        if self.configSpecial(date: date, endDate: endDate, endyear: endyear, endMonth: endMonth, endDay: endDay) {
            self.startModel?.dayState = .DayModelStateNormal
            self.startModel = nil
            self.endModel?.dayState = .DayModelStateNormal
            self.endModel = nil
            self.cleanData()
            GDAlertView.alert("仅支持购买至多三个月的广告", image: nil, time: 1, complateBlock: nil)
        }
        
    }
    func configSpecial(date: Date, endDate: Date, endyear: Int, endMonth: Int, endDay: Int) -> Bool {
        var isNotSelected = false
        self.dataArr.forEach { (monthModel) in
            let days = monthModel.days
            days.forEach({ (day) in
                /// c1=1，现在的时间在开始时间的右边 。
                let c1 = self.calander.comparDate(date1: day.dayDate , date2: date)
                
                let c2 = self.calander.comparDate(date1: day.dayDate , date2: endDate)
                if (c1 == 1 && c2 == -1) {
                    if !(day.dayState == .DayModelNoSelect) {
                        day.dayState = .DayModelSelected
                        if (endyear == day.year) && (endMonth == day.month) && (endDay == day.day) {
                            self.endModel = day
                            self.endModel?.dayState = .DayModelEnd
                        }
                        
                        if (self.startModel?.year == day.year) && (self.startModel?.month == day.month) && (self.startModel?.day == day.day) {
                            self.startModel?.dayState = .DayModelStart
                        }
                        if self.dayCount == 1 {
                            day.dayState = DayModelState.DayModelStartAndEnd
                            self.startModel = day
                            self.endModel = day
                        }
                    }else {
                        isNotSelected = true
                        
                        
                        
                    }
                    
                }
                
            })
        }
        return isNotSelected
    }
    deinit {
        mylog("***************SelectStartAndEndTime销毁")
    }
    
    ///重置状态
    func cleanData() {
        self.dataArr.forEach { (monthModel) in
            let days = monthModel.days
            days.forEach({ (day) in
                if day.dayState != DayModelState.DayModelNoSelect {
                    day.dayState = .DayModelStateNormal
                }
                
            })
        }
    }
    
    func cellClick(indexPath: IndexPath) {
        let monthModel = self.dataArr[indexPath.section]
        let days = monthModel.days
        let day = days[indexPath.item]
        if day.dayState == .DayModelNoSelect {
            if let month = day.month {
                if month <= (self.calander.getMonth() + 1) {
                    GDAlertView.alert("仅支持购买15天后的广告", image: nil, time: 1, complateBlock: nil)
                }else {
                    GDAlertView.alert("仅支持购买至多三个月广告", image: nil, time: 1, complateBlock: nil)
                }
            }
            
            
            return
        }
        var isHaveStart = false
        var isHaveEnd = false
        var isHaveSelected = false
        var startDate: Date?
        var endDate: Date?
        self.dataArr.forEach { (monthModel) in
            let days = monthModel.days
            days.forEach({ (day) in
                if day.dayState == .DayModelStart {
                    isHaveStart = true
                    startDate = day.dayDate
                    startModel = day
                }else if day.dayState == .DayModelSelected {
                    isHaveSelected = true
                }else if day.dayState == .DayModelEnd {
                    isHaveEnd = true
                    endDate = day.dayDate
                    endModel = day
                    
                }else if day.dayState == DayModelState.DayModelStartAndEnd {
                    isHaveEnd = true
                    isHaveStart = true
                    self.startModel = day
                    self.endModel = day
                }
            })
        }
        
        
        
        if (!isHaveEnd && !isHaveStart && !isHaveSelected) || (!isHaveEnd && !isHaveStart) {
            //没有开始选
            self.endModel?.dayState = .DayModelStateNormal
            self.endModel = nil
            day.dayState = .DayModelStart
            startDate = day.dayDate
            if self.startModel?.year == day.year && self.startModel?.month == day.month && self.startModel?.day == day.day && self.dayCount > 0 {
                GDAlertView.alert("所选日期不可与原投放日期相同", image: nil, time: 1, complateBlock: nil)
                day.dayState = .DayModelStateNormal
                return
            }
            self.startModel = day
            if self.dayCount > 0 {
                
                self.configCountSelect()
            }
            
        }else if (isHaveEnd && isHaveStart) {
            
            
            if self.dayCount > 0 {
                //获取结束日期
                if !self.isCanclehaveSelect(startModel: day) {
                    return
                }
                self.cleanData()
                //有开始有结束
                self.endModel?.dayState = .DayModelStateNormal
                self.endModel = nil
                day.dayState = .DayModelStart
                startDate = day.dayDate
                self.startModel = day
                self.configCountSelect()
                
            }else {
                self.cleanData()
                //有开始有结束
                self.endModel?.dayState = .DayModelStateNormal
                self.endModel = nil
                day.dayState = .DayModelStart
                startDate = day.dayDate
                self.startModel = day
            }
            
            
        }else if (isHaveStart && !isHaveEnd) {
            let result = self.calander.comparDate(date1: startDate ?? Date.init(), date2: day.dayDate)
            switch result {
            case 1:
                //开始日期大于结束日期。
                startModel?.dayState = .DayModelStateNormal
                day.dayState = .DayModelStart
                self.startModel = day
                
            case -1:
                day.dayState = .DayModelEnd
                endDate = day.dayDate
                self.endModel = day
                self.dataArr.forEach { (monthModel) in
                    let days = monthModel.days
                    days.forEach({ (day) in
                        /// c1=1，现在的时间在开始时间的右边 。
                        let c1 = self.calander.comparDate(date1: day.dayDate , date2: startDate ?? Date.init())
                        
                        let c2 = self.calander.comparDate(date1: day.dayDate , date2: endDate ?? Date.init())
                        if (c1 == 1 && c2 == -1) {
                            if !(day.dayState == .DayModelNoSelect) {
                                day.dayState = .DayModelSelected
                            }
                            
                        }
                        
                    })
                }
            case 0:
                day.dayState = .DayModelStateNormal
                self.startModel = nil
            default:
                break
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalanderHeaderView", for: indexPath) as! CalanderHeaderView
            let monthModel = self.dataArr[indexPath.section]
            let year = monthModel.year ?? 2018
            let month = monthModel.month ?? 4
            header.myTitleLabel.text = String.init(format: "%ld年%02ld月", year, month)
            return header
            
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath) as UICollectionReusableView
            return footer
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREENWIDTH, height: 35)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREENWIDTH, height: 0.01)
    }
    
    
    
    
    
    
    
    
    
    let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    lazy var trueBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("确定", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ed8102"), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(btnAction(sender:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("cccccc"), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(btnAction(sender:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    let containerView: UIView = UIView.init()
    var collectionView: UICollectionView!
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
