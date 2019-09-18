//
//  DDShopVC.swift
//  Project
//
//  Created by WY on 2019/9/15.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit
import Alamofire
class DDItem2VC: DDNormalVC , UITextFieldDelegate{
    let noMsgNoticeLabel = UILabel()
    var naviBarStartShowH : CGFloat =  DDDevice.isFullScreen ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.isFullScreen ? 100 : 80
    var pageNum : Int  = 1
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    var apiModel : ApiModel<[DDMessageModel]> = {
       var api = ApiModel<[DDMessageModel]>()
//        var data = [DDMessageModel]()
//        for i in 0...5 {
//            let m = DDMessageModel()
//            if i%2 == 0 {
//                m.message_type = "1"
//            }else{
//                m.message_type = "2"
//            }
//            data.append(m )
//        }
//        api.data = data
        return api
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "tabbar_item2_title"|?|
        configNaviBar()
        self.configTableView()
        
        self.view.addSubview(noMsgNoticeLabel)
        noMsgNoticeLabel.frame = CGRect(x: 0, y: self.view.bounds.height/2, width: self.view.bounds.width, height: 44)
        noMsgNoticeLabel.textColor = UIColor.DDSubTitleColor
        self.switchNoMsgStatus(show: false)
        noMsgNoticeLabel.textAlignment = .center
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false 
        }
        self.requestApi(loadType: LoadDataType.reload)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestApi(loadType: LoadDataType.reload)
    }
    override func viewDidAppear(_ animated: Bool) {
//        let img = UIImage(named:"WechatIMG2")
//        mylog("old image size \(img?.size ) , byte \(img?.jpegData(compressionQuality: 1)?.count)")
//        let iii = img?.compressImageSize()
//        mylog("new image size \(iii?.size ) , byte \(iii?.jpegData(compressionQuality: 1)?.count)")
//        super.viewDidAppear(animated)
//        let vv = DDExceptionView()
//        vv.exception = DDExceptionModel(title:"adsfgasdgf",image:"profile_renzheng_bg_01")
//        vv.manualRemoveAfterActionHandle = {
//            mylog("reload action")
//        }
//        self.view.alert(vv )
    }
    func switchNoMsgStatus(show:Bool)  {
        if show {
            self.noMsgNoticeLabel.isHidden = false
        }else{
            self.noMsgNoticeLabel.isHidden = true
        }
    }
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        tableView.gdLoadControl?.loadHeight = 40
        tableView.contentInset = UIEdgeInsets(top: MARGIN/2, left: 0, bottom: 0, right: 0  )
       requestApi(loadType: LoadDataType.initialize)
        tableView.backgroundColor = VIEW_BACK_COLOR
    }
    @objc func loadMore() {
        requestApi(loadType: LoadDataType.loadMore)
    }
    func requestApi(loadType : LoadDataType )  {
        self.view.removeAllMaskView(maskClass: DDExceptionView.self)
        if loadType == .loadMore {
            pageNum += 1
        }else if loadType == .initialize{
            pageNum = 1
            noMsgNoticeLabel.text = "no_content"|?|
        }else{
            noMsgNoticeLabel.text = "no_search_content"|?|
            pageNum = 1
        }
        DDRequestManager.share.messagePage(type: ApiModel<[DDMessageModel]>.self, page: pageNum, success: { (apiModel ) in
            if loadType == .loadMore {
                if (apiModel.data?.count ?? 0) > 0{
                    self.apiModel.data?.append(contentsOf: apiModel.data!)
                    self.switchNoMsgStatus(show: false)
                }
            }
                //                else if loadType == .initialize{
                //                    if (apiModel.data?.count ?? 0) > 0{
                //                        self.switchNoMsgStatus(show: false)
                //                    }else{
                //                        self.switchNoMsgStatus(show: true)
                //                    }
                //                    self.apiModel = apiModel
                //                }
            else{
                //                    self.tableView.gdLoadControl?.showStatus = .idle
                if (apiModel.data?.count ?? 0) > 0{
                    self.switchNoMsgStatus(show: false)
                }else{
                    self.switchNoMsgStatus(show: true)
                }
                self.apiModel = apiModel
            }
            
            self.tableView.reloadData()
        }, failure: { (error ) in
                    let vv = DDExceptionView()
                    vv.exception = DDExceptionModel(title:"network_error_try_again"|?|,image:"notice_noinformation")
                    vv.manualRemoveAfterActionHandle = {
                        mylog("reload action")
                        self.requestApi(loadType: LoadDataType.initialize)
                    }
                    self.view.alert(vv )
        }) {
            if loadType == .loadMore {
                if (self.apiModel.data?.count ?? 0) > 0{
                    self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                }else{
                    self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                }
            }
        }
    }
    func configNaviBar() {

    }
    
  
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
            
        }
    }
    
}

