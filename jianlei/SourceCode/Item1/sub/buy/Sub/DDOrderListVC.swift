//
//  DDOrderListVC.swift
//  Project
//
//  Created by WY on 2018/3/6.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDOrderListVC: DDNormalVC  {
    enum DDOrderType : Int {  
        case total = 0
        case paddingPayTotal = 1
        case paddingPayPart = 2
        case done = 3
    }
    var selectedOrderType  = DDOrderType.done
    let bar = DDNavigationItemBar.init(CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: 34), DDOrderListNavibarItem.self)
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    let arr = ["全部订单" , "待支付" , "待补交" , "已完成" ]
    var pageNum : Int  = 1
    var apiModel = ApiModel<DDOrderListApiData>()
//    let tipsLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 64))
    let noMsgNoticeLabel = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        configBar()
        configTableView()
        configTipsLbel()
        
        self.title = "我的订单"
        self.view.backgroundColor = UIColor.white
        requestApi(requestType: .initialize)
        // Do any additional setup after loading the view.
    }
    func configTipsLbel(){
        
        self.view.addSubview(noMsgNoticeLabel)
        noMsgNoticeLabel.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width/3, height: self.view.bounds.width/3)
        noMsgNoticeLabel.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        noMsgNoticeLabel.image = UIImage(named: "order_blank")
        noMsgNoticeLabel.contentMode = .scaleAspectFit
        
        //        self.view.addSubview(tipsLabel)
        //        tipsLabel.textAlignment = .center
        //        tipsLabel.text = "暂无订单"
        //        tipsLabel.textColor = .lightGray
        //        tipsLabel.isHidden = true
        //        tipsLabel.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
    }
    func requestApi(requestType:DDLoadType )  {
        if requestType == .loadMore {
            pageNum += 1
        }else if requestType == .initialize {
            pageNum = 1
        }else if requestType == .refresh{
            pageNum = 1
        }
        
        var type : String?
        switch bar.selectedIndexPath.item {
        case 0:
            type = nil
        case 1:
            type = "0"
        case 2:
            type = "1"
        case 3:
            type = "3"
        default:
            type = nil
        }
        
        DDRequestManager.share.getOrderList(type: type , page: pageNum , true)?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<DDOrderListApiData>.self , from: response ){
                    mylog(apiModel.data)
                if requestType == .loadMore {
                    if (apiModel.data?.order_list?.count ?? 0) > 0{
                        self.apiModel.data?.order_list?.append(contentsOf: (apiModel.data?.order_list)!)
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                        self.tableView.reloadData()
                    }else{//没有更多数据
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                    }
                }else if requestType == .initialize {
                    self.apiModel = apiModel
//                    self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                    self.tableView.gdLoadControl?.loadStatus = .idle
                    self.tableView.reloadData()
                    if self.apiModel.data?.order_list?.count ?? 0 > 0 {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false )
                        self.noMsgNoticeLabel.isHidden = true
                    }else{
                        self.noMsgNoticeLabel.isHidden = false
                    }
                    
                }
                    
                else if requestType == .refresh{
                    self.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
                    self.apiModel = apiModel
                    //                    self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                    self.tableView.gdLoadControl?.loadStatus = .idle
                    self.tableView.reloadData()
                    if self.apiModel.data?.order_list?.count ?? 0 > 0 {
                        self.noMsgNoticeLabel.isHidden = true
                    }else{
                        self.noMsgNoticeLabel.isHidden = false
                    }
                    
                }
            }else{
                if requestType == .loadMore {
                    self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                }
                else if requestType == .refresh{
                    self.tableView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
                }
            }
        })
        
    }
}


