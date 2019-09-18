//
//  DDRewardDetailVC.swift
//  Project
//
//  Created by WY on 2019/8/20.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDRewardDetailVC: DDInternalVC {
    let headerBackView = UIView()
    let rewardMoneyCountValue = UILabel()
    let rewardMoneyCountTitle = UILabel()
    /// type : 1:累计收益 , 2:订单信息
    var type = 1
    ///type 为2时,需要这个字段
    var id = ""
    ///type 为1时,需要这两个字段的其一
    var shop_id : String?//分店id
    var head_id : String?//总店id
    let orderTotalMoney = UILabel()
    let shadowView = UIView()
    var apiModel = ApiModel<DDRewardDetailData>()
    var page = 1
    var blankView : DDBlankView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.configSubviews()
        // Do any additional setup after loading the view.
        self.getData(loadType:LoadDataType.initialize)
    }
    func getData(loadType:LoadDataType)  {
        

        if loadType == LoadDataType.loadMore{
            page += 1
        }else{
            page = 1
        }
        DDRequestManager.share.getRewardDetail(type: ApiModel<DDRewardDetailData>.self, requestType: self.type, page: page, id: id,shop_id: self.shop_id,head_id: self.head_id ,success: { (model ) in
            if loadType == LoadDataType.loadMore{
                if let items = model.data?.items , items.count > 0 {
                    self.apiModel.data?.items?.append(contentsOf: items)
                    self.setValueToUI()
                    self.tableView?.reloadData()
                }else{
                    GDAlertView.alert("没有更多数据", image: nil, time: 2, complateBlock: nil)
                }
            }else{
                self.apiModel = model
                self.setValueToUI()
                self.tableView?.reloadData()
            }
        }) {
            self.tableView?.gdLoadControl?.endLoad()
        }
    }
}

// MARK: requestData
extension DDRewardDetailVC{
    struct DDRewardDetailData: Codable {
        var order_total : String?
        var reward_total : String?
        var items : [DDRewardDetailRowData]?
    }
    struct DDRewardDetailRowData: Codable {
//        var reward_price : String?
//        var order_id : String?
//        var order_price : String?
//        var create_at : String?
        
        var id : String?
        var reward_member_id : String?
        var member_id : String?
        var reward_price : String?
        var order_id : String?
        var order_price : String?
        var finish_at : String?
        
    }
    /*
     reward_price奖励金 order_id 订单号 order_price订单额 create_at时间
     
     
     
     
     "id\":\"12\",\"reward_member_id\":\"11\",\"member_id\":\"205\",\"reward_price\":0.1,\"order_id\":\"A10465465456\",\"order_price\":10,\"create_at\":\"2018-11-20\
     */
}
// MARK: UI
extension DDRewardDetailVC{
    func configNavigationBar() {
        self.naviBar.backBtn.setImage(UIImage(named:"back_icon"), for: UIControl.State.normal)
        var titleStr = ""
        if type == 2 {
            titleStr = "订单信息"
        }else{
            titleStr = "奖励金明细"
        }
        let attributeTitle : NSMutableAttributedString = NSMutableAttributedString(string: titleStr)
        attributeTitle.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(0, attributeTitle.string.count))
        self.naviBar.attributeTitle = attributeTitle
        self.naviBar.backgroundColor = .clear
//        self.view.backgroundColor = .red
    }
    func configSubviews() {
        self.view.addSubview(shadowView)
        shadowView.backgroundColor = UIColor.white
        self.view.addSubview(headerBackView)
        self.view.addSubview(rewardMoneyCountValue)
        self.view.addSubview(rewardMoneyCountTitle)
        self.view.addSubview(orderTotalMoney)
        let table = UITableView(frame: CGRect.zero)
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
        self.tableView = table
        table.separatorStyle = .none
        rewardMoneyCountValue.font = GDFont.boldSystemFont(ofSize: 38)
        orderTotalMoney.font = GDFont.boldSystemFont(ofSize: 20)
        rewardMoneyCountValue.textColor = .white
        rewardMoneyCountTitle.textColor = .white
        rewardMoneyCountValue.textAlignment = .center
        rewardMoneyCountTitle.textAlignment = .center
        orderTotalMoney.textColor = .white
        let headerBackViewH = self.view.bounds.width * 0.6 + DDNavigationBarHeight
        headerBackView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: headerBackViewH)
        let rewardMoneyCountValueH : CGFloat = 64
        rewardMoneyCountValue.frame = CGRect(x: 0, y: headerBackViewH/2 - rewardMoneyCountValueH, width: self.view.bounds.width, height: rewardMoneyCountValueH)
        rewardMoneyCountTitle.frame = CGRect(x: 0, y: headerBackViewH/2 , width: self.view.bounds.width, height: 20)
