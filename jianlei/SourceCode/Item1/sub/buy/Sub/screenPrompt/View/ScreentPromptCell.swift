//
//  ScreentPromptCell.swift
//  Project
//
//  Created by 张凯强 on 2018/3/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ScreentPromptCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.subTitle.font = GDFont.boldSystemFont(ofSize: 14)
        // Initialization code
    }
    @IBOutlet var subTitle: UILabel!
    
    @IBOutlet var backView: UIView!
    var model: AdvertisModel? {
        didSet{
            self.mytitle.text = model?.name
            self.subTitle.text = model?.describe
            self.timeValue.text = model?.time
            self.sizelable.text = model?.rateStr
            self.formatLabel.text = model?.spec
            
            self.frequency.text = model?.format
        }
    }
    var propmtModel: PromptModel? {
        didSet {
            self.mytitle.text = propmtModel?.name
            self.subTitle.text = propmtModel?.describe
            self.timeValue.text = propmtModel?.time
            self.sizelable.text = propmtModel?.rate
            self.formatLabel.text = propmtModel?.spec
            self.frequency.text = model?.format
            
        }
    }
    @IBOutlet var mytitle: UILabel!
    @IBOutlet var timeValue: UILabel!
    
    @IBOutlet var sizelable: UILabel!
    
    @IBOutlet var formatLabel: UILabel!
    
    @IBOutlet var frequency: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