extension DDItem2VC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.apiModel.data?[indexPath.row]{
            toWebView(messageID: model.id)
        }
    }
    
    @objc func toWebView(messageID:String) {
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: DomainType.wap.rawValue + "message/\(messageID)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.apiModel.data?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDMessageCell") as? DDMessageCell{
            cell.model = model
            return cell
        }else{
            let cell = DDMessageCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDMessageCell")
            cell.model = model
            return cell
        }
    }
}
import SDWebImage
extension DDItem2VC{
    class DDMessageCell : UITableViewCell {
        let backView = UIView()
        let icon  = UIImageView()
        let title = UILabel()
        let subTitle = UILabel()
        let time = UILabel()
        let messageStatus = UIView()
        var model : DDMessageModel? {
            didSet{
                
//                title.text = model?.id
                if let messageType = model?.message_type , messageType == "1"{
                    icon.image = UIImage(named:"message_notice")
                    title.text = "public_message"|?|
                }else{
                    icon.image = UIImage(named:"message_information")
                    title.text = "system_message"|?|
                }
                if let messageStatus  = model?.status , messageStatus == "1" {
                    self.messageStatus.isHidden = true
                }else{self.messageStatus.isHidden = false}
                subTitle.text = model?.title
                time.text = model?.create_at
            }
        }
        var keyWorld : String? = ""{
            didSet{
                
                if let title = model?.title, let keyWorkUnwrap = keyWorld{
                    let attributeStr = title.setColor(color: UIColor.red, keyWord: keyWorkUnwrap)
                    subTitle.attributedText = attributeStr
                }else{
//                    subTitle.attributedText = nil
//                    subTitle.text = model?.title
                }

            }
        }
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.backgroundColor = VIEW_BACK_COLOR
            self.selectionStyle = .none
            self.contentView.addSubview(backView)
            self.contentView.addSubview(icon)
            self.contentView.addSubview(messageStatus)
            self.contentView.addSubview(title)
            self.contentView.addSubview(subTitle)
            self.contentView.addSubview(time)
            time.textColor = CELL_SUBTITLE_COLOR
            messageStatus.backgroundColor = .red
            backView.backgroundColor = .white
            title.textColor = UIColor.DDTitleColor
            subTitle.textColor = CELL_SUBTITLE_COLOR
            title.font = F6
            time.font = F4
            subTitle.font = F4
            title.text = "name_in_message_page"|?|
            self.messageStatus.isHidden = true
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            backView.frame = CGRect(x: 0, y: MARGIN/2, width: self.bounds.width - 0, height: self.bounds.height - 2)
            let iconWH = backView.bounds.height  - MARGIN * 2
            icon.frame = CGRect(x:backView.frame.minX + margin , y:backView.frame.minY + MARGIN , width:iconWH, height:iconWH )
            title.ddSizeToFit()
            title.frame = CGRect(x: icon.frame.maxX + margin, y: icon.frame.minY , width: self.frame.width - margin - icon.frame.maxX - margin , height: title.font.lineHeight)
            subTitle.frame = CGRect(x: icon.frame.maxX + margin, y: icon.frame.maxY - subTitle.font.lineHeight , width: self.frame.width - margin - icon.frame.maxX - margin , height: subTitle.font.lineHeight)
            let messageStatusWH : CGFloat = 10
            messageStatus.frame = CGRect(x: icon.frame.maxX - messageStatusWH/2 , y: icon.frame.minY, width: messageStatusWH, height: messageStatusWH)
            messageStatus.layer.cornerRadius = messageStatusWH/2
            messageStatus.layer.masksToBounds = true
            time.sizeToFit()
            time.frame = CGRect(x: self.bounds.width - time.bounds.width - 15, y: title.frame.minY, width: time.bounds.width, height: time.bounds.height)
            backView.layer.cornerRadius = 5
//            backView.layer.masksToBounds = true
//            backView.layer.shadowColor = UIColor.lightGray.cgColor
//            backView.layer.shadowOffset = CGSize(width: 2, height: 4)
//            backView.layer.shadowOpacity = 0.5
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}
