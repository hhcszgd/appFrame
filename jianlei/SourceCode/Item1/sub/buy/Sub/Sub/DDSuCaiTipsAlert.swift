//
//  DDSuCaiTipsAlert.swift
//  Project
//
//  Created by WY on 2018/3/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSuCaiTipsAlert: DDCoverView {

    let contentView = UIView()
    let titleLable = UILabel()
    let line = UIView()
    let suCaiDescrip = UILabel()
    let suCaiPara1 = UILabel()
    let suCaiPara2 = UILabel()
    let suCaiPara3 = UILabel()
    ///    var format : String? = ""
    ///var spec  : String? = ""
    ///var size  : String? = ""
    var tips : (format : String? ,spec  : String?,size  : String?) = (format : nil  ,spec  : nil ,size  : nil ){
        didSet{
                suCaiPara1.text = "广告素材尺寸:\(tips.spec ?? "")"
                suCaiPara2.text = "支持的广告素材格式: \(tips.format ?? "png")"
                suCaiPara3.text = "图片大小: \(tips.size ?? "100")以内"
            }
    }
    
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(contentView)
        contentView.backgroundColor = .black
        self.contentView.addSubview(titleLable)
        titleLable.numberOfLines = 2
        titleLable.textColor = .white
        titleLable.textAlignment = .center
        titleLable.text = "支付成功后,您需要尽快提交广告素材\n以免耽误广告投放进度"
        self.contentView.addSubview(line)
        line.backgroundColor = .white
        self.contentView.addSubview(suCaiDescrip)
        suCaiDescrip.text = "素材说明"
        suCaiDescrip.textColor = .white
        self.contentView.addSubview(suCaiPara1)
//        suCaiPara1.text = "广告素材尺寸:480*1080"
        suCaiPara1.text = "广告素材尺寸:\(tips.size ?? "")"
        suCaiPara1.adjustsFontSizeToFitWidth = true
        suCaiPara2.adjustsFontSizeToFitWidth = true
        suCaiPara3.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(suCaiPara2)
//        suCaiPara2.text = "支持的广告素材格式: JPG、JPEG、PNG"
        suCaiPara2.text = "支持的广告素材格式: \(tips.format ?? "png")"
        self.contentView.addSubview(suCaiPara3)
//        suCaiPara3.text = "图片大小: 50kb以内"
        suCaiPara3.text = "图片大小: \(tips.size ?? "100")以内"
        suCaiPara1.textColor = .white
        suCaiPara2.textColor = .white
        suCaiPara3.textColor = .white
        suCaiPara1.font = GDFont.systemFont(ofSize: 14)
        suCaiPara2.font = GDFont.systemFont(ofSize: 14)
        suCaiPara3.font = GDFont.systemFont(ofSize: 14)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 40
        let contentViewW = self.bounds.width - toBorder * 2
        let contentViewH : CGFloat = 230
        contentView.frame = CGRect(x: toBorder, y: self.bounds.height / 2 - contentViewH, width: contentViewW, height: contentViewH)
        titleLable.frame =  CGRect(x: 0, y: 10, width: contentViewW, height: 44)
        line.frame = CGRect(x: 10, y: titleLable.frame.maxY + 10 , width: contentViewW - 10 * 2, height: 2)
        suCaiDescrip.frame =  CGRect(x: 10, y: line.frame.maxY, width: contentViewW - 10 * 2, height: 44)
        suCaiPara1.frame = CGRect(x: 10, y: suCaiDescrip.frame.maxY , width: contentViewW - 10 * 2, height: 34)
        suCaiPara2.frame = CGRect(x: 10, y: suCaiPara1.frame.maxY , width: contentViewW - 10 * 2, height: 34)
        suCaiPara3.frame = CGRect(x: 10, y: suCaiPara2.frame.maxY , width: contentViewW - 10 * 2, height: 34)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
