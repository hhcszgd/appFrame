//
//  DDCommentPersonVC.swift
//  Project
//
//  Created by WY on 2018/3/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import Alamofire
class DDCommentPersonVC: DDNormalVC , UITextViewDelegate{
    enum PersonType : Int  {
        case hezuo
        case duijie
    }
    let personLabel = UILabel()
    let bottomLabel = UILabel()
    let commitButton = UIButton()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()
    let button5 = UIButton()
    let textView  = UITextView()
    var personType : PersonType?
    var orderID : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价"
        let dict = self.userInfo as! [String:Any]
        if let type  = dict["key1"] as? PersonType {
            self.personType = type
        }
        if let personName  = dict["key2"] as? String {
            if self.personType == .duijie {
                self.personLabel.text = "广告对接人:" + personName
            }else if self.personType == .hezuo {
//                self.personLabel.text = "业务合作人:" + personName
                self.personLabel.text = "业务对接人:" + personName
            }else{
                self.personLabel.text = "广告对接人:" + personName
            }
        }
        if let orderID = dict["key3"] as? String{
            self.orderID = orderID
        }
        self.configPersonLabel()
        self.addButtons()
        self.configBottomView()
        self.configTextView()
        // Do any additional setup after loading the view.
    }
    func configTextView()  {
        self.view.addSubview(textView)
        textView.frame = CGRect(x: 20, y: self.button1.frame.maxY + 10, width: self.view.bounds.width - 40, height: bottomLabel.frame.minY - button1.frame.maxY - 10)
//        textView.placeholder = "我们会根据您的意见来改进\n谢谢您的配合(选填)"
//        textField.textInputMode = .boldText
        textView.backgroundColor = .white
        textView.layer.borderColor = UIColor.colorWithHexStringSwift("dddddd").cgColor
        textView.layer.borderWidth = 1
        textView.pleaceHolder = "请填写您对我们的意见(选填)"//"请填写您对我们的意见(选填)"
        textView.delegate = self
        textView.returnKeyType = .done
    }

    ///textView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            self.view.endEditing(true )
            return false
        }
        if textView.text.count > 120 && text.count > 0{
            return false
        }
        return true
    }
    func configBottomView() {
        self.view.addSubview(commitButton)
        self.view.addSubview(bottomLabel)
        commitButton.setTitle("提交", for: UIControl.State.normal)
        bottomLabel.numberOfLines = 3
        let attributeStr = [ "如果您对我们的工作有任何意见\n可致电"," 400-073-6688","\n感谢您的配合"].setColor(colors: [UIColor.lightGray , UIColor.orange , UIColor.lightGray])
//        bottomLabel.text = "如果您对我们的工作又任何意见\n可致电010-1234567\n感谢您的配合"
        bottomLabel.attributedText =  attributeStr
        bottomLabel.textAlignment = .center
//        bottomLabel.textColor = .lightGray
        let toBorder : CGFloat = 64
        let buttonW   = self.view.bounds.width - toBorder * 2
        commitButton.frame = CGRect(x: toBorder, y: self.view.bounds.height - DDSliderHeight - 44 - 60, width: buttonW, height: 44)
        commitButton.backgroundColor = .orange
        
        bottomLabel.frame = CGRect(x: 0, y: commitButton.frame.minY - 94, width: self.view.bounds.width, height: 94)
        commitButton.addTarget(self , action: #selector(confirmClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func confirmClick(sender:UIButton)  {
        mylog("提交")
        var pingLun = "5"
        if button1.isSelected {
            pingLun = "5"
        }else if button2.isSelected{
            pingLun = "4"
        }else if button3.isSelected{
            pingLun = "3"
        }else if button4.isSelected{
            pingLun = "2"
        }else if button5.isSelected{
            pingLun = "1"
        }
        if self.personType == .duijie {
            DDRequestManager.share.tousuDuijieren(order_id: self.orderID, complain_level: pingLun, complain_content: self.textView.text , true )?.responseJSON(completionHandler: { (response) in
                self.dealResponse(response: response)
            })
        }else if self.personType == .hezuo {
            DDRequestManager.share.tousuHezuoren(order_id: self.orderID, complain_level: pingLun, complain_content: self.textView.text , true)?.responseJSON(completionHandler: { (response) in
                self.dealResponse(response: response)
            })
        }else{
            DDRequestManager.share.saleManTousuDuijieren(order_id: self.orderID, complain_level: pingLun, complain_content: self.textView.text , true )?.responseJSON(completionHandler: { (response) in
                self.dealResponse(response: response)
            })
        }
    }
    func dealResponse(response : DataResponse<Any>) {
        switch response.result {
        case .success:
            mylog("成功")
            if let dict  = response.value as? [String : Any] , let status = dict["status"]{
                if let statusCode = status as? Int , statusCode == 200{
                   self.pushVC(vcIdentifier: "DDCommentResultVC", userInfo: "1" )
                    return
                }
            }
            self.pushVC(vcIdentifier: "DDCommentResultVC", userInfo: "2" )
            break
        case .failure:
            mylog("失败")
            self.pushVC(vcIdentifier: "DDCommentResultVC", userInfo: "2" )
            break
        }
    }
    deinit {
        mylog("comment vc is destroyed")
    }
    func configPersonLabel() {
        self.view.addSubview(personLabel)
//        if self.personType == .duijie {
//            self.personLabel.text = "广告对接人"
//        }else if self.personType == .hezuo {
//            self.personLabel.text = "业务合作人"
//        }
        personLabel.frame = CGRect(x: 15, y: DDNavigationBarHeight, width: self.view.bounds.width - 30, height: 44)
        personLabel.textColor = .gray
    }
    
    func addButtons() {
        self.configButton(sender: button1, title: " 非常满意")
        button1.center = CGPoint(x: 15 + button1.bounds.width/2, y: personLabel.frame.maxY + button1.bounds.height/2)
        button1.isSelected = true
        self.configButton(sender: button2, title: " 满意")
        button2.center = CGPoint(x: button1.frame.maxX + button2.bounds.width/2, y: personLabel.frame.maxY + button2.bounds.height/2)
        self.configButton(sender: button3, title: " 一般")
        button3.center = CGPoint(x: button2.frame.maxX + button3.bounds.width/2, y: personLabel.frame.maxY + button3.bounds.height/2)
        self.configButton(sender: button4, title: " 不满意")
        
        button4.center = CGPoint(x: button3.frame.maxX + button4.bounds.width/2, y: personLabel.frame.maxY + button4.bounds.height/2)
        self.configButton(sender: button5, title: " 极不满意")
        button5.center = CGPoint(x: button4.frame.maxX + button5.bounds.width/2, y: personLabel.frame.maxY + button5.bounds.height/2)
    }
    func getWidth(title : String ) -> CGFloat {
        let toBorder : CGFloat = 10
        let buttonImageW : CGFloat = 15
        let jiange : CGFloat = 6
        let oneW = (self.view.bounds.width  - toBorder * 2 - (buttonImageW  + jiange) * 5 ) / 15
        return buttonImageW + jiange + oneW * CGFloat(title.count - 1)
    }
    func configButton(sender:UIButton,title : String) {
        self.view.addSubview(sender)
        sender.setTitle(title, for: UIControl.State.normal)
        sender.setTitle(title, for: UIControl.State.selected)
        sender.setImage(UIImage(named:"unchecked"), for: UIControl.State.normal)
        sender.setImage(UIImage(named:"selected"), for: UIControl.State.selected)
        sender.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        sender.setTitleColor(UIColor.lightGray, for: UIControl.State.selected)
        sender.contentHorizontalAlignment = .left
        sender.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControl.Event.touchUpInside)
        sender.titleLabel?.font = GDFont.systemFont(ofSize: 14)
        sender.adjustsImageWhenHighlighted = false
        sender.bounds = CGRect(x: 0, y: 0, width: self.getWidth(title: title), height: 40)
    }
    @objc func buttonClick(sender:UIButton)  {
        self.view.endEditing(true )
        if sender.isSelected {return}else{
            sender.isSelected = !sender.isSelected
            if sender == button1 {
                button2.isSelected = false
                button3.isSelected = false
                button4.isSelected = false
                button5.isSelected = false
            }else if sender == button2 {
                button1.isSelected = false
                button3.isSelected = false
                button4.isSelected = false
                button5.isSelected = false
            }else if sender == button3 {
                button2.isSelected = false
                button1.isSelected = false
                button4.isSelected = false
                button5.isSelected = false
            }else if sender == button4{
                button2.isSelected = false
                button3.isSelected = false
                button1.isSelected = false
                button5.isSelected = false
            }else if sender == button5{
                button2.isSelected = false
                button3.isSelected = false
                button4.isSelected = false
                button1.isSelected = false
            }
        }
    }
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
