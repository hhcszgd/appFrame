//
//  ChaXunResultVC.swift
//  Project
//
//  Created by 张凯强 on 2018/4/24.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation
import MapKit
class ChaXunResultVC: GDNormalVC{
   
    
    
    var areaName: String = ""
    var areaid: String = ""
    var startMonthAndDay: String?
    var endMonthAndDay: String?
    var startDay: DayModel?
    var endDay: DayModel?
    var hud: MBProgressHUD?
    ///返回查询页面的时候调用
    var back: (((String, String)) -> ())?
    override func popToPreviousVC() {
        super.popToPreviousVC()
        self.back?((self.areaid, self.areaName))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let paramete = self.userInfo as? [String: String] else {
            return
        }
        configNavigation()
        self.calanderBtn.title = self.startMonthAndDay
        self.calanderBtn.subTitle = self.endMonthAndDay
        self.globalParamete = paramete
        self.globalParamete["page"] = String(self.page)
        self.requestData(paramete: self.globalParamete, success: nil)
        self.maskView.frame = CGRect.init(x: 0, y: self.sortBtn.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.sortBtn.max_Y - self.allSelected.height - DDSliderHeight)
        self.maskView.finished = { [weak self] (areaid) in
            self?.globalParamete["area_id"] = areaid
            self?.globalParamete["keyword"] = ""
            self?.requestData(paramete: (self?.globalParamete)!, success: nil)
            self?.searchBtn.text = ""
            
        }
        let _ = self.searchBtn.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.globalParamete["keyword"] = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.searchBtn.returnKeyType = .search
    
        
        
        
        // Do any additional setup after loading the view.
    }

  
    
    lazy var maskView: MaskView = {
        let subView = MaskView.init(frame: CGRect.zero)
        subView.isHidden = true
        self.view.addSubview(subView)
        return subView
    }()
    var calander = Calendar.current
    var globalParamete: [String: String] = [String: String]()
    
    override func loadMore() {
        self.page += 1
        self.globalParamete["page"] = String(self.page)
        self.requestData(paramete: self.globalParamete) {
//            self.configWithHaveArr()
        }
        
    }
    
    //MARK:编辑数据源
    func configDataArr() {
        self.dataArr.forEach { (model) in
            if (model.cant_buy_date == nil) || (model.cant_buy_date?.count == 0) {
                //表示该地区有余量
                model.isEnable = true
                
            }else {
                if model.cant_buy_date == "所选地区余量不足" {
                    //该地区没有余量
                    model.isEnable = false
                    
                }
            }
        }
        
        
    }
    //MARK:查询结果
    func requestData(paramete: [String: String], success: (() -> ())?) {
        self.allSelected.isEnabled = false
        let router = Router.get("member/1/confirm-area", .api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            self.allSelected.isEnabled = true
            let model = BaseModelForArr<ChaxunResultModel>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    if self.page == 1 {
                        self.dataArr.removeAll()
                        self.tableV.gdLoadControl?.loadStatus = .idle
                    }
                    self.dataArr.append(contentsOf: data)
                    if data.count > 0 {
                        self.tableV.gdLoadControl?.endLoad(result: GDLoadResult.success)
                        self.allSelected.isSelected = false
                    }else {
                        self.tableV.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                    }
                    self.configAllSelectBtnAndDataArr()
                    
                    
                    success?()
                    
                    
                    self.maskView.isHidden = true
                }else {
                    if self.page == 1 {
                        self.tableV.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                        self.maskView.isHidden = false
                    }else {
                        self.tableV.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                        
                    }
                    
                }
                
            }else if model?.status == 603 {
                self.maskView.isHidden = false
                if let data = model?.data {
                    self.maskView.dataArr = data
                    self.haveSelectArr.removeAll()
                    self.haveSelectedBtn.subTitle = ""
                    self.calanderControl.subTitle = ""
                    self.allSelected.isSelected = false
                    
                    
                    
                }else {
                    self.dataArr = []
                    self.maskView.titleLabel.text = "所选地区屏幕正在推广，请查看其它地区"
                    self.maskView.isHidden = false
                }
            }else {
                ///data是空。
                
            }
            
