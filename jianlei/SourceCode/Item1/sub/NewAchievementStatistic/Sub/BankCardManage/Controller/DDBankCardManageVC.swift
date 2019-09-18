//
//  DDBankCardManageVC.swift
//  Project
//
//  Created by WY on 2019/8/23.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
private let BankBackColor = UIColor.colorWithHexStringSwift("#383f49")
class DDBankCardManageVC: DDNormalVC {
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    var apiModel = ApiModel<[DDBankCardModel]>()
    
    let noBankCardNoticeLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#383f49")
        self.tableView.backgroundColor = BankBackColor
        self.title = "bankCardManage"|?|
        let rightBtn = UIBarButtonItem.init(image: UIImage(named:"addBankCardicon"), style: UIBarButtonItem.Style.plain, target: self , action: #selector(addBankCardClick(sender:)))
        self.navigationItem.rightBarButtonItem = rightBtn
        _configSubviews()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false 
        }
//        self.view.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight)
        layoutNobankNotice()
        self.requestApi()
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }
    
    func switchNobankNoticeStatus(_ hidden:Bool) {
        self.noBankCardNoticeLabel.isHidden = hidden
    }
    func layoutNobankNotice() {
        self.view.addSubview(noBankCardNoticeLabel)
        noBankCardNoticeLabel.isHidden  = true 
//        switchNobankNoticeStatus(true)
        noBankCardNoticeLabel.numberOfLines = 4
        noBankCardNoticeLabel.textColor = UIColor.DDSubTitleColor
        noBankCardNoticeLabel.textAlignment = .center
        noBankCardNoticeLabel.text = "noBankCardTips"|?|
        noBankCardNoticeLabel.frame = CGRect(x: 40, y: DDNavigationBarHeight + 200, width: SCREENWIDTH - 80, height: 100)
    }
    func requestApi() {
        self.view.removeAllMaskView(maskClass: DDExceptionView.self)
        DDRequestManager.share.getBandkCard(type: ApiModel<[DDBankCardModel]>.self, success: { (apiModel) in
            self.apiModel = apiModel
            if let numberOrRows = self.apiModel.data?.count , numberOrRows > 0{
                self.switchNobankNoticeStatus(true )
            }else{
                self.switchNobankNoticeStatus(false)
                let vv = DDExceptionView()
                vv.exception = DDExceptionModel(title:"noBankCardTips"|?|,image:"notice_noinformation")
                vv.reloadButton.isHidden = true 
                self.view.alert(vv )
            }
            self.tableView.reloadData()
        }, failure: { (error ) in
            
        }) {
            
        }
    }
    func _configSubviews()  {
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight)// CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addBankCardClick(sender:UIBarButtonItem){
//        mylog("add bank card click")
//        let vc = DDAdBankCardVC()
        let alertview = PersonalOrCompanySheet()
        alertview.selectedCompleted = {
            if $0 == 1{//个人
                let vc = DDAdBankCardVC()
                vc.doneHandle = {self.requestApi()}
                self.navigationController?.pushViewController(vc, animated: true )
            }else{//公司
                let vc = DDAddCompanyBankCardVC()
                vc.doneHandle = {self.requestApi()}
                self.navigationController?.pushViewController(vc, animated: true )
            }
        }
        UIApplication.shared.keyWindow?.alert(alertview)
        /*
        return
        let personal = UIAlertAction(title: "个人账户", style: UIAlertAction.Style.default) { (action ) in
            let vc = DDAdBankCardVC()
            vc.doneHandle = {self.requestApi()}
            self.navigationController?.pushViewController(vc, animated: true )
        }
        let company = UIAlertAction(title: "公司账户", style: UIAlertAction.Style.default) { (action ) in
            let vc = DDAddCompanyBankCardVC()
            vc.doneHandle = {self.requestApi()}
            self.navigationController?.pushViewController(vc, animated: true )
        }
        self.alert(title: "银行卡类型", detailTitle: nil , style: UIAlertController.Style.actionSheet, actions: [personal , company])
        */
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    class BankCardCell: UITableViewCell {
        var model : DDBankCardModel = DDBankCardModel(){
            didSet{
                if let url  = URL(string:model.bank_logo) {
                    bankLogo.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }else{
                    bankLogo.image = DDPlaceholderImage
                }
//                if let url  = URL(string:model.bank_back ?? "") {
//                    backImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
//                }
//                else{
//                    backImage.image = DDPlaceholderImage
//                }
                bankName.text = model.bank_name
                bankType.text = "DebitCard"|?|
                bandCardNum.text = model.number.insertSplit(string: " ", perDistance: 4)
                if let type = model.type , type == "2"{
                    self.personalOrCompany.isHidden = false
                }else{
                    self.personalOrCompany.isHidden = true
                }
            }
        }
        weak var delegate : BankCardCellDelegate?
        let backImage = UIImageView()
        let bankLogo = UIImageView()
        let bankName = UILabel()
        let bankType = UILabel()
        let bandCardNum = UILabel()
        let UntieButton = UIButton()
        let personalOrCompany = UILabel()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(backImage)
            self.contentView.addSubview(bankLogo)
            self.contentView.addSubview(bankName)
            self.contentView.addSubview(bankType)
            self.contentView.addSubview(bandCardNum)
            self.contentView.addSubview(UntieButton)
            self.contentView.addSubview(personalOrCompany)
            self.contentView.backgroundColor = BankBackColor
            UntieButton.addTarget(self , action: #selector(untieButtonClick(sender:)), for: UIControl.Event.touchUpInside)
            bankName.textColor = .white
            bankType.textColor = .white
            bandCardNum.textColor = .white
            backImage.image = UIImage(named:"bankcard_back_image")
            bankName.text = "招商银行"
            bankType.text = "DebitCard"|?|
            bandCardNum.text = "**** **** **** 2238"
//            UntieButton.setTitle("解除绑定", for: UIControl.State.normal)
            UntieButton.setImage(UIImage(named:"unbind"), for: UIControl.State.normal)
//            UntieButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            bankLogo.image = UIImage(named:"installbusinessicons")
//            backImage.image = UIImage(named:"bankcardbackground_blue")
            personalOrCompany.backgroundColor = .red
            personalOrCompany.textColor = .white
            personalOrCompany.textAlignment = .center
            self.personalOrCompany.isHidden = true
            self.personalOrCompany.text = "companyAccount"|?|
            personalOrCompany.font = UIFont.systemFont(ofSize: 13)
            bankName.font = UIFont.systemFont(ofSize: 15)
            personalOrCompany.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            personalOrCompany.textColor = UIColor.colorWithHexStringSwift("#cf3a37")
        }
        @objc func untieButtonClick(sender:UIButton){
            self.delegate?.untieBankCard(cell: self )
        }
        
        /*
        override func layoutSubviews() {
            super.layoutSubviews()
            let logoMargin : CGFloat = 10
            backImage.frame = CGRect(x: 10, y: 0, width: self.contentView.bounds.width - 10 * 2, height: self.contentView.bounds.height - 20)
            bankLogo.frame = CGRect(x: backImage.frame.minX + logoMargin, y: backImage.frame.minY + logoMargin, width: 64, height: 64)
            bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
            bankLogo.layer.masksToBounds = true
            UntieButton.ddSizeToFit()
            let untieButtonW = UntieButton.bounds.width + 5
            UntieButton.frame = CGRect(x: self.contentView.bounds.width - 10 - untieButtonW - 10, y: bankLogo.frame.minY, width: untieButtonW, height: 30)
            bankName.frame = CGRect(x:bankLogo.frame.maxX + logoMargin, y: bankLogo.frame.minY, width: UntieButton.frame.minX - bankLogo.frame.maxX - logoMargin, height: 30)
            
            bankType.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: 100, height: 30)
            bandCardNum.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.maxY, width: self.contentView.bounds.width - bankName.frame.minX, height: 30)
        }
        */
        override func layoutSubviews() {
            super.layoutSubviews()
            let logoMargin : CGFloat = 10
            let bottomMargin : CGFloat = 10
            backImage.frame = CGRect(x: 10, y: 0, width: self.contentView.bounds.width - 10 * 2, height: self.contentView.bounds.height - bottomMargin)
            bankLogo.frame = CGRect(x: backImage.frame.minX + logoMargin, y: backImage.frame.minY + logoMargin, width: 64, height: 64)
            bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
            bankLogo.layer.masksToBounds = true
            personalOrCompany.ddSizeToFit()
//            let untieButtonW = UntieButton.bounds.width + 5
            UntieButton.frame = CGRect(x: backImage.frame.maxX -  40, y: 5, width: 40, height: 40)
//
//            personalOrCompany.frame = CGRect(x: self.contentView.bounds.width - 10 - untieButtonW - 10 - 10, y: bankLogo.frame.minY, width: untieButtonW + 10, height: 30)
//
            
//            bankName.sizeToFit()
            bankName.frame = CGRect(x:bankLogo.frame.maxX + logoMargin, y: bankLogo.frame.minY, width:UntieButton.frame.minX - bankLogo.frame.maxX - 10, height: 30)
            
//            personalOrCompany.frame = CGRect(x: bankName.frame.maxX + 10, y: bankLogo.frame.minY + 5, width: personalOrCompany.bounds.width + 10, height: bankName.bounds.height - 5 * 2)
            
//            bankName.frame = CGRect(x:bankLogo.frame.maxX + logoMargin, y: bankLogo.frame.minY, width: personalOrCompany.frame.minX - bankLogo.frame.maxX - logoMargin, height: 30)
            
            bankType.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: 100, height: 30)
            personalOrCompany.frame = CGRect(x: backImage.frame.maxX - personalOrCompany.bounds.width - 20, y: bankLogo.frame.midY , width: personalOrCompany.bounds.width + 10, height: 20)
            
            bandCardNum.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.maxY, width: self.contentView.bounds.width - bankName.frame.minX, height: 30)
