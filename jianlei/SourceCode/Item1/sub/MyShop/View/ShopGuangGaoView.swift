//
//  ShopGuangGaoView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class ShopGuangGaoView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            
            // Fallback on earlier versions
        }
        
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 0.4 * (frame.width - 26) + 26))
        view1.backgroundColor = UIColor.white
        self.addSubview(view1)
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 13, y: 13, width: frame.width - 26, height: 0.4 * (frame.width - 26)))
        view1.addSubview(imageView)
        self.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        imageView.image = UIImage.init(named: "title_bg")
        let label = UILabel.init(frame: CGRect.init(x: 13, y: imageView.height - 50, width: imageView.width - 26, height: 50))
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 0
        label.textColor =  UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        imageView.addSubview(label)
        label.text = "LED屏B屏廣告位每20分鐘10幀廣告由您獨立管理，您可以上傳自己店內的美髮作品、活動宣傳及產品介紹"
        
        
        let privateheight: CGFloat = SCALE * 40
        //图片规范
        let imageGuiFan = self.configTuPianGuiFan(title: "圖片規範", isHidden: false)
        imageGuiFan.frame = CGRect.init(x: 0, y: view1.max_Y, width: frame.width, height: privateheight)
        
        let guiFan1 = self.configTuPianGuiFanSubView(title: "1", subTitle: "格式：JPG、JPEG、PNG")
        guiFan1.frame = CGRect.init(x: 0, y: imageGuiFan.max_Y + 1, width: frame.width, height: privateheight)
        
        let guiFan2 = self.configTuPianGuiFanSubView(title: "2", subTitle: "尺寸：360 * 1080")
        guiFan2.frame = CGRect.init(x: 0, y: guiFan1.max_Y, width: frame.width, height: privateheight)
        
        let guifan3 = self.configTuPianGuiFanSubView(title: "3", subTitle: "大小： 5M以內，最多上傳30張")
        guifan3.frame = CGRect.init(x: 0, y: guiFan2.max_Y, width: frame.width, height: privateheight)
        
        let guifan4 = self.configTuPianGuiFanSubView(title: "4", subTitle: "展示區域：B屏")
        guifan4.frame = CGRect.init(x: 0, y: guifan3.max_Y, width: frame.width, height: privateheight)
        let guifan5Title = "禁止上傳：法律法規禁止播放的內容及暴力、恐怖、侵犯肖像、喪葬、逝者回憶錄、不雅、負能量等內容"
        let guifan5 = self.configTuPianGuiFanSubView(title: "5", subTitle: guifan5Title, isTop: true)
        let guifan5Size = guifan5Title.sizeWith(font: GDFont.boldSystemFont(ofSize: 14), maxWidth: frame.width - 56)
        guifan5.frame = CGRect.init(x: 0, y: guifan4.max_Y, width: frame.width, height: guifan5Size.height + 20)
        
        
        //当前展示
        
        let dangQian = self.configTuPianGuiFan(title: "當前展示", isHidden: true)
        dangQian.frame = CGRect.init(x: 0, y: guifan5.max_Y + 13, width: frame.width, height: 44)
        
        
        let imageCount = ShopInfoCell.init(frame: CGRect.init(x: 0, y: dangQian.max_Y + 1, width: frame.width, height: privateheight), title: "圖片數量")
        
        self.addSubview(imageCount)
        let lunBo = ShopInfoCell.init(frame: CGRect.init(x: 0, y: imageCount.max_Y + 1, width: frame.width, height: privateheight), title: "輪播週期")
        
        self.addSubview(lunBo)
        self.contentSize = CGSize.init(width: frame.width, height: lunBo.max_Y + DDSliderHeight + 44 + 20)
        self.lunbo = lunBo
        self.imageCount = imageCount
        
    }
    var lunbo: ShopInfoCell?
    var imageCount: ShopInfoCell?
    var zongDianData: ShopZongDianInfo<ShopInfoModel, FendianList>? {
        didSet {
            self.lunbo?.subTitleValue = (zongDianData?.shop_info?.loop_time ?? "")
            self.imageCount?.subTitleValue = (zongDianData?.shop_info?.image_num ?? "")
        }
    }
    var shopModel: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>? {
        didSet {
            self.lunbo?.subTitleValue = shopModel?.shop?.loop_time
            self.imageCount?.subTitleValue = shopModel?.shop?.image_num
        }
    }
    
    
    func configTuPianGuiFan(title: String, isHidden: Bool) -> UIView {
        let contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        let imageView = UIView.init()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
        imageView.backgroundColor = UIColor.colorWithHexStringSwift("ff7d09")
        let label = UILabel.configlabel(font: GDFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("323232"), text: title)
        label.sizeToFit()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        let rightImage = UIImageView.init()
        contentView.addSubview(rightImage)
       
        
        
        let button = UIButton.init()
        button.setTitle("查看展示的區域>>", for: UIControl.State.normal)
        button.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: UIControl.State.normal)
        button.setImage(UIImage.init(named: "examples"), for: UIControl.State.normal)
        button.titleLabel?.font = GDFont.systemFont(ofSize: 10)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        button.isHidden = isHidden
        button.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(self.frame.height)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        return contentView
        
    }
    @objc func btnClick(btn: UIButton) {
        let cover = DDCoverView.init(superView: self.window!)
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let imageView = UIImageView.init(image: UIImage.init(named: "examplespicture"))
        cover.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(imageView.image?.size.width ?? 0)
            make.height.equalTo(imageView.image?.size.height ?? 0)
        }
        cover.isHideWhenWhitespaceClick = true
    }
    
    
    func configTuPianGuiFanSubView(title: String, subTitle: String, isTop: Bool = false) -> UIView {
        let contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        let leftLabel = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 13), textColor: UIColor.white, text: title)
        leftLabel.backgroundColor = UIColor.colorWithHexStringSwift("feab5c")
        leftLabel.text = title
        
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.width.equalTo(20)
            make.height.equalTo(20)
            if isTop {
                make.top.equalToSuperview().offset(10)
            }else {
                make.centerY.equalToSuperview()
            }
           
        }
        leftLabel.textAlignment = .center
        
        let label = UILabel.configlabel(font: GDFont.boldSystemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: title)
    
        
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(10)
            make.top.equalToSuperview().offset(isTop ? 10 : 5)
            make.right.equalToSuperview().offset(-13)
            if !isTop {
                make.bottom.equalToSuperview().offset(-3)
            }
            
            
        }
        
        label.numberOfLines = 0
        label.text = subTitle
        
       
        
     
        return contentView
        
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
