//
//  QRCodeScannerVC.swift
//  zjlao
//
//  Created by WY on 2019/8/9.
//  Copyright ©2019年 jianlei. All rights reserved.
//

import UIKit
import AVFoundation
protocol QRCodeScannerVCDelegate {
    func scannerComplate(code: String?)
}
class QRCodeScannerVC: DDInternalVC,AVCaptureMetadataOutputObjectsDelegate , QRViewDelegate {
    let qrView  = QRView()
    var delegate: QRCodeScannerVCDelegate?
    var complateHandle : ((String)->())?
    var captureSession: AVCaptureSession!
    var code: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavBar()
        self.setup()
        // Do any additional setup after loading the view.
    }
    func configNavBar()  {
        naviBar.title = ""
//        naviBar.currentType = NaviBarStyle.withBackBtn
        self.naviBar.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.purple
        self.naviBar.backBtn.setImage(UIImage(named:"back_icon"), for: UIControl.State.normal)
    }
    
    func setup()  {
        let frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        self.view.addSubview(self.qrView)
        self.qrView.delegate = self
        self.qrView.frame  =  frame
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func qrView(view: QRView, didCompletedWithQRValue: String) {
        mylog(didCompletedWithQRValue)
        self.delegate?.scannerComplate(code: didCompletedWithQRValue)
        self.complateHandle?(didCompletedWithQRValue)
    }
    
    class func creatQRCode(string:String , imageToInsert : UIImage?) -> UIImage?{
    //  使用coreImage框架中的滤镜来实现生成的二维码
    //  kCICategoryBuiltIn 内置的过滤器的分类
    //  1.创建一个用于生成二维码的滤镜
//    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    let qrFilter = CIFilter(name: "CIQRCodeGenerator")
    //  2.设置默认值
    qrFilter?.setDefaults()
    //  3.设置输入数据
    qrFilter?.setValue(string.data(using: String.Encoding.utf8), forKey: "inputMessage")
    
    //  4.生成图片
        var ciImage = qrFilter?.outputImage
    //  默认生成的ciImage的大小是很小
    //  放大ciImage
        let scale = CGAffineTransform(scaleX: 8, y: 8);
        ciImage = ciImage?.transformed(by: scale)
    //  5.设置二维码的前景色和背景色
        let colorFilter = CIFilter(name: "CIFalseColor")
    //  设置默认值
    colorFilter?.setDefaults()
    //  设置输入的值
    /*
     inputImage,
     inputColor0,
     inputColor1
     */
    //    NSLog(@"%@",colorFilter.inputKeys);
        colorFilter?.setValue(ciImage, forKey: "inputImage")
    //  设置前景色
        colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
    //  设置背景
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
    //  取出colorFilter中的图片
        ciImage = colorFilter?.outputImage;
    //  在中心增加一张图片
        if let ciImageUnwrap = ciImage  {
            let image = UIImage(ciImage: ciImageUnwrap)
            //  生成图片
            //  1.开启图片的上下文
            UIGraphicsBeginImageContext(image.size);
            //  2.把二维码的图片划入
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            //  3.在中心画其他图片
            if let insertImg = imageToInsert {
                let  weiW : CGFloat = 40;
                let weiH : CGFloat = 40;
                let weiX = (image.size.width - weiW) * 0.5;
                let  weiY = (image.size.height - weiH) * 0.5;
                insertImg.draw(in: CGRect(x: weiX, y: weiY, width: weiW, height: weiH))
            }
            let  qrImageForReturn =  UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            return qrImageForReturn
        }
        UIGraphicsEndImageContext();
        return nil
    }
    deinit{
        mylog("扫描控制器销毁")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true )
        if !self.qrView.session.isRunning{
            self.qrView.session.startRunning()
            self.qrView.setNeedsLayout()
        }
    }
}











@objc protocol QRViewDelegate : NSObjectProtocol{
    func qrView(view : QRView , didCompletedWithQRValue : String)
}