extension DDOrderListVC :  UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog(indexPath)
        if let cell = tableView.cellForRow(at: indexPath) as? DDOrderCell{
            let orderCode = cell.model.id
            self.pushVC(vcIdentifier: "DDOrderDetailVC", userInfo: orderCode)
        }
        
    }
    func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: bar.frame.maxY, width: SCREENWIDTH, height: self.view.bounds.height - bar.frame.maxY - DDSliderHeight)
        let loadControl = GDLoadControl.init(target: self , selector: #selector(loadMoreData))
        loadControl.loadHeight = 40
        tableView.gdLoadControl = loadControl
        let refreshControl = GDRefreshControl.init(target: self , selector: #selector(refresh))
        tableView.gdRefreshControl = refreshControl
        refreshControl.refreshHeight = 40
    }
    @objc func refresh(){
        self.requestApi(requestType: DDLoadType.refresh)
    }
    @objc func loadMoreData(){
        self.requestApi(requestType: DDLoadType.loadMore)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.order_list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var targetCell : DDOrderCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDOrderCell") as? DDOrderCell{
            targetCell = cell
        }else{
            targetCell = DDOrderCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDOrderCell")
        }
        if let model  = self.apiModel.data?.order_list?[indexPath.row] {
            targetCell.model = model
        }
        
        return targetCell
    }
}

