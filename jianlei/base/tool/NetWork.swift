//
//  NetWork.swift
//  RxSwiftLearn
//
//  Created by 张凯强 on 2019/9/29.
//  Copyright © 2019年 张凯强. All rights reserved.
//


import Foundation
import Alamofire
import RxSwift
///全局变量键盘的高度
var keyboardHeight: CGFloat = 346



enum Router: URLRequestConvertible {
    ///get请求
    case get(String, DomainType, [String: Any]?)
    ///post请求
    case post(String,DomainType , [String: Any]?)
    
    case put(String, DomainType, [String: Any]?)
    
    case delete(String, DomainType, [String: Any]?)
    
    ///URLRequestConvertible 代理方法
    func asURLRequest() throws -> URLRequest {
        ///请求方式
        var method: HTTPMethod {
            switch self {
            case .get:
                return HTTPMethod.get
            case .post:
                return HTTPMethod.post
            case .put:
                return HTTPMethod.put
            case .delete:
                return HTTPMethod.delete
            }
        }
        ///请求参数
        var params: [String: Any]? {
            switch self {
            case let .get(_, _, dict):
                return dict
            case let .post(_, _, dict):
               return dict
            case let .put(_, _, dict):
                return dict
            case let .delete(_, _, dict):
                return dict
                
            }
            
        }
        ///请求的网址
        var url: URL {
            var URLStr: String = ""
            switch self {
            case let .get(urlStr, baseUrl, _):
                URLStr = baseUrl.rawValue  + "v\(DDCurrentAppVersion)/" + urlStr
            case let .post(urlStr, baseUrl, _):
                URLStr = baseUrl.rawValue + "v\(DDCurrentAppVersion)/"  + urlStr
            case let .put(urlStr, baseUrl, _):
                URLStr = baseUrl.rawValue + "v\(DDCurrentAppVersion)/"  + urlStr
            case let .delete(urlStr, baseUrl, _):
                URLStr = baseUrl.rawValue + "v\(DDCurrentAppVersion)/"  + urlStr
            }
            
           
            let url = URL.init(string: URLStr)
            
            return url!
            
            
            
        }
        var request = URLRequest.init(url: url)
        
        request.httpMethod = method.rawValue
        if let headerToken = UserDefaults.standard.value(forKey: "Public_Key") as? String{
            request.allHTTPHeaderFields = ["device-number": UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString, "public-key": headerToken   ]
        }
        
        let encoding = URLEncoding.default
        let urlEncoding = try encoding.encode(request, with: params)
        mylog(urlEncoding.url?.absoluteString)
        return urlEncoding
    }

    
    
    
    
}
enum NetWorkStatus {
    ///不清楚
    case unknow
    ///蜂窝数据
    case wwan
    ///wifi
    case wifi
    ///不可达
    case notReachable
}

enum NetWorkError: Error {
    ///数据格式错误
    case formatError
    ///已经初始化
    case repeadInit
    ///没有连接到网络
    case notReachable
}
class NetWork {
    static let manager = NetWork.init()
    private init() {
        
    }
    func requestData(router: Router) -> Observable<[String: AnyObject]> {
        return Observable<[String: AnyObject]>.create({ (observer) -> Disposable in
            //数据处理
            mylog(router)
            if let status = NetworkReachabilityManager.init(host: "www.baidu.com")?.networkReachabilityStatus {
                switch status {
                case .notReachable, .unknown:
                    GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                    observer.onError(NetWorkError.notReachable)
                    return Disposables.create()
                case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi), .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                    break
                default:
                    break
                    
                }
            }
            let request = Alamofire.request(router).responseJSON(completionHandler: { (result) in
                mylog(result)
                switch result.result {
                case .success(let value):
                    
                    guard let dict = value as? [String: AnyObject] else {
                        observer.onError(NetWorkError.formatError)
                        return
                    }
                    
                    observer.onNext(dict)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            
            
            return Disposables.create {
                request.cancel()
            }
            
            
            
        })
    }
    func getTime(word: String, hour: String, finished: @escaping ((String) -> ())) {
        
        let router = Router.get("system/get-date-time/\(word)/\(hour)", DomainType.api, ["token": DDAccount.share.token ?? ""])
        let _ = self.requestData(router: router).subscribe(onNext: { (dict) in
            let model = BaseModel<String>.deserialize(from: dict)
            if model?.status == 200, let time = model?.data {
                finished(time)
            }else {
                finished("时间没有获取")
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    func requestData(router: Router, success: @escaping (DataResponse<Any>) -> (), failure failure: @escaping () -> ()) {
        if let status = NetworkReachabilityManager.init(host: "www.baidu.com")?.networkReachabilityStatus {
            switch status {
            case .notReachable, .unknown:
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                failure()
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi), .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                break
                
                
            }
        }
        mylog(router)
        let _ = Alamofire.request(router).responseJSON { (result) in
            switch result.result {
            case .success(_):
                
                
                success(result)
                break
            case .failure(let error):
                mylog(error)
                failure()
                break
            }
        }
    }
    
    
    
    func getPublicKey(success: @escaping (String) ->()) {
        class PrivateModel: Codable {
            var public_key: String?
        }
        let paramete = ["device_number": ZKQUUID, "type": "ios"]
        let router = Router.get("system/public-key", DomainType.api, paramete)
        self.requestData(router: router, success: { (response) in
            let model = DDJsonCode.decodeAlamofireResponse(ApiModel<PrivateModel>.self, from: response)
            if let key = model?.data?.public_key, key.count > 0 {
                let mdKey = (key + "1sA5d1gPPms8Oolos").md5()
                
                success(mdKey)
            }else {
                success("")
            }
            
        }) {
            success("")
            mylog("獲取publickey失敗")
        }
    }
//    func requestData(router: Router) -> Observable<[String: AnyObject]> {
//        return Observable<[String: AnyObject]>.create({ (observer) -> Disposable in
//            //数据处理
//            
//            let request = Alamofire.request(router).responseJSON(completionHandler: { (result) in
//                mylog(result)
//                switch result.result {
//                case .success(let value):
//                    
//                    guard let dict = value as? [String: AnyObject] else {
//                        observer.onError(NetWorkError.formatError)
//                        return
//                    }
//                
//                    observer.onNext(dict)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//            })
//            
//            
//            return Disposables.create {
//                request.cancel()
//            }
//            
//            
//            
//        })
//    }
   
    
}