class QRView: UIView ,AVCaptureMetadataOutputObjectsDelegate{
    weak var delegate : QRViewDelegate?
    let bgView  = UIImageView()//背景框
    let lineView = UIImageView()//上下扫描的线
    let session = AVCaptureSession()
    var sublayer    : AVCaptureVideoPreviewLayer?
    let videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
    //        AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    let flashLightBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupQRScannerCompose()
        self.setupControlCompose()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupControlCompose ()  {
        self.addSubview( bgView)
        self.addSubview(lineView)
        self.addSubview(flashLightBtn)
        flashLightBtn.setImage(UIImage(named: "flashlightshut"), for: UIControl.State.normal)
        flashLightBtn.setImage(UIImage(named: "flashlightopen"), for: UIControl.State.selected)
        flashLightBtn.addTarget(self, action: #selector(flashBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        self.bgView.image = UIImage.init(named: "pick_bg")
        self.lineView.image = UIImage.init(named: "line")
        if videoCaptureDevice?.isTorchAvailable ?? false{
            flashLightBtn.isHidden = false
        }else{
            flashLightBtn.isHidden = true
        }
        
    }
    @objc func flashBtnClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if videoCaptureDevice?.isTorchAvailable ?? false{
            self.videoCaptureDevice?.torchMode = sender.isSelected ?  .on : .off
        }
    }
    func setupQRScannerCompose()  {
        //        let videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //        videoCaptureDevice.unlockForConfiguration()
        do {
            try  videoCaptureDevice?.lockForConfiguration()
            
        }catch{
            mylog(error)
        }
        if videoCaptureDevice?.isTorchAvailable ?? false{
            videoCaptureDevice?.torchMode = .off
        }
        //MARK:先注销 , 等会儿再测
        //        let setting = AVCapturePhotoSettings.init(format: nil).flashMode = AVCaptureFlashMode.on
        
        //        videoCaptureDevice.torchMode =  AVCaptureTorchMode.on
        //        videoCaptureDevice.flashMode  = AVCaptureFlashMode.on
        if let videoCaptureDevice  = self.videoCaptureDevice {
            do {
                
                let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                
                if self.session.canAddInput(videoInput) {
                    self.session.addInput(videoInput)
                } else {
                    print("Could not add video input")
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                if self.session.canAddOutput(metadataOutput) {
                    self.session.addOutput(metadataOutput)
                    
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.pdf417]
                } else {
                    print("Could not add metadata output")
                }
                
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.sublayer = previewLayer
                self.layer.addSublayer(self.sublayer!)
                //            previewLayer?.frame = self.view.layer.bounds
                //            self.view.layer .addSublayer(previewLayer!)
                self.session.startRunning()
            } catch let error as NSError {
                print("Error while creating vide input device: \(error.localizedDescription)")
            }
        }
        
        
    }
    //    override func layoutSublayers(of layer: CALayer) {
    //        super.layoutSublayers(of: layer)
    //        sublayer?.frame = self.layer.bounds
    //
    //    }
    //扫描成功的代理
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        mylog(metadataObjects)
        for item in metadataObjects {
            if let obj  = item as? AVMetadataMachineReadableCodeObject {
                if obj.stringValue?.count ?? 0 > 0 {
                    let isRespondOption = (self.delegate?.responds(to: #selector(QRViewDelegate.qrView(view:didCompletedWithQRValue:))))
                    if let isRespond = isRespondOption  {
                        if isRespond {
                            self.delegate?.qrView(view: self, didCompletedWithQRValue: obj.stringValue!)
                            self.session.stopRunning();
                            return
                        }
                    }
                }
                
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mylog(self.bounds)
        sublayer?.frame = self.bounds
        let  size = self.bounds.size;
        let  bgW : CGFloat = 200
        let bgH  : CGFloat = 200
        let  bgX  : CGFloat = (size.width - bgW) * 0.5;
        let  bgY  : CGFloat = (size.height - bgH) * 0.5;
        //  背景的位置
        self.bgView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: bgH)
        //  线的frame
        self.lineView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: 2)
        //  使用核心动画
        self.lineView.layer.removeAnimation(forKey: "positionAnimation")
        let  positionAnimation : CABasicAnimation =  CABasicAnimation.init(keyPath: "position.y")
        positionAnimation.fromValue = (bgY);
        positionAnimation.toValue = (self.bgView.frame.maxY)
        positionAnimation.duration = 2
        positionAnimation.repeatCount = Float(NSIntegerMax)
        self.lineView.layer.add(positionAnimation, forKey: "positionAnimation")
        self.flashLightBtn.frame = CGRect(x: self.bounds.width/2 - 22 , y: self.bounds.height - 88, width:44, height:44)
    }
    
    deinit {
        mylog("二维码视图销毁了")
    }
}
