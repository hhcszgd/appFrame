//
//  AuthenticWithoutApplayVC.swift
//  YiLuMedia
//
//  Created by WY on 2019/9/10.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class DDNotAuthenticateVC: DDInternalVC {
    let backgroundImage = UIImageView(image: UIImage(named: "profile_renzheng_bg_01"))
    let topLogo =  UIImageView(image: UIImage(named: "profile_renzheng_not_apply"))
    let topLabel = UILabel()
    let midBackview = UIView()
    fileprivate let row1 = DDRowViewNotAuthenticate()
    fileprivate let row2 = DDRowViewNotAuthenticate()
    fileprivate let row3 = DDRowViewNotAuthenticate()
    private let bottomButton = UIButton()
    private let bottomLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.backgroundColor = .clear
        let attributeTitle : NSMutableAttributedString = NSMutableAttributedString(string: "not_authenticate_navi_title"|?|)
        attributeTitle.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(0, attributeTitle.string.count))
        self.naviBar.attributeTitle = attributeTitle
        naviBar.backBtn.setImage(UIImage(named:"profile_return_white"), for: UIControl.State.normal)
        // Do any additional setup after loading the view.
        _addSubviews()
        _layoutSubviews()
    }
    func _addSubviews() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(topLogo)
        self.view.addSubview(topLabel)
        self.view.addSubview(midBackview)
        self.view.addSubview(row1)
        self.view.addSubview(row2)
        self.view.addSubview(row3)
        self.view.addSubview(bottomButton)
        self.view.addSubview(bottomLabel)
        topLabel.text = "not_authenticate_content_title"|?|
        topLabel.font = DDFont.boldSystemFont(ofSize: 18)
        topLabel.textColor = UIColor.colorWithHexStringSwift("dfca88")
        topLabel.textAlignment = .center
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.text = "not_authenticate_notice"|?|
        bottomLabel.font = DDFont.systemFont(ofSize: 14)
        row1.model = ("profile_guarantee","not_authenticate_power1"|?|,"Guarantee legitimate rights and interests")
        row2.model = ("profile_enjoy","not_authenticate_power2"|?|,"Enjoy more privileges")
        row3.model = ("profile_increase","not_authenticate_power3"|?|,"Increasing Income")
        bottomButton.setTitle("not_authenticate_perform"|?|, for: UIControl.State.normal)
        bottomButton.backgroundColor = UIColor.black
        midBackview.backgroundColor = .white
        bottomButton.addTarget(self , action: #selector(buttonButtomAction(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func buttonButtomAction(sender:UIButton)  {
        let vc = DDPersonInfoVC()
        vc.personalInfo = DDAuthenticateInfo()
        self.navigationController?.pushViewController(vc , animated: true )
    }
    func _layoutSubviews()  {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
        let topLogoWH : CGFloat = 88 * SCALE
        topLogo.frame = CGRect(x:(view.bounds.width - topLogoWH)/2 , y: backgroundImage.frame.midY - topLogoWH, width: topLogoWH, height: topLogoWH)
        topLabel.frame = CGRect(x:0 , y: topLogo.frame.maxY + 20, width: self.view.bounds.width, height: topLabel.font.lineHeight)
        let midBackviewX : CGFloat = 20
        let midBackviewH : CGFloat = SCREENWIDTH * 0.6
        midBackview.frame = CGRect(x: midBackviewX, y: topLabel.frame.maxY + 40, width: view.bounds.width - midBackviewX * 2, height: midBackviewH)
        midBackview.layer.cornerRadius = 6
        midBackview.layer.shadowOpacity = 0.5
        midBackview.layer.shadowColor = UIColor.gray.cgColor
        midBackview.layer.shadowOffset = CGSize(width: 0, height: 5)
        let rowx : CGFloat = midBackview.frame.minX + 20
        let rowTopBottomMargin : CGFloat = 20
        let row1Y = midBackview.frame.minY + rowTopBottomMargin
        let rowMargin : CGFloat = 15
        
        let rowH : CGFloat = (midBackviewH - rowTopBottomMargin * 2 - rowMargin * 2) / 3
        let rowW = midBackview.bounds.width - 20
        
        row1.frame = CGRect(x: rowx, y: row1Y, width: rowW, height: rowH)
        row2.frame = CGRect(x: rowx, y: row1Y + rowH + rowMargin, width: rowW, height: rowH)
        row3.frame = CGRect(x: rowx, y: row1Y + (rowH + rowMargin) * 2, width: rowW, height: rowH)
        
        
        bottomButton.frame = CGRect(x: 15, y: midBackview.frame.maxY + 30, width: view.bounds.width - 30, height: 40)
        bottomButton.layer.cornerRadius = bottomButton.bounds.height/2
        bottomLabel.frame = CGRect(x: 0, y: bottomButton.frame.maxY + 20, width: view.bounds.width , height: 25)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
fileprivate class DDRowViewNotAuthenticate: UIView {
    var model : (image:String,title:String,subtitle:String) = (image:"",title:"",subtitle:"") {
        didSet{
            logo.image = UIImage(named: model.image)
            titleLabel.text = model.title
            subtitleLabel.text = model.subtitle
        }
    }
    
    private let logo = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.addSubview(logo)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        titleLabel.font = DDFont.systemFont(ofSize: 15)
        subtitleLabel.font = DDFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.DDTitleColor
        subtitleLabel.textColor = UIColor.DDSubTitleColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        logo.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
        let labelX = logo.frame.maxX + 10
        titleLabel.frame = CGRect(x: labelX, y: 5, width: self.bounds.width - labelX, height: titleLabel.font.lineHeight)
        subtitleLabel.frame = CGRect(x: labelX, y: self.bounds.height - subtitleLabel.font.lineHeight - 5, width: titleLabel.bounds.width, height: subtitleLabel.font.lineHeight)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DDAuthenticateInfo: Codable {
    var sex : String?
    var name : String?
    var id_number  : String?
    var id_front_image  : String?
    var id_back_image  : String?
    var id_hand_image  : String?
    ///审核状态(-1、待提交 0、待审核 1、审核通过 2、审核不通过)
    var examine_status : String?
    var examine_desc : String?
    var avatar : String?
}