            self.tableV.reloadData()
            
            
            
        }, onError: { (error) in
            self.allSelected.isEnabled = true
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChaXunResultCell = tableView.dequeueReusableCell(withIdentifier: "ChaXunResultCell", for: indexPath) as! ChaXunResultCell
        let model = self.dataArr[indexPath.row]
        self.haveSelectArr.forEach { (haveModel) in
            if haveModel.area_id == model.area_id {
                model.isSelected = true
                mylog(model.isEnable)
            }
        }
        mylog(model.isEnable)
        mylog(model)
        cell.model = model
        cell.areaType = self.areaType
        cell.clickFinish = { [weak self] (sender, mo) in
            if self?.haveView != nil {
                self?.haveView?.removeFromSuperview()
                self?.haveView = nil
            }
            sender.isSelected = true
            mo.isSelected = true
            let count = self?.haveSelectArr.filter({ (subModel) -> Bool in
                return subModel.area_id == mo.area_id
            }).count
            if count != 1 {
                self?.haveSelectArr.append(mo)
                if let num = self?.haveSelectArr.count {
                    self?.haveSelectedBtn.subTitle = String(num)
                    self?.calanderControl.subTitle = String(num)
                }
                
            }
            var bo: Bool = false
            self?.dataArr.forEach({ (model) in
                if (!model.isSelected) && model.isEnable {
                    bo = true
                }
            })
            self?.allSelected.isSelected = !bo
            self?.searchBtn.resignFirstResponder()
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row]
        if !model.isEnable {
            GDAlertView.alert("所选地区余量不足", image: nil, time: 1, complateBlock: nil)
        }
        self.searchBtn.resignFirstResponder()
        self.haveView?.removeFromSuperview()
        self.haveView = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    lazy var areaBtn: CustomControl = {
        let btn = CustomControl.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30))
        btn.title = "北京"
        btn.titleLabel.font = GDFont.systemFont(ofSize: 10)
        btn.image = UIImage.init(named: "downarrow")
        btn.addTarget(self, action: #selector(navigationBtnAction(sender:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.colorWithRGB(red: 230, green: 230, blue: 230)
        return btn
    }()
    
    lazy var calanderBtn: CustomControl = {
        let btn = CustomControl.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30))
        btn.style = .haveTwoTitle
        btn.subTitleColor = UIColor.colorWithRGB(red: 168, green: 168, blue: 168)
        btn.titleColor = UIColor.colorWithRGB(red: 168, green: 168, blue: 168)
        btn.title = "2-5"
        btn.subTitle = "3-5"
        btn.addTarget(self, action: #selector(navigationBtnAction(sender:)), for: .touchUpInside)
        btn.image = UIImage.init(named: "downarrow")
        btn.backgroundColor = UIColor.colorWithRGB(red: 230, green: 230, blue: 230)
        return btn
    }()
    lazy var searchBtn: UITextField = {
        let bar = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        bar.backgroundColor = UIColor.colorWithRGB(red: 230, green: 230, blue: 230)
        bar.font = GDFont.systemFont(ofSize: 14)
        let image = UIImageView.init(image: UIImage.init(named: "searchicon_o"))
        
        image.contentMode = UIViewContentMode.center
        bar.leftViewMode = .always
     
        image.frame = CGRect.init(x: 0, y: 0, width: 20, height: bar.height)
        bar.leftView = image
        image.backgroundColor = UIColor.clear
        
        bar.delegate = self
        bar.placeholder = "地名/街道名"
        return bar
    }()
    
    lazy var sortBtn: InstallBtn = {
        let btn = InstallBtn.init()
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.setTitle("屏幕降序", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9a65"), for: .selected)
        btn.setImage(UIImage.init(named: "downarrow"), for: .normal)
        btn.setImage(UIImage.init(named: "uparrow"), for: .selected)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(sortAction(btn:)), for: .touchUpInside)
        return btn
    }()
    lazy var areaB: InstallBtn = {
        let btn = InstallBtn.init()
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.setTitle("区域选择", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9a65"), for: .selected)
        btn.setImage(UIImage.init(named: "downarrow"), for: .normal)
        btn.setImage(UIImage.init(named: "uparrow"), for: .selected)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(sortAction(btn:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var screenBtn: InstallBtn = {
        let btn = InstallBtn.init()
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.setTitle("筛选", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9a65"), for: .selected)
        btn.setImage(UIImage.init(named: "downarrow"), for: .normal)
        btn.setImage(UIImage.init(named: "uparrow"), for: .selected)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(sortAction(btn:)), for: .touchUpInside)
        return btn
    }()
    lazy var tableV: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.rowHeight = 110
        table.gdLoadControl = GDLoadControl.init(target: self, selector: #selector(loadMore))
        table.register(UINib.init(nibName: "ChaXunResultCell", bundle: Bundle.main), forCellReuseIdentifier: "ChaXunResultCell")
        
        return table
    }()
    var page: Int = 1
    lazy var haveSelectedBtn: CustomControl = {
        let control = CustomControl.init(frame: CGRect.zero)
        control.style = .CornerMarkTitleWithSubTitle
        control.backgroundColor = UIColor.colorWithRGB(red: 204, green: 204, blue: 204)
        control.title = "已选择"
        control.addTarget(self, action: #selector(navigationBtnAction(sender:)), for: .touchUpInside)
        control.titleColor = UIColor.colorWithHexStringSwift("333333")
        control.subTitleColor = UIColor.white
        control.subTitleBackColor = UIColor.colorWithHexStringSwift("ea6761")
        return control
    }()
    lazy var calanderControl: CustomControl = {
        let control = CustomControl.init(frame: CGRect.zero)
        control.addTarget(self, action: #selector(navigationBtnAction(sender:)), for: .touchUpInside)
        control.backgroundColor = UIColor.clear
        control.style = .CornerMarkImageWithSubtitle
        control.subTitleColor = UIColor.white
        control.subTitleBackColor = UIColor.colorWithHexStringSwift("ea6761")
        control.image = UIImage.init(named: "calendar")
        
        return control
    }()
    ///切换地图
    lazy var changeMap: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        btn.setImage(UIImage.init(named: "map"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(changeMapAction(sender:)), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    lazy var allSelected: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("全选", for: .normal)
        btn.setTitle("取消全选", for: .selected)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("ffffff")
        btn.addTarget(self, action: #selector(tabBarBtnAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var sureAreaBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("确认区域", for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 17)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ffffff"), for: .normal)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
        btn.addTarget(self, action: #selector(tabBarBtnAction(sender:)), for: .touchUpInside)
        return btn
    }()
    

    var sort: String = "desc"
    var dataArr: [ChaxunResultModel] = [ChaxunResultModel]() {
        didSet{
            self.tableV.reloadData()
        }
    }
    ///已选择的地区的areaid
    var selectShopAreaId: String {
        get {
            if self.haveSelectArr.count == 0 {
                return ""
            }else {
                var area: String = ""
                self.haveSelectArr.forEach { (model) in
                    if let areaid = model.area_id, areaid.count > 0 {
                        area += areaid + ","
                    }
                }
                if area.hasSuffix(",") {
                    area.removeLast()
                    
                }
                return area
            }
        }
    }
    var leftAreaArr: [AreaModel] = [AreaModel]()
    var rightAreaArr: [String: [AreaModel]] = [String: [AreaModel]]()
    var model: DDItem4Model<AdvertisModel, AdvertiseBannerModel>?
    var sortView: SortView?
    var sortThree: SortThreeView?
    var sortTwo: SortTwoVIew?
    var areaType: AreaType = AreaType.province
    var cover: DDCoverView?
    var haveSelectArr: [ChaxunResultModel] = [ChaxunResultModel]()  {
        didSet{
            let num = haveSelectArr.count
            self.haveSelectedBtn.subTitle = num > 0 ? "\(num)":""
            self.calanderControl.subTitle = num > 0 ? "\(num)":""
            var totalPrice: Float = 0
            haveSelectArr.forEach { (model) in
                if let price = model.total_price, let pricefloat = Float(price) {
                    mylog(pricefloat)
                    mylog(totalPrice)
                    totalPrice = totalPrice + pricefloat
                    mylog(totalPrice)
                }
            }
            mylog(totalPrice)
            if totalPrice > 0 {
                
                self.sureAreaBtn.setTitle(String.init(format: "确认地区￥%.02f", totalPrice), for: UIControlState.normal)
            }else {
                self.sureAreaBtn.setTitle("确认地区", for: UIControlState.normal)
            }
            
        }
    }
    var haveView: HaveSelectView?
    var selectScreenNumber: String {
        get {
            var screenNum: Int = 0

            self.haveSelectArr.forEach { (model) in
                if let screenNumber = model.screen_number, let num = Int(screenNumber) {
                    screenNum += num
                }

            }
            return String(screenNum)
        }
    }
    
    ///地图坐标数据源
    var mapModel: MapModel?
}
extension ChaXunResultVC {
    //MARK:底部按钮全部，确认区域
    @objc func tabBarBtnAction(sender: UIButton) {
        switch sender {
        case self.allSelected:
            let count = self.dataArr.filter { (model) -> Bool in
                return model.isEnable
                }.count
            if count == 0{
                GDAlertView.alert("所选地区余量不足", image: nil, time: 1, complateBlock: nil)
                return
            }
            
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                var arr: [ChaxunResultModel] = []
                self.dataArr.forEach({ (model) in
                    if model.isEnable && (!model.isSelected) {
                        model.isSelected = true
                        arr.append(model)
                    }
                })
                self.haveSelectArr.append(contentsOf: arr)
                self.tableV.reloadData()
            }else {
                
                configWithHaveArr()
                
            }
            self.haveView?.removeFromSuperview()
            self.haveView = nil
            //1，判断能不能加入。
           
            

        //MARK:确认地区
        case self.sureAreaBtn:
            sender.isEnabled = false
            let token = DDAccount.share.token ?? ""
            let area: String = self.selectShopAreaId
            
            let type = (areaType == .province) ? "1":((areaType == AreaType.city) ? "2" : "3")
            let member_id = DDAccount.share.id ?? ""
            if area.count < 1 {
                sender.isEnabled = true
                GDAlertView.alert("请选择广告投放地区", image: nil, time: 1, complateBlock: nil)
                return
            }
            
            var paramete: [String: String] = ["token": token, "area_id": area, "area_type": type, "type": "1"]
            
            var orderParamete: [String: String] = [String: String]()
            if let model = self.haveSelectArr.first, let time = model.advert_time {
                orderParamete["time"] = time
                paramete["advert_time"] = time
                
            }
            if let id = self.globalParamete["advert_id"] {
                orderParamete["advert_id"] = id
                paramete["advert_id"] = id
            }
            if let rate = self.globalParamete["rate"] {
                orderParamete["rate"] = rate
                paramete["rate"] = rate
            }
            if let start = self.globalParamete["start_at"] {
                orderParamete["start_at"] = start
                paramete["start_at"] = start
            }
            if let end = self.globalParamete["end_at"] {
                orderParamete["end_at"] = end
                paramete["end_at"] = end
            }
            if let totalDay = self.globalParamete["total_day"] {
                orderParamete["total_day"] = totalDay
            }
            if let token = DDAccount.share.token {
                orderParamete["token"] = token
            }
            orderParamete["screenNumber"] = self.selectScreenNumber
            mylog(self.globalParamete)
            
            self.generalButtonAction()
            
            
            
            //接口名字提交地区
            let router = Router.post("member/\(member_id)/order/area", .api, paramete)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                self.hud?.removeFromSuperview()
                self.hud = nil
                let model = BaseModel<GDModel>.deserialize(from: dict)
                if model?.status == 200 {
                    let orderVC = TrueOrderVC()
                    orderVC.userInfo = orderParamete
                    self.navigationController?.pushViewController(orderVC, animated: true)
                }else {
                    
                    if let message = dict["message"] as? String {
                        GDAlertView.alert(message, image: nil, time: 1, complateBlock: nil)
                    }
                    
                }
                sender.isEnabled = true
            }, onError: { (error) in
                self.hud?.removeFromSuperview()
                self.hud = nil
                sender.isEnabled = true
            }, onCompleted: {
                mylog("结束")
            }, onDisposed: {
                mylog("回收")
            })
            
            
        default:
            break
        }
    }
    
    
    func generalButtonAction()  {
        self.hud = MBProgressHUD.init(view: self.view)
        self.view.addSubview(self.hud!)
        self.hud?.label.text = ""
        self.hud?.detailsLabel.text = "请耐心等待..."
        self.hud?.show(animated: true)
        
    }
    //MARK:屏幕降序，区域选择，筛选
    @objc func sortAction(btn: InstallBtn) {
        btn.isSelected = !btn.isSelected
        switch btn {
        case self.sortBtn:
            self.screenBtn.isSelected = false
            self.areaB.isSelected = false
            self.sortTwo?.removeFromSuperview()
            self.sortTwo = nil
            self.sortThree?.removeFromSuperview()
            self.sortThree = nil
            self.searchBtn.resignFirstResponder()
            sortView(btn: btn)
        case self.screenBtn:
            self.sortBtn.isSelected = false
            self.areaB.isSelected = false
            self.sortView?.removeFromSuperview()
            self.sortView = nil
            self.sortTwo?.removeFromSuperview()
            self.searchBtn.resignFirstResponder()
            self.sortTwo = nil
            configWithHaveArr()
            configSortThreeView(btn: btn)
        case self.areaB:
            self.screenBtn.isSelected = false
            self.sortBtn.isSelected = false
            self.sortView?.removeFromSuperview()
            self.sortView = nil
            self.sortThree?.removeFromSuperview()
            self.sortThree = nil
             self.searchBtn.resignFirstResponder()
            configArea(btn: btn)
        default:
            break
        }
    }
    //MARK:编辑数据源和全选按钮
    func configAllSelectBtnAndDataArr() {
        self.configDataArr()
        self.haveSelectArr.forEach({ (model) in
            self.dataArr.forEach({ (subModel) in
                if model.area_id == subModel.area_id {
                    subModel.isSelected = true
                }
            })
        })
        let canSelectArr = self.dataArr.filter({ (model) -> Bool in
            if model.isEnable {
                return !model.isSelected
            }else {
                return model.isEnable
            }
        })
        if canSelectArr.count > 0 {
            self.allSelected.isSelected = false
            
        }else {
            self.allSelected.isSelected = true
        }
    }
    
    func configArea(btn: InstallBtn) {
        if btn.isSelected {
            self.sortTwo = SortTwoVIew.init(frame: CGRect.init(x: 0, y: -500, width: SCREENWIDTH, height: SCREENHEIGHT - self.sortBtn.max_Y - DDSliderHeight), leftArr: self.leftAreaArr, rightArr: self.rightAreaArr)
            
            self.view.addSubview(self.sortTwo!)
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.sortTwo?.frame = CGRect.init(x: 0, y: self.sortBtn.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.sortBtn.max_Y - DDSliderHeight)
            }, completion: { (finished) in
                mylog("结束")
            })
            self.sortTwo?.finished = {[weak self] (title, leftArr, rightArr) in
                if title == "" {
                    self?.page = 1
                    self?.globalParamete["page"] = "1"
                    self?.globalParamete["except_area_id"] = title
                    self?.requestData(paramete: (self?.globalParamete)!, success: { [weak self] in
//                        self?.configAllSelectBtnAndDataArr()
                        
                        
                        
                    })
                    
                    //MARK:修改地区之后重新定位
                    self?.sortTwo?.removeFromSuperview()
                    self?.sortTwo = nil
                    self?.areaB.isSelected = false
                }else {
                    self?.page = 1
                    self?.globalParamete["page"] = "1"
                    self?.globalParamete["except_area_id"] = title
                    self?.requestData(paramete: (self?.globalParamete)!, success: {[weak self] in
//                        self?.haveSelectArr.forEach({ (model) in
//                            self?.dataArr.forEach({ (subModel) in
//                                if model.area_id == subModel.area_id {
//                                    subModel.isEnable = false
//                                }
//                            })
//                        })
                    })
                    self?.sortTwo?.removeFromSuperview()
                    self?.sortTwo = nil
                    self?.areaB.isSelected = false
                }
                self?.leftAreaArr = leftArr
                self?.rightAreaArr = rightArr
                
                
            }
            
        }else {
            if self.sortTwo != nil {
                self.sortTwo?.removeFromSuperview()
                self.sortTwo = nil
                
            }
        }
    }
    
    
    func configSortThreeView(btn: InstallBtn) {
        
        if btn.isSelected {
            guard let model = self.model else {
                GDAlertView.alert("数据源不能为空", image: nil, time: 1, complateBlock: nil)
                return
            }
            guard let advertID = self.globalParamete["advert_id"] else {
                return
            }
            guard let time = self.globalParamete["advert_time"] else {
                return
            }
            guard let rate = self.globalParamete["rate"] else {
                return
            }
            self.sortThree = SortThreeView.init(frame: CGRect.init(x: 0, y: -500, width: SCREENWIDTH, height: SCREENHEIGHT - self.sortBtn.max_Y), model: model, rate: rate, advertID: advertID, time: time)
            self.sortThree?.paramete = self.globalParamete
            self.view.addSubview(self.sortThree!)
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.sortThree?.frame = CGRect.init(x: 0, y: self.sortBtn.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.sortBtn.max_Y)
            }, completion: { (finished) in
                mylog("结束")
            })
            self.sortThree?.finished = { [weak self](paramete) in
                if (self?.globalParamete)! != paramete {
                    self?.haveSelectArr.removeAll()
                    self?.haveSelectedBtn.subTitle = ""
                    self?.calanderControl.subTitle = ""
                    self?.page = 1
                    self?.globalParamete["page"] = "1"
                    self?.globalParamete["advert_id"] = paramete["advert_id"] ?? ""
                    self?.globalParamete["advert_time"] = paramete["advert_time"] ?? ""
                    self?.globalParamete["time"] = paramete["advert_time"] ?? ""
                    self?.globalParamete["rate"] = paramete["rate"] ?? ""
                    self?.requestData(paramete: (self?.globalParamete)!, success: {
                        
                    })
                }else{
                    self?.sortThree?.removeFromSuperview()
                    self?.sortThree = nil
                    self?.screenBtn.isSelected = false
                    
                    self?.requestData(paramete: (self?.globalParamete)!, success: {
                        
                    })
                    return
                }
                
                self?.sortThree?.removeFromSuperview()
                self?.sortThree = nil
                self?.screenBtn.isSelected = false
                self?.searchBtn.resignFirstResponder()
            }

        }else {
            if self.sortThree != nil {
                self.sortThree?.removeFromSuperview()
                self.sortThree = nil
                self.searchBtn.resignFirstResponder()
            }
        }
    }
    
    
    
    func sortView(btn: InstallBtn) {
        if btn.isSelected {
            self.sortView = SortView.init(frame: CGRect.init(x: 0, y: self.sortBtn.max_Y, width: SCREENWIDTH, height: 70))
            self.view.addSubview(self.sortView!)
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.sortView?.frame = CGRect.init(x: 0, y: self.sortBtn.max_Y, width: SCREENWIDTH, height: 70)
            }, completion: { (finished) in
                mylog("结束")
            })
            self.sortView?.finished = { [weak self](type) in
                self?.sort = type.rawValue
                self?.globalParamete["sort"] = type.rawValue
                self?.page = 1
                self?.globalParamete["page"] = "1"
                self?.requestData(paramete: (self?.globalParamete)!, success: { [weak self] in
//                    self?.haveSelectArr.forEach({ (model) in
//                        self?.dataArr.forEach({ (subModel) in
//                            if model.area_id == subModel.area_id {
//                                subModel.isEnable = false
//                            }
//                        })
//                    })
                
                    
                })
                self?.searchBtn.resignFirstResponder()
                self?.sortView?.removeFromSuperview()
                self?.sortView = nil
                if type == SortType.asec {
                    self?.sortBtn.setTitle("屏幕升序", for: .normal)
                }else {
                    self?.sortBtn.setTitle("屏幕降序", for: .normal)
                }
                self?.sortBtn.isSelected = false
            }
        }else {
            if self.sortView != nil {
                self.searchBtn.resignFirstResponder()
                self.sortView?.removeFromSuperview()
                self.sortView = nil
            }
        }
    }
    
    
}
extension ChaXunResultVC {
    //MARK:导航栏中的按钮的点击方法
    @objc func navigationBtnAction(sender: CustomControl) {
        switch sender {
        case self.areaBtn:
            self.searchBtn.resignFirstResponder()
            self.configArea()
        case self.calanderBtn:
            self.searchBtn.resignFirstResponder()
            configCalander()
            configWithHaveArr()
        
        case self.haveSelectedBtn:
            if self.haveSelectArr.count <= 0 {
                GDAlertView.alert("请先选择投放地区", image: nil, time: 1, complateBlock: nil)
                return
            }
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                self.confighaveView()
            }else {
                if self.haveView != nil {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self.haveView?.frame = CGRect(x: 0 , y: SCREENHEIGHT, width: self.view.bounds.width, height: 200)
                    }, completion: { (bool ) in
                        self.haveView?.removeFromSuperview()
                        self.haveView = nil
                        
                    })
                }
            }
            
            
        case self.calanderControl:
            if self.haveSelectArr.count == 0 {
                GDAlertView.alert("请先选择地区", image: nil, time: 1, complateBlock: nil)
                return
            }
            var orderParamete: [String: String] = [String: String]()
            if let model = self.haveSelectArr.first, let time = model.advert_time {
                orderParamete["time"] = time
            }
            if let id = self.globalParamete["advert_id"] {
                orderParamete["advert_id"] = id
            }
            if let rate = self.globalParamete["rate"] {
                orderParamete["rate"] = rate
            }
            if let start = self.globalParamete["start_at"] {
                orderParamete["start_at"] = start
            }
            if let end = self.globalParamete["end_at"] {
                orderParamete["end_at"] = end
            }
            if let totalDay = self.globalParamete["total_day"] {
                orderParamete["total_day"] = totalDay
            }
            if let token = DDAccount.share.token {
                orderParamete["token"] = token
            }
            orderParamete["screenNumber"] = self.selectScreenNumber
            
            
            let web = ClaanderWebVC()
            web.paramete = orderParamete
            web.userInfo = DomainType.wap.rawValue + "order"
            
            let advert_id = self.globalParamete["advert_id"]!
            let advert_time = self.globalParamete["advert_time"]!
            let rate = self.globalParamete["rate"]!
            let start_at = self.globalParamete["start_at"]!
            let end_at = self.globalParamete["end_at"]!
            let member_id = DDAccount.share.id ?? ""
            web.subUserInfo = "&area_id=\(self.selectShopAreaId)&advert_id=\(advert_id)&advert_time=\(advert_time)&rate=\(rate)&start_at=\(start_at)&end_at=\(end_at)&member_id=\(member_id)&request_types=query"
            self.navigationController?.pushViewController(web, animated: true)
            
        default:
            break
        }
    }
    //MARK:弹出已选择页面
    func confighaveView() {
        let totalDay = self.globalParamete["total_day"] ?? "0"
        let totalDayInt = Int(totalDay)
        let pickerContailerH: CGFloat = 400
        self.haveView = HaveSelectView.init(frame: CGRect.init(x: 0, y: -SCREENHEIGHT, width: SCREENWIDTH, height: pickerContailerH), dataArr: self.haveSelectArr, totalDay: totalDayInt ?? 0)
        self.view.addSubview(self.haveView!)
        self.haveView?.dataArr = self.haveSelectArr
        if let race = self.globalParamete["rate"] {
            self.haveView?.raceTitle.text = "该\(race)频次预计观看人数"
        }
        
        self.haveView?.finished = { [weak self](model) in
            self?.configWithModel(model: model)
            
        }
        self.haveView?.clean = {[weak self](dataArr) in
            self?.haveSelectArr = dataArr
            self?.clean()
            self?.haveView?.removeFromSuperview()
            self?.haveView = nil
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.haveView?.frame = CGRect(x: 0 , y: self.haveSelectedBtn.y - pickerContailerH, width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
            
        })
        
    }
    func configWithModel(model: ChaxunResultModel) {
        var index: Int = 0
        for (i, subModel) in self.haveSelectArr.enumerated() {
            if subModel.area_id == model.area_id {
                index = i
            }
        }
        self.haveSelectArr.remove(at: index)
        if self.haveSelectArr.count == 0 {
            self.haveSelectedBtn.subTitle = ""
            self.calanderControl.subTitle = ""
            self.haveView?.removeFromSuperview()
            self.haveView = nil
        }else {
            self.haveSelectedBtn.subTitle = String(self.haveSelectArr.count)
            self.calanderControl.subTitle = String(self.haveSelectArr.count)
        }
        
        
        
        
        for (_, subModel) in self.dataArr.enumerated() {
            if subModel.area_id == model.area_id {
                subModel.isSelected = false
            }
        }
        self.tableV.reloadData()
        self.allSelected.isSelected = false
        
    }
    func clean() {
        self.dataArr.forEach { (model) in
            self.haveSelectArr.forEach({ (subModel) in
                if subModel.area_id == model.area_id {
                    model.isEnable = true
                    subModel.isEnable = true
                    model.isSelected = false
                    subModel.isSelected = false
                    
                }
            })
        }
        self.haveSelectArr.removeAll()
        self.tableV.reloadData()
        self.allSelected.isSelected = false
    }
    ///取消全选后的操作。清空操作
    func configWithHaveArr() {
        self.dataArr.forEach { (model) in
            self.haveSelectArr.forEach({ (subModel) in
                if subModel.area_id == model.area_id {
                    model.isEnable = true
                    subModel.isEnable = true
                    model.isSelected = false
                    subModel.isSelected = false
                    
                }
            })
        }
        self.haveSelectArr = self.haveSelectArr.filter({ (model) -> Bool in
            return model.isSelected
        })
        self.tableV.reloadData()
        self.allSelected.isSelected = false
        
    }
    
    

 
    
    func configArea() {
        if self.areaType == .city {
            let containerView = ToufangCity.init(superView: self.view)
            containerView.selectFinished = {[weak self](value) in
                self?.areaid = value.0
                self?.areaName = value.1
                self?.areaBtn.title = value.1
                self?.globalParamete["area_id"] = ""
                self?.page = 1
                self?.globalParamete["page"] = "1"
                self?.resign()
                self?.changeAredAfter()
                
                
            }
        }else {
            let vc = ToufangAreaVC.init(nibName: "ToufangAreaVC", bundle: Bundle.main)
            vc.type = self.areaType
            self.navigationController?.pushViewController(vc, animated: true)
            let _ = vc.selectArea.subscribe(onNext: { [weak self](dict) in
                self?.areaName = dict["areaName"] ?? ""
                self?.areaid = dict["area"] ?? ""
                self?.areaBtn.title = dict["areaName"]
                self?.globalParamete["area_id"] = ""
                self?.page = 1
                self?.globalParamete["page"] = "1"
                self?.resign()
                self?.changeAredAfter()
                
                }, onError: nil, onCompleted: nil, onDisposed: nil)
        }
        
        
        
    }
    //MARK:切换地区后重新请求数据
    func changeAredAfter() {
        self.requestData(paramete: self.globalParamete, success: {
//            var bo: Bool = false
//            self.dataArr.forEach({ (model) in
//                if model.isEnable {
//                    bo = true
//                }
//            })
//            self.allSelected.isSelected = !bo
//            self.haveSelectArr.forEach({ (model) in
//                self.dataArr.forEach({ (subModel) in
//                    if model.area_id == subModel.area_id {
//                        subModel.isEnable = false
//                    }
//                })
//            })
            
        })
    }
    
    
    //MARK:导航栏
    func configCalander() {
        let pickerContailerH: CGFloat = SCREENHEIGHT * 0.7
        
        let pickerContainer = SelectStartAndEndTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH), startModel: self.startDay, endModel: self.endDay)
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            
        }
        let _ = pickerContainer.finished.subscribe(onNext: { [weak self](result) in
            if let days = result as? [DayModel] {
                let firstModel = days.first!
                let lastModel = days.last!
                self?.startDay = firstModel
                self?.endDay = lastModel
                let start = String.init(format: "%ld-%02ld-%02ld", firstModel.year ?? 2018, firstModel.month ?? 4, firstModel.day ?? 21)
                self?.calanderBtn.title = String.init(format: "%ld-%ld", firstModel.month ?? 4, firstModel.day ?? 21)
                let end = String.init(format: "%ld-%02ld-%02ld", lastModel.year ?? 2018, lastModel.month ?? 4, lastModel.day ?? 3)
                self?.calanderBtn.subTitle = String.init(format: "%ld-%ld", lastModel.month ?? 4, lastModel.day ?? 3)
                let day = (self?.calander.getDifferenceByDate(oldTime: start, newTime: end))! + 1
                self?.globalParamete["start_at"] = start
                self?.page = 1
                self?.globalParamete["page"] = "1"
                self?.globalParamete["end_at"] = end
                self?.globalParamete["total_day"] = String(day)
                self?.requestData(paramete: (self?.globalParamete)!, success: {
                    self?.haveSelectArr.removeAll()
                    self?.haveSelectedBtn.subTitle = ""
                    self?.calanderControl.subTitle = ""
                })
                //MARK:设置大头针                
            }
            }, onError: nil, onCompleted: { [weak self] in
                self?.conerClick()
            }, onDisposed: nil)
        
        self.cover?.addSubview(pickerContainer)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContailerH - TabBarHeight, width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
            
        })
        
    }
    @objc func conerClick()  {
        self.cover?.remove()
        //        self.levelSelectButton.isSelected = false
//        if let corverView = self.cover{
//            for (_ ,view) in corverView.subviews.enumerated(){
//                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//                    view.frame = CGRect(x: 0 , y: self.view.bounds.height, width: self.view.bounds.width , height: 250)
//                    corverView.alpha = 0
//                }, completion: { (bool ) in
//                    corverView.remove()
//                    self.cover = nil
//                })
//            }
//        }
    }
    
}

