//
//  InstallHistoryVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/8.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class InstallHistoryVC: DDInternalVC, UITableViewDelegate, UITableViewDataSource {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.loadMore()
        

        // Do any additional setup after loading the view.
    }
    let table = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight), style: UITableView.Style.plain)
    let maskView = ShopMaskView.init(frame: CGRect.zero, title: "screenInstallNoNUll"|?|)
    
    func configUI() {
        self.naviBar.title = "installHistory"|?|
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        rightBtn.setImage(UIImage.init(named: "installBussiness_search_small"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction(btn:)), for: UIControl.Event.touchUpInside)
        self.naviBar.rightBarButtons = [rightBtn]
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.view.addSubview(self.maskView)
        self.maskView.frame = CGRect.init(x: 0, y: (SCREENHEIGHT - 200) / 2.0, width: SCREENWIDTH, height: 200)
        self.maskView.isHidden = true
        
        
        
        
        
        self.view.addSubview(table)
        table.contentInset = UIEdgeInsets.init(top: 50, left: 0, bottom: 0, right: 0)
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
        self.view.addSubview(self.header)
        self.header.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 44)
        self.header.button.addTarget(self, action: #selector(calanderTimeAction(btn:)), for: UIControl.Event.touchUpInside)
        
        
    }
    
    
    @objc func rightBtnAction(btn: UIButton) {
        self.pushVC(vcIdentifier: "ScreenInstallHistorySearchVC", userInfo: nil)
    }
    var date: String = "" {
        didSet{
            if date == "" {
                self.refreshBtn.isHidden = true
            }else {
                self.refreshBtn.isHidden = false
                self.header.myTitle.text = date
            }
        }
    }
    @objc func loadMore() {
        let parameter: [String: AnyObject] = ["date": self.date as AnyObject, "page": self.page as AnyObject, "token": (DDAccount.share.token ?? "") as AnyObject, "data_type": "1" as AnyObject]
        if self.page == 1 {
            self.table.gdLoadControl?.loadStatus = .idle
        }
        self.page += 1
        let router = Router.get("install-history/install", DomainType.api, parameter)
        
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<[InstallHistoryModel]>.self, from: response)
            
            if let data = model?.data, model?.status == 200 {
                
                self.table.gdLoadControl?.endLoad(result: GDLoadResult.success)
                self.analyDate(date: data)
                if self.page == 2 {
                    //第一次加载第一页的数据的时候
                    self.header.isHidden = false
                    self.header.myTitle.text = data.first?.month
                }
                
            }else {
                if self.page == 2 {
                    self.header.isHidden = true
                }
                self.table.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                self.table.reloadData()
            }
            
            if self.dataArr.count == 0 {
                self.table.isHidden = true
                self.maskView.isHidden = false
            }else {
                self.table.isHidden = false
                self.maskView.isHidden = true
            }
            
        }) {
            if self.page == 2 {
                self.header.isHidden = true
            }
        }
        
        
        
    }
    func analyDate(date: [InstallHistoryModel]) {
//        var key: String = ""
//        var count: Int = 0
//        var fatherArr: [InstallHistoryModel] = [InstallHistoryModel]()
//        var originArr: [InstallHistoryModel] = [InstallHistoryModel]()
//        self.dataArr.forEach { (arr) in
//            arr.forEach({ (model) in
//                originArr.append(model)
//            })
//        }
//        originArr.append(contentsOf: date)
//        originArr.forEach { (model) in
//            if key != model.month {
//                key = model.month ?? ""
//                count += 1
//                fatherArr.append(model)
//
//            }
//        }
//        self.dataArr.removeAll()
//        fatherArr.forEach { (superModel) in
//            var arr = [InstallHistoryModel]()
//            originArr.forEach({ (model) in
//                if superModel.month == model.month {
//                    arr.append(model)
//                }
//            })
//            self.dataArr.append(arr)
//
//        }
        self.dataArr.append(contentsOf: date)
        
        self.table.reloadData()
        
        
    }
    
    //    func analyDate(date: [InstallHistoryModel]) {
    //        var fatherArr: [[InstallHistoryModel]] = [[InstallHistoryModel]]()
    //        var currentIndex  = 0
    //        var currentMonth = ""
    //        for ( index , model)  in date.enumerated() {
    //            if model.month != currentMonth {
    //                currentMonth = model.month ?? ""
    //                currentIndex = index
    //                fatherArr.append([InstallHistoryModel]())
    //            }
    //            fatherArr[currentIndex].append(model)
    //        }
    //        self.dataArr.append(fatherArr)
    //        self.table.reloadData()
    //    }
    
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
    
    let header: InstallHistoryHeader = InstallHistoryHeader.init(reuseIdentifier: "InstallHistoryHeader")
    
    var page: Int = 1
    var keyword: String = ""
    
    var dataArr: [InstallHistoryModel] = [InstallHistoryModel]()
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstallHistoryCell", for: indexPath) as! InstallHistoryCell
//        if indexPath.section < (self.dataArr.count) {
//            let arr = self.dataArr[indexPath.section]
//            if indexPath.row < arr.count {
//                cell.model = arr[indexPath.row]
//            }
//
//        }
        cell.bussinessHistoryModel = self.dataArr[indexPath.row]

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let arr = self.dataArr[indexPath.section]
        let model = self.dataArr[indexPath.row]
        let vc = ShopInfoVC()
        vc.vcType = .installHistory
        vc.userInfo = ["id": model.id, "type": model.type, "shop_type": model.shop_type ?? "1"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section >= self.dataArr.count {
//            return nil
//        }
//        let arr = self.dataArr[section]
//        let model = arr.first
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InstallHistoryHeader") as! InstallHistoryHeader
//        header.myTitle.text = model?.month ?? ""
//        let cellArr = tableView.visibleCells
//        if let cell = cellArr.first, let index = tableView.indexPath(for: cell) {
//
//        }
//        let index = tableView.indexPath(for: cell!) ?? IndexPath.init(row: 0, section: 0)
//        header.button.isHidden = (section == index.section) ? false : true
//        header.button.addTarget(self, action: #selector(calanderTimeAction(btn:)), for: UIControl.Event.touchUpInside)
//        header.button.isHidden = true
//        self.header.myTitle.text = model?.month ?? ""
        
//        self.header.button.addTarget(self, action: #selector(calanderTimeAction(btn:)), for: UIControl.Event.touchUpInside)
//        header.myTitle.text = model?.month
//        return header
//
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = self.table.visibleCells.first, let index = self.table.indexPath(for: cell) {
            let model = self.dataArr[index.row]
            self.header.myTitle.text = model.month
        }
    }

    
    

    
    
    
    @objc func calanderTimeAction(btn: UIButton) {
        let subView = DDCoverView.init(superView: self.view)
        self.cover = subView
        let selectTime = ScreenHistorySelectTime.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 300 - DDSliderHeight, width: SCREENWIDTH, height: 300 + DDSliderHeight))
        self.cover?.addSubview(selectTime)
        self.cover?.deinitHandle = {
            self.cover?.removeFromSuperview()
            self.cover = nil
        }
        let _ = selectTime.sender.subscribe(onNext: { [weak self](title) in
            self?.date = title
            self?.page = 1
            self?.dataArr.removeAll()
            self?.loadMore()
        }, onError: { (error) in
            
        }, onCompleted: {
            self.cover?.removeFromSuperview()
            self.cover = nil
        }) {
            mylog("回收")
        }
        
        
        
    }
    weak var cover: DDCoverView?
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}



//
class ScreenInstallHistoryModel: GDModel {
    var address: String?
    var area_name: String?
    var create_at: String?
    var id: String?
    var member_id: String?
    var month: String?
    var replace_id: String?
    var screen_number: String?
    var shop_id: String?
    var shop_image: String?
    var shop_name: String?
    
    var name: String?
    var status: String?
    
    
    
    
    
}