extension DDOrderListVC {
//    class DDOrderListApi: DDActionModel , Codable {
//        var message = ""
//        var status = -1
//        var data : DDOrderListApiData?
//    }
    class DDOrderListApiData: Codable {
        var order_list :  [DDOrderCellModel]?
    }
    class DDOrderCellModel: DDActionModel , Codable {
        var advert_name = "";
        var advert_time = "";
        var advert_id : String? = ""
        var advert_key : String? = ""
        var end_at : String?
        var examine_status : String = ""
        var id : String = ""
        var order_code = ""
        var order_price = ""
        var payment_status = ""
        var start_at : String?
        var unit_price = ""
    }
    class DDOrderCell: UITableViewCell {
        let timeRange = UILabel()
        let timeInterval = UILabel()
        let addArea = UILabel()
        let price = UILabel()
        let addStatus = UILabel()
        let payStatus = UILabel()
        let bottomLine = UIView()
        var model : DDOrderCellModel = DDOrderCellModel(){
            didSet{
                timeRange.text = (model.start_at ?? "") + "到" + (model.end_at ?? "")
                timeInterval.text = model.advert_time
                addArea.text =  model.advert_name
                var addStatusShowStr = model.examine_status
                let identify = model.advert_key ?? ""
                if identify.contains("A"){
                    self.addArea.backgroundColor = UIColor.colorWithHexStringSwift("ffb9a9")
                }else if identify.contains("C") || identify.contains("D"){
                    self.addArea.backgroundColor = UIColor.colorWithHexStringSwift("fee7b0")
                }else if identify.contains("B"){
                    self.addArea.backgroundColor = UIColor.colorWithHexStringSwift("b9eff6")
                }else{
                    self.addArea.backgroundColor = UIColor.orange
                }
                if model.payment_status == "-1"{
                    addStatusShowStr = "取消支付"
                }else{
                    switch model.examine_status {
                    case "0":
                        addStatusShowStr = "素材待提交"
                    case "1":
                        addStatusShowStr = "素材待审核"
                    case "2":
                        addStatusShowStr = "素材被驳回"
                    case "3":
                        addStatusShowStr = "广告待投放"
                    case "4":
                        addStatusShowStr = "广告已投放"
                    case "5":
                        addStatusShowStr = "广告投放完成"
                    default:
                        break
                    }
                }
                addStatus.text = addStatusShowStr
                
                
                
                var payStatusShowStr = model.payment_status
                switch model.payment_status {
                case "-1":
                    payStatusShowStr = "放弃支付"
                    payStatus.textColor = .lightGray
                case "0":
                    payStatusShowStr = "待支付"
                    payStatus.textColor = .orange
                case "1":
                    payStatusShowStr = "待补交"
                    payStatus.textColor = .orange
                case "2":
                    payStatusShowStr = "预付款已过期"
                case "3":
                    payStatusShowStr = "已完成"
                    payStatus.textColor = .green
                default:
                    break
                }
                payStatus.text = payStatusShowStr
                price.text = "¥" + model.order_price
                self.layoutIfNeeded()
            }
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style , reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(timeRange)
            self.contentView.addSubview(timeInterval)
            self.contentView.addSubview(addArea)
            self.contentView.addSubview(addStatus)
            self.contentView.addSubview(price)
            price.font = GDFont.boldSystemFont(ofSize: 15)
            timeRange.font = GDFont.boldSystemFont(ofSize: 15)
            timeInterval.font = GDFont.boldSystemFont(ofSize: 14)
            payStatus.font = GDFont.boldSystemFont(ofSize: 14)
            addStatus.font = GDFont.boldSystemFont(ofSize: 14)
            self.contentView.addSubview(payStatus)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = UIColor.DDLightGray
            price.textColor = .red
            addArea.textColor = UIColor.white
            addArea.textAlignment = .center
            self.selectionStyle = .none
            timeRange.textColor = .gray
            timeInterval.textColor = .lightGray
            addStatus.textColor = .lightGray
            payStatus.textColor = .lightGray
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let borderMargin : CGFloat = 10
            self.bottomLine.frame = CGRect(x: borderMargin, y: self.bounds.height - 2, width: self.bounds.width - borderMargin * 2, height: 2)
            self.price.sizeToFit()
            self.price.center = CGPoint(x: self.bounds.width - self.price.bounds.width / 2 - borderMargin, y: self.price.bounds.height / 2 + borderMargin)
            self.timeRange.sizeToFit()
            self.timeRange.center = CGPoint(x:borderMargin + self.timeRange.bounds.width/2, y: self.timeRange.bounds.height / 2 + borderMargin)
            self.addStatus.ddSizeToFit()
            self.addStatus.center = CGPoint(x: self.addStatus.bounds.width/2  + borderMargin, y: self.bounds.height - self.addStatus.bounds.height/2 - borderMargin)
            self.addArea.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            self.addArea.frame = CGRect(x: borderMargin, y: timeRange.frame.maxY + borderMargin/2, width: self.addArea.bounds.width , height: addStatus.frame.minY - timeRange.frame.maxY - borderMargin)
            self.timeInterval.sizeToFit()
            self.timeInterval.center = CGPoint(x: addArea.frame.maxX + self.timeInterval.bounds.width/2 + borderMargin  , y: addArea.frame.midY)
            
            self.payStatus.sizeToFit()
            self.payStatus.center = CGPoint(x : self.bounds.width - self.payStatus.bounds.width/2 - borderMargin , y: timeInterval.frame.midY)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
extension DDOrderListVC :  DDNavigationItemBarDelegate {
    func configBar()  {
        self.view.addSubview(bar)
        bar.delegate = self
//        bar.selectedIndexPath = IndexPath(item: 0, section: 0)
        bar.selectedIndexPath = IndexPath(item:selectedOrderType.rawValue, section: 0)
        bar.scrollDirection = .horizontal
    }
    func itemSizeOfNavigationItemBar(bar : DDNavigationItemBar) -> CGSize{
        return CGSize(width: 44, height: 34)
    }
    func numbersOfNavigationItemBar(bar: DDNavigationItemBar) -> Int {
        return arr.count
    }
    
    func setParameteToItem(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
        
        if let itemInstens = item as? DDOrderListNavibarItem{
            itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
            
            
            itemInstens.hidLeftJiange = indexPath.item == 0 ? true : false
            itemInstens.hidRightJiange = indexPath.item == (self.arr.count - 1) ? true : false
            itemInstens.label.text = "\(arr[indexPath.item])"
        }
    }
    
    func didSelectedItemOfNavigationItemBar(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
        
        self.loadData()
        mylog(indexPath)
    }
    func loadData()  {
        self.requestApi(requestType: DDLoadType.initialize )
    }
}
class DDOrderListNavibarItem: DDNavigationItem {
    let leftJiange = UIView()
    let rightJiange = UIView()
    override var selectedStatus: Bool{
        didSet{
            self.label.textColor = selectedStatus ? .orange : .darkGray
        }
    }
    var hidLeftJiange  : Bool = false {
        didSet{
            leftJiange.isHidden = hidLeftJiange
            
        }
    }
    
    var hidRightJiange  : Bool = false {
        didSet{
            rightJiange.isHidden = hidRightJiange
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.selectedBackColor = .white
        self.contentView.addSubview(leftJiange)
        leftJiange.backgroundColor = UIColor.DDLightGray
        
        self.contentView.addSubview(rightJiange)
        rightJiange.backgroundColor = UIColor.DDLightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.leftJiange.frame = CGRect(x: 0, y: 5, width: 1, height: self.bounds.height - 5 * 2)
        self.rightJiange.frame = CGRect(x: self.bounds.width - 1, y: 5, width: 1, height: self.bounds.height - 5 * 2)
    }
}
