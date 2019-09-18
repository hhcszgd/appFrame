//
//  ChangeTimeVC.swift
//  Project
//
//  Created by 张凯强 on 2018/5/22.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import MBProgressHUD
class ChangeTimeVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource {

    var startDay: String?
    var endDay: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestDataList(success: nil)
        self.configTable()
        self.configTimeBtn()
        self.configTimeBtnTitle()
        self.configTrueChangeBtn()
        mylog(self.timeBtn)
        self.navigationItem.titleView = self.timeBtn
        mylog(self.timeBtn)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    var finished: ((String, String) -> ())?
    var is_update: String?
    var orderID: String?
    var count: String?
    var dayCount: Int = 0
    @objc func trueAction(sender: UIButton) {
        
        
        let arr = self.dataArr.filter { (model) -> Bool in
            if model.cant_buy_date == "所选地区余量不足" {
                return true
            }else {
                return false
            }
        }
        if arr.count == self.dataArr.count {
            GDAlertView.alert("所选时间无余量，请修改时间范围", image: nil, time: 1, complateBlock: nil)
            self.calanderControl.isUserInteractionEnabled = false
            return
        }else {
            self.calanderControl.isUserInteractionEnabled = true
        }
        
        
        self.cover = DDCoverView.init(superView: self.view.window!)
        self.cover?.deinitHandle = { [weak self] in
            self?.cover?.removeFromSuperview()
            self?.cover = nil

        }
        guard let start = startDay, let end = endDay else {
            return
        }
        let y: CGFloat = (SCREENHEIGHT - 180) / 2.0
        
        let containerView = ZChangeTimeAlert.init(frame: CGRect.init(x: 30, y: y , width: SCREENWIDTH - 60, height: 180), startDay: start, endDay: end, superView: self.cover!, count: self.is_update ?? "0")
       
        containerView.sureBtn.addTarget(self, action: #selector(sureChangeAction(sender:)), for: .touchUpInside)
        
    
        
    }
    @objc func sureChangeAction(sender: UIButton) {
        sender.isEnabled = false
        self.requestData {
            sender.isEnabled = true
            
        }
        
        
    }
    
    
    func configTimeBtn() {
        self.timeBtn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        self.timeBtn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .selected)
        self.timeBtn.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        self.timeBtn.setImage(UIImage.init(named: "downarrow"), for: .normal)
        self.timeBtn.setImage(UIImage.init(named: "uparrow"), for: .selected)
        self.timeBtn.addTarget(self, action: #selector(calanderBtn(sender:)), for: .touchUpInside)
        let interImageTitleSpaceing: CGFloat = 5
      
        self.timeBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: self.timeBtn.width, bottom: 0, right: -self.timeBtn.width - interImageTitleSpaceing - 40)
        
        
        
        
        
    }
    func configTrueChangeBtn() {
        self.trueChange.setTitle("确认修改", for: .normal)
        self.trueChange.setTitleColor(UIColor.white, for: .normal)
        self.trueChange.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
        self.trueChange.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        self.view.addSubview(self.trueChange)
        self.trueChange.addTarget(self, action: #selector(trueAction(sender:)), for: .touchUpInside)
    }
    func configTimeBtnTitle() {
        if let day1 = self.startDay, let day2 = self.endDay {
            let str = day1 + "-" + day2
            self.timeBtn.setTitle(str, for: .normal)
            
        }
    }
    var hud: MBProgressHUD?
    func generalButtonAction()  {
        self.hud = MBProgressHUD.init(view: self.view.window!)
        self.view.window?.addSubview(self.hud!)
        self.hud?.label.text = "修改中"
        self.hud?.detailsLabel.text = "请耐心等待..."
        self.hud?.show(animated: true)
        
    }
    
    func requestData(success: (() -> ())?) {
        let orderid = self.orderID ?? ""
        let memberid = DDAccount.share.id ?? ""
        let paramete = ["start_at": self.startDay ?? "", "end_at": self.endDay ?? "", "token": DDAccount.share.token ?? ""]
        let router = Router.put("member/\(memberid)/orderdate/\(orderid)", .api, paramete)
        self.generalButtonAction()
        
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                self.cover?.removeFromSuperview()
                self.cover = nil
                guard let day1 = self.startDay, let day2 = self.endDay else {
                    return
                }
                self.finished?(day1, day2)
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
                
                success?()
            }else {
                success?()
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: {
                    
                })
            }
            self.hud?.removeFromSuperview()
            self.hud = nil
            
        }, onError: { (error) in
            self.hud?.removeFromSuperview()
            self.hud = nil
            GDAlertView.alert("修改失败，请重试", image: nil, time: 1, complateBlock: nil)
            success?()
        }, onCompleted: {
            success?()
            mylog("结束")
            self.hud?.removeFromSuperview()
            self.hud = nil
           
        }) {
            mylog("回收")
        }
    }
    
    func requestDataList(success: (() -> ())?) {
        let orderid = self.orderID ?? ""
        let memberid = DDAccount.share.id ?? ""
        let paramete = ["start_at": self.startDay ?? "", "end_at": self.endDay ?? "", "token": DDAccount.share.token ?? "", "order_id": orderid, "member_id": memberid, "page": 1] as [String : Any]
        let router = Router.get("member/\(memberid)/ordermodifyview/\(orderid)", .api, paramete)
        
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<ChaxunResultModel>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    self.dataArr = data
                    
                    
                    success?()
                    
                    
                    //                    self.maskView.isHidden = true
                }else {
                    self.dataArr = []
                    //                    self.maskView.isHidden = false
                }
                
            }else if model?.status == 603 {
                //                self.maskView.isHidden = false
                if let data = model?.data {
                    //                    self.maskView.dataArr = data
                    
                    
                    
                }else {
                    self.dataArr = []
                    //                    self.maskView.titleLabel.text = "所选地区屏幕正在推广，请查看其它地区"
                    //                    self.maskView.isHidden = false
                }
            }
            self.calanderControl.subTitle = String.init(format: "%d", self.dataArr.count)
            self.tableView.reloadData()
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    var cover: DDCoverView?
    @objc func navigationBtnAction(sender: CustomControl) {
//        http://wap.bjyltf.cc/order?token=65df688f384b1889163a3906c9e8c9ec&order_id=36&start_at=2018-06-16&end_at=2018-06-30&request_types=modify
        let web = ClaanderWebVC()
        web.userInfo = DomainType.wap.rawValue + "order"
        web.start = self.startDay ?? ""
        web.end = self.endDay ?? ""
        web.orderID = self.orderID ?? ""
//        let token = DDAccount.share.token ?? ""
        web.is_update = self.is_update
        web.subUserInfo = "&order_id=\(self.orderID ?? "")&start_at=\(self.startDay ?? "")&end_at=\(self.endDay ?? "")&request_types=modify"
        self.navigationController?.pushViewController(web, animated: true)
        
    }
    @objc func calanderBtn(sender: InstallBtn) {
        if self.cover != nil {
            self.cover?.removeFromSuperview()
            self.cover = nil
            sender.isSelected = false
            return
        }
        sender.isSelected = !sender.isSelected
    
        let pickerContailerH: CGFloat = SCREENHEIGHT * 0.7
        let pickerContainer = SelectStartAndEndTime.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - pickerContailerH, width: SCREENWIDTH, height: pickerContailerH), dayCount: self.dayCount)
        cover = DDCoverView.init(superView: self.view.window!)
        cover?.deinitHandle = { [weak self] in
            sender.isSelected = false
            self?.cover?.removeFromSuperview()
            self?.cover = nil
        }
        self.cover?.addSubview(pickerContainer)
        let _ = pickerContainer.finished.subscribe(onNext: { [weak self](result) in
            if let days = result as? [DayModel] {
                let firstModel = days.first!
                let lastModel = days.last!
                self?.startDay = String.init(format: "%d-%02d-%02d", firstModel.year ?? 2018, firstModel.month ?? 2, firstModel.day ?? 2)
                self?.endDay = String.init(format: "%d-%02d-%02d", lastModel.year ?? 2018, lastModel.month ?? 2, lastModel.day ?? 2)
                let time = (self?.startDay ?? "") + "-" + (self?.endDay ?? "")
                self?.timeBtn.setTitle(time, for: .normal)
                self?.timeBtn.isSelected = false
                self?.requestDataList(success: nil)
            }
            }, onError: nil, onCompleted: {[weak self] in
                self?.cover?.removeFromSuperview()
                self?.cover = nil
            }, onDisposed: nil)
    }
    
    func configTable() {
        self.tableView.register(UINib.init(nibName: "ChaXunResultCell", bundle: Bundle.main), forCellReuseIdentifier: "ChaXunResultCell")
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 110
        self.view.addSubview(self.tableView)
        self.calanderControl.backgroundColor = UIColor.clear
        
    
    }
    var dataArr: [ChaxunResultModel] = [ChaxunResultModel]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChaXunResultCell = tableView.dequeueReusableCell(withIdentifier: "ChaXunResultCell", for: indexPath) as! ChaXunResultCell
        cell.priceTitile.isHidden = true
        cell.price.isHidden = true
        cell.model = self.dataArr[indexPath.row]
        cell.addBtn.isHidden = true
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 40), style: UITableView.Style.plain)
    let timeBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 160, height: 30))
    let trueChange = UIButton.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 40, width: SCREENWIDTH, height: 40))
    lazy var calanderControl: CustomControl = {
        let control = CustomControl.init(frame: CGRect.zero)
        control.addTarget(self, action: #selector(navigationBtnAction(sender:)), for: .touchUpInside)
        control.backgroundColor = UIColor.clear
        control.style = .CornerMarkImageWithSubtitle
        control.subTitleColor = UIColor.white
        control.subTitleBackColor = UIColor.colorWithHexStringSwift("ea6761")
        control.image = UIImage.init(named: "calendar")
        self.view.addSubview(control)
        control.frame = CGRect.init(x: SCREENWIDTH - 70, y: SCREENHEIGHT - 150, width: 50, height: 50)
        return control
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
