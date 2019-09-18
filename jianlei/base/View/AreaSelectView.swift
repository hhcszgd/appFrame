//
//  AreaSelectView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/11.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
enum GetAreaType: String {
    case area = "獲取公共地址"
}
import RxSwift
class AreaSelectView: DDCoverView, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    var areaType = AreaType.street
    lazy var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        self.addSubview(view)
        return view
    }()

    @objc func removeFrom() {
        UIView.animate(withDuration: 0.3, animations: {

        }) { (finished) in
            self.subFinished.onNext("finished")
            self.subFinished.onCompleted()
        }
    }
    var subFinished: PublishSubject<String> = PublishSubject<String>.init()
    var dataArr: [AreaModel] = []
    
    
    init(superView: UIView, areaType: GetAreaType, subFrame: CGRect = CGRect.zero, parent_id: String? = nil) {
        
        super.init(superView: superView)
        self.parentid = parent_id
        self.setUI(subFrame: subFrame)
    }


    func setUI(subFrame: CGRect) {
        self.containerView.frame = subFrame
        self.setTopScroll(frame: self.containerView.frame)
        self.topScroll.addSubview(self.selectBtn)
        let size = self.selectBtn.currentTitle?.sizeSingleLine(font: GDFont.systemFont(ofSize: 14)) ?? CGSize.init(width: 50, height: 3)
        let center = CGPoint.init(x: self.selectBtn.center.x, y: 38.5)
        self.lineView.center = center
        self.lineView.bounds = CGRect.init(x: 0, y: 0, width: size.width, height: 3)
        self.setCollectionView()
        if #available(iOS 10.0, *) {
            self.collectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        ///获取地区接口
        self.requestData(parentid: self.parentid) { (data) in
            if let dataArr = data {
                self.dataArr = dataArr
                self.countItem = 1
                self.collectionView.reloadData()
            }else {
                self.countItem = 0
                self.collectionView.reloadData()
            }
        }
        self.addSubview(self.sureBtn)
        self.sureBtn.frame = CGRect.init(x: (subFrame.size.width - 100) /  2.0, y: self.collectionView.max_Y + 3, width: 100, height: 35)
    }
    
    
    var parentid: String?

    func requestData(parentid: String?, success: @escaping (([AreaModel]?) -> ())) {
        let token = DDAccount.share.token ?? ""
        var paramete = ["token": token] as [String: Any]
        if let fatherid = parentid {
            paramete["parent_id"] = fatherid
        }
        let router: Router = Router.get("area", .api, paramete)
        NetWork.manager.requestData(router: router, success: { (response) in
            let data = DDJsonCode.decodeAlamofireResponse(ApiModel<[AreaModel]>.self, from: response)
            success(data?.data)
        }) {
            
        }
    }
    
    
    
    
    let margin: CGFloat = 10
    
    var topScroll: UIScrollView!
    func setTopScroll(frame: CGRect) {
        self.topScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 40))
        self.topScroll.delegate = self
        self.topScroll.isScrollEnabled = true
        self.topScroll.bounces = false
        self.topScroll.backgroundColor = UIColor.white
        
        self.containerView.addSubview(self.topScroll)
        
    }
    var collectionView: UICollectionView!
    func setCollectionView() {
        let flowLayout = UICollectionViewFlowLayout.init()
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: self.topScroll.max_Y, width: self.containerView.frame.size.width, height: self.containerView.size.height - self.topScroll.height), collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self 
        self.collectionView.register(UINib.init(nibName: "AreaSelectColCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AreaSelectColCell")
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = self.collectionView.bounds.size
        self.collectionView.isPagingEnabled = true
        self.containerView.addSubview(collectionView)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.countItem
    }
    var countItem: Int = 0
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AreaSelectColCell", for: indexPath) as? AreaSelectColCell else {
            return UICollectionViewCell.init()
        }
        
        cell.backgroundColor = UIColor.random
        cell.cellBlock = { [weak self](model) in
            self?.createBtn(model: model, index: indexPath.item)
            
        }
        switch indexPath.item {
        case 0:
            cell.dataArr = self.dataArr
        case 1:
            cell.dataArr = self.dataArr2
        case 2:
            cell.dataArr = self.dataArr3
        case 3:
            cell.dataArr = self.dataArr4
        default:
            break
        }
        
        return cell
    }
    
    var dataArr2: [AreaModel] = []
    var dataArr3: [AreaModel] = []
    var dataArr4: [AreaModel] = []
    var index: Int = 0
    
    ///创建按钮的tag并且取值
    var btnTag: Int {
        get {
            return self.index + 10000
        }
    }
    var oneAddress: String = ""
    var twoAddress: String = ""
    var threeAddress: String = ""
    var fourAddress: String = ""
    
    
    
    
    @objc func sureActon(btn: UIButton) {
        let address: String = self.oneAddress + self.twoAddress + self.threeAddress + self.fourAddress
        if let model = self.selectModel {
            self.finished.onNext((address, model.id ?? ""))
            self.finished.onCompleted()
            self.removeFrom()
            
        }else {
            GDAlertView.alert("请选择地区", image: nil, time: 1, complateBlock: nil)
        }
        
    }
    var selectModel: AreaModel?
    @objc func areaAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.lineView.center = CGPoint.init(x: btn.centerX, y: self.lineView.centerY)
            self.lineView.bounds = CGRect.init(x: 0, y: 0, width: btn.bounds.size.width, height: 3)
        })
        
        self.index = btn.tag - 10000
        self.collectionView.scrollToItem(at: IndexPath.init(item: self.index, section: 0), at: .left, animated: true)
    }
    
    @objc func selectBtnAction(btn: UIButton) {
        if self.countItem < 1 {
            return
        }
        let index = self.countItem - 1
        self.collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.lineView.center = CGPoint.init(x: btn.centerX, y: self.lineView.centerY)
            self.lineView.bounds = CGRect.init(x: 0, y: 0, width: btn.bounds.size.width, height: 3)
        })
    }
    var finished = PublishSubject<(String, String)>.init()
    
    lazy var selectBtn: UIButton = {
        let btn = UIButton.init()
        btn.tag = 100010
        btn.setTitle("請選擇", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        let size = "請選擇".sizeSingleLine(font: GDFont.systemFont(ofSize: 14))
        btn.frame = CGRect.init(x: self.margin, y: 0, width: size.width + 10, height: 37)
        btn.addTarget(self, action: #selector(selectBtnAction(btn:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        return btn
    }()
    lazy var lineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
        self.topScroll.addSubview(view)
        return view
    }()
    
    
    lazy var sureBtn: UIButton = {
        let btn = UIButton.init()
        btn.tag = 100010
        btn.setTitle("确 定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.frame = CGRect.init(x:0, y: 0, width: 100, height: 37)
        btn.addTarget(self, action: #selector(sureActon(btn:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
        
        return btn
    }()
    
    deinit {
        mylog("销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension AreaSelectView {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.collectionView.isUserInteractionEnabled = false
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.collectionView.isUserInteractionEnabled = true
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.collectionView.isUserInteractionEnabled = true
            self.index = Int(scrollView.contentOffset.x / SCREENWIDTH)
            UIView.animate(withDuration: 0.3, animations: {
                var btn: UIView!
                let index = self.tag
                ///在没有选择完成的情况下
                if index == self.selectBtn.tag {
                    btn = self.selectBtn
                }else {
                    btn = self.topScroll.viewWithTag(self.btnTag)
                }
                
                if btn != nil {
                    self.lineView.center = CGPoint.init(x: btn.centerX, y: self.lineView.centerY)
                    self.lineView.bounds = CGRect.init(x: 0, y: 0, width: btn.bounds.size.width, height: 3)
                }
                
            })
        }
        
    }
    
    
    func configmentBtn(model: AreaModel) -> UIButton {
        var btn: UIButton!
        
        if let b = self.topScroll.viewWithTag(self.btnTag) as? UIButton {
            btn = b
            //如果后面存在btn那么删除后面除selectbtn之外的所有按钮
            for view in self.topScroll.subviews {
                mylog(view.tag)
                mylog(self.btnTag)
                mylog(self.selectBtn.tag)
                if (view.tag > self.btnTag) && (view.tag < self.selectBtn.tag) {
                    view.removeFromSuperview()
                }
            }
            if self.index > 0 {
                if let previousBtn = self.topScroll.viewWithTag(self.btnTag - 1) {
                    let x = previousBtn.max_X + self.margin
                    let y: CGFloat = 0
                    let width: CGFloat = self.selectBtn.bounds.size.width
                    let height: CGFloat = self.selectBtn.bounds.size.height
                    self.selectBtn.frame = CGRect.init(x: x, y: y, width: width, height: height)
                    
                }
                
            }else {
                let x = self.margin
                let y: CGFloat = 0
                let width: CGFloat = self.selectBtn.bounds.size.width
                let height: CGFloat = self.selectBtn.bounds.size.height
                self.selectBtn.frame = CGRect.init(x: x, y: y, width: width, height: height)
            }
        }else {
            btn = UIButton.init()
        }
        
        btn.setTitle(model.name, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(areaAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        btn.tag = self.btnTag
        let size = (model.name ?? "").sizeSingleLine(font: GDFont.systemFont(ofSize: 14))
        if self.index == 0 {
            btn.frame = CGRect.init(x: self.margin, y: 0, width: size.width + 10, height: 37)
        }else {
            
            if let previousBtn = self.topScroll.viewWithTag(self.btnTag - 1) {
                btn.frame = CGRect.init(x: previousBtn.max_X + self.margin, y: 0, width: size.width, height: 37)
            }
            
        }
        
        self.topScroll.addSubview(btn)
        self.topScroll.insertSubview(self.selectBtn, belowSubview: btn)
        return btn
    }
    
    
    
    ///创建按钮
    func createBtn(model: AreaModel, index: Int) {
      
        self.collectionView.isUserInteractionEnabled = false
        self.selectModel = model
        
        //根据点击的index确定有collectionView的item数量
        switch index {
        case 0:
            self.oneAddress = model.name ?? ""
            self.twoAddress = ""
            self.threeAddress = ""
            self.fourAddress = ""
            if self.areaType == .province {
                self.selected()
            }
        case 1:
            self.twoAddress = model.name ?? ""
            self.threeAddress = ""
            self.fourAddress = ""
            if self.areaType == .city {
                self.selected()
            }
        case 2:
            self.threeAddress = model.name ?? ""
            self.fourAddress = ""
            if self.areaType == .area {
                self.selected()
            }
        case 3:
            self.fourAddress = model.name ?? ""
            if self.areaType == .street {
                self.selected()
            }
        default:
            break
        }
        
        self.requestData(parentid: model.id) { (arr) in
            
            if let data = arr, data.count > 0 {
                self.countItem = self.countItem + 1
                self.selectBtn.isHidden = false
                //点击cell跳转到下一个页面。
                switch index {
                case 0:
                    self.countItem = 2
                    self.dataArr2 = data
                case 1:
                    self.countItem = 3
                    self.dataArr3 = data
                case 2:
                    self.countItem = 4
                    self.dataArr4 = data
                case 3:
                    self.countItem = 5
                    
                default:
                    break
                    
                }
                let btn = self.configmentBtn(model: self.selectModel!)
                
                UIView.animate(withDuration: 0.25) {
                    if let btn = self.topScroll.viewWithTag(self.btnTag) {
                        self.selectBtn.frame = CGRect.init(x: self.margin + btn.max_X, y: 0, width: self.selectBtn.bounds.size.width, height: self.selectBtn.bounds.size.height)
                        let center = CGPoint.init(x: self.selectBtn.center.x, y: 38.5)
                        self.lineView.center = center
                        self.lineView.bounds = CGRect.init(x: 0, y: 0, width: self.lineView.bounds.size.width, height: 3)
                    }
                    
                }
                
                self.collectionView.reloadData()
                self.index = index + 1
                if self.index < self.countItem {
                    self.collectionView.scrollToItem(at: IndexPath.init(item: self.index, section: 0), at: .left, animated: true)
                }
                
                self.topScroll.contentSize = CGSize.init(width: self.selectBtn.max_X, height: 0)
            }else {
                let btn = self.configmentBtn(model: self.selectModel!)

                btn.setTitle(self.selectModel?.name ?? "", for: .normal)
                let size = btn.currentTitle?.sizeSingleLine(font: GDFont.systemFont(ofSize: 14)) ?? CGSize.init(width: 80, height: 1)
                self.lineView.center = CGPoint.init(x: btn.center.x, y: 38.5)
                self.lineView.bounds = CGRect.init(x: 0, y: 0, width: size.width, height: 3)
                self.selectBtn.isHidden = true
                
                
                self.selected()
                
            }
            self.collectionView.isUserInteractionEnabled = true
        }
        
        
    }
    
    enum AreaType {
        case province
        case city
        case area
        case street
        ///没有限制
        case unlimit
    }
    func selected() {
        let address: String = self.oneAddress + self.twoAddress + self.threeAddress + self.fourAddress
        
        if let model = self.selectModel {
            
            self.finished.onNext((address, model.id ?? ""))
            self.finished.onCompleted()
            self.removeFrom()
            
        }else {
            GDAlertView.alert("請選擇地區", image: nil, time: 1, complateBlock: nil)
        }
    }
    
    
    
}
class AreaModel: Codable {
    var areaName: String? = ""
    var isSelected: Bool? = false
    var id: String? = ""
    var name: String? = ""
    var rightBtnIsHidden: Bool? = true
    var rightBtnIsSelect: Bool? = false
    var rightImage: String? = ""
}


