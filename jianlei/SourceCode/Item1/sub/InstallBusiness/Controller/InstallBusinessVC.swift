//
//  InstallBusinessVC.swift
//  YiLuMedia
//
//  Created by 张凯强 on 2019/9/11.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class InstallBusinessVC: DDInternalVC , UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadMore()
    }
    let table = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), style: UITableView.Style.plain)
    let maskView = ShopMaskView.init(frame: CGRect.zero)
    
    func configUI() {
        self.naviBar.title = "home_installBussiness"|?|
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        rightBtn.setImage(UIImage.init(named: "installBussiness_history"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction(btn:)), for: UIControl.Event.touchUpInside)
        self.naviBar.rightBarButtons = [rightBtn]
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.view.addSubview(self.maskView)
        self.maskView.frame = CGRect.init(x: 0, y: (SCREENHEIGHT - 200) / 2.0, width: SCREENWIDTH, height: 200)
        self.maskView.isHidden = true
        
        
        
        
        
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        table.register(InstallHistoryCell.self, forCellReuseIdentifier: "InstallHistoryCell")
        table.register(InstallHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "InstallHistoryHeader")
        table.separatorStyle = .none
//        table.gdLoadControl = GDLoadControl.init(target: self, selector: #selector(loadMore))
        if #available(iOS 11.0, *) {
            self.table.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.refreshBtn.frame = CGRect.init(x: SCREENWIDTH - 60, y: SCREENHEIGHT - DDSliderHeight - 100, width: 44, height: 44)
        self.refreshBtn.isHidden = true

        
        
    }
    
    
    @objc func rightBtnAction(btn: UIButton) {
        self.pushVC(vcIdentifier: "BusinessHistroryVC", userInfo: nil)
    }
    var date: String = ""
