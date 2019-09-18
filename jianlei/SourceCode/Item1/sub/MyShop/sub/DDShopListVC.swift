//
//  DDShopListVC.swift
//  Project
//
//  Created by WY on 2019/8/13.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDShopListVC: DDNormalVC {
    let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    var apiModel : ApiModel<[DDShopModel]>?
    var noShop : DDNoShopView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SL_shop_list_title"|?|
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.DDLightGray1
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight)
        tableView.dataSource = self
        tableView.delegate = self
        getShopList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func switchNoShopViewStatus(isShow:Bool)  {
        let vv = DDExceptionView()
        vv.reloadButton.isHidden = true
        vv.exception = DDExceptionModel(title:"SL_no_shop_pending_install"|?|,image:"notice_noinformation")
        self.view.alert(vv , isShow )
        
//        if isShow{
//            if noShop == nil {
//                let tempNoShop = DDNoShopView(frame: CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight))
//                self.noShop = tempNoShop
//                self.view.addSubview(tempNoShop)
//            }
//            self.noShop?.isHidden = false
//        }else{
//            self.noShop?.isHidden = true
//            self.noShop?.removeFromSuperview()
//            self.noShop = nil
//        }
    }
    func getShopList()  {
        DDRequestManager.share.getShopList(type: ApiModel<[DDShopModel]>.self , success: { (apiModel) in
            self.apiModel = apiModel
            self.switchNoShopViewStatus(isShow:  (apiModel.data?.count ?? 0) <= 0)
            self.tableView.reloadData()
        })
//        DDRequestManager.share.getShopList()?.responseJSON(completionHandler: { (response ) in
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<[DDShopModel]>.self, from: response){
//                mylog(response.value)
//                self.apiModel = apiModel
//                self.switchNoShopViewStatus(isShow:  (apiModel.data?.count ?? 0) <= 0)
////                if apiModel.data?.count > 0{
////
////                }
//                self.tableView.reloadData()
//            }
//        })
    }

}
extension DDShopListVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = apiModel?.data?[indexPath.row]
        let vc = MyShopVC()
        var shopType = "2"
        if let tempT = model?.shop_operate_type , tempT == "4"{
            
            shopType = "1"
        }

        vc.userInfo = ["shopID":model?.id ?? "", "type":shopType]//1总店 , 2分店
        self.navigationController?.pushViewController(vc , animated: true )
        mylog(indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDShopListCell") as? DDShopListCell{
            cell.model = self.apiModel?.data?[indexPath.row]
            return cell
        }else{
            let cell = DDShopListCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDShopListCell")
            cell.model = self.apiModel?.data?[indexPath.row]
            return cell
        }
    }
}
import SDWebImage
extension DDShopListVC{
    class DDShopListCell: UITableViewCell {
        let containerView = UIView()
        let shopLogo  = UIImageView()
        let shopName = UIButton()
        let shopStreet = UILabel()
        let shopDetailAddress = UILabel()
        let shopType = UILabel()
        var model : DDShopModel?{
            didSet{
                shopName.setTitle("  \(model?.name ?? "")", for: UIControl.State.normal)
                shopStreet.text = model?.area_name
                shopDetailAddress.text = model?.address
                shopLogo.setImageUrl(url: model?.shop_image , placeHolderImage: UIImage(named: "generalstorephoto"))
                switch model?.shop_operate_type {
                case "1":
                    shopType.text = "SL_zulin_title"|?|
                case "2":
                    shopType.text = "SL_ziying_title"|?|
                case "3":
                    shopType.text = "SL_liansuo_title"|?|
                case "4":
                    shopType.text = "SL_zongbu_title"|?|
                default:
                    break
                }
                self.layoutIfNeeded()
                self.setNeedsLayout()
            }
        }
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(containerView)
            self.containerView.addSubview(shopLogo)
            self.containerView.addSubview(shopName)
            self.containerView.addSubview(shopStreet)
            self.containerView.addSubview(shopDetailAddress)
            self.containerView.addSubview(shopType)
            self.containerView.backgroundColor = UIColor.white
            shopName.isUserInteractionEnabled = false
            self.shopLogo.backgroundColor = UIColor.DDLightGray
            self.shopLogo.image = UIImage(named: "generalstorephoto")
            shopName.contentHorizontalAlignment = .left
            shopName.setImage(UIImage(named:"shopImage"), for: UIControl.State.normal)
            self.contentView.backgroundColor = UIColor.DDLightGray1
            self.selectionStyle = .none
            self.shopType.textAlignment  =  .center
            shopType.textColor = UIColor.orange
            shopStreet.font = UIFont.systemFont(ofSize: 15)
            shopDetailAddress.font = UIFont.systemFont(ofSize: 13)
            shopStreet.textColor = UIColor.gray
            shopDetailAddress.textColor = UIColor.lightGray
            shopName.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
//            self.setContent()
        }
//        func setContent()  {
//            shopName.setTitle("  this is shop name", for: UIControl.State.normal)
//            shopStreet.text = "privence-city-area-street"
//            shopDetailAddress.text = "address detail"
//            shopType.text = "pending install"
//        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let containerMargin : CGFloat = 16
            let subComponentsMargin : CGFloat = 8
            containerView.frame = CGRect(x: containerMargin, y: 0, width: self.bounds.width - containerMargin * 2, height: self.bounds.height - containerMargin)
//            containerView.embellishView(redius: 10)
            containerView.layer.cornerRadius = 10
            shopName.frame = CGRect(x: subComponentsMargin, y: subComponentsMargin, width: containerView.bounds.width - subComponentsMargin, height: 25)
            let logoY = shopName.frame.maxY + subComponentsMargin
            shopLogo.frame = CGRect(x: subComponentsMargin, y:logoY, width: containerView.bounds.height - logoY - subComponentsMargin, height: containerView.bounds.height - logoY - subComponentsMargin)
            