extension ChaXunResultVC {
    
    
    
}
extension ChaXunResultVC {
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func configNavigation() {
        let titleView = NavTitleView.init(frame: CGRect.zero)
     
        titleView.insets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 50)
        self.naviBar.navTitleView = titleView
        self.naviBar.rightBarButtons = [self.changeMap]
        titleView.addSubview(self.areaBtn)
        titleView.addSubview(self.searchBtn)
        titleView.addSubview(self.calanderBtn)

        self.areaBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: self.naviBar.navTitleView.height)
        self.searchBtn.frame = CGRect.init(x: self.areaBtn.max_X, y: 0, width: self.naviBar.navTitleView.width - self.areaBtn.max_X - 60, height: self.naviBar.navTitleView.height)
        self.calanderBtn.frame = CGRect.init(x: self.searchBtn.max_X, y: 0, width: 60, height: self.naviBar.navTitleView.height)

        self.areaBtn.title = self.areaName
        
        
        
        self.view.addSubview(self.sortBtn)
        self.view.addSubview(self.areaB)
        self.view.addSubview(self.screenBtn)
        
        let width = SCREENWIDTH / 3.0
        let height: CGFloat = 30
        let y = DDNavigationBarHeight + 1
        self.sortBtn.frame = CGRect.init(x: 0, y: y, width: width + 15, height: height)
        self.areaB.frame = CGRect.init(x: self.sortBtn.max_X, y: y, width: width + 15, height: height)
        self.screenBtn.frame = CGRect.init(x: self.areaB.max_X, y: y, width: width -
            30, height: height)
        
        
        
        
        self.view.addSubview(self.haveSelectedBtn)
        self.view.addSubview(self.allSelected)
        self.view.addSubview(self.sureAreaBtn)
        self.haveSelectedBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-DDSliderHeight)
            make.width.equalTo(100 * SCALE)
            make.height.equalTo(40)
        }
        self.allSelected.snp.makeConstraints { (make) in
            make.left.equalTo(self.haveSelectedBtn.snp.right)
            make.width.equalTo(75 * SCALE)
            make.height.equalTo(40)
            make.centerY.equalTo(self.haveSelectedBtn)
        }
        self.sureAreaBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.allSelected.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.centerY.equalTo(self.haveSelectedBtn)
        }
        self.view.addSubview(self.tableV)
        self.tableV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.sortBtn.snp.bottom)
            make.bottom.equalTo(self.haveSelectedBtn.snp.top)
        }
        self.view.addSubview(self.calanderControl)
        self.calanderControl.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalTo(self.sureAreaBtn.snp.top).offset(-40)
            make.width.equalTo(34)
            make.height.equalTo(34)
            
        }
        
        
        
        
        
        
    }
   
    
    
    
    
}
extension ChaXunResultVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.resign()
        
    }
    
    func resign() {
        self.sortView?.removeFromSuperview()
        self.sortView = nil
        self.sortBtn.isSelected = false
        self.sortTwo?.removeFromSuperview()
        self.sortTwo = nil
        self.areaB.isSelected = false
        self.sortThree?.removeFromSuperview()
        self.sortThree = nil
        self.screenBtn.isSelected = false
        self.haveView?.removeFromSuperview()
        self.haveView = nil
        self.haveSelectedBtn.isSelected = false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            if let text = textField.text {
                self.globalParamete["keyword"] = text
                self.page = 1
                self.globalParamete["page"] = "1"
                self.requestData(paramete: self.globalParamete, success: {[weak self] in
//                    self?.haveSelectArr.forEach({ (model) in
//                        self?.dataArr.forEach({ (subModel) in
//                            if model.area_id == subModel.area_id {
//                                subModel.isEnable = false
//                            }
//                        })
//                    })
                    
                })
            }
            return false
        }else {
            return true
        }
    }
    //MARK:切换地图
    @objc func changeMapAction(sender: UIButton) {
        let vc = ChaXunMapVC()
        vc.areaName = self.areaName
        vc.globalParamete = self.globalParamete
        vc.selectShopAreaId = self.selectShopAreaId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
}
class MapModel: GDModel {
    var selectedShop: [MapSubModel]?
    var shop: [MapSubModel]?
}
class MapSubModel: GDModel {
    var latitude: String?
    var longitude: String?
}

