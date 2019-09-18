//
//  DDSearchShopVC.swift
//  Project
//
//  Created by WY on 2019/8/17.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDSearchShopVC: DDNormalVC {
//    enum DDSearchType {
//        case shop
//        case location
//    }
    var blankView : DDBlankView?
    var model : ApiModel<[DDSelectShopModel]>?
    let searchBar = DDSearchBar()
    let cancle = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
    let tableView = UITableView()
    var done : ((DDSelectShopModel?)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        confitTableView()
        self.searchBar.textField.text = (self.userInfo as? String) ?? ""
        performSearch()
    }
    
    func performSearch() {
        self.blankView?.remove()
        self.blankView = nil
        guard let keyWord = self.searchBar.textField.text  else {
            GDAlertView.alert("type_in_keyword_please"|?|, image: nil, time: 2 , complateBlock: nil)
            return
        }
        DDRequestManager.share.shopSearch(type: ApiModel<[DDSelectShopModel]>.self , keyWord: keyWord, success: { (model ) in
            mylog(model.data)
            if model.data?.count ?? 0 > 0 {
                self.model = model
                self.tableView.reloadData()
            }else{
                let alert = DDBlankView(message: "can_not_find_shop"|?|, image: UIImage(named:"noteam"))
                self.blankView = alert
                alert.action = {[weak self] in
                    self?.performSearch()
                }
                self.tableView.alert(alert)
            }
        })
    }
    func setNavigationItem() {
        cancle.setTitle("cancel"|?|, for: UIControl.State.normal)
        cancle.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        cancle.addTarget(self , action: #selector(cancel), for: UIControl.Event.touchUpInside)
        cancle.layer.cornerRadius = 5
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancle)
        
        
        
        self.view.addSubview(searchBar)
        self.view.addSubview(cancle)
//        self.navigationItem.titleView = searchBar
        
        let searchBarToNavibarbottom : CGFloat = 4
        let searchBarX : CGFloat = 20
        cancle.frame = CGRect(x: self.view.bounds.width - 44 - 10, y: DDNavigationBarHeight - 40 - searchBarToNavibarbottom, width:44, height: 40)
        searchBar.frame = CGRect(x: searchBarX, y: DDNavigationBarHeight - 40 - searchBarToNavibarbottom, width: self.view.bounds.width - searchBarX - cancle.bounds.width - 20, height: 40)
        searchBar.backgroundColor = UIColor.DDLightGray
        searchBar.layer.cornerRadius = searchBar.bounds.height/2
        searchBar.layer.masksToBounds = true
        searchBar.doneAction = { [weak self ] text in
            self?.performSearch()
            mylog(text)
        }
        
    }
    @objc func cancel() {
        self.dismiss(animated: true) {
            
        }
    }
}
extension DDSearchShopVC : UITableViewDelegate , UITableViewDataSource{
  
    
    func confitTableView(){
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let H = self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height:H)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultShopCell") as? SearchResultShopCell{
            
            cell.name.text = model?.data?[indexPath.row].name
            cell.address.text = model?.data?[indexPath.row].address
            return cell
        }else{
            let cell = SearchResultShopCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SearchResultShopCell")
           
            cell.name.text = model?.data?[indexPath.row].name
            cell.address.text = model?.data?[indexPath.row].address
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.isSelected = false
        self.dismiss(animated: true) {
                self.done?(self.model?.data?[indexPath.row])
        }
    }
    class SearchResultShopCell: UITableViewCell {
        let name = UILabel()
        let address = UILabel()
        let selectButton = UIButton()
        let bottomLine = UIView()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(name )
            self.contentView.addSubview(address )
            self.contentView.addSubview(selectButton )
            self.contentView.addSubview(bottomLine )
            selectButton.setImage(UIImage(named: ""), for: UIControl.State.normal)
            selectButton.setImage(UIImage(named: "select"), for: UIControl.State.selected)
            name.font = GDFont.systemFont(ofSize: 16)
            address.font = GDFont.systemFont(ofSize: 14)
            name.textColor = UIColor.darkGray
            address.textColor = UIColor.lightGray
            bottomLine.backgroundColor = UIColor.DDLightGray
            selectButton.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControl.Event.touchUpInside)
            
        }
        @objc func buttonClick(sender:UIButton) {
            sender.isEnabled = !sender.isEnabled
        }
        override var isSelected: Bool{
            didSet{
                selectButton.isSelected = isSelected
            }
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let selectButtonY : CGFloat = 20
            let selectButtonWH : CGFloat = self.bounds.height - selectButtonY * 2
            let selectButtonX = self.bounds.width - selectButtonWH - 20
            selectButton.frame = CGRect(x: selectButtonX, y: selectButtonY, width: selectButtonWH, height: selectButtonWH)
            let leftMargin : CGFloat = 10
            let topBottomMargin : CGFloat = 6
            let midMargin : CGFloat = 10
            name.frame = CGRect(x: leftMargin, y: topBottomMargin, width: selectButtonX - leftMargin - midMargin , height: (self.bounds.height - topBottomMargin * 2 ) * 0.6 )
            address.frame = CGRect(x: leftMargin, y: name.frame.maxY, width: selectButtonX - leftMargin - midMargin, height: (self.bounds.height - topBottomMargin * 2 ) * 0.4)
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - 1.5, width: self.bounds.width, height: 1.5)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