            shopStreet.frame = CGRect(x: shopLogo.frame.maxX + subComponentsMargin, y: shopLogo.frame.minY, width: containerView.bounds.width - shopLogo.frame.maxX - subComponentsMargin, height: 25)
            shopDetailAddress.frame = CGRect(x: shopLogo.frame.maxX + subComponentsMargin, y: shopStreet.frame.maxY, width: containerView.bounds.width - shopLogo.frame.maxX - subComponentsMargin, height: 20)
            shopType.sizeToFit()
            shopType.frame = CGRect(x: shopLogo.frame.maxX + subComponentsMargin, y: shopLogo.frame.maxY - 30, width: shopType.bounds.width + 20, height: 25)
//            shopType.embellishView(redius: shopType.bounds.height/2)
            shopType.layer.cornerRadius =  shopType.bounds.height/2
            
            shopType.layer.borderWidth = 1
            shopType.layer.borderColor = UIColor.orange.cgColor
            
            containerView.layer.shadowOpacity = 0.6
            containerView.layer.shadowOffset = CGSize(width: 0, height: 2.5)
            containerView.layer.shadowColor = UIColor.gray.cgColor
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}

class DDShopModel : NSObject , Codable {
    var address : String?
    var area_name : String?
    var name  : String?
    var id  : String?
    var shop_image  : String?
    ///1租赁店,2自营店,3连锁店,4总店
    var shop_operate_type  : String?

}
class DDNoShopView: UIView {
    let image = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(image)
        self.addSubview(label)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.lightGray
        image.image = UIImage(named: "notice_noinformation")
        image.contentMode = .scaleAspectFill
        label.text = "SL_no_shop_pending_install"|?|
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageX : CGFloat = 111
        image.frame = CGRect(x: imageX, y: 100, width: self.bounds.width - imageX * 2, height: self.bounds.width - imageX * 2)
        label.frame = CGRect(x: 0, y: image.frame.maxY + 20, width: self.bounds.width, height: 20)
    }
}
