//
//  ShopFendianView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class ShopFendianView: UITableView, UITableViewDelegate, UITableViewDataSource {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
//        NotificationCenter.default.addObserver(self, selector: #selector(addShopFinished), name: NSNotification.Name.init("AddShopInfoVC"), object: nil)
        self.configUI()
        self.cover = self.maskV()
        self.cover.isHidden = true
        self.cover.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    var cover: UIView!
    
    func maskV() -> UIView {
        let contentView = UIView.init()
        self.addSubview(contentView)
        
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "noshopinformation")
        contentView.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        contentView.addSubview(imageView)
        
        let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("999999"), text: "shop_fendian_no"|?|)
        contentView.addSubview(label)
        imageView.contentMode = UIView.ContentMode.center
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(imageView.image?.size.width ?? 0)
            make.height.equalTo(imageView.image?.size.height ?? 0)
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(13)
        }
        
        
        return contentView
    }
//    @objc func addShopFinished() {
//        self.refresh()
//
//    }
    @objc func refresh() {
        self.page = 1
        self.dataArr.removeAll()
        self.request()
    }
    @objc func loadMore() {
        self.page += 1
        self.request()
        
    }
    
    var shopID: String = "" {
        didSet {
            self.refresh()
        }
    }
    
    func request() {
        let token = DDAccount.share.token ?? ""
        let paramete = ["token": token, "headquarters_id": self.shopID, "page": String(self.page)]
        let router = Router.get("my-shop/get-branches", DomainType.api, paramete)
        let _ = NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<Model<FendianList>>.deserialize(from: dict)
            if let data = model?.data?.list, model?.status == 200, data.count > 0{
                self.gdLoadControl?.endLoad(result: GDLoadResult.success)
                self.gdRefreshControl?.endRefresh()
                self.gdLoadControl?.loadingStr = String.init(format: "shop_fendian_shopCount"|?|, model?.data?.total ?? "0")
//                self.gdLoadControl?.loadingImages = [UIImage.init()]
                if self.page == 1 {
                    self.gdLoadControl?.loadStatus = GDLoadStatus.idle
                    self.dataArr.removeAll()
                }else {
                    if data.count == 0 {
                        self.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                    }
                    
                }
                self.dataArr += data
                
            }else {
                self.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
            }
            if self.dataArr.count > 0 {
                self.cover?.isHidden = true
            }else {
                self.cover?.isHidden = false
            }
            self.reloadData()
        }, onError: { (_) in
            
        }, onCompleted: {
            
        }) {
            
        }
    }
    deinit {
//        NotificationCenter.default.removeObserver(self)
    }
    var page: Int = 1
    var dataArr: [FendianList] = [FendianList]() {
        didSet {
            self.reloadData()
        }
    }
    func configUI() {
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.colorWithHexStringSwift("f0f0f0")
        self.register(InstallHistoryCell.self, forCellReuseIdentifier: "InstallHistoryCell")
        self.register(InstallHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "InstallHistoryHeader")
        self.separatorStyle = .none
        self.gdLoadControl = GDLoadControl.init(target: self, selector: #selector(loadMore))
        self.gdRefreshControl = GDRefreshControl.init(target: self, selector: #selector(refresh))
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstallHistoryCell", for: indexPath) as! InstallHistoryCell
        
        cell.fenDianListModel = self.dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    
    class Model<T: HandyJSON>: GDModel {
        var list: [T]?
        var total: String?
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
