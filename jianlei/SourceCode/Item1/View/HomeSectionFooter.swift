//
//  HomeSectionFooter.swift
//  YiLuMedia
//
//  Created by WY on 2019/9/9.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit
private  let shortDescribeLableFont = DDFont.systemFont(ofSize: 14)
private let topWhiteLineH :CGFloat =  10
private let aboutUsImageViewH : CGFloat  = 88 * SCALE

private let shortDescribeH : CGFloat  = 44
///shang xia jian ju
private let shortDescribeTextPaddingH : CGFloat  = 15

//private let hezuoImage1H : CGFloat  = 88 * SCALE
//private let hezuoImage2H : CGFloat  = 280 * SCALE
private let hezuoImage1H : CGFloat  = 0
private let hezuoImage2H : CGFloat  = 0
private let threeMargin : CGFloat = 30
private let describeTextMaxW = (SCREENWIDTH - 10 * 2) - 15 * 2
class HomeSectionFooter: UICollectionReusableView {
    var describeString  = ""{didSet{shortDescribeDetail.text = describeString}}
    
    let topWhiteLine = UIView()
    let aboutBackView = UIView()
    let aboutUsImageView = UIImageView()
    let shortDescribeLeft = UIView()
    let shortDescribe = UILabel()
    let shortDescribeRight = UIImageView()
    let shortDescribeDetail = UILabel()
    let hezuoImage1 = UIImageView()
    let hezuoImage2 = UIImageView()
    static func totalH(text:String) -> CGFloat {
        return 0
        let maxSize = text.sizeWith(font: shortDescribeLableFont, maxWidth: describeTextMaxW)
        return maxSize.height + topWhiteLineH + aboutUsImageViewH + shortDescribeH + hezuoImage1H + hezuoImage2H + threeMargin + shortDescribeTextPaddingH * 2
    }
    var textH :  CGFloat {
        get {
            let maxSize = describeString.sizeWith(font: shortDescribeLableFont, maxWidth: describeTextMaxW)
            return maxSize.height
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = VIEW_BACK_COLOR
        self.addSubview(topWhiteLine)
        self.addSubview(aboutBackView)
        self.addSubview(aboutUsImageView)
        self.addSubview(shortDescribeLeft)
        self.addSubview(shortDescribe)
        self.addSubview(shortDescribeRight)
        self.addSubview(shortDescribeDetail)
        self.addSubview(hezuoImage1)
        self.addSubview(hezuoImage2)
        topWhiteLine.backgroundColor = .white
        shortDescribeDetail.font = shortDescribeLableFont
        shortDescribeDetail.textColor = UIColor.lightGray
        aboutUsImageView.image = UIImage(named: "home_aboutus")
        shortDescribeRight.image = UIImage(named: "home_line")
        hezuoImage1.image = UIImage(named: "home_cooperativebrand")
        hezuoImage2.image = UIImage(named: "home_brands")
        aboutBackView.backgroundColor = .white
        shortDescribeLeft.backgroundColor = .orange
        shortDescribe.text = "home_company_describe_title"|?|
        shortDescribeDetail.numberOfLines = 0
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topWhiteLine.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: topWhiteLineH)
        mylog(describeTextMaxW)
        aboutUsImageView.frame = CGRect(x: 10, y: topWhiteLine.frame.maxY + 10, width: self.bounds.width - 20, height: aboutUsImageViewH)
        aboutBackView.frame = CGRect(x: 10, y: aboutUsImageView.frame.maxY, width: aboutUsImageView.frame.width, height: shortDescribeH + textH + shortDescribeTextPaddingH * 2 )
        shortDescribeLeft.frame = CGRect(x:aboutBackView.frame.minX + 15, y: aboutUsImageView.frame.maxY + (44 - 20 )/2, width: 3, height: 20)
        shortDescribe.sizeToFit()
        shortDescribe.frame = CGRect(x: shortDescribeLeft.frame.maxX + 8, y: aboutUsImageView.frame.maxY, width: shortDescribe.bounds.width, height: shortDescribeH)
        shortDescribeRight.frame = CGRect(x: shortDescribe.frame.maxX + 10, y: aboutUsImageView.frame.maxY + (44 - 8 )/2, width: aboutBackView.bounds.width - shortDescribe.frame.maxX , height: 8)
        shortDescribeDetail.frame = CGRect(x:aboutBackView.frame.minX +  15, y: shortDescribe.frame.maxY + shortDescribeTextPaddingH, width: describeTextMaxW, height: textH )
        hezuoImage1.frame = CGRect(x: 10, y: aboutBackView.frame.maxY + 10, width: aboutBackView.frame.width, height: hezuoImage1H)
        hezuoImage2.frame = CGRect(x: 10, y: hezuoImage1.frame.maxY, width: hezuoImage1.frame.width, height: hezuoImage2H)
        aboutBackView.layer.shadowOpacity  = 0.5
        aboutBackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        aboutBackView.layer.shadowColor = UIColor.gray.cgColor
        hezuoImage2.layer.shadowOpacity  = 0.5
        hezuoImage2.layer.shadowOffset = CGSize(width: 0, height: 4)
        hezuoImage2.layer.shadowColor = UIColor.gray.cgColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