//        self.view.addSubview(<#T##view: UIView##UIView#>)
        let tableViewX : CGFloat = 18
        let tableViewY : CGFloat = headerBackViewH - 40
        let tableToBottom : CGFloat = 20
        tableView?.frame = CGRect(x: tableViewX, y:tableViewY , width: self.view.bounds.width - tableViewX * 2, height: self.view.bounds.height - DDSliderHeight -  tableViewY - tableToBottom)
        orderTotalMoney.frame = CGRect(x: table.frame.minX, y: table.frame.minY - 58, width: table.bounds.width, height:58 )
        orderTotalMoney.backgroundColor = .black
        
        jianbian(view: headerBackView)
//        dddd(v: table)
        orderTotalMoney.setSpecifyCornerRound(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadius: 10)
//        setValueToUI()
        shadowView.frame = CGRect(x: table.frame.minX, y: headerBackViewH, width: table.frame.width, height: table.frame.maxY - headerBackViewH + 10)
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.cornerRadius = 5
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
        
        let loadControl = GDLoadControl.init(target: self , selector: #selector(loadMoreData))
        tableView?.gdLoadControl = loadControl
        tableView?.gdLoadControl?.loadHeight = 40
    }
    @objc func loadMoreData() {
        self.getData(loadType: LoadDataType.loadMore)
    }
    func setValueToUI() {
        self.rewardMoneyCountValue.text = self.apiModel.data?.reward_total ?? "0"
        self.rewardMoneyCountTitle.text = "奖励金总金额 (元)"
        let img = UIImage.ImageWithColor(color: UIColor.orange, frame: CGRect(x: 0, y: 0, width: 5, height: 25))
        let manAttchment  = img?.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -3, width: 5, height: 25)) ?? NSAttributedString()
        let manAttribute = NSMutableAttributedString(string: "  ")
        manAttribute.append(manAttchment)
        manAttribute.append(NSAttributedString(string: "  订单总金额: ¥\(self.apiModel.data?.order_total ?? "0")"))
        orderTotalMoney.attributedText = manAttribute
    }
    
    func jianbian(view:UIView?)  {
        let colorlayer: CAGradientLayer = CAGradientLayer()
        colorlayer.startPoint = CGPoint(x: 0, y: 0.5)
        colorlayer.endPoint = CGPoint(x: 1, y: 0.5)
        let startColor = UIColor.colorWithHexStringSwift("#f77c0a").cgColor //UIColor.red.cgColor
        //        let midColor  = UIColor.green.cgColor
        let endColor =  UIColor.colorWithHexStringSwift("#ef5009").cgColor //UIColor.blue.cgColor
        colorlayer.colors = [startColor,endColor]
        colorlayer.frame = view?.bounds ?? CGRect.zero
        view?.layer.addSublayer(colorlayer)
    }
}


