//
//  CalanderCell.swift
//  Project
//
//  Created by 张凯强 on 2018/4/21.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class CalanderCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var flowlayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionIVew: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CalanderColCell = collectionIVew.dequeueReusableCell(withReuseIdentifier: "CalanderColCell", for: indexPath) as! CalanderColCell
        cell.dayModel = self.dataArr[indexPath.item]
        return cell
        
    }
    var dataArr: [DayModel] = [DayModel]() {
        didSet{
            self.collectionIVew.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
