//
//  DDSelectLiveAreaView.swift
//  Project
//
//  Created by WY on 2019/8/10.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSelectedAddressModel: DDActionModel,Codable {
    
    var area_name = ""
    var shop_number : Int = 0
    var item : [DDSelectedAddressModel]?
    //    var isSelected: Bool? = false
    
    var id : String  = "0"
    var name = ""
    var isSelected: Bool? = false
}


private let itemW = SCREENWIDTH / 3
class DDSelectLiveAreaView: DDAlertContainer {
    var selectComplated : ((String,String  ) -> Void )?
    
    enum AddressType : Int {
        case County
        case province
        case city
        case area
        case street
    }
    let bar1 = DDNavigationItemBar.init(CGRect(x: 0, y: DDNavigationBarHeight, width: itemW, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), DDNavigationProvince.self)
    let bar2 = DDNavigationItemBar.init(CGRect(x: itemW, y: DDNavigationBarHeight, width: itemW, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), DDNavigationCity.self)
    let bar3 = DDNavigationItemBar.init(CGRect(x: itemW * 2, y: DDNavigationBarHeight, width: itemW, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), DDNavigationArea.self)
    var apiModel1 = ApiModel<[DDSelectedAddressModel]>()
    var apiModel2 = ApiModel<[DDSelectedAddressModel]>()
    var apiModel3 = ApiModel<[DDSelectedAddressModel]>()
//    var apiModel4 = ApiModel<[DDSelectedAddressModel]>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        if self.userInfo == nil  {
//            self.userInfo = "0"
//        }
        configBar(bar: bar1)
        bar1.whetherItemSizeAverage = false
        bar1.backgroundColor = .black
        configBar(bar: bar2)
        bar2.whetherItemSizeAverage = false
        bar2.backgroundColor = .lightGray
        configBar(bar: bar3)
        bar3.backgroundColor = .white
        bar3.whetherItemSizeAverage = false
        // Do any additional setup after loading the view.
        requestApi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type: String = ""
    func requestApi(addressType : AddressType = .County, parentID : String? = nil, finished: (() -> ())? = nil)  {
        DDRequestManager.share.getArea(type: ApiModel<[DDSelectedAddressModel]>.self, parent_id: parentID, success: { (apiModel) in
            switch addressType {
            case .County :
                self.apiModel1 = apiModel
                self.bar1.reloadData()
                break
            case .province :
                self.apiModel2 = apiModel
                self.bar2.selectedIndexPath = IndexPath(item: 0, section: 0 )
                self.apiModel3 = ApiModel<[DDSelectedAddressModel]>()
                self.bar3.reloadData()
                self.bar3.selectedIndexPath = IndexPath(item: 0, section: 0 )
                self.bar2.reloadData()
                break
            case .city :
                self.apiModel3 = apiModel
                self.bar3.selectedIndexPath = IndexPath(item: 0, section: 0 )
                self.bar3.reloadData()
                break
            case .area :
                break
            case .street:
                break
                //                    self.apiModel4 = apiModel
                //                    self.apiModel4.data?.forEach({ (model) in
                //                        model.isSelected = false
                //                    })
                //                    finished?()
                //TODO:这里还有一个功能要做。
                
                
            }
        }, failure: { (error ) in
            
        }) {
            
        }
        /*
        DDRequestManager.share.getArea(parent_id: parentID)?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<[DDSelectedAddressModel]>.self, from: response){
                switch addressType {
                case .County :
                    self.apiModel1 = apiModel
                    self.bar1.reloadData()
                    break
                case .province :
                    self.apiModel2 = apiModel
                    self.bar2.selectedIndexPath = IndexPath(item: 0, section: 0 )
                    self.apiModel3 = ApiModel<[DDSelectedAddressModel]>()
                    self.bar3.reloadData()
                    self.bar3.selectedIndexPath = IndexPath(item: 0, section: 0 )
                    self.bar2.reloadData()
                    break
                case .city :
                    self.apiModel3 = apiModel
                    self.bar3.selectedIndexPath = IndexPath(item: 0, section: 0 )
                    self.bar3.reloadData()
                    break
                case .area :
                    break
                case .street:
                    break
//                    self.apiModel4 = apiModel
//                    self.apiModel4.data?.forEach({ (model) in
//                        model.isSelected = false
//                    })
//                    finished?()
                    //TODO:这里还有一个功能要做。
                    
                    
                }
            }
        })
        */
        
    }
    var streetView: DDSelectedAreaSubView?
    func popStreetView(title: String, dataArr: [DDSelectedAddressModel]) {
        self.streetView = DDSelectedAreaSubView.init(frame: CGRect.init(x: 40, y: DDNavigationBarHeight + 20, width: SCREENWIDTH - 80, height: SCREENHEIGHT - DDNavigationBarHeight - 20 - TabBarHeight - 20), title: title, dataArr: dataArr)
        self.addSubview(self.streetView!)
        self.streetView?.dataArr = dataArr
        self.streetView?.cancleBtn.addTarget(self, action: #selector(cancleAction(sender:)), for: .touchUpInside)
    }
    @objc func cancleAction(sender: UIButton) {
        self.streetView?.removeFromSuperview()
        self.streetView = nil
    }
    
}

extension DDSelectLiveAreaView :  DDNavigationItemBarDelegate {
    func configBar(bar:DDNavigationItemBar)  {
        self.addSubview(bar)
        bar.delegate = self
        bar.selectedIndexPath = IndexPath(item: 0, section: 0)
        bar.scrollDirection = .vertical
    }
    func itemSizeOfNavigationItemBar(bar : DDNavigationItemBar) -> CGSize{
        return CGSize(width: itemW, height: 34)
    }
    func numbersOfNavigationItemBar(bar: DDNavigationItemBar) -> Int {
        switch bar  {
        case bar1:
            return self.apiModel1.data?.count ?? 0
        case bar2:
            return self.apiModel2.data?.count ?? 0
        case bar3:
            return self.apiModel3.data?.count ?? 0
        default:
            return 0
        }
    }
    func setParameteToItem(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
        switch bar  {
        case bar1:
            if let itemInstens = item as? DDNavigationProvince{
                itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
                if  let model = self.apiModel1.data?[indexPath.item] , bar.selectedIndexPath == indexPath{
                    self.requestApi(addressType: DDSelectLiveAreaView.AddressType.province, parentID: "\(model.id)")
                }
                itemInstens.label.text = self.apiModel1.data?[indexPath.item].name//dataSource of province
            }
        case bar2:
            if let itemInstens = item as? DDNavigationCity{
                itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
                itemInstens.label.text = self.apiModel2.data?[indexPath.item].name//dataSource of city
                if  let model = self.apiModel2.data?[indexPath.item] , bar.selectedIndexPath == indexPath{
                    self.requestApi(addressType: DDSelectLiveAreaView.AddressType.city, parentID: "\(model.id)")
                }
            }
        case bar3:
            if let itemInstens = item as? DDNavigationArea{
                itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
                itemInstens.label.text = self.apiModel3.data?[indexPath.item].name//dataSource of area
            }
        default:
            break
        }
        
    }
    func didSelectedItemOfNavigationItemBar(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
        if let itemInstens = item as? DDNavigationProvince{
            itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
            self.bar1.reloadData()
        } else if let itemInstens = item as? DDNavigationCity{
            itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
            self.bar2.reloadData()
        }else if item is DDNavigationArea{
//            if self.streetView != nil {
//                return
//            }
            if let arr = self.apiModel3.data {
                let model = arr[indexPath.row]
                let privance = self.apiModel1.data?[self.bar1.selectedIndexPath.item].name ?? ""
                let city = self.apiModel2.data?[self.bar2.selectedIndexPath.item].name ?? ""
                let area = self.apiModel3.data?[self.bar3.selectedIndexPath.item].name ?? ""
                self.selectComplated?(model.id , privance + city + area)
            }
        }
    }
}


extension DDSelectLiveAreaView {
    class DDNavigationProvince: DDNavigationItem {
        override var selectedStatus : Bool{
            didSet{
                if selectedStatus {
                    self.contentView.backgroundColor = UIColor.lightGray
                    self.label.textColor = .black
                }else{
                    self.contentView.backgroundColor = UIColor.black
                    self.label.textColor = .white
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.backgroundColor = .black
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDNavigationCity: DDNavigationItem {
        override var selectedStatus : Bool{
            didSet{
                if selectedStatus {
                    self.backgroundColor = UIColor.white
                    self.label.textColor = .black
                }else{
                    self.backgroundColor = UIColor.lightGray
                    self.label.textColor = .white
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDNavigationArea: DDNavigationItem {
        override var selectedStatus : Bool{
            didSet{
                if selectedStatus {
                    self.backgroundColor = UIColor.white
                }else{
                    self.backgroundColor = UIColor.white
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

