//
//  BussInessView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/2.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class BussInessView: UIView {

    let myTitleLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    let leftImage: UIImageView = UIImageView.init()
    let countLabel = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("ff8302"), text: "")
    let company = UILabel.configlabel(font: GDFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    let lineView = UIView.init()
    init(frame: CGRect, title: String, image: String, count: String, des: String) {
        super.init(frame: frame)
        self.addSubview(myTitleLabel)
        self.addSubview(self.leftImage)
        self.addSubview(countLabel)
        self.addSubview(self.company)
        self.addSubview(lineView)
        let img = UIImage.init(named: image)
        self.leftImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(img?.size.width ?? 0)
            make.height.equalTo(img?.size.height ?? 0)
        }
        self.leftImage.image = img
        self.myTitleLabel.sizeToFit()
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftImage.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        self.myTitleLabel.text = title
        self.countLabel.text = count
        self.countLabel.sizeToFit()
        self.countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.company.snp.left).offset(-20)
            make.centerY.equalToSuperview()
        }
        self.company.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
        self.company.sizeToFit()
        self.company.text = des
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            
        }
        self.lineView.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
class DDCircleButton: UIControl {
    let numberLable = UILabel()
    let titleLable = UILabel()
    let backImage = UIImageView(image: UIImage(named: "money_ring"))
    override init(frame: CGRect ) {
        super.init(frame: frame)
        self.addSubview(numberLable)
        self.addSubview(titleLable)
        self.addSubview(backImage)
        numberLable.textAlignment = .center
        titleLable.textAlignment = .center
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding : CGFloat = 20
        let imageWH : CGFloat = self.bounds.width - padding * 2
        let ImageX = padding
        let ImageY = padding
        
        let titleH : CGFloat = 30
        let titleY : CGFloat = self.bounds.height - titleH - padding
        backImage.frame = CGRect(x: ImageX, y: ImageY, width: imageWH, height: imageWH)
        numberLable.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
        numberLable.center = backImage.center
        titleLable.frame = CGRect(x: 0, y: titleY, width: self.bounds.width, height: titleH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
