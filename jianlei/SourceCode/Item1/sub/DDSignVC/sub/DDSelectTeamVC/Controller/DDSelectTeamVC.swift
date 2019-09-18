//
//  DDSelectTeamVC.swift
//  Project
//
//  Created by WY on 2019/8/19.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDSelectTeamVC: DDNormalVC {
     var selectedIndexPath  : IndexPath = IndexPath(row: 0, section: 111   )
    var model : ApiModel<[DDSelectTeamModel]>?
    let tableView = UITableView()
    var done : ((DDSelectTeamModel)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "selct_team"|?|
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let H = (self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight) 
        tableView.frame = CGRect(x: 0, y:DDNavigationBarHeight, width: self.view.bounds.width, height:H)
        requestApi()
        tableView.separatorStyle = .none
    }
    func requestApi() {
        DDRequestManager.share.selectTeam(type: ApiModel<[DDSelectTeamModel]>.self , success: { (model ) in
            if model.status == 200 {
                self.model = model
                self.tableView.reloadData()
            }else{
                GDAlertView.alert(model.message , image: nil , time: 2, complateBlock: nil )
            }
        })
    }
}
extension DDSelectTeamVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell") as? TeamCell{
            if indexPath == self.selectedIndexPath{
                cell.isSelected = true
            }else{
                cell.isSelected = false
            }
            cell.model = self.model?.data?[indexPath.row]
//            cell.name.text = self.model?.data?[indexPath.row].team_name
//            cell.personCount.text = self.model?.data?[indexPath.row].team_member_number
            return cell
        }else{
            let cell = TeamCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "TeamCell")
            if indexPath == self.selectedIndexPath{
                cell.isSelected = true
            }else{
                cell.isSelected = false
            }
            
//            cell.name.text = self.model?.data?[indexPath.row].team_name
//            cell.personCount.text = self.model?.data?[indexPath.row].team_member_number
            cell.model = self.model?.data?[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        if let m = self.model?.data?[indexPath.row]{
            self.done?(m)
        }
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    class TeamCell: UITableViewCell {
        let name = UILabel()
        let personCount = UILabel()
        let selectButton = UIButton()
        let bottomLine = UIView()
        var model : DDSelectTeamModel?{
            didSet{
                name.text = model?.team_name
                if let text = model?.team_member_number , text.count > 0{
                    personCount.text = "(\(text )人)"
                }else{
                    personCount.text = nil
                }
                self.layoutIfNeeded()
                self.setNeedsLayout()
            }
        }
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(name )
            self.contentView.addSubview(personCount )
            self.contentView.addSubview(selectButton )
            self.contentView.addSubview(bottomLine )
            selectButton.setImage(UIImage(named: ""), for: UIControl.State.normal)
            selectButton.setImage(UIImage(named: "select"), for: UIControl.State.selected)
            name.font = GDFont.systemFont(ofSize: 16)
            personCount.font = GDFont.systemFont(ofSize: 16)
            name.textColor = UIColor.darkGray
            personCount.textColor = UIColor.lightGray
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
            name.sizeToFit()
            personCount.sizeToFit()
            let selectButtonY : CGFloat = 20
            let selectButtonWH : CGFloat = self.bounds.height - selectButtonY * 2
            let selectButtonX = self.bounds.width - selectButtonWH - 20
            selectButton.frame = CGRect(x: selectButtonX, y: selectButtonY, width: selectButtonWH, height: selectButtonWH)
            let leftMargin : CGFloat = 10
            let topBottomMargin : CGFloat = 6
            let midMargin : CGFloat = 10
            name.frame = CGRect(x: leftMargin, y: 0, width:name.bounds.width + midMargin , height: self.bounds.height )
            personCount.frame = CGRect(x: name.frame.maxX + midMargin, y: 0, width: personCount.bounds.width + midMargin, height:self.bounds.height )
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - 1.5, width: self.bounds.width, height: 1.5)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
class DDSelectTeamModel: Codable {
    var id : String?
    var team_name : String?
    var team_member_number : String?
    var team_type: String?
}
