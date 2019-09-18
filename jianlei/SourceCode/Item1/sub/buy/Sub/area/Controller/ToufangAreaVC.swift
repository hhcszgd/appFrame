//
//  ToufangAreaVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
enum AreaType {
    ///省
    case province
    ///市
    case city
    ///区
    case area
}
class ToufangAreaVC: DDNormalVC {
    var type: AreaType = AreaType.area
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configmentView()
        self.title = "投放地区"
        
        
        // Do any additional setup after loading the view.
    }
    
    func configmentView() {
        
        self.bottomViewBottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        switch type {
        case .area:
            ///选择区
            self.view.addSubview(self.provinceView)
        case .city:
            self.view.addSubview(self.provinceView)
        case .province:
            self.view.addSubview(self.allView)
        }

    }
    
    lazy var provinceView: ToufangProvinceView = {
        
        let subView = ToufangProvinceView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 50 - TabBarHeight ))
        
        return subView
    }()
    lazy var cityView: ToufangQuView = {
        
        let subView = ToufangQuView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 50 - TabBarHeight))
        
        return subView
    }()
    lazy var allView: AllProvinceView = {
        let subView = AllProvinceView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 50 - TabBarHeight))
        return subView
    }()

    
    @IBOutlet var bottomViewBottom: NSLayoutConstraint!
    
    
    @IBOutlet var bottomView: UIView!
    
    @IBAction func eleminateaction(_ sender: UIButton) {
        switch self.type {
        case .area:
            self.provinceView.clearData()
//            self.cityView.clearData()
        case .city:
            self.provinceView.clearData()
        case .province:
            self.allView.clearData()
       
        }
        
        
        //清除
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
        switch self.type {
        case .area:
            self.provinceView.selectFinished(success: { [weak self](area, areaName) in
                mylog("成功")
                self?.selectArea.onNext(["area": area, "areaName": areaName])
                self?.selectArea.onCompleted()
                self?.navigationController?.popViewController(animated: true)
                }, failure: {
                    mylog("失败")
            })
//            self.cityView.selectFinished(success: {[weak self](area, areaName) in
//                mylog("成功")
//                self?.selectArea.onNext(["area": area, "areaName": areaName])
//                self?.selectArea.onCompleted()
//                self?.navigationController?.popViewController(animated: true)
//                }, failure: {
//                    mylog("四百")
//            })
        case .city:
            
            break
        case .province:
            self.allView.selectFinished(success: { [weak self](area, areaName) in
                mylog("成功")
                self?.selectArea.onNext(["area": area, "areaName": areaName])
                self?.selectArea.onCompleted()
                self?.navigationController?.popViewController(animated: true)
                }, failure: {
                    mylog("失败")
            })
       
        }
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    var selectArea: PublishSubject<[String: String]> = PublishSubject<[String: String]>.init()
   

    

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIButton {
    //设置在不同状态下按钮的背景颜色
    
}
