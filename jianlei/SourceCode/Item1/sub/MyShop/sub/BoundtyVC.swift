//
//  BoundtyVC.swift
//  Project
//  扫码奖励金
//  Created by 张凯强 on 2019/8/20.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class BoundtyVC: DDInternalVC {
    ///*昨日奖励金*
    let yesterdayBounty = UILabel.configlabel(font: GDFont.boldSystemFont(ofSize: 43 * SCALE), textColor: UIColor.colorWithHexStringSwift("ffffff"), text: "")
    ///l累计奖励金
    let totalBounty = UILabel.configlabel(font: GDFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("ffffff"), text: "")
    ///扫码记录
    let sweepCodeRecord = ShopInfoCell.init(frame: CGRect.zero, title: "扫码记录", btnImage: "arrow_shaixuan_01", btnSelectImage: "arrow_shaixuan_02")
    ///根本的店铺类型
    var rootShopType: String = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dict = self.userInfo as? [String: String], let type = dict["type"], let id = dict["shopID"] {
            self.shopType = type
            
            if type == "1" {
                self.sweepCodeRecord.rightBtn2.isHidden = false
            }else {
                self.sweepCodeRecord.rightBtn2.isHidden = true
            }
            self.rootShopType = type
            self.headerId = id
            self.id = id
            self.requestHeaderData()
            self.requestData()
        }
        self.configUI()
        // Do any additional setup after loading the view.
    }
    var headerId: String = ""
    ///一是总店，2是分店
    var shopType: String = "1"
    ///店铺id或者id
    var id: String = ""
    ///UISearchBar textfield width
    var searchFieldWidth: CGFloat = 0
    ///排序
    var sort: String = "0"
    ///排序数据源
    var sortDataArr: [SortModel] = [SortModel.init(title: "默认排序", id: "0", isSelected: true),
                                    SortModel.init(title: "奖励金由高到低", id: "1", isSelected: false),
                                    SortModel.init(title: "奖励金由低到高", id: "2", isSelected: false),
                                    SortModel.init(title: "扫码时间由近到远", id: "3", isSelected: false),
                                    SortModel.init(title: "扫码时间由远到近", id: "4", isSelected: false)]
    ///头部数据源
    var headerData: BoundtypHeaderModel?
    var branchListView: BoundtyScreenView?
    ///排序View
    var sortView: BoundtySortView?
    var boundListArr: [BoundListModel] = [BoundListModel]() {
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    var pageNum: Int = 1
    var mobile: String = ""
    
    
    let search: UITextField = UITextField.init()
    ///排序
    let sortBtn = PrivateBtnInShopCell.init(frame: CGRect.zero)
    override func _configNavBar() {
        super._configNavBar()
        //TODO:设置导航栏字体
        self.naviBar.attributeTitle = NSMutableAttributedString.init(string: "扫码订单奖励金", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.naviBar.backBtn.setImage(UIImage.init(named: "return_white"), for: UIControl.State.normal)
        self.naviBar.backgroundColor = UIColor.clear
        
        
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BoundtyVC: UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    func configUI() {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENWIDTH / 1.49 + StatusBarHeight))
        self.view.addSubview(headerView)
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: headerView.width, height: headerView.height)
        gradientLayer.colors = [UIColor.colorWithHexStringSwift("ff7d09").cgColor, UIColor.colorWithHexStringSwift("ef4e07").cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        headerView.layer.addSublayer(gradientLayer)
        
        
        headerView.addSubview(self.sweepCodeRecord)
        self.sweepCodeRecord.frame = CGRect.init(x: 0, y: headerView.height - 50, width: headerView.width, height: 50)
        self.sweepCodeRecord.backgroundColor = UIColor.black
        self.sweepCodeRecord.rightBtn2.setTitle("筛选", for: UIControl.State.normal)
        self.sweepCodeRecord.rightBtn2.setTitleColor(UIColor.colorWithHexStringSwift("ef4e07"), for: UIControl.State.selected)
        self.sweepCodeRecord.rightBtn2.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.sweepCodeRecord.rightBtn2.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.sweepCodeRecord.rightBtn2.addTarget(self, action: #selector(filterAction(sender:)), for: UIControl.Event.touchUpInside)
        self.sweepCodeRecord.title.textColor = UIColor.white
        
        self.sweepCodeRecord.addSubview(self.sortBtn)
        self.sortBtn.setTitle("排序", for: UIControl.State.normal)
        self.sortBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.sortBtn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.sortBtn.setImage(UIImage.init(named: "arrow_shaixuan_01"), for: UIControl.State.normal)
        self.sortBtn.setImage(UIImage.init(named: "arrow_shaixuan_02"), for: UIControl.State.selected)
        self.sortBtn.addTarget(self, action: #selector(sortAction(sender:)), for: UIControl.Event.touchUpInside)
        self.sortBtn.setTitleColor(UIColor.colorWithHexStringSwift("ef4e07"), for: UIControl.State.selected)
        self.sortBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            if self.rootShopType == "1" {
                make.right.equalTo(self.sweepCodeRecord.rightBtn2.snp.left).offset(-13)
            }else {
                make.right.equalTo(self.sweepCodeRecord.rightBtn2.snp.right).offset(0)
            }
            
            make.width.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        
        
        
        
        let yesterdayBoundtyTitle = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("f1ccc0"), text: "昨日奖励金（港幣）")
        headerView.addSubview(yesterdayBoundtyTitle)
        yesterdayBoundtyTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(DDNavigationBarHeight + 10)
        }
        yesterdayBoundtyTitle.sizeToFit()
        headerView.addSubview(self.yesterdayBounty)
        self.yesterdayBounty.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(yesterdayBoundtyTitle.snp.bottom).offset(10)
        }
        self.yesterdayBounty.sizeToFit()
        
        headerView.addSubview(self.totalBounty)
        self.totalBounty.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.yesterdayBounty.snp.bottom).offset(20 * SCALE)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(totalBoundTap(tap:)))
        headerView.addGestureRecognizer(tap)
        headerView.isUserInteractionEnabled = true
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        
        //config search UI
        
        self.view.addSubview(self.search)
        self.search.frame = CGRect.init(x: 20, y: headerView.max_Y + 13 , width: SCREENWIDTH - 40, height: 30)
        self.search.placeholder = "请输入注册手机号或昵称查询扫码记录"
        self.search.leftViewMode = .always
        let leftImageView = UIImageView.init(image: UIImage.init(named: "search"))
        leftImageView.frame = CGRect.init(x: 0, y: 0, width: 44, height: self.search.height)
        
        leftImageView.contentMode = .center
        self.search.leftView = leftImageView
        self.search.textColor = UIColor.colorWithHexStringSwift("323232")
        self.search.backgroundColor = UIColor.white
        self.search.layer.masksToBounds = true
        self.search.layer.cornerRadius = 15
        self.search.font = GDFont.systemFont(ofSize: 14)
        
        //搜索
        self.search.returnKeyType = .search
        self.search.delegate = self
        
        
        
        ///tableView
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.search.max_Y + 10, width: SCREENWIDTH, height: SCREENHEIGHT - self.search.max_Y - DDSliderHeight - 10), style: UITableView.Style.plain)
        self.view.addSubview(tableView)
        self.tableView = tableView
        tableView.register(BoundtyTableViewCell.self, forCellReuseIdentifier: "BoundtyTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        tableView.separatorStyle = .none
        tableView.gdLoadControl = GDLoadControl.init(target: self, selector: #selector(loadMore))
        
        self.zkqMaskView.title = "暫無掃碼記錄"
        self.zkqMaskView.image = "noinformation"
        self.zkqMaskView.frame = CGRect.init(x: 0, y: tableView.y, width: tableView.width, height: tableView.height)
        
        
    }
    ///总的奖励金
    @objc func totalBoundTap(tap: UITapGestureRecognizer)  {
        let vc = DDRewardDetailVC()
        
        vc.type = 1
        if self.rootShopType == "1" {
            vc.head_id  = self.headerId
        }else {
            vc.shop_id = self.headerId
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //search
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            self.mobile = textField.text ?? ""
            self.pageNum = 1
            self.sort = "1"
            self.requestData()
            textField.resignFirstResponder()
        }
        
        
        return true
    }
    
    
    
    
    
    @objc func loadMore() {
        self.pageNum += 1
        self.requestData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boundListArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoundtyTableViewCell", for: indexPath) as! BoundtyTableViewCell
        cell.model = self.boundListArr[indexPath.item]
        if self.shopType == "1" {
            cell.shopNameView.isHidden = false
        }else {
            cell.shopNameView.isHidden = true
        }
        cell.clcikAction = { [weak self] (id) in
            let vc = DDRewardDetailVC()
            vc.type = 2
            vc.id = id
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.shopType == "1" {
            return 203
            
        }else {
            return 172
        }
    }
    
    
    func requestHeaderData() {
        var paramete = ["token": DDAccount.share.token ?? ""]
        if self.shopType == "1" {
            paramete["head_id"] = self.headerId
        }else {
            paramete["shop_id"] = self.id
        }
        let router = Router.get("reward/reward-list", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<BoundtypHeaderModel>.deserialize(from: dict)
            self.headerData = model?.data
            self.yesterdayBounty.text = model?.data?.yestoday_reward
            self.totalBounty.text = String.init(format: "累计奖励金（港幣）: %@", model?.data?.total_reward ?? "0")
            if (model?.data?.branch_list?.count ?? 0) > 0 {
                self.sweepCodeRecord.rightBtn2.isHidden = false
            }else {
                self.sweepCodeRecord.rightBtn2.isHidden = true
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
    }
    func requestData() {
        var paramete = [String: String]()
        if self.shopType == "1" {
            paramete["head_id"] = self.headerId
        }else {
            paramete["shop_id"] = self.id
        }
        paramete["token"] = DDAccount.share.token ?? ""
        paramete["mobile"] = self.mobile
        paramete["page"] = String(self.pageNum)
        paramete["create_at"] = self.sort
        
        let router = Router.get("reward/shop-search", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            if self.pageNum == 1 {
                self.boundListArr.removeAll()
                self.tableView?.gdLoadControl?.loadStatus = GDLoadStatus.idle
            }
            let model = BaseModelForArr<BoundListModel>.deserialize(from: dict)
            if let data = model?.data, data.count > 0 {
                self.tableView?.gdLoadControl?.endLoad(result: GDLoadResult.success)
                
                self.boundListArr.append(contentsOf: data)
            }else {
                self.tableView?.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
            }
            if self.boundListArr.count == 0 {
                self.zkqMaskView.isHidden = false
            }else {
                self.zkqMaskView.isHidden = true
            }
            
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
        
    }
    
    
    
    
    ///筛选
    @objc func filterAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.sortBtn.isSelected = false
            self.sortView?.removeFromSuperview()
            self.sortView = nil
            
            self.branchListView = BoundtyScreenView.init(frame: CGRect.init(x: 0, y: SCREENWIDTH / 1.49 + StatusBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - SCREENWIDTH / 1.49 - StatusBarHeight), dataList: self.headerData?.branch_list ?? [BranchListModel]())
            self.view.addSubview(self.branchListView!)
            self.branchListView?.finishedClick = { [weak self] (id) in
                if id == "cancle" {
                    self?.branchListView = nil
                    self?.shopType = "1"
                    self?.pageNum = 1
                    self?.requestData()
                }else if id == "total" {
                    self?.branchListView = nil
                    self?.shopType = "1"
                    self?.pageNum = 1
                    self?.requestData()
                }else {
                    self?.id = id
                    self?.shopType = "2"
                    self?.pageNum = 1
                    self?.requestData()
                }
                sender.isSelected = false
                
            }
        }else {
            self.branchListView?.removeFromSuperview()
            self.branchListView = nil
        }
    }
    ///排序
    @objc func sortAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.sweepCodeRecord.rightBtn2.isSelected = false
            self.branchListView?.removeFromSuperview()
            self.branchListView = nil
            
            self.sortView = BoundtySortView.init(frame: CGRect.init(x: 0, y: SCREENWIDTH / 1.49 + StatusBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - SCREENWIDTH / 1.49 - StatusBarHeight), dataList: self.sortDataArr)
            
     
            self.view.addSubview(self.sortView!)
            self.sortView?.finishedClick = { [weak self] (id) in
                if id == "cancle" {
                    self?.sortView = nil
                }else if id == "total" {
                    self?.sortView = nil
                    self?.pageNum = 1
                    self?.requestData()
                }else {
                    self?.sortView = nil
                    self?.sort = id
                    self?.pageNum = 1
                    self?.requestData()
                    let model = self?.sortDataArr[Int(id)!]
                    let size = (model?.title ?? "").sizeSingleLine(font: GDFont.systemFont(ofSize: 14))
                    self?.sortBtn.setTitle(model?.title, for: UIControl.State.normal)
                    self?.sortBtn.snp.updateConstraints({ (make) in
                        make.width.equalTo(size.width + 20)
                    })
                    
                    
                    
                    
                }
                sender.isSelected = false
                
            }
        }else {
            self.sortView?.removeFromSuperview()
            self.sortView = nil
        }
    }
    
    
    
}




