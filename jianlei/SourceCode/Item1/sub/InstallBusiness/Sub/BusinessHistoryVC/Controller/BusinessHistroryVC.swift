//
//  BusinessHistroryVC.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/9/11.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class BusinessHistroryVC: DDInternalVC , UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.loadMore()
        
        
        // Do any additional setup after loading the view.
    }
    let table = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight), style: UITableView.Style.plain)
    let maskView = ShopMaskView.init(frame: CGRect.zero, title: "bussinessHistoryNUll"|?|)
    
    func configUI() {
        self.naviBar.title = "bussinessHistoy"|?|
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        rightBtn.setImage(UIImage.init(named: "installBussiness_search_small"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction(btn:)), for: UIControl.Event.touchUpInside)
        self.naviBar.rightBarButtons = [rightBtn]
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.view.addSubview(self.maskView)
        self.maskView.frame = CGRect.init(x: 0, y: (SCREENHEIGHT - 200) / 2.0, width: SCREENWIDTH, height: 200)
        self.maskView.isHidden = true
        
        
        
        
        
        self.view.addSubview(table)
        table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        table.register(InstallHistoryCell.self, forCellReuseIdentifier: "InstallHistoryCell")
        table.register(InstallHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "InstallHistoryHeader")
        table.separatorStyle = .none
        table.gdLoadControl = GDLoadControl.init(target: self, selector: #selector(loadMore))
        if #available(iOS 11.0, *) {
            self.table.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        
        self.refreshBtn.frame = CGRect.init(x: SCREENWIDTH - 60, y: SCREENHEIGHT - DDSliderHeight - 100, width: 44, height: 44)
        self.refreshBtn.isHidden = true
//        self.view.addSubview(self.header)
//        self.header.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 44)
//        self.header.button.addTarget(self, action: #selector(calanderTimeAction(btn:)), for: UIControl.Event.touchUpInside)
        
        
    }

    @objc func rightBtnAction(btn: UIButton) {
        self.pushVC(vcIdentifier: "InstallHistorySearchVC", userInfo: nil)
    }
    var date: String = ""
//    {
//        didSet{
//            if date == "" {
//                self.refreshBtn.isHidden = true
//            }else {
//                self.refreshBtn.isHidden = false
////                self.header.myTitle.text = date
//            }
//        }
//    }
    @objc func loadMore() {
        let parameter: [String: AnyObject] = ["date": self.date as AnyObject, "page": self.page as AnyObject, "token": (DDAccount.share.token ?? "") as AnyObject, "data_type": "2" as AnyObject]
        if self.page == 1 {
            self.table.gdLoadControl?.loadStatus = .idle
        }
        self.page += 1
        let router = Router.get("install-history/install", DomainType.api, parameter)
        let _ = NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<[InstallHistoryModel]>.self, from: response)
            if let data = model?.data, model?.status == 200 {
                
                self.table.gdLoadControl?.endLoad(result: GDLoadResult.success)
                self.analyDate(date: data)
                if self.page == 2 {
                    //第一次加载第一页的数据的时候
//                    self.header.isHidden = false
//                    self.header.myTitle.text = data.first?.month
                }
                
            }else {
                if self.page == 2 {
//                    self.header.isHidden = true
                }
                self.table.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                self.table.reloadData()
            }
            
            if self.dataArr.count == 0 {
                self.table.isHidden = true
                self.maskView.isHidden = false
                self.refreshBtn.isHidden = false
            }else {
                self.refreshBtn.isHidden = true
                self.table.isHidden = false
                self.maskView.isHidden = true
            }
        }, failure: {
            if self.page == 2 {
//                self.header.isHidden = true
            }
        })
        
    }
    func analyDate(date: [InstallHistoryModel]) {
        var key: String = ""
        var count: Int = 0
        var fatherArr: [InstallHistoryModel] = [InstallHistoryModel]()
        var originArr: [InstallHistoryModel] = [InstallHistoryModel]()
        self.dataArr.forEach { (arr) in
            arr.forEach({ (model) in
                originArr.append(model)
            })
        }
        originArr.append(contentsOf: date)
        originArr.forEach { (model) in
            if key != model.month {
                key = model.month ?? ""
                count += 1
                fatherArr.append(model)

            }
        }
        self.dataArr.removeAll()
        fatherArr.forEach { (superModel) in
            var arr = [InstallHistoryModel]()
            originArr.forEach({ (model) in
                if superModel.month == model.month {
                    arr.append(model)
                }
            })
            self.dataArr.append(arr)

        }
        
        self.table.reloadData()
        
        
    }
    

    
    lazy var refreshBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "returnOrigin"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(refreshBtnClick(btn:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    @objc func refreshBtnClick(btn: UIButton) {
        self.page = 1
        self.date = ""
        self.loadMore()
    }
    
//    let header: InstallHistoryHeader = InstallHistoryHeader.init(reuseIdentifier: "InstallHistoryHeader")
    
    var page: Int = 1
    var keyword: String = ""
    
    var dataArr: [[InstallHistoryModel]] = [[InstallHistoryModel]]()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < self.dataArr.count {
            let arr = self.dataArr[section]
            return arr.count
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstallHistoryCell", for: indexPath) as! InstallHistoryCell
        if indexPath.section < (self.dataArr.count) {
            let arr = self.dataArr[indexPath.section]
            if indexPath.row < arr.count {
                cell.bussinessHistoryModel = arr[indexPath.row]
            }

        }
        cell.statusLabel.isHidden = true

        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < self.dataArr.count {
            let arr = self.dataArr[indexPath.section]
            if indexPath.row < arr.count {
                let model = arr[indexPath.row]
                let vc = ShopInfoVC()
                vc.vcType = .bussinessHistory
                vc.userInfo = ["id": model.id, "type": model.shop_place_type, "shop_type": model.shop_type ?? "1"]
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section >= self.dataArr.count {
                return nil
            }
            let arr = self.dataArr[section]
            let model = arr.first
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InstallHistoryHeader") as! InstallHistoryHeader
            header.myTitle.text = model?.month ?? ""
           
            header.button.addTarget(self, action: #selector(calanderTimeAction(btn:)), for: UIControl.Event.touchUpInside)
//            header.button.isHidden = true
//            self.header.myTitle.text = model?.month ?? ""
//            self.header.button.addTarget(self, action: #selector(calanderTimeAction(btn:)), for: UIControl.Event.touchUpInside)
            header.myTitle.text = model?.month
            return header
    
        }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
    
    
    
    
    @objc func calanderTimeAction(btn: UIButton) {
        let subView = DDCoverView.init(superView: self.view)
        self.cover = subView
        let selectTime = HistorySelectTime.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 300 - DDSliderHeight, width: SCREENWIDTH, height: 300 + DDSliderHeight))
        self.cover?.addSubview(selectTime)
        self.cover?.deinitHandle = {
            self.cover?.removeFromSuperview()
            self.cover = nil
        }
        selectTime.sender = {[weak self] (title) in
            if title == "cancle" {
                self?.cover?.removeFromSuperview()
                self?.cover = nil
            }else {
                self?.date = title ?? ""
                self?.page = 1
                self?.dataArr.removeAll()
                self?.loadMore()
                self?.cover?.removeFromSuperview()
                self?.cover = nil
            }
            
        }
        
        
        
        
    }
    weak var cover: DDCoverView?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

class InstallHistoryModel: Codable {
    ///店鋪詳細地址
    var address: String?
    ///店鋪所在地
    var area_name: String?
    ///安裝時間
    var create_at: String?
    ///屬於幾月份
    var month: String?
    ///替換表ID
    var replace_id: String?
    ///屏幕數量
    var screen_number: String?
    var id: String?
    var shop_id: String?
    var shop_image: String?
    var shop_name: String?
    ///安裝類型：1：新店安裝，2：屏幕更換，3：屏幕拆除，4：新增屏幕
    var type: String?
    ///1理髮店，2寫字樓，3住宅
    var shop_place_type: String?
    ///1，分店，2总店
    var shop_type: String?
    
    
    
    
    
}
//MARK:选择年份和月份
class HistorySelectTime: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    var currentMonthCount: Int = 0
    func request() {
        let date = Date.init()
        let fm = DateFormatter.init()
        fm.dateFormat = "yyyy"
        let year = fm.string(from: date)
        self.yearNow = year
        let currentYear = Int(year) ?? 2018
        self.choseYear = currentYear
        var arr: [Int] = []
        for i in 2018...currentYear {
            arr.append(i)
        }
        arr.forEach { (num) in
            let numstr = String(num)
            self.yearArr.append(numstr)
        }
        fm.dateFormat = "MM"
        self.monthNow = fm.string(from: date)
        self.choseMonth = Int(self.monthNow) ?? 02
        for i in 1...self.choseMonth {
            self.currentYearMonth.append(String.init(format: "%02d", i))
        }
        self.pickerView.reloadAllComponents()
        self.defaultDisplay()
        
    }
    deinit {
        mylog("销毁销毁")
    }
    let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 50))
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.backView)
        self.backView.addSubview(self.cancleBtn)
        self.backView.addSubview(self.trueBtn)
        self.backgroundColor = UIColor.white
        self.pickerView.backgroundColor = UIColor.white
        self.addSubview(self.pickerView)
        self.pickerView.frame = CGRect.init(x: 0, y: self.backView.max_Y, width: SCREENWIDTH, height: frame.height - self.backView.max_Y)
        self.request()
    }
    var currentYearMonth: [String] = [String]()
    func defaultDisplay() {
        self.rowLeft = self.yearArr.index(of: self.yearNow) ?? 0
        self.rowMiddle = self.currentYearMonth.index(of: self.monthNow) ?? 0
        
        self.pickerView.selectRow(self.rowLeft, inComponent: 0, animated: false)
        self.pickerView.selectRow(self.rowMiddle, inComponent: 1, animated: false)
        
    }
    var rowLeft = 0
    var rowMiddle = 0
    
    var monthARr: [String] = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var yearArr: [String] = []
    var yearNow: String = ""
    var choseYear: Int = 2018
    var monthNow: String = ""
    var choseMonth: Int = 02
    var dayNow: String = ""
    var choseDay: Int = 28
    
    
    
    @objc func cancleAction(btn: UIButton) {
        self.sender?("cancle")
    }
    @objc func trueAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            let year = self.yearArr[self.rowLeft]
            let month = self.monthARr[self.rowMiddle]
            self.sender?(year + "-" + month)
            self.removeFromSuperview()
        }
    }
    var sender: ((String?) ->())?
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 15, y: 10, width: 50, height: 35))
        btn.setTitle("cancel"|?|, for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    lazy var trueBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 50 - 15, y: 10, width: 50, height: 35))
        btn.setTitle("sure"|?|, for: .normal)
        btn.addTarget(self, action: #selector(trueAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    
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
            return self.yearArr.count
        }else if component == 1 {
            if String(self.choseYear) == self.yearNow {
                return self.currentYearMonth.count
            }else {
                return self.monthARr.count
            }
            
        }
        return 0
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
            self.commonYearOrLeapYear()
        }
        if component == 1 {
            self.rowMiddle = row
            
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
        }
        return nil
        
    }
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 162, width: SCREENWIDTH, height: 162))
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    
    
    
}
extension HistorySelectTime {
    func commonYearOrLeapYear() {
        let year = self.yearArr[self.rowLeft]
        self.choseYear = Int(year) ?? 2018
        self.pickerView.reloadComponent(1)
        
    }
    
    
    
    
}



