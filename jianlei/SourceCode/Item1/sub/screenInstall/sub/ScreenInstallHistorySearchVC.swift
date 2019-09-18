//
//  ScreenInstallHistorySearchVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ScreenInstallHistorySearchVC: DDInternalVC, UITableViewDelegate, UITableViewDataSource, CustomSearchProtocol {
    
    
    let table = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight), style: UITableView.Style.plain)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        let titleView = CustomSearch.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 80, height: 44))
        titleView.delegate = self
        mylog(titleView.frame)
        self.naviBar.navTitleView = titleView
        mylog(titleView.frame)
        self.naviBar.backBtn.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    func searchWithkeyWord(keywork: String) {
        if keywork == "" {
            self.dataArr = [InstallHistoryModel]()
            self.table.reloadData()
        }else {
            self.dataArr.removeAll()
            self.keyword = keywork
            loadMore()
        }
        
    }
    func cancleBtn() {
        self.popToPreviousVC()
    }
    
    
    func configUI() {
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        table.register(InstallHistoryCell.self, forCellReuseIdentifier: "InstallHistoryCell")
        table.register(InstallHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "InstallHistoryHeader")
        table.separatorStyle = .none
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(self.maskView)
        self.maskView.frame = CGRect.init(x: 0, y: (SCREENHEIGHT - 200) / 2.0, width: SCREENWIDTH, height: 200)
    
        self.maskView.isHidden = true
        
        
    }
    @objc func rightBtnAction(btn: UIButton) {
        self.pushVC(vcIdentifier: "ScreenInstallHistorySearchVC", userInfo: nil)
    }
    
    
    func loadMore() {
        let parameter: [String: AnyObject] = ["page": self.page as AnyObject, "key_word": self.keyword as AnyObject, "token": (DDAccount.share.token ?? "") as AnyObject, "data_type": "1" as AnyObject]
        let router = Router.get("install-history/install", DomainType.api, parameter)
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<[InstallHistoryModel]>.self, from: response)
            
            if let data = model?.data, model?.status == 200 {
                self.dataArr = data
            }else {
                self.dataArr.removeAll()
            }
            
            if self.dataArr.count == 0 {
                self.maskView.isHidden = false
            }else {
                self.maskView.isHidden = true
            }
            self.table.reloadData()
        }) {
            
        }
   
        
    }
    var page: Int = 1
    var keyword: String = ""
    let maskView = ShopMaskView.init(frame: CGRect.zero, title: "bussinessSearchNull"|?|)
    var dataArr: [InstallHistoryModel] = [InstallHistoryModel]()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstallHistoryCell", for: indexPath) as! InstallHistoryCell
//        cell.model = self.dataArr[indexPath.row]
        cell.bussinessHistoryModel = self.dataArr[indexPath.section]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let model = self.dataArr[section]
//        if let month = model.month, month.count > 0 {
//            return 40
//        }else {
//            return 0.01
//        }
//
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = self.dataArr[indexPath.row]
        let model = self.dataArr[indexPath.section]
        let vc = ShopInfoVC()
        vc.vcType = .installHistory
        vc.userInfo = ["id": model.id, "type": model.type, "shop_type": model.shop_type ?? "1"]

        self.navigationController?.pushViewController(vc, animated: true)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InstallHistoryHeader") as! InstallHistoryHeader
//        let model = self.dataArr[section]
//        header.myTitle.text = model.month ?? ""
//        header.button.addTarget(self, action: #selector(calanderTimeAction(btn:)), for: UIControl.Event.touchUpInside)
//        return header
//    }
//    @objc func calanderTimeAction(btn: UIButton) {
//        self.cover = DDCoverView.init(superView: self.view)
//
//    }
//    weak var cover: DDCoverView?
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}




import RxSwift

class ScreenHistorySelectTime: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
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
        self.sender.onCompleted()
    }
    @objc func trueAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            let year = self.yearArr[self.rowLeft]
            let month = self.monthARr[self.rowMiddle]
            self.sender.onNext(year + "-" + month)
            self.sender.onCompleted()
            self.removeFromSuperview()
        }
    }
    var sender: PublishSubject<String> = PublishSubject<String>.init()
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 15, y: 10, width: 50, height: 35))
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        return btn
    }()
    lazy var trueBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 50 - 15, y: 10, width: 50, height: 35))
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(trueAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
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
extension ScreenHistorySelectTime {
    func commonYearOrLeapYear() {
        let year = self.yearArr[self.rowLeft]
        self.choseYear = Int(year) ?? 2018
        self.pickerView.reloadComponent(1)
        
    }

    

    
}










