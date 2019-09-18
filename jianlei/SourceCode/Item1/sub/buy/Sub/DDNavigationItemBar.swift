//
//  DDNavigationItemBar.swift
//  Project
//
//  Created by WY on 2018/3/6.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
protocol DDNavigationItemBarDelegate : NSObjectProtocol{
    func itemSizeOfNavigationItemBar(bar : DDNavigationItemBar) -> CGSize
    func numbersOfNavigationItemBar(bar : DDNavigationItemBar) -> Int
    func setParameteToItem(bar : DDNavigationItemBar,item:UICollectionViewCell , indexPath:IndexPath)
    func didSelectedItemOfNavigationItemBar(bar : DDNavigationItemBar, item : UICollectionViewCell ,  indexPath:IndexPath)
}
extension DDNavigationItemBarDelegate{
    func itemSizeOfNavigationItemBar(bar : DDNavigationItemBar) -> CGSize{
        mylog("DDNavigationItemBarDelegate 默认实现")
        return CGSize(width: 44, height: 34)
    }
    func numbersOfNavigationItemBar(bar : DDNavigationItemBar) -> Int {
        return 1
    }
}

class DDNavigationItemBar : UIView , UICollectionViewDelegate , UICollectionViewDataSource{
    var whetherItemSizeAverage : Bool = true //当item占不满bar时 , 是否均分
    var selectedIndexPath : IndexPath = IndexPath(item: 0, section: 0  )
    weak var delegate : DDNavigationItemBarDelegate?
    private let collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    open var scrollDirection: UICollectionView.ScrollDirection = .vertical // default is UICollectionViewScrollDirectionVertical
    var itemIdentifier = ""
    convenience init<T:UICollectionViewCell>(_ frame: CGRect ,_ itemType:T.Type ){
        self.init(frame: frame)
        self.addSubview(collectionView)
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate  = self
        self.collectionView.dataSource = self
        self.itemIdentifier = NSStringFromClass(T.self)
        self.collectionView.register(T.self , forCellWithReuseIdentifier: self.itemIdentifier)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.bounces  = false
        self.collectionView.reloadData()
        mylog(self.itemIdentifier)
    }
    ///默认首次进入选中第一个item
//    override func didMoveToWindow() {
//        super.didMoveToWindow()
//        let item = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0   ))
//        mylog(item )
////        self.delegate?.didSelectedItemOfNavigationItemBar(bar: self , indexPath: IndexPath(item: 0, section: 0  ))
//    }
    
//    func regis<T:UICollectionViewCell>(a : T )-> T{
//        let ax = T.self
//        let b = T()
////        t = T.self
////        if let  CC = t as? type(DDNavigationItem) {}
//
//        self.collectionView.register(T.self, forCellWithReuseIdentifier: "a")
//        return a
//    }
    func reloadData()  {
        self.collectionView.reloadData()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            var itemSize = self.delegate?.itemSizeOfNavigationItemBar(bar: self) ?? CGSize.zero
            let count = self.delegate?.numbersOfNavigationItemBar(bar: self) ?? 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0 
            if self.scrollDirection == .horizontal {
                flowLayout.scrollDirection = .horizontal
                if itemSize.width * CGFloat(count) < self.bounds.width && whetherItemSizeAverage{
                    itemSize = CGSize(width: self.bounds.width / CGFloat(count), height: itemSize.height)
                }
                flowLayout.itemSize = itemSize
                self.layoutWhenHorizontal()
            }else{
                flowLayout.scrollDirection = .vertical
                if itemSize.height * CGFloat(count) < self.bounds.height && whetherItemSizeAverage{
                    itemSize = CGSize(width: itemSize.width, height: self.bounds.height / CGFloat(count))
                }
                flowLayout.itemSize = itemSize
                self.layoutWhenVertical()
            }
        }
    }
    
    func layoutWhenHorizontal()  {
        
    }
    func layoutWhenVertical()  {
        
    }
    /// delegate and dadasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.numbersOfNavigationItemBar(bar: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemIdentifier, for: indexPath)
        mylog(cell)
        dump(cell)
       self.delegate?.setParameteToItem(bar : self,item: cell, indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndexPath = self.selectedIndexPath
        self.selectedIndexPath = indexPath
//        if previousIndexPath == indexPath {
//            if let _ = collectionView.cellForItem(at: previousIndexPath){
//                collectionView.reloadItems(at: [previousIndexPath])
//            }
//        }else {
//            collectionView.reloadItems(at: [indexPath, previousIndexPath])
//        }
       collectionView.reloadData()
        let cell = collectionView.cellForItem(at: previousIndexPath) ?? UICollectionViewCell()
        self.delegate?.didSelectedItemOfNavigationItemBar(bar: self , item : cell  , indexPath: indexPath)
        
    }
}


