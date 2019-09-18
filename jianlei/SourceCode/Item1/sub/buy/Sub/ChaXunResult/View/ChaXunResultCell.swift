//
//  ChaXunResultCell.swift
//  Project
//
//  Created by 张凯强 on 2018/4/24.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class ChaXunResultCell: UITableViewCell {
    ///镜面数量
    @IBOutlet weak var mirrorNumber: UILabel!
    
    @IBOutlet weak var priceTitile: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var screen: UILabel!
    
    @IBOutlet var price: UILabel!
    
    @IBOutlet var status: UILabel!
    @IBOutlet var addBtn: UIButton!
    
    @IBOutlet var screenNum: UILabel!
    @IBOutlet var promptImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.addBtn.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        
        // Initialization code
    }
    var model: ChaxunResultModel? {
        didSet{
            if let image = model?.image_url {
                if let url = imgStrConvertToUrl(image) {
                    self.myImageView.sd_setImage(with: url)
                }
//                
            }
            self.screen.text = model?.advert_name
            self.addressLabel.text = model?.area_name

            self.price.text = "￥" + (model?.price ?? "")
            if (model?.cant_buy_date == nil) || (model?.cant_buy_date?.count == 0) {
                self.status.isHidden = true
                self.promptImage.isHidden = true
                model?.isEnable = true
                
            }else {
                if model?.cant_buy_date == "所选地区余量不足" {
                    model?.isEnable = false
                    
                }
                self.status.isHidden = false
                self.promptImage.isHidden = false
                self.status.text = model?.cant_buy_date
                
            }
            mylog(model)
            mylog(model?.isEnable)
            if let bo = model?.isEnable, bo {
                self.addBtn.isEnabled = true
                if model?.isSelected ?? false {
                    self.addBtn.isSelected = true
                    self.addBtn.isUserInteractionEnabled = false
                }else {
                    self.addBtn.isSelected = false
                    self.addBtn.isUserInteractionEnabled = true
                }
                
            }else {
                self.addBtn.isEnabled = false
            }
            
            
            
            
            self.screenNum.text = model?.screen_number
            self.mirrorNumber.text = "辐射镜面数" + "\(model?.mirror_number ?? "")" + "面"
            
            
        }
    }
    
    @IBOutlet var unitLabel: UILabel!
    
    var areaType: AreaType = AreaType.area {
        didSet{
            switch areaType {
            case .area:
                self.unitLabel.text = "台"
            case .city:
                self.unitLabel.text = "台"
            case .province:
                self.unitLabel.text = "台"
            
            }
        }
    }
    var clickFinish: ((UIButton, ChaxunResultModel) -> ())?
    @objc func addAction(sender: UIButton) {
        guard let mo = self.model else {
            return
        }
        self.clickFinish?(sender, mo)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
