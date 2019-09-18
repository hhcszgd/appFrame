//
//  DDChooseBankListVC.swift
//  Project
//
//  Created by WY on 2019/8/29.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class DDChooseBankListVC: DDNormalVC {
    var doneHandle : ((DDGetCsahApiDataModel)->())?
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    var apiModel = ApiModel<[DDBankCardModel]>()
    
    let noBankCardNoticeLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "chooseBankcardTitle"|?|
        _configSubviews()
        self.requestApi()
        // Do any additional setup after loading the view.
    }
    
    func requestApi() {
        DDRequestManager.share.getBandkCard(type: ApiModel<[DDBankCardModel]>.self, success: { (apiModel) in
            
            self.apiModel = apiModel
            self.tableView.reloadData()
        } , failure:{error in
            
        })
        
    }
    func _configSubviews()  {
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight) //  CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    class DDChooseBankCell: UITableViewCell {
        var model : DDBankCardModel = DDBankCardModel(){
            didSet{
                if let url  = URL(string:model.bank_logo) {
                    bankLogo.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }else{
                    bankLogo.image = DDPlaceholderImage
                }
                bankName.text = model.bank_name
                let bankNum  = model.number
                if bankNum.count >= 4{
                    let num = bankNum.suffix(from:bankNum.index(bankNum.endIndex, offsetBy: -4) )
                    self.bankNumber.text = "\("tailBankCardNumber"|?|) (\(num))"
                }else{
                    self.bankNumber.text = "\("tailBankCardNumber"|?|) (\(model.number))"
                }
                if let type = model.type , type == "2"{
                    self.accountType.isHidden = false
                }else{
                    self.accountType.isHidden = true
                }
            }
        }
        let getCashContainer : UIView = UIView()
        let bankLogo = UIImageView()
        let bankName = UILabel()
        let bankNumber = UILabel()
        let arrowBtn = UIButton()
        let accountType = UILabel()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(getCashContainer)
            getCashContainer.addSubview(bankLogo)
            getCashContainer.addSubview(bankName)
            getCashContainer.addSubview(bankNumber)
            getCashContainer.addSubview(arrowBtn)
            getCashContainer.addSubview(accountType)
            bankName.textColor = UIColor.DDSubTitleColor
            bankNumber.textColor = UIColor.DDSubTitleColor
            accountType.backgroundColor = .orange
            accountType.textColor = .white
            accountType.text = "companyAccount"|?|
            accountType.textAlignment = .center
            accountType.font = UIFont.systemFont(ofSize: 14)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let containerMargin : CGFloat = 10
            getCashContainer.frame = CGRect(x: containerMargin, y: containerMargin / 2, width: self.contentView.bounds.width - containerMargin * 2, height: self.contentView.bounds.height - containerMargin )
            getCashContainer.layer.borderWidth = 2
            getCashContainer.layer.borderColor = UIColor.DDLightGray.cgColor
            
            bankLogo.frame = CGRect(x: containerMargin, y: containerMargin, width: getCashContainer.bounds.height - containerMargin * 2, height: getCashContainer.bounds.height - containerMargin * 2)
            bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
            bankLogo.layer.masksToBounds = true
//            bankName.frame = CGRect(x: bankLogo.frame.maxX + 10, y: bankLogo.frame.minY, width: getCashContainer.bounds.width
//                - (bankLogo.frame.maxX + 10), height: 30)
//
//            bankNumber.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: bankName.frame.width, height: bankName.frame.height)
//
            arrowBtn.frame = CGRect(x: getCashContainer.bounds.width - 44 - containerMargin, y: bankLogo.frame.midY - 44/2, width: 44, height: 44)
            arrowBtn.setImage(UIImage(named:"enterthearrow"), for: UIControl.State.normal)
            
            bankName.frame = CGRect(x: bankLogo.frame.maxX + 10, y: bankLogo.frame.minY, width: arrowBtn.frame.minX
                - (bankLogo.frame.maxX + 10), height: 30)
            bankName.font = UIFont.systemFont(ofSize: 13)
            bankNumber.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: bankName.frame.width, height: bankName.frame.height)
            
            
            accountType.frame = CGRect(x: arrowBtn.frame.minX - 100, y: bankNumber.frame.minY + 2, width: 90, height: 25)
            accountType.layer.cornerRadius = accountType.bounds.height/2
            accountType.layer.masksToBounds = true
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    deinit {
        mylog("choose bank over ")
    }
}



extension DDChooseBankListVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.apiModel.data?[indexPath.row]{
            let tempModel = DDGetCsahApiDataModel()
            tempModel.id = model.id
            tempModel.bank_logo = model.bank_logo
            tempModel.number = model.number
            tempModel.bank_name = model.bank_name
            self.doneHandle?(tempModel)
            self.navigationController?.popViewController(animated: true )
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : DDChooseBankCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDChooseBankCell") as? DDChooseBankCell{
            returnCell = cell
        }else{
            let cell = DDChooseBankCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDChooseBankCell")
            returnCell = cell
        }
        if let model = self.apiModel.data?[indexPath.row]{
            returnCell.model = model
        }
        returnCell.textLabel?.textColor = UIColor.DDSubTitleColor
        returnCell.selectionStyle = .none
        return returnCell
    }
}
