
//
//  PhotoManagerVC.swift
//  Project
//
//  Created by 张凯强 on 2019/8/13.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
import Photos

class PhotoManagerVC: DDInternalVC, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    var shopID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "素材详情"
        
        
        self.configUI()
        self.getPhotoAlbum()
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    lazy var editBt: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("编辑", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        btn.addTarget(self, action: #selector(editAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    lazy var releaseBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("发布", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        btn.addTarget(self, action: #selector(releaseAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    @objc func releaseAction(sender: UIButton) {
        
    }
    
    @objc func editAction(sender: UIButton) {
        
    }
    
    private func configUI() {
        
        self.naviBar.rightBarButtons = [self.editBt]
        
        self.flowLayout = UICollectionViewFlowLayout.init()
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight), collectionViewLayout: self.flowLayout)
        self.view.addSubview(self.collectionView)
        self.collectionView.register(UINib.init(nibName: "PhotoManagerImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PhotoManagerImageCell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.minimumInteritemSpacing = 0
        let itemWidth: CGFloat = SCREENWIDTH / 3.0
        let itemHeight: CGFloat = 150
        self.flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        self.flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
    }
    
    
    
    private func getPhotoAlbum() {
        //创建一个PHFetchOptions对象检索图片
        let options = PHFetchOptions.init()
        //通过创建时间来检索
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        //通过数据类型只检索图片
        options.predicate = NSPredicate.init(format: "mediaType in %@", [PHAssetMediaType.image.rawValue])
        //通过检索条件检索出符合检索条件的所有数据。也就是所有图片
        let allResult = PHAsset.fetchAssets(with: options)
        //获取用户创建的相册
        let userAlbum = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
        //获取智能相册
        let samartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        //将获取的相册加入到相册的数组中。
        allResult.enumerateObjects { (photo, i, _) in
            mylog(photo)
            self.dataArr.append(photo)
            
        }
        
        self.collectionView.reloadData()
        
        
        
    }

    // collectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoManagerImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoManagerImageCell", for: indexPath) as! PhotoManagerImageCell
        let url = self.dataArr[indexPath.item]
        imageManager.requestImage(for: url, targetSize: CGSize.init(width: 100, height: 100), contentMode: PHImageContentMode.aspectFit, options: nil) { (image, dict) in
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        mylog(sourceIndexPath)
        mylog(destinationIndexPath)
    }
    
    
    //图片管理。
    let imageManager = PHImageManager.default()
    ///数据源
    var dataArr: [PHAsset] = [PHAsset]()
    let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENWIDTH))
    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    
    
    
    
    

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