//    {
//        didSet{
//            if date == "" {
//                self.refreshBtn.isHidden = true
//            }else {
//                self.refreshBtn.isHidden = false
//            }
//        }
//    }
    @objc func loadMore() {
        let parameter: [String: AnyObject] = ["page": self.page as AnyObject, "token": (DDAccount.share.token ?? "") as AnyObject]
        if self.page == 1 {
            self.table.gdLoadControl?.loadStatus = .idle
        }
        self.page += 1
        let router = Router.get("shop", DomainType.api, parameter)
        let _ = NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<[InstallBusinessModel]>.self, from: response)
            if let data = model?.data, model?.status == 200, data.count > 0 {
                
                self.table.gdLoadControl?.endLoad(result: GDLoadResult.success)
                self.dataArr.removeAll()
                self.dataArr.append(contentsOf: data)
                
                if self.page == 2 {
                    //第一次加载第一页的数据的时候
                }
                
                
            }else {
                
                self.table.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                
            }
            self.table.reloadData()
            if self.dataArr.count == 0 {
                self.table.isHidden = true
                self.maskView.isHidden = false
                self.refreshBtn.isHidden = false
            }else {
                self.refreshBtn.isHidden = true
                self.table.isHidden = false
                self.maskView.isHidden = true
            }
        }) {
            
        }
        
        
        
        
        
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
    

    
    var page: Int = 1
    var keyword: String = ""
    
    var dataArr: [InstallBusinessModel] = [InstallBusinessModel]()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstallHistoryCell", for: indexPath) as! InstallHistoryCell
        cell.model = self.dataArr[indexPath.row]
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = self.dataArr[indexPath.row]
        let vc = ShopInfoVC()
        vc.vcType = .installBusiness
        vc.userInfo = ["id": model.id, "type": model.shop_place_type, "operateType": model.shop_operate_type]
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
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if let cell = self.table.visibleCells.first, let index = self.table.indexPath(for: cell) {
//            let model = self.dataArr[index.row]
//        }
//    }
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
class ShopMaskView: UIView {
    init(frame: CGRect, title: String = "installBussinessNUll"|?|) {
        super.init(frame: frame)
        let imageView = UIImageView.init(image: UIImage.init(named: "notice_noinformation"))
        let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("afafaf"), text: title)
        label.text = title
        self.addSubview(imageView)
        self.addSubview(label)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(imageView.image?.size.width ?? 0)
            make.height.equalTo(imageView.image?.size.height ?? 0)
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(30)
            
        }
        label.sizeToFit()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class InstallHistoryHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.myTitle)
        self.contentView.backgroundColor = UIColor.white
        self.myTitle.sizeToFit()
        self.myTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(self.button)
        self.button.setImage(UIImage.init(named: "installBussiness_date"), for: UIControl.State.normal)
        self.button.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
        self.backgroundColor = UIColor.white
        //        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        //        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.old, context: nil)
    }
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //
    //
    //    }
    let button = UIButton.init()
    
    let myTitle: UILabel = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class InstallBusinessModel: Codable {
    ///屏幕状态，1正常，2异常
    var screen_status: String?
    ///店铺ID
    var id: String?
    ///店铺状态0：待审核，1：待安装，2：被驳回 ，5：已安装
    var status: String?
    ///店铺所在地区
    var area_name: String?
    ///创建时间
    var create_at: String?
    ///店铺所在地类型
    var shop_place_type: String?
    ///屏幕数量
    var screen_number: String?
    ///店铺门脸图
    var shop_image: String?
    ///店铺名称
    var name: String?
    var address: String?
///1，租赁店，2，自营店, 3,连锁店， 4,总店
    var shop_operate_type: String?
    
    
    
    
    
}
import SDWebImage
class InstallHistoryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        let backView = UIView.init()
        self.contentView.addSubview(backView)
        backView.backgroundColor = UIColor.white
        backView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        backView.layer.cornerRadius = 6
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        backView.layer.shadowOpacity = 0.1
        backView.addSubview(self.editShopBtn)
        
        self.image1.image = UIImage.init(named: "installBussiness_shop")
        backView.addSubview(self.image1)
        self.image1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(self.image1.image?.size.width ?? 0)
            make.height.equalTo(self.image1.image?.size.height ?? 0)
        }
        
        backView.addSubview(self.shopName)
        self.shopName.sizeToFit()
        self.shopName.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.image1.snp.centerY)
            make.left.equalTo(self.image1.snp.right).offset(10)
        }
        
        backView.addSubview(self.calanderTime)
        self.calanderTime.sizeToFit()
        self.calanderTime.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(self.image1.snp.centerY)
        }
    
        self.editShopBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.image1.snp.centerY)
            make.right.equalToSuperview().offset(-15)
        }
        self.editShopBtn.isHidden = true
        
        let lineView = UIView.init()
        backView.addSubview(lineView)
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("e5e5e5")
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.image1.snp.bottom).offset(10)
            make.height.equalTo(1)
            
        }
        backView.addSubview(self.shopImage)
        self.shopImage.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
        backView.addSubview(self.shopAddress)
        self.shopAddress.sizeToFit()
        self.shopAddress.snp.makeConstraints { (make) in
            make.left.equalTo(self.shopImage.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.shopImage.snp.top).offset(3)
            
        }
        backView.addSubview(self.shopAddressDetail)
        self.shopAddressDetail.sizeToFit()
        self.shopAddressDetail.snp.makeConstraints { (make) in
            make.left.equalTo(self.shopImage.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.shopAddress.snp.bottom).offset(5)
        }
        
        backView.addSubview(self.statusLabel)
        self.statusLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.shopImage.snp.right).offset(10)
            make.top.equalTo(self.shopAddressDetail.snp.bottom).offset(5)
            make.height.equalTo(21)
            make.width.equalTo(125)
            
        }
        self.statusLabel.layer.masksToBounds = true
        self.statusLabel.layer.cornerRadius = 10
        self.statusLabel.textColor = UIColor.colorWithHexStringSwift("ffab34")
        self.statusLabel.layer.cornerRadius = 10.5
        self.statusLabel.layer.borderColor = UIColor.colorWithHexStringSwift("ffab34").cgColor
        self.statusLabel.layer.borderWidth = 1
        self.statusLabel.textAlignment = NSTextAlignment.center
        
        
        backView.addSubview(count)
        
        self.count.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.shopAddressDetail.snp.bottom).offset(10)
            make.height.equalTo(21)
            make.width.equalTo(60)
        }
        self.count.backgroundColor = UIColor.colorWithHexStringSwift("eeeeee")
        self.count.layer.cornerRadius = 5
        self.count.layer.masksToBounds = true
        self.count.textAlignment = NSTextAlignment.center
        self.count.isHidden = true
        
        
    }
    
    var fenDianListModel: FendianList? {
        didSet {
            
            self.shopName.text = fenDianListModel?.branch_shop_name
            self.calanderTime.text = ""
            self.shopAddress.text = fenDianListModel?.branch_shop_area_name
            self.shopAddressDetail.text = fenDianListModel?.branch_shop_address
            self.shopImage.sd_setImage(with: imgStrConvertToUrl(fenDianListModel?.shop_image ?? ""), placeholderImage: UIImage.init(named: "defaultshop"), options: SDWebImageOptions.cacheMemoryOnly)
            self.count.text = ""
            self.count.snp.updateConstraints { (make) in
                make.width.equalTo(0)
                make.height.equalTo(0)
            }
            var statusStr: String = ""
            
            if let status = fenDianListModel?.status {
                self.editShopBtn.isHidden = true
                switch status {
                case "-1":
                    self.editShopBtn.isHidden = false
                    statusStr = "shop_fendian_status_no_apply"|?|
                case "0":
                    //待安裝
                    statusStr = "shop_fendian_to_be_install"|?|
                    self.editShopBtn.isHidden = true
                    self.editShopBtn.isHidden = true
                    //1申请未通过
//                case "1":
//                    statusStr = "applyShopStatus1"|?|
//                    self.editShopBtn.isHidden = true
//                case "3":
//                    //安裝待申請
//                    statusStr = "shop_fendian_tobe_audited"|?|
//                    self.editShopBtn.isHidden = true
//                case "2":
//                    //待安裝
//                    statusStr = "shop_fendian_to_be_install"|?|
//                    self.editShopBtn.isHidden = true
//                case "4":
//                    //安裝未通過
//                    statusStr = "shop_fendian_noInstall"|?|
//                    self.editShopBtn.isHidden = true
                case "5":
                    //已安裝
                    statusStr = "shop_fendian_installed"|?|
                    self.editShopBtn.isHidden = true

                default:
                    break
                }
            }else {
                self.editShopBtn.isHidden = false
            }
            
            self.statusLabel.text = statusStr
            let statusSize = statusStr.sizeSingleLine(font: GDFont.systemFont(ofSize: 12))
            self.statusLabel.snp.updateConstraints { (make) in
                make.width.equalTo(statusSize.width + 20)
            }



        }
    }
    var screenModel: ScreenInstallHistoryModel? {
        didSet {
            if let model = screenModel {
                self.shopName.text = model.name
                self.calanderTime.text = model.create_at
                self.shopImage.sd_setImage(with: imgStrConvertToUrl(model.shop_image ?? ""), placeholderImage: placeholderImage, options: SDWebImageOptions.cacheMemoryOnly)
                self.shopAddress.text = model.area_name
                self.shopAddressDetail.text = model.address
                self.count.text = (model.screen_number ?? "") + "台"|?|
                let countSize = ((model.screen_number ?? "") + "台"|?|).sizeSingleLine(font: UIFont.systemFont(ofSize: 20))
                self.count.snp.updateConstraints { (make) in
                    make.width.equalTo(countSize.width + 20)
                }
                let status: String = model.status ?? ""
                var statusStr: String = ""
                switch status {
                case "0":
                    statusStr = "applyShopStatus0"|?|
                case "1":
                    statusStr = "applyShopStatus1"|?|
                    
                    
                    
                case "3":
                    statusStr = "applyShopStatus3"|?|
                case "2":
                    statusStr = "applyShopStatus2"|?|
                case "4":
                    statusStr = "applyShopStatus4"|?|
                case "5":
                    statusStr = "applyShopStatus5"|?|
                case "6":
                    statusStr = "applyShopStatus6"|?|
                    
                default:
                    break
                }
               
                let statusSize = statusStr.sizeSingleLine(font: UIFont.systemFont(ofSize: 12))
                self.statusLabel.text = statusStr
                self.statusLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(statusSize.width + 20)
                }
            }
        }
    }
    lazy var editShopBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "edit-1"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(editShopAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    @objc func editShopAction(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init("MyshopEditFendian"), object: nil, userInfo: ["model": self.fenDianListModel ?? ""])
    }
    
    
    
    
    let placeholderImage = UIImage.init(named: "media16")
    var model: InstallBusinessModel = InstallBusinessModel.init() {
        didSet{
            self.shopName.text = model.name
            self.calanderTime.text = model.create_at
            self.shopImage.sd_setImage(with: imgStrConvertToUrl(model.shop_image ?? ""), placeholderImage: placeholderImage, options: SDWebImageOptions.cacheMemoryOnly)
            self.shopAddress.text = model.area_name
            self.shopAddressDetail.text = model.address
            self.count.text = (model.screen_number ?? "") + "台"|?|
            let countSize = ((model.screen_number ?? "") + "台"|?|).sizeSingleLine(font: UIFont.systemFont(ofSize: 20))
            self.count.snp.updateConstraints { (make) in
                make.width.equalTo(countSize.width + 20)
            }
            let status: String = model.status ?? ""
            var statusStr: String = ""
            switch status {
            case "0":
                statusStr = "applyShopStatus0"|?|
            case "1":
                statusStr = "applyShopStatus1"|?|
            


            case "3":
                statusStr = "applyShopStatus3"|?|
            case "2":
                statusStr = "applyShopStatus2"|?|
            case "4":
                statusStr = "applyShopStatus4"|?|
            case "5":
                statusStr = "applyShopStatus5"|?|
            case "6":
                statusStr = "applyShopStatus6"|?|
                
            default:
                break
            }
            let statusSize = statusStr.sizeSingleLine(font: UIFont.systemFont(ofSize: 12))
            self.statusLabel.text = statusStr
            self.statusLabel.snp.updateConstraints { (make) in
                make.width.equalTo(statusSize.width + 20)
            }
        
        }
    }
    
    ///安装历史页面
    var bussinessHistoryModel: InstallHistoryModel = InstallHistoryModel.init() {
        didSet{
            self.count.isHidden = false
            self.shopName.text = bussinessHistoryModel.shop_name
            self.calanderTime.text = bussinessHistoryModel.create_at
            self.shopImage.sd_setImage(with: imgStrConvertToUrl(bussinessHistoryModel.shop_image ?? ""), placeholderImage: placeholderImage, options: SDWebImageOptions.cacheMemoryOnly)
            self.shopAddress.text = bussinessHistoryModel.area_name
            self.shopAddressDetail.text = bussinessHistoryModel.address
            self.count.text = (bussinessHistoryModel.screen_number ?? "") + "台"|?|
            let countSize = ((bussinessHistoryModel.screen_number ?? "") + "台"|?|).sizeSingleLine(font: UIFont.systemFont(ofSize: 20))
            self.count.snp.updateConstraints { (make) in
                make.width.equalTo(countSize.width + 20)
            }
            let status: String = bussinessHistoryModel.type ?? ""
            var statusStr: String = ""
            switch status {
            case"1":
                statusStr = "businessHistoryType1"|?|
            case "2":
                statusStr = "businessHistoryType2"|?|
            case "3":
                statusStr = "businessHistoryType3"|?|
            case "4":
                statusStr = "businessHistoryType4"|?|
                
            default:
                break
            }
            let statusSize = statusStr.sizeSingleLine(font: UIFont.systemFont(ofSize: 12))
            self.statusLabel.text = statusStr
            self.statusLabel.snp.updateConstraints { (make) in
                make.width.equalTo(statusSize.width + 20)
            }
            
                        
        }
    }
    
    
    
    
    let shopName = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    
    let calanderTime = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    
    let shopAddress = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: "阿来得及发卡机砥砺奋进阿里斯顿家乐福卡")
    
    let shopAddressDetail = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "案件发漏发了的离开法律的福利卡聚隆科技绿卡阿来得及拉法基老是看到")
    let shopImage = UIImageView.init()
    let image1 = UIImageView.init()
    
    let statusLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("ff7d09"), text: "安装完成")
    let count = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: "12台")
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension InstallHistoryCell {
    
}

