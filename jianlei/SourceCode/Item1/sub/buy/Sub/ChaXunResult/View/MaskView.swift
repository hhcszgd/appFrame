//
//  MaskView.swift
//  Project
//
//  Created by 张凯强 on 2018/4/28.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class MaskView: UIView {

    let titleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickTap(tap:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        self.titleLabel.isUserInteractionEnabled = true
        self.titleLabel.sizeToFit()
        self.backgroundColor = UIColor.white
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            
        }
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
    }
    var dataArr: [ChaxunResultModel] = [] {
        didSet{
            var areaName: String = ""
            //不选中全国上传选中的市
            
            for (_, model) in dataArr.enumerated() {
                areaName += (model.area_name ?? "") + ","
            }
            if areaName.hasSuffix(",") {
                areaName = String(areaName.prefix(areaName.count - 1))
//                areaName.substring(to: areaName.index(areaName.endIndex, offsetBy: -1))
            }
            let title = "您选择的区域还没有屏幕\n请点击\(areaName)查看对应区域屏幕业务"
            self.titleLabel.text = "您选择的区域还没有屏幕\n请点击\(areaName)查看对应区域屏幕业务"
            let range = title.range(of: areaName)
            
            if let startRange = range {
                 let start = startRange.lowerBound.encodedOffset
                let attribute = NSMutableAttributedString.init(string: title)
                attribute.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithHexStringSwift("ea9061")], range: NSRange.init(location: start, length: areaName.count))
                self.titleLabel.attributedText = attribute
            }

            
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var finished: ((String) -> ())?
    @objc func clickTap(tap: UIGestureRecognizer) {
        var area: String = ""
        var areaName: String = ""
        //不选中全国上传选中的市
        for (_, model) in self.dataArr.enumerated() {
            area += (model.area_id ?? "") + ","
        }
        if area.hasSuffix(",") {
            area = area.substring(to: area.index(area.endIndex, offsetBy: -1))
        }
        self.finished?(area)
    }
}