class BranchListModel: GDModel {
    var id: String?
    var name: String?
    var isSelected: Bool = false
}

class BoundtypHeaderModel: GDModel {
    var total_reward: String?
    var yestoday_reward: String?
    var branch_list: [BranchListModel]?
}
class BoundListModel: GDModel {
    var b_member_id: String?
    var bind_id: String?
    var create_at: String?
    var head_id: String?
    var id: String?
    var member_id: String?
    var mobile: String?
    var nickname: String?
    var reward_price: String?
    var shop_id: String?
    var shop_name: String?
    var software_number: String?
    
    
    
    
    
}

class SortModel: NSObject {
    init(title:  String, id: String, isSelected: Bool = false) {
        super.init()
        self.title = title
        self.id = id
        self.isSelected = isSelected
    }
    var title: String = ""
    var id: String = ""
    var isSelected: Bool = false
}



class BoundtyTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.selectionStyle = .none
        let backView = UIView.init()
        backView.backgroundColor = UIColor.white
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 10
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowRadius = 5
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        
        self.contentView.addSubview(backView)
        
        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
        }
        
        backView.addSubview(self.nikename)
        self.nikename.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(13)
        }
        backView.addSubview(self.boundtyMoney)
        self.boundtyMoney.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-13)
            make.top.equalToSuperview().offset(13)
        }
        
        backView.addSubview(self.setNickname)
        self.setNickname.snp.updateConstraints { (make) in
            make.top.equalTo(self.nikename.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(13)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        self.setNickname.setTitle("[设置昵称]", for: UIControl.State.normal)
        self.setNickname.setTitle("[设置昵称]", for: UIControl.State.disabled)
        self.setNickname.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        self.setNickname.setTitleColor(UIColor.colorWithHexStringSwift("cccccc"), for: UIControl.State.disabled)
        self.setNickname.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.setNickname.setImage(UIImage.init(named: "arrow_name"), for: UIControl.State.normal)
        self.setNickname.addTarget(self, action: #selector(setNickNameAction(sender:)), for: UIControl.Event.touchUpInside)
        
        let lineView = UIView.init()
        backView.addSubview(lineView)
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.setNickname.snp.bottom).offset(0)
            make.height.equalTo(1)
        }
        backView.addSubview(self.screenCodeView)
        self.screenCodeView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(25 * SCALE)
        }
        self.screenCodeView.title.font = GDFont.systemFont(ofSize: 14)
        self.screenCodeView.subTitle.font = GDFont.systemFont(ofSize: 14)
        backView.addSubview(self.sweepTimeView)
        self.sweepTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.screenCodeView.snp.bottom).offset(0)
            make.right.left.equalToSuperview()
            make.height.equalTo(25 * SCALE)
        }
        self.sweepTimeView.title.font = GDFont.systemFont(ofSize: 14)
        self.sweepTimeView.subTitle.font = GDFont.systemFont(ofSize: 14)
        backView.addSubview(self.shopNameView)
        self.shopNameView.snp.makeConstraints { (make) in
            make.top.equalTo(self.sweepTimeView.snp.bottom).offset(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(25 * SCALE)
        }
        self.shopNameView.title.font = GDFont.systemFont(ofSize: 14)
        self.shopNameView.subTitle.font = GDFont.systemFont(ofSize: 14)
        
        
        
        
        let cancleBtn = UIButton.init()
        backView.addSubview(cancleBtn)
        cancleBtn.setTitle("订单信息", for: UIControl.State.normal)
        cancleBtn.setTitleColor(UIColor.colorWithHexStringSwift("ff7d09"), for: UIControl.State.normal)
        cancleBtn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.disabled)
        cancleBtn.backgroundColor = UIColor.colorWithHexStringSwift("ffecd9")
        cancleBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(backView.snp.width).multipliedBy(0.5)
        }
        cancleBtn.addTarget(self, action: #selector(orderInfoAction(sender:)), for: UIControl.Event.touchUpInside)
        
        let sureBtn = UIButton.init()
        backView.addSubview(sureBtn)
        sureBtn.setTitle("拨打电话", for: UIControl.State.normal)
        sureBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        sureBtn.setTitleColor(UIColor.white, for: UIControl.State.disabled)
        sureBtn.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        sureBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(backView.snp.width).multipliedBy(0.5)
        }
        sureBtn.addTarget(self, action: #selector(telephoneAction(sender:)), for: UIControl.Event.touchUpInside)
        self.orderInfoBtn = cancleBtn
        self.telephoneBtn = sureBtn
        
    }
    var orderInfoBtn: UIButton?
    var telephoneBtn: UIButton?
    @objc func orderInfoAction(sender: UIButton) {
        if let id = self.model?.id {
            self.clcikAction?(id)
        }
        
    }
    @objc func setNickNameAction(sender: PrivateBtnInShopCell) {
        guard let id = self.model?.id else { return  }
        
        sender.isEnabled = false
        let cancle = ZKAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { [weak self](action) in
            sender.isEnabled = true
            
        }
        let sure = ZKAlertAction.init(title: "确定", style: UIAlertAction.Style.default) { [weak self](action) in
            
            ZkqAlert.share.activeAlert.startAnimating()
            
          
            let paramete = ["token": DDAccount.share.token ?? "", "id": id, "nickname": action.paramete as! String]
            let router = Router.post("reward/update-name", .api, paramete)
            let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
                let model = BaseModel<String>.deserialize(from: dict)
                if model?.status == 200 {
                    let size = "[\(action.paramete as! String)]".sizeSingleLine(font: GDFont.systemFont(ofSize: 14))
                    self?.setNickname.snp.updateConstraints { (make) in
                        make.width.equalTo(size.width + 13)
                    }
                    if let title = action.paramete as? String {
                        self?.setNickname.setTitle(title, for: UIControl.State.normal)
                    }
                    if let nickName = action.paramete as? String {
                        self?.model?.nickname = nickName
                    }
                    
                    
                }else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
                sender.isEnabled = true
                ZkqAlert.share.activeAlert.stopAnimating()
            }, onError: { (error) in
                sender.isEnabled = true
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
        }
        let alert = MyAlertView.init(frame: CGRect.zero, title: "设置昵称", textFieldStr: self.model?.nickname, message: "请输入昵称", actions: [cancle, sure])
        
        UIApplication.shared.keyWindow?.alertZkq(alert)
        
    }
    
    
    @objc func telephoneAction(sender: UIButton) {
        if let url = URL.init(string: "tel:\(self.model?.mobile ?? "")") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
                // Fallback on earlier versions
            }
        }
        
    }
    var clcikAction:((String) -> ())?
    
    
    var model: BoundListModel? {
        didSet {
            self.nikename.text = model?.mobile
            if let title = model?.nickname, title.count > 0 {
                
                let size = "[\(title)]".sizeSingleLine(font: self.setNickname.titleLabel?.font ?? GDFont.systemFont(ofSize: 14))
                self.setNickname.snp.updateConstraints { (make) in
                    make.width.equalTo(size.width + 13)
                }
                self.setNickname.setTitle("[\(title)]", for: UIControl.State.normal)
            }else {
                let size = "[设置昵称]".sizeSingleLine(font: self.setNickname.titleLabel?.font ?? GDFont.systemFont(ofSize: 14))
                self.setNickname.snp.updateConstraints { (make) in
                    make.width.equalTo(size.width + 13)
                }
                self.setNickname.setTitle("[设置昵称]", for: UIControl.State.normal)
            }
            self.boundtyMoney.text = "奖励金：￥\(model?.reward_price ?? "0")"
            self.screenCodeView.subTitleValue = model?.software_number
            self.sweepTimeView.subTitleValue = model?.create_at
            self.shopNameView.subTitleValue = model?.shop_name
            
            
            
            if model?.b_member_id == "0" {
                ///未注册的时候设置昵称，订单详情，和拨打电话的按钮都不可点
                self.orderInfoBtn?.isEnabled = false
                self.telephoneBtn?.isEnabled = false
                self.orderInfoBtn?.backgroundColor = UIColor.colorWithHexStringSwift("eaeaea")
                self.telephoneBtn?.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                self.setNickname.isEnabled = false
                self.nikename.text = "未注册"
                
                
                let size = "[设置昵称]".sizeSingleLine(font: self.setNickname.titleLabel?.font ?? GDFont.systemFont(ofSize: 14))
                self.setNickname.snp.updateConstraints { (make) in
                    make.width.equalTo(size.width + 13)
                }
            }else {
                
                if let mobile = model?.mobile, mobile.mobileLawful() {
                    self.telephoneBtn?.isEnabled = true
                    self.telephoneBtn?.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
                }else {
                    self.nikename.text = "邮箱注册"
                    self.telephoneBtn?.isEnabled = false
                    self.telephoneBtn?.backgroundColor = UIColor.colorWithHexStringSwift("cccccc")
                }
                
                
                self.orderInfoBtn?.isEnabled = true
                
                self.orderInfoBtn?.backgroundColor = UIColor.colorWithHexStringSwift("ffecd9")
                
                self.setNickname.isEnabled = true
            }
            
            
            
        }
    }
    
    
    ///昵称
    let nikename: UILabel = UILabel.configlabel(font: GDFont.boldSystemFont(ofSize: 16), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    ///奖励金
    let boundtyMoney = UILabel.configlabel(font: GDFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("ff7d09"), text: "")
    ///设置昵称
    let setNickname = PrivateBtnInShopCell()
    ///屏幕码title
    let screenCode = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    ///屏幕码value
    let screenValue = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    
    ///扫码时间
    let sweepTime = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    ///扫码时间value
    let sweepTimeValue = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    
    let screenCodeView = ShopInfoCell.init(frame: CGRect.zero, title: "屏幕码")
    let sweepTimeView = ShopInfoCell.init(frame: CGRect.zero, title: "扫码时间")
    let shopNameView = ShopInfoCell.init(frame: CGRect.zero, title: "分店名称")
    
    ///分店名称
    let shopName = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    ///扫码时间value
    let shopNameValue = UILabel.configlabel(font: GDFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
