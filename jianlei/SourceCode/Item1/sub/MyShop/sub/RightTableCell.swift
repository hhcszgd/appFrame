//
//  RightTableCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class RightTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(1)
        }
        
        
        // Initialization code
    }
    @IBOutlet var title: UILabel!
    var model: TimeModel? {
        didSet{
            guard let myModel = self.model else {
                return
            }
            switch model?.title ?? "" {
            case "01":
                self.title.text = "一月"
            case "02":
                self.title.text = "二月"
            case "03":
                self.title.text = "三月"
            case "04":
                self.title.text = "四月"
            case "05":
                self.title.text = "五月"
            case "06":
                self.title.text = "六月"
            case "07":
                self.title.text = "七月"
            case "08":
                self.title.text = "八月"
            case "09":
                self.title.text = "九月"
            case "10":
                self.title.text = "十月"
            case "11":
                self.title.text = "十一月"
            case "12":
                self.title.text = "十二月"
        
            default:
                break
            }
            
            if myModel.isSelected {
                self.title.textColor = UIColor.colorWithHexStringSwift("ea9061")
                
            }else {
                self.title.textColor = UIColor.colorWithHexStringSwift("333333")
            }
        }
    }
    
    
    var statusModel: StatusModel? {
        didSet{
            guard let myModel = self.statusModel else {
                return
            }
            self.title.text = myModel.title
            if myModel.isSelected {
                self.title.textColor = UIColor.colorWithHexStringSwift("ea9061")
                self.lineView.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
                
            }else {
                self.title.textColor = UIColor.colorWithHexStringSwift("333333")
                self.lineView.backgroundColor = UIColor.clear
            }
        }
    }
    lazy var lineView: UIView = {
        let view = UIView.init()
        self.contentView.addSubview(view)
        return view
    }()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
class StatusModel: GDModel {
    var isSelected: Bool = false
    var title: String = ""
    var status: Int?
    init(title: String, isSelected: Bool, status: Int?) {
        super.init()
        self.title = title
        self.isSelected = isSelected
        self.status = status
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
