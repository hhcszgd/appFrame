//
//  MingXiVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/24.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class MingXiVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource {

    var withDrawView: WithDrawalView?
    var selectTimeView: SelectTime?


    var tableView: UITableView!
    func configTabel() {
        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)

        self.tableView.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.gdRefreshControl = GDRefreshControl.init(target: self, selector: #selector(refresh))
        self.tableView.gdRefreshControl?.refreshHeight = 40
        self.tableView.gdLoadControl = GDLoadControl.init(target: self, selector: #selector(loadMore))
        self.tableView.gdLoadControl?.loadHeight = 40
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MingXiVCTitle"|?|
        self.configTabel()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "MingXiVCScreening"|?|, style: UIBarButtonItem.Style.plain, target: self, action: #selector(screenAction(sender:)))
        self.tableView.register(UINib.init(nibName: "MingXiCell", bundle: Bundle.main), forCellReuseIdentifier: "MingXiCell")
        self.tableView.register(MingXiHeader.self, forHeaderFooterViewReuseIdentifier: "MingXiHeader")
        self.refresh()
        self.allBtn.isHidden = true
        
        self.zkqMaskView.title = "noMingxiData"|?|
        self.zkqMaskView.image = "noinformation"
        self.zkqMaskView.frame = CGRect.init(x: 20, y: (tableView.height - 200) / 2.0, width: tableView.width - 40, height: 200)
        self.zkqMaskView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    var cover: DDCoverView?
    ///筛选
    @objc func screenAction(sender: UIBarButtonItem) {
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
                self?.time = title ?? ""
                self?.refresh()
                self?.cover?.removeFromSuperview()
                self?.cover = nil
            }
            
        }
        
    }
    lazy var allBtn : UIButton = {
        let btn = UIButton.init()
         btn.setBackgroundImage(UIImage.init(named: "money_all"), for: UIControl.State.normal)
        btn.frame = CGRect.init(x: SCREENWIDTH - 52 - 15, y: SCREENHEIGHT - 52 - DDSliderHeight, width: 52, height: 52)
        btn.addTarget(self, action: #selector(allAction(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    @objc func allAction(sender: UIButton) {
        self.time = nil
        self.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    var page: Int = 1
    ///年月日
    var time: String? {
        didSet {
            if (time == nil) || (time?.count == 0) {
                self.allBtn.isHidden = true
            }else {
                self.allBtn.isHidden = false
            }
        }
    }
    @objc func refresh() {
        self.page = 1
        self.request(time: time) { [weak self](data) in
            self?.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            self?.tableView.reloadData()
            self?.tableView.gdLoadControl?.loadStatus = .idle
            self?.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)

            
        }
        
    }
    @objc func loadMore() {
        self.page += 1
        self.request(time: time) { (data) in
            self.tableView.reloadData()
            if data.count > 0 {
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
            }else {
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
            }
            
            
        }
    }
    
    lazy var zkqMaskView: ZkqMaskView = {
        let cover = ZkqMaskView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight), title: "", image: "nonetwork")
        cover.backgroundColor = UIColor.white
        self.view.addSubview(cover)
        return cover
    }()
    
    

    func request(time: String?, finished: (([MingXiItem]) -> ())? = nil) {
        let token = DDAccount.share.token ?? ""
        var paramete = ["token": token] as [String: Any]
        if let time = time, time.count > 0 {
            paramete["create_at"] = time
        }
        paramete["page"] = String.init(format: "%d", self.page)
        let memberid = DDAccount.share.id ?? ""
        let _ = NetWork.manager.requestData(router: Router.get("member/\(memberid)/account/list", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<MingXiItem>.deserialize(from: dict)
            if let data = model?.data, model?.status == 200 {
                
                if self.page == 1{
                    mylog("0")
                    self.baseData.removeAll()
                    mylog("1")
                    self.configDataArr(item: data)
                    mylog("2")
                    mylog("3")
                    finished?([])
                    mylog("4")
                }else {
                    self.configDataArr(item: data)
                    finished?(data)
                }
                
                
            }else {
                if self.page == 1 {
                    self.baseData.removeAll()
                    self.configDataArr(item: [])
                    finished?([])
                }else {
                    self.configDataArr(item: [])
                    finished?([])
                }
                
                
            }
        }, onError: { (error) in
            if self.page == 1 {
                self.baseData.removeAll()
                self.configDataArr(item: [])
                finished?([])
            }else {
                finished?([])
            }
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    
    
    
    func configDataArr(item: [MingXiItem]) {
        self.baseData.append(contentsOf: item)
        self.dataArr.removeAll()
        var rq: String?
        var linshiItem: [MingXiItem] = [MingXiItem]()
        self.baseData.forEach { (model) in
            if model.rq != rq {
                linshiItem.append(model)
                rq = model.rq
            }
        }
        linshiItem.forEach { (model) in
            var arr: [MingXiItem] = [MingXiItem]()
            self.baseData.forEach({ (subModel) in
                if model.rq == subModel.rq {
                    arr.append(subModel)
                }
            })
            self.dataArr.append(arr)
        }
        

    }
    var baseData: [MingXiItem] = [MingXiItem]()
    var dataArr: [[MingXiItem]] = [[MingXiItem]]() {
        didSet {
            if dataArr.count == 0 {
                self.zkqMaskView.isHidden = false
            }else {
                self.zkqMaskView.isHidden = true
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = self.dataArr[section]
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MingXiCell = tableView.dequeueReusableCell(withIdentifier: "MingXiCell", for: indexPath) as! MingXiCell
        let arr = self.dataArr[indexPath.section]
        if indexPath.row == (arr.count - 1) {
            cell.lineView.isHidden = true
        }else {
            cell.lineView.isHidden = false
        }
        cell.model = arr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MingXiHeader") as! MingXiHeader
        let arr = self.dataArr[section]
        let model = arr.first
        header.model = model
        return header
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BillDetailVC()
        let arr = self.dataArr[indexPath.section]
        let model = arr[indexPath.row]
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class DataListModel: GDModel {
    
    var years: String?
    var month: [String]?
}
class MingXiBtn: UIButton {
    
//    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
//
//        let titleWidth = self.currentTitle?.sizeWith(font: GDFont.systemFont(ofSize: 15), maxSize: CGSize.init(width: 80, height: 20)) ?? CGSize.init(width: 80, height: 20)
//        let x: CGFloat = 10
//        mylog("-------------------------------------------------------------")
//        mylog(CGRect.init(x: x, y: CGFloat(0), width: titleWidth.width + 10, height: contentRect.height))
//        mylog(self.currentTitle)
//
//        mylog("-------------------------------------------------------------")
//        return CGRect.init(x: x, y: CGFloat(0), width: titleWidth.width + 10, height: contentRect.height)
//
//    }
//    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
//        let titleWidth =  self.currentTitle?.sizeWith(font: GDFont.systemFont(ofSize: 15), maxSize: CGSize.init(width: 80, height: 20)) ?? CGSize.zero
//        let image = self.currentImage
//        let y = (contentRect.size.height - (image?.size.height)!) / 2.0
//        let x = titleWidth.width + 30
//        let width = image?.size.width
//        let height = image?.size.height
//        mylog("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
//        mylog(CGRect.init(x: x, y: y, width: width!, height: height!))
//        mylog(self.currentTitle)
//         mylog("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
//        return CGRect.init(x: x, y: y, width: width!, height: height!)
//
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleWidth = self.currentTitle?.sizeWith(font: GDFont.systemFont(ofSize: 15), maxSize: CGSize.init(width: 80, height: 20)) ?? CGSize.init(width: 80, height: 20)
        let x: CGFloat = 10
        self.titleLabel?.frame = CGRect.init(x: x, y: 0, width: titleWidth.width + 20, height: self.bounds.height)
        
        let imageSize = self.currentImage?.size ?? CGSize.init(width: 9, height: 9)
        
        let imageX: CGFloat = self.titleLabel?.max_X ?? 100
        
        let imageY: CGFloat = (self.bounds.height - imageSize.height) / 2.0
        
        self.imageView?.frame = CGRect.init(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
        
        
        
        
    }
    
    
    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
}