// MARK: action
extension DDRewardDetailVC : UITableViewDelegate  , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.blankView?.remove()
        self.blankView = nil
        var count = 0
        if let c = self.apiModel.data?.items?.count , c > 0 {
            self.tableView?.isScrollEnabled = true
            count = c
        }else{
            self.tableView?.isScrollEnabled = false
            let alert = DDBlankView(message: "暂无订单信息", image: UIImage(named: "DDnoinformation"))
            alert.action = {
                mylog("xxxx")
                self.getData(loadType: LoadDataType.initialize)
            }
            self.blankView = alert
            self.tableView?.alert(alert)
        }
        return count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let c = tableView.dequeueReusableCell(withIdentifier: "DDRewardDetailCell") , let cell = c as?  DDRewardDetailCell{
            cell.model  = self.apiModel.data?.items?[indexPath.row]
            return cell
        }else {
            let cell = DDRewardDetailCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDRewardDetailCell")
            cell.model  = self.apiModel.data?.items?[indexPath.row]
            return cell
        }
    }
    
    
}
// MARK: tableViewDelegate
extension DDRewardDetailVC{
    class DDRewardDetailCell: UITableViewCell {
        var model : DDRewardDetailRowData?{
            didSet{
                self.orderNumberValue.text = model?.order_id
                self.submmitTimeValue.text = model?.finish_at
                self.rewardMoney.text = "+" + (model?.reward_price ?? "0")
                self.orderMoney.text = "¥" + (model?.order_price ?? "0")
                self.layoutIfNeeded()
                self.setNeedsLayout()
            }
        }
        let orderNumberTitle = UILabel()
        let orderNumberValue = UILabel()
        let submmitTimeTitle = UILabel()
        let submmitTimeValue = UILabel()
        let rewardMoney = UILabel()
        let orderMoney = UILabel()
        let bottomLine = UIView()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(orderNumberTitle)
            self.contentView.addSubview(orderNumberValue)
            self.contentView.addSubview(submmitTimeTitle)
            self.contentView.addSubview(submmitTimeValue)
            self.contentView.addSubview(rewardMoney)
            self.contentView.addSubview(orderMoney)
            self.contentView.addSubview(bottomLine)
            rewardMoney.font = UIFont.boldSystemFont(ofSize: 17)
            rewardMoney.textColor = .red
            orderNumberTitle.textColor = UIColor.darkGray
            orderNumberValue.textColor = UIColor.lightGray
            
            submmitTimeTitle.textColor = UIColor.darkGray
            submmitTimeValue.textColor = UIColor.lightGray
            
            orderMoney.textColor = UIColor.darkGray
            
            orderNumberTitle.font = UIFont.systemFont(ofSize: 15)
            orderNumberValue.font = UIFont.systemFont(ofSize: 15)
            
            submmitTimeTitle.font = UIFont.systemFont(ofSize: 15)
            submmitTimeValue.font = UIFont.systemFont(ofSize: 15)
            
            orderMoney.font = UIFont.systemFont(ofSize: 15)
            
            orderNumberTitle.text = "订单编号: "
            submmitTimeTitle.text = "提交时间: "
            self.selectionStyle = .none
//            orderNumberValue.text = "vvvvvvvvvvvvvvvvvvvv"
//            submmitTimeValue.text = "ccccccccccccccccc"
//
//            rewardMoney.text = "+1111"
//            orderMoney.text = "¥1111"
            bottomLine.backgroundColor = UIColor.DDLightGray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let borderMargin : CGFloat = 20
            rewardMoney.sizeToFit()
            orderMoney.sizeToFit()
            orderNumberTitle.sizeToFit()
            submmitTimeTitle.sizeToFit()
            rewardMoney.frame = CGRect(x: self.bounds.width - borderMargin - rewardMoney.bounds.width, y: borderMargin, width: rewardMoney.bounds.width + 10, height: 20)
            orderMoney.frame = CGRect(x: self.bounds.width - borderMargin - orderMoney.bounds.width, y: self.bounds.height - borderMargin - 18, width: orderMoney.bounds.width + 10, height: 18)
            
            
            orderNumberTitle.frame = CGRect(x: borderMargin, y: borderMargin, width: orderNumberTitle.bounds.width, height: 18)
            submmitTimeTitle.frame = CGRect(x: borderMargin, y: self.bounds.height - borderMargin - 18, width: submmitTimeTitle.bounds.width, height: 18)
            orderNumberValue.frame = CGRect(x: orderNumberTitle.frame.maxX, y: borderMargin, width: rewardMoney.frame.minX - orderNumberTitle.frame.maxX, height: 18)
            submmitTimeValue.frame = CGRect(x: submmitTimeTitle.frame.maxX, y: self.bounds.height - borderMargin - 18, width: orderMoney.frame.minX -  submmitTimeTitle.frame.maxX, height: 18)
            bottomLine.frame = CGRect(x: 10, y: self.bounds.height - 2, width: self.bounds.width - 10, height: 2)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