//            UntieButton.frame = CGRect(x: self.contentView.bounds.width - 10 - untieButtonW - 10, y: bandCardNum.frame.minY, width: untieButtonW, height: 30)
            personalOrCompany.embellishView(redius: personalOrCompany.bounds.height/2)
            UntieButton.embellishView(redius: 5)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
protocol BankCardCellDelegate : NSObjectProtocol {
    func untieBankCard(cell : DDBankCardManageVC.BankCardCell)
}
extension DDBankCardManageVC : UITableViewDelegate , UITableViewDataSource , BankCardCellDelegate{
    struct JudgeModel: Codable {
        var status : Int
        var message : String
    }
    func untieBankCard(cell : DDBankCardManageVC.BankCardCell){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            let cancel = DDAlertAction(title: "cancel"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                //                print(action._title)
            })
            
            let sure = DDAlertAction(title: "sure"|?|, style: UIAlertAction.Style.default, handler: { (action ) in
                if let indexPath = self.tableView.indexPath(for: cell){
                    guard let model  = self.apiModel.data?[indexPath.row] else {return}
                    DDRequestManager.share.untieBankCard(type: JudgeModel.self, bankID: model.id, success: { (apiModel) in
                        if apiModel.status == 200 {
                            self.requestApi()
                        }else {
                            GDAlertView.alert(apiModel.message, image: nil , time: 2, complateBlock: nil )
                        }
                    },failure: {error in
                        GDAlertView.alert("server_data_type_error"|?|, image: nil , time: 2, complateBlock: nil )
                        return
                    })
                    
                }
            })
            let message1  = "askForUnband"|?|
            
