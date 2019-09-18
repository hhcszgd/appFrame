//
//  ToufangCity.swift
//  Project
//
//  Created by 张凯强 on 2019/9/20.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class SelectEducation: DDCoverView, UITableViewDelegate, UITableViewDataSource {
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(self.containerTable)
        self.addSubview(self.topView)
        self.topView.backgroundColor = UIColor.white
        self.topView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.containerTable.snp.top)
            make.height.equalTo(44)
        }
        self.topView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        self.topView.addSubview(self.cancleBtn)
        self.cancleBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(44)
        }
        self.cancleBtn.setImage(UIImage.init(named: "close"), for: UIControl.State.normal)
        self.cancleBtn.addTarget(self, action: #selector(cancleAction(sender:)), for: UIControl.Event.touchUpInside)
        containerTable.frame = CGRect.init(x: 0, y: SCREENHEIGHT - 300 - TabBarHeight - 40, width: SCREENWIDTH, height: 300)
        containerTable.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        containerTable.separatorColor = UIColor.clear
        self.addSubview(self.sureBtn)
         let loginBackImage = UIImage.init(gradientColors: [UIColor.colorWithHexStringSwift("ffcd34"), UIColor.colorWithHexStringSwift("ffab34")], bound: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 40))
        self.sureBtn.setBackgroundImage(loginBackImage, for: UIControl.State.normal)
        self.sureBtn.frame = CGRect.init(x: 0, y: self.containerTable.max_Y, width: SCREENWIDTH, height: 40)
        
    }
    deinit {
        mylog("ToufangCity销毁****************")
    }
    let topView = UIView.init()
    let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "")
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    let cancleBtn = UIButton.init()
    @objc func cancleAction(sender: UIButton) {
        self.remove()
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dataArr: [AreaModel] = [] {
        didSet{
            self.containerTable.reloadData()
        }
    }
    lazy var sureBtn : UIButton = {
        let btn = UIButton.init()
        btn.setTitle("sure"|?|, for: .selected)
        btn.setTitle("sure"|?|, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("323232"), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(sureAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var containerTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        table.register(ToufangCityCell.self, forCellReuseIdentifier: "ToufangCityCell")
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.white
        self.addSubview(table)
        return table
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ToufangCityCell = tableView.dequeueReusableCell(withIdentifier: "ToufangCityCell", for: indexPath) as! ToufangCityCell
       
        cell.model = self.dataArr[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataArr.forEach { (model) in
            model.isSelected = false
        }
        self.dataArr[indexPath.row].isSelected = true
        tableView.reloadData()
    }
    @objc func sureAction(sender: UIButton) {
        let bo = self.dataArr.filter { (model) -> Bool in
            return model.isSelected ?? false
        }.count == 0
        
        if bo {
            GDAlertView.alert("請選擇學歷", image: nil, time: 1, complateBlock: nil)
            return
        }
        let name = self.dataArr.filter { (model) -> Bool in
            return model.isSelected ?? false
        }.first?.name
        
        
        
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": token, "education": name ?? ""]
        let router = Router.put("member/\(id)", DomainType.api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<String>.self, from: response)
            if model?.status == 200 {
                self.selectFinished?(("", name ?? ""))
                self.remove()
                
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }) {
            GDAlertView.alert("重新上傳", image: nil, time: 1, complateBlock: nil)
        }
     
    }
    
    var selectFinished: (((String, String)) -> ())?
    //选定数据
    
    
    
    
    
}
class ToufangCityCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            
        }
        self.contentView.addSubview(self.rightBtn)
        self.rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
    
    }

    var model: AreaModel? {
        didSet{
            if model?.isSelected ?? false {
                self.rightBtn.isSelected = true
            }else {
                self.rightBtn.isSelected = false
            }
            
            self.rightBtn.setImage(UIImage.init(named: model?.rightImage ?? ""), for: .selected)
            
            self.myTitleLabel.text = model?.name
        }
    }
    @objc func configBtn(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.model?.isSelected = sender.isSelected
//        guard let mo = self.model else { return }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var myTitleLabel: UILabel = {
        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("323232"), text: "北京市")
        label.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(label)
        return label
    }()
    lazy var rightBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(), for: .normal)
        btn.addTarget(self, action: #selector(configBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
