//
//  MyShopAddressView.swift
//  Project
//
//  Created by 张凯强 on 2019/8/3.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class MyShopAddressView: UIView, UITableViewDelegate, UITableViewDataSource {

    
    init(frame: CGRect, subFrame: CGRect, dataArr: [ScreensModel], selectShop: ScreensModel) {
        super.init(frame: frame)
        self.selectModel = selectShop
        self.addSubview(containerView)
        self.dataArr = dataArr
        let model = ScreensModel.init()
        model.name = "新申请安装"
        model.isSelected = true
        model.id = "install"
        self.dataArr.insert(model, at: 0)
        self.containerView.frame = subFrame
        self.tableView.frame = self.containerView.bounds
        self.tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        
        let maskPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: subFrame.size.width, height: subFrame.size.height), byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: 15, height: 15))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = CGRect.init(x: 0, y: 0, width: subFrame.size.width, height: subFrame.size.height)
        maskLayer.path = maskPath.cgPath
        self.containerView.layer.mask = maskLayer
        
        self.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
//        self.addGestureRecognizer(tap)
        self.containerView.isUserInteractionEnabled = true
    }
    @objc func tapAction(tap: UITapGestureRecognizer) {
        //页面消失
        let point = tap.location(in: self)
        if !self.containerView.frame.contains(point) {
            self.viewhidden(finished: nil)
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        if !self.containerView.frame.contains(point) {
            self.viewhidden(finished: nil)
        }
    }
    
    
    var select: PublishSubject<ScreensModel> = PublishSubject<ScreensModel>.init()
    var finished: PublishSubject<String> = PublishSubject<String>.init()
    let containerView = UIView.init()
    var dataArr: [ScreensModel] = []
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SimpleCell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath) as! SimpleCell
        cell.model = self.dataArr[indexPath.row]
        return cell
    }
    var selectModel: ScreensModel?
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let model = self.selectModel {
            let view = SimpleHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: 140, height: 30), model: model)
            view.addressBtn.invalidate()
            view.addressBtn.addTarget(self, action: #selector(remove), for: .touchUpInside)
            
            return view
        }
        return nil
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    var jump: PublishSubject<String> = PublishSubject<String>.init()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //跳转到添加页面
            self.viewhidden(finished: {
                self.jump.onNext("apply")
                self.jump.onCompleted()
            })
            
            
        }else {
            //选中
            let model = self.dataArr[indexPath.row]
            self.select.onNext(model)
            self.select.onCompleted()
            self.viewhidden(finished: nil)
            
        }
    }
    @objc func viewhidden(finished: (() -> ())?) {
        if finished != nil {
            finished!()
        }
        self.finished.onNext("finished")
        self.finished.onCompleted()
        
    }
    @objc func remove() {
        self.finished.onNext("finished")
        self.finished.onCompleted()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.containerView.addSubview(table)
        table.register(UINib.init(nibName: "SimpleCell", bundle: Bundle.main), forCellReuseIdentifier: "SimpleCell")
        
        return table
    }()
    

}