            let alert = DDNotice1Alert(message: message1, backgroundImage: nil , image: nil , actions:  [cancel,sure])
            alert.titleLabel.textAlignment = .center
            alert.isHideWhenWhitespaceClick = false
            UIApplication.shared.keyWindow?.alert( alert)
            
        })
        
        
        
        
        
        /*
        
        let alertVC = UIAlertController.init(title: "askForUnband"|?|, message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancleAction = UIAlertAction.init(title: "cancel"|?|, style: UIAlertAction.Style.cancel) { (action ) in
            
        }
        let confirmAction = UIAlertAction.init(title: "sure"|?|, style: UIAlertAction.Style.destructive) { (action ) in
            
            if let indexPath = self.tableView.indexPath(for: cell){
                guard let model  = self.apiModel.data?[indexPath.row] else {return}
                DDRequestManager.share.untieBankCard(type: JudgeModel.self, bankID: model.id, success: { (apiModel) in
                    if apiModel.status == 200 {
                        self.requestApi()
                    }else {
                        GDAlertView.alert(apiModel.message, image: nil , time: 2, complateBlock: nil )
                    }
                },failure: {error in
                    GDAlertView.alert("server_data_type_error"|?|, image: nil , time: 2, complateBlock: nil )
                    return
                })
                
            }
        }
        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true , completion: nil )
        */
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOrRows = self.apiModel.data?.count , numberOrRows > 0{
//            switchNobankNoticeStatus(true )

            return numberOrRows
        }else{
//            switchNobankNoticeStatus(false)
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : BankCardCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as? BankCardCell{
            returnCell = cell
        }else{
            let cell = BankCardCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "systemCell")
            returnCell = cell
        }
        if let model = self.apiModel.data?[indexPath.row]{
            returnCell.model = model
        }
        returnCell.delegate = self
        returnCell.textLabel?.textColor = UIColor.DDSubTitleColor
        returnCell.selectionStyle = .none
        return returnCell
    }
}