enum CustomBtnStyle {
    ///常见的图片在右边，文字在左边
    case normal
    ///角标,使用titlelabel和subtitlelabel
    case CornerMarkTitleWithSubTitle
    ///角标使用imageview和subtitleLabel
    case CornerMarkImageWithSubtitle
    ///标题是两个的。
    case haveTwoTitle
}

class CustomControl: UIControl {
    let titleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    let subTitleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    let imageView = UIImageView.init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.sizeToFit()
    }
    var subTitle: String? {
        didSet{
            self.layoutSubviews()
        }
    }
    var image: UIImage? {
        didSet{
            self.layoutSubviews()
        }
    }
    var title: String? {
        didSet{
            self.layoutSubviews()
        }
    }
    var titleColor: UIColor? {
        didSet {
            self.titleLabel.textColor = titleColor
        }
    }
    var titleBackColor: UIColor? {
        didSet {
            self.titleLabel.backgroundColor = titleBackColor
        }
    }
    var subTitleColor: UIColor? {
        didSet{
            self.subTitleLabel.textColor = subTitleColor
        }
    }
    var subTitleBackColor: UIColor? {
        didSet{
            self.subTitleLabel.backgroundColor = subTitleBackColor
        }
    }
    var style: CustomBtnStyle = CustomBtnStyle.normal
    override func layoutSubviews() {
        super.layoutSubviews()
        switch self.style {
        case .normal:
            self.subTitleLabel.isHidden = true
            if let myImage = self.image {
                self.imageView.image = self.image
                self.imageView.snp.makeConstraints({ (make) in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(myImage.size.width)
                    make.height.equalTo(myImage.size.height)
                })
            }
            if let mytitle = self.title {
                self.titleLabel.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(2)
                    make.right.equalTo(self.imageView.snp.left).offset(-2)
                    make.centerY.equalToSuperview()
                })
                self.titleLabel.text = mytitle
            }
        case .CornerMarkTitleWithSubTitle:
            self.imageView.isHidden = true
            if let mytitle = self.title {
                let size = mytitle.sizeWith(font: self.titleLabel.font, maxSize: CGSize.init(width: 100, height: 30))
                self.titleLabel.snp.makeConstraints({ (make) in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(size.width + 10)
                    make.height.equalTo(size.height + 5)
                })
                self.titleLabel.text = mytitle
            }
            if let mytitle = self.subTitle {
                let size = mytitle.sizeWith(font: self.subTitleLabel.font, maxSize: CGSize.init(width: 100, height: 30))
                var width: CGFloat = 0
                if size.width <= size.height {
                    width = size.height
                }else {
                    width = size.width
                }
                self.subTitleLabel.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(self.titleLabel.snp.right)
                    make.centerY.equalTo(self.titleLabel.snp.top)
                    make.width.equalTo(width)
                    make.height.equalTo(width)
                })
                self.subTitleLabel.text = mytitle
                if mytitle == "" {
                    self.subTitleLabel.isHidden = true
                }else {
                    self.subTitleLabel.isHidden = false
                }
                self.subTitleLabel.layer.masksToBounds = true
                 self.subTitleLabel.textAlignment = NSTextAlignment.center
                self.subTitleLabel.layer.cornerRadius = CGFloat(width) / 2.0
            }
            
        case .CornerMarkImageWithSubtitle:
            self.titleLabel.isHidden = true
            if let image = self.image {
                
                self.imageView.snp.makeConstraints({ (make) in
                    make.centerY.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.width.equalTo(image.size.width)
                    make.height.equalTo(image.size.height)
                })
                self.imageView.image = image
            }
            if let mytitle = self.subTitle {
            
                let size = mytitle.sizeWith(font: self.subTitleLabel.font, maxSize: CGSize.init(width: 100, height: 30))
                var width: CGFloat = 0
                if size.width <= size.height {
                    width = size.height
                }else {
                    width = size.width
                }
                self.subTitleLabel.snp.makeConstraints({ (make) in
                    
                    make.centerX.equalTo(self.imageView.snp.right).offset(-10)
                    make.centerY.equalTo(self.imageView.snp.top).offset(10)
                    make.width.equalTo(width)
                    make.height.equalTo(width)
                    
                })
                self.subTitleLabel.text = mytitle
                if mytitle == "" {
                    self.subTitleLabel.isHidden = true
                }else {
                    self.subTitleLabel.isHidden = false
                }
                self.subTitleLabel.layer.masksToBounds = true
                self.subTitleLabel.layer.cornerRadius = CGFloat(width) / 2.0
                self.subTitleLabel.textAlignment = NSTextAlignment.center
            }
            
        case .haveTwoTitle:
            if let title = self.title {
                self.titleLabel.font = GDFont.systemFont(ofSize: 9)
                
//                let size = title.sizeWith(font: self.titleLabel.font, maxSize: CGSize.init(width: 100, height: 35)) ?? CGSize.init(width: 100, height: 35)
                self.titleLabel.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(2)
                    make.top.equalToSuperview().offset(5)
                    make.right.equalTo(self.imageView.snp.left).offset(-3)
                    
                })
                self.titleLabel.textAlignment = .center
                self.titleLabel.text = title
                
            }
            if let title = self.subTitle {
                self.subTitleLabel.font = GDFont.systemFont(ofSize: 9)
                
//                let size = title.sizeWith(font: self.subTitleLabel.font, maxSize: CGSize.init(width: 100, height: 35)) ?? CGSize.init(width: 100, height: 35)
                self.subTitleLabel.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(2)
                    make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
                    make.right.equalTo(self.imageView.snp.left).offset(-3)
                    make.bottom.equalToSuperview().offset(-5)
                    
                })
                self.subTitleLabel.textAlignment = .center
                self.subTitleLabel.text = title
                
            }
            if let image = self.image {
                
                self.imageView.snp.makeConstraints({ (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-2)
                    make.width.equalTo(image.size.width)
                    make.height.equalTo(image.size.height)
                })
                self.imageView.image = image
            }
            
       
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class ChaxunModel: GDModel {
    var advert_id: String = ""
    var advert_time: String = ""
    var rate: String = ""
    var start_at: String = ""
    var end_at: String = ""
    var area_id: String = ""
    var total_day: String = ""
    var time: String = ""
    
}



class ChaxunResultModel: GDModel {
    var image_url: String?
    var area_id: String?
    var area_name: String?
    var screen_number: String?
    var cant_buy_date: String?
    var advert_name: String?
    var advert_time: String?
    var price: String?
    var advert_key: String?
    var isEnable: Bool = true
    var buy_area_name: String?
    var buy_parent_area_name: String?
    var isSelected: Bool = false
    var shop_number: String?
    var watch_number: String?
    var covered_number: String?
    var mirror_number: String?
    ///地区总金额
    var total_price: String?
    ///12频次观看人数
    var max_covered_number: String?
    var total_screen_number: String?

    
}


