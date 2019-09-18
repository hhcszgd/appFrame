//
//  ShopGuangGaoCell.swift
//  Project
//
//  Created by 张凯强 on 2019/8/13.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit
protocol ShopGuangGaoCellDelegate: NSObjectProtocol {
    ///编辑上传图片
    func editUploadPicture()
}
class ShopGuangGaoCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var zongDianData: ShopZongDianInfo<ShopInfoModel, FendianList>? {
        didSet{
            self.targetView?.zongDianData = zongDianData
        }
    }
    var shopModel: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>? {
        didSet {
            self.targetView?.shopModel = shopModel
            //编辑上传图片在店铺关闭状态下禁用
            if shopModel?.shop?.status == "6" {
                self.editBtn.isEnabled = false
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView = ShopGuangGaoView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        self.contentView.addSubview(subView)
        self.contentView.addSubview(self.editBtn)
        self.editBtn.frame = CGRect.init(x: 0, y: frame.height - 44 - DDSliderHeight, width: frame.width, height: 44 + DDSliderHeight)
        
        self.targetView = subView
        
    }

    weak var delegate: ShopGuangGaoCellDelegate?
    var targetView: ShopGuangGaoView?
    
    
    
    
    lazy var editBtn: UIButton = {
        let btn = UIButton.init()
        let backImageNormal = UIImage.getImage(startColor: UIColor.colorWithHexStringSwift("ff7d09"), endColor: UIColor.colorWithHexStringSwift("ef4e07"), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0), size: CGSize.init(width: SCREENWIDTH, height: DDSliderHeight + 44))
        btn.setBackgroundImage(backImageNormal, for: UIControl.State.normal)
        let backImageEnable = UIImage.ImageWithColor(color: UIColor.colorWithHexStringSwift("cccccc"), frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44 + DDSliderHeight))
        btn.setBackgroundImage(backImageEnable, for: UIControl.State.disabled)
        btn.setTitle("编辑上传图片", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    @objc func btnClick(btn: UIButton) {
        self.delegate?.editUploadPicture()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
