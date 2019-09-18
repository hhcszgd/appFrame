//
//  SelectStartAndEndTime.swift
//  Project
//
//  Created by 张凯强 on 2018/4/21.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class SelectStartAndEndTime: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var containerView: UIView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    init(frame: CGRect, dayCount: Int = 0, isFirstVC: Bool = false) {
        super.init(frame: frame)
        self.dayCount = dayCount
        if let subView = Bundle.main.loadNibNamed("SelectStartAndEndTime", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
       
        self.configDataArr()
        self.flowLayout.minimumLineSpacing = 2.5
        self.flowLayout.minimumInteritemSpacing = 0
        
        let itemHeight: CGFloat = 33
        let itemWidth: CGFloat = SCREENWIDTH / 7.0
        self.flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        self.collectionView.register(UINib.init(nibName: "CalanderColCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalanderColCell")
        self.collectionView.register(CalanderHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "CalanderHeaderView")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        self.flowLayout.sectionHeadersPinToVisibleBounds = true
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    /// 订单生成完成，天数不可修改。
    var dayCount: Int = 0
    init(frame: CGRect, startModel: DayModel?, endModel: DayModel?, dayCount: Int = 0) {
        super.init(frame: frame)
        self.dayCount = dayCount
        self.startDay = startModel?.day
        self.startMonth = startModel?.month
        self.startYear = startModel?.year
        self.endDay = endModel?.day
        self.endMonth = endModel?.month
        self.endYear = endModel?.year
        if let subView = Bundle.main.loadNibNamed("SelectStartAndEndTime", owner: self, options: nil)?.last as? UIView {
            self.containerView = subView
            self.addSubview(self.containerView)
        }
        
        
        self.configDataArr()
        self.flowLayout.minimumLineSpacing = 2.5
        self.flowLayout.minimumInteritemSpacing = 0
        
        let itemHeight: CGFloat = 33
        let itemWidth: CGFloat = SCREENWIDTH / 7.0
        self.flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        self.collectionView.register(UINib.init(nibName: "CalanderColCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalanderColCell")
        self.collectionView.register(CalanderHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "CalanderHeaderView")
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        self.flowLayout.sectionHeadersPinToVisibleBounds = true
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
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
    ///限制在什么时间段内可以买
    var limitDay: Int = 89 //其实89其实相当于90天
    
    func cellClick(indexPath: IndexPath) {
        let monthModel = self.dataArr[indexPath.section]
        let days = monthModel.days
        let day = days[indexPath.item]
        if day.dayState == .DayModelNoSelect {
            if let month = day.month {
                if month <= (self.calander.getMonth() + 1) {
                    GDAlertView.alert("仅支持购买15天后的广告", image: nil, time: 1, complateBlock: nil)
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
                if let startDate = startDate {
                    //再次加上17是因为在创建数据的时候规定的时间是当天的六点。这段区域应该是在开始0：0：15秒到第90天的23：59：00秒可以在这段时间内判断
                    if day.dayDate > startDate.addingTimeInterval(TimeInterval(limitDay * 3600 * 24 + 17 * 3600)) {
                        GDAlertView.alert("只能购买90天的广告", image: nil, time: 1, complateBlock: nil)
                        break
                    }
                }
                
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
    var startModel: DayModel?
    var endModel: DayModel?
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
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
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
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
    var finished: PublishSubject<AnyObject> = PublishSubject<AnyObject>.init()
    
    @IBAction func cancleBtnAction(_ sender: UIButton) {
        self.finished.onCompleted()
    }
    
    
    @IBAction func sureBtnAction(_ sender: UIButton) {
        if self.startModel != nil {
            if self.endModel != nil {
                self.finished.onNext([self.startModel!, self.endModel!] as AnyObject)
                self.finished.onCompleted()
            }else {
                self.finished.onNext([self.startModel!, self.startModel!] as AnyObject)
                self.finished.onCompleted()
            }
        }else {
            GDAlertView.alert("请选择开始时间", image: nil, time: 1, complateBlock: nil)
        }
        
    }
    
    
    var dataArr: [MonthModel] = [MonthModel]()
    var startYear: Int?
    var startMonth: Int?
    var startDay: Int?
    var endYear: Int?
    var endMonth: Int?
    var endDay: Int?
    
    func configDataArr() {
        let yearGlobal = self.calander.getyear()
        let globalMonth = self.calander.getMonth()
        let globalDay = self.calander.getDay()
        
        ///设定的时间是从这天的0时0分15秒开始的。
        let date = self.calander.getDate(year: yearGlobal, month: globalMonth, day: globalDay, h: 0, m: 0, s: 15)
        let targetDate = Date.init(timeInterval: 60 * 60 * 24 * 15, since: date)
        let targetYear = self.calander.getyear(date: targetDate)
        let targetDay = self.calander.getDay(date: targetDate)
        let targetMonth = self.calander.getMonth(date: targetDate)
        let fatureDate = Date.init(timeInterval: 60 * 60 * 24 * 400, since: date)
        ///四个月的时间
        for i in 0...12 {
            let monthModel = MonthModel.init()
            var month = i + globalMonth
            var year = yearGlobal
            if month <= 12 {
                
            }else {
                month = month - 12
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
                        if targetMonth == month && targetDay == j && year == targetYear {
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
    }
    
    
    
}
///日历中的状态
enum DayModelState {
    ///正常状态
    case DayModelStateNormal
    ///开始状态
    case DayModelStart
    ///结束状态
    case DayModelEnd
    ///选择状态
    case DayModelSelected
    ///不能选择
    case DayModelNoSelect
    ///只选择一天，即使开始也是结束
    case DayModelStartAndEnd
}
///日期是周几
enum DayWeek {
    case Sun
    case Mon
    case Tues
    case Wed
    case Thrus
    case friday
    case saturday 
}
class DayModel {
    var dayState: DayModelState = DayModelState.DayModelStateNormal
    var weekDay: DayWeek!
    var day: Int?
    var month: Int?
    var year: Int?
    var dayDate: Date = Date.init()
    var week: Int?
}
class MonthModel {
    var days: [DayModel] = [DayModel]()
    var year: Int?
    var month: Int?
}

