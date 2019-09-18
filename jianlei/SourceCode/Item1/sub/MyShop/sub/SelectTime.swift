//
//  SelectTime.swift
//  Project
//
//  Created by 张凯强 on 2019/8/17.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class SelectTime: UIView, UITableViewDataSource, UITableViewDelegate {
    
    lazy var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        self.addSubview(view)
        return view
    }()
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeFrom))
        self.bottomView.isUserInteractionEnabled = true
        
        return tap
    }()
    let bottomView = UIView.init()
    @objc func removeFrom() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }) { (finished) in
            self.finished.onNext("finished")
            self.finished.onCompleted()
        }
    }
    
    
    init(frame: CGRect, dataArr: [TimeModel]) {
        super.init(frame: frame)
        self.dataArr = dataArr
        for (index, model) in self.dataArr.enumerated() {
            if model.isSelected {
                self.leftSelectIndex = IndexPath.init(row: index, section: 0)
                self.year = model.title
                for (subIndex, subModel) in model.days.enumerated() {
                    if subModel.isSelected {
                        self.month = subModel.title
                        self.rightSelectIndex = IndexPath.init(row: subIndex, section: 0)
                    }
                }
            }
        }
       
        let width: CGFloat = frame.size.width
        let height: CGFloat = frame.size.height
        self.containerView.frame = CGRect.init(x: 0, y: 0, width: width, height: height * 0.7)
        self.leftTableView.frame = CGRect.init(x: 0, y: 0, width: 150 * SCALE, height: self.containerView.frame.size.height)
        self.rightTableView.frame = CGRect.init(x: self.leftTableView.max_X, y: 0, width: self.containerView.frame.size.width - self.leftTableView.max_X, height: self.containerView.frame.size.height)
        self.bottomView.addGestureRecognizer(self.tap)
        self.addSubview(self.bottomView)
        self.bottomView.frame = CGRect.init(x: 0, y: self.containerView.max_Y, width: width, height: height - self.containerView.max_Y)
        self.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        
        
        
       
        
    }
    var dataArr: [TimeModel] = []

    lazy var leftTableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        table.register(UINib.init(nibName: "LeftTableCell", bundle: Bundle.main), forCellReuseIdentifier: "LeftTableCell")
        self.containerView.addSubview(table)
        return table
    }()
    
    lazy var rightTableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        
        table.register(UINib.init(nibName: "RightTableCell", bundle: Bundle.main), forCellReuseIdentifier: "RightTableCell")
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.backgroundColor = UIColor.white
        self.containerView.addSubview(table)
        return table
    }()
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.leftTableView == tableView {
            return self.dataArr.count
        }else {
            if self.dataArr.count > 0 {
                let model = self.dataArr[self.leftSelectIndex?.row ?? 0]
                return model.days.count
            }else {
                return 0
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.leftTableView == tableView {
            let cell: LeftTableCell = tableView.dequeueReusableCell(withIdentifier: "LeftTableCell", for: indexPath) as! LeftTableCell
            cell.model = self.dataArr[indexPath.row]
            return cell
        }else {
            let cell: RightTableCell = tableView.dequeueReusableCell(withIdentifier: "RightTableCell", for: indexPath) as! RightTableCell
            let model = self.dataArr[self.leftSelectIndex?.row ?? 0]
            cell.model = model.days[indexPath.row]
            return cell
        }
    }
    var leftSelectIndex: IndexPath?
    var rightSelectIndex: IndexPath?
    var year: String?
    var month: String?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.leftTableView == tableView {
            let model = self.dataArr[self.leftSelectIndex?.row ?? 0]
            model.isSelected = false
            
            let selectModel = self.dataArr[indexPath.row]
            selectModel.isSelected = true
            self.leftSelectIndex = indexPath
            self.rightSelectIndex = nil
            year = selectModel.title
            month = nil
            selectModel.days.forEach { (model) in
                model.isSelected = false
            }
            self.leftTableView.reloadData()
            self.rightTableView.reloadData()
        }else {
            let model = self.dataArr[self.leftSelectIndex?.row ?? 0]
            
            let dayModel = model.days[self.rightSelectIndex?.row ?? 0]
            dayModel.isSelected = false
            let selectModel = model.days[indexPath.row]
            selectModel.isSelected = true
            self.rightSelectIndex = indexPath
            self.rightTableView.reloadData()
            month = selectModel.title
        }
        if let yearStr = self.year, let monthStr = self.month {
            let time = yearStr + "-" + monthStr
            self.send.onNext(time)
            self.send.onCompleted()
        }
        
        
        
    }
    var send: PublishSubject<String> = PublishSubject<String>.init()
    var finished: PublishSubject<String> = PublishSubject<String>.init()
    
    deinit {
        mylog("销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
