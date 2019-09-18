
//  DDRequestManager.swift
//  ZDLao
//
//  Created by WY on 2019/9/17.
//  Copyright © 2019年 jianlei. All rights reserved.

import UIKit
import Alamofire
import CoreLocation
let TestToken : String? = "3AfmM8NUUcV4vdhkIeQ_OaC64f2bZSqH"
//http://dpi.jianlei.com
enum DomainType : String  {
    #if DEBUG
    /// 正式环境
//        case api  = "https://api.jianlei.com/"
//        case wap = "https://wap.jianlei.com/"
    /// 测试环境
//    case api  = "https://tpi.jianlei.cn/"
//    case wap = "https://tap.jianlei.cn/"
    /// 开发环境
        case api = "http://dpi.jianlei.com/"
        case wap = "http://wap.jianlei.com/"
    /// 灰度
//            case api = "https://hapi.16media.com/"
//            case wap = "https://hwap.16media.com/"

    #else
        case api  = "https://api.jianlei.com/"
        case wap = "https://wap.jianlei.com/"
    
    #endif
}
/// api list
extension DDRequestManager{
    /// write your api here 👇
    
    @discardableResult
    func getArea<T>(type : ApiModel<T>.Type , parent_id : String?, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "area"
        var  para = ["token" : DDAccount.share.token ?? "" ]
        if let parentID = parent_id {
            para["parent_id"] = parentID
        }
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    @discardableResult
    func changeDianGongInfo<T>(type : ApiModel<T>.Type,parameters : DianGongInfo , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/cert"//TODO 1 要改成真是的memberID
        var para = ["token" : DDAccount.share.token ?? ""]
        para["electrician_certificate_number"] = parameters.electrician_certificate_number
        //        para["electrician_certificate_level"] = parameters.electrician_certificate_level
        para["electrician_certificate_type"] = parameters.electrician_certificate_type
        para["electrician_certificate_area_name"] = parameters.electrician_certificate_area_name
        para["electrician_certificate_front_image"] = parameters.electrician_certificate_front_image
        para["electrician_certificate_back_image"] = parameters.electrician_certificate_back_image
        para["professional_name"] = parameters.professional_name
        para["live_area_id"] = parameters.live_area_id
        para["live_address"] = parameters.live_address
        para["electrician_expire_start"] = parameters.electrician_expire_start
        para["electrician_expire_end"] = parameters.electrician_expire_end
        return self.requestServer(type: type , method: HTTPMethod.put, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    
    
    @discardableResult
    func getDianGongInfo<T>(type : ApiModel<T>.Type, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/cert"//TODO 1 要改成真是的memberID
        let para = ["token" : DDAccount.share.token ?? ""]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    @discardableResult
    func joinTeam<T>(type : ApiModel<T>.Type,team_member_name : String, team_member_mobile : String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "team/join"
        let para = ["token" : DDAccount.share.token ?? "" , "team_member_name":team_member_name ,"team_member_mobile" : team_member_mobile ]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func leaveTeam<T>(type : ApiModel<T>.Type,teamID : String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "team/\(teamID)"
        let  para = ["token" : DDAccount.share.token ?? "" ]
        return self.requestServer(type: type , method: HTTPMethod.delete, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    @discardableResult
    func releaseShopMedia<T>(type : ApiModel<T>.Type,shop_id : String,ttype:String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "my-shop/release/\(shop_id)"
        let  para = ["token" : DDAccount.share.token ?? "" ,"shop_type" : ttype]
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func getShopList<T>(type : ApiModel<T>.Type, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "my-shop/list"//TODO 1 要改成真是的memberID
        let para = ["token" : DDAccount.share.token ?? ""]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    @discardableResult
    func manageShopAdMedia<T>(type : ApiModel<T>.Type,shop_id : String ,sort_json : String , ttype: String? = "" , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest? {
        let url  =  "my-shop/sort/\(shop_id)"
        var  para = ["token" : DDAccount.share.token ?? "" ]
        para["shop_id"] = shop_id
        para["sort_json"] = sort_json
        para["shop_type"] = ttype
        return self.requestServer(type: type , method: HTTPMethod.put, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    /// type : 1:累计收益 , 2:订单信息
    @discardableResult
    func getRewardDetail<T>(type : ApiModel<T>.Type , requestType : Int,page:Int = 1,id:String? = nil ,shop_id : String? = nil , head_id:String? = nil ,success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        var url = ""
        var  para = [String:String]()
        if requestType == 2{
            url = "reward/order-list"
            para["id"] =  id
            para["page"] = "\(page)"
        }else{//累计收益
            url = "reward/all"
            para["page"] = "\(page)"
            if let value = shop_id{
                para["shop_id"] = "\(value)"
            }else if let value = head_id{
                para["head_id"] = "\(value)"
            }
        }
        
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    @discardableResult
    func showHasBeenUploadMedias<T>(type : ApiModel<T>.Type ,shop_id : String,ttype: String? = "", success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "my-shop/show/\(shop_id)"
        var  para = ["token" : DDAccount.share.token ?? "" ]
        para["shop_type"] = ttype
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    @discardableResult
    func getCashAction<T>(type : ApiModel<T>.Type ,bank_id :String , price:String , payment_password:String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "")/withdraw"
//        let nsStr  = NSString.init(string: price)
//        let priceFloat = nsStr.floatValue
        let  para = [
            "token" : DDAccount.share.token ?? "",
            "bank_id" :bank_id ,
            "price":price ,
            "payment_password":payment_password
        ]
        return self.request(type: type , method: HTTPMethod.post, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    @discardableResult
    func getBankBrandList<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" ]
        
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    //account_name個人時要傳
    @discardableResult
    func bandBankCard<T>(type : ApiModel<T>.Type  ,ownName : String,account_name:String = "" , cardNum:String , mobile:String , bankID : String = "0" , verify : String,cardType:String = "1" ,bankName:String? = nil,abbreviation_name:String? = nil ,countryCode : String, success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "0")/bank"//TODO 1 替换成真实memberID
        var  para = ["token" : DDAccount.share.token ?? "" , "bank_id" : bankID , "number" : cardNum , "mobile" : mobile ,"verify" : verify , "name":ownName , "type":cardType, "country_code":countryCode]
        if let bankname = bankName{para["bank_name"] = bankname}
        if let abbreviation_name = abbreviation_name , abbreviation_name.count > 0{para["abbreviation_name"] = abbreviation_name}
        if account_name.count > 0 {para["account_name"] = account_name}
        return self.request(type: type , method: HTTPMethod.post, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    /*
     getPublicKey
     */
    struct PublickKeyModel : Codable {
        var public_key : String
    }

    @discardableResult
    private func getPublicKey( functionType : String = "3" , success:@escaping (ApiModel<PublickKeyModel>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil  ) -> DataRequest? {
        let url  =  "system/public-key"
        //        "40d1783fbb98f6ed3b17c661786d5edf"
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let para = ["device_number" : deviceID  , "type" : "ios"] as [String : Any]
        return self.request(type: ApiModel<PublickKeyModel>.self , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    func getPublickKey(force:Bool = false , publicKey :@escaping (String?) -> Void)  {
        if let tempPublicKey = UserDefaults.standard.value(forKey: "Public_Key") as? String , !force{
            publicKey(tempPublicKey)
        }else{
            DDRequestManager.share.getPublicKey(success:  { (apiModel) in
                if let  tempPublicKey = apiModel.data?.public_key{
                    let salt = "1sA5d1gPPms8Oolos"
                    let headerToken = ( tempPublicKey + salt).md5()
                    UserDefaults.standard.setValue(headerToken, forKey: "Public_Key")
                    print("get public key success\(headerToken)")
                    publicKey(headerToken)
                }else{
                    print("get public key failure")
                    publicKey(nil)
                }
            })
        }
        
    }
    
    
    
    
    @discardableResult
    func getAuthCode<T>(type : ApiModel<T>.Type  ,functionType : String = "3" , mobile : String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        
        let url  =  "verify"//
        let  para = ["token" : DDAccount.share.token ?? "" , "type" : functionType , "mobile" :  mobile , "country_code" : staticPhoneCode]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    @discardableResult
    func achievementStatistic<T>(type : ApiModel<T>.Type  ,create_at:String? , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "0")/account"//TODO 1 替换成真实memberID
        var  para = ["token" : DDAccount.share.token ?? ""]
        if let create_at_unwrap = create_at{
            para["create_at"] = create_at_unwrap
        }
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    
    
    @discardableResult
    func untieBankCard<T:Codable>(type : T.Type  ,bankID : String , success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "")/bank/\(bankID)"
        let  para = ["token" : DDAccount.share.token ?? "" ]
        return self.request(type: type , method: HTTPMethod.delete, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    
    @discardableResult
    func getBandkCard<T>(type : ApiModel<T>.Type  , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "0")/bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" ]
        
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    @discardableResult
    func getCashPage<T>(type : ApiModel<T>.Type  , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "")/withdraw"
        let  para = ["token" : DDAccount.share.token ?? "" ]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    @discardableResult
    func getServerTime<T>(type : ApiModel<T>.Type , showDate : Bool = false , shouTime:Bool = true, minute : Bool = false , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        var url =  "system/get-date-time/\(showDate ? "1" : "0")/\(shouTime ? "1" : "0")"
        if minute{
            url.append("?minute=1")
        }
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    ///搜索dianpu
    @discardableResult
    func shopSearch<T>(type : ApiModel<T>.Type,keyWord:String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/shop-search"
        var para = [ "country_name":DDLocationManager.share.userLocateCountry.countryName,"country_code":DDLocationManager.share.userLocateCountry.countryCode , "screen_type":"2"]
        if let longitude = DDLocationManager.share.locationManager.location?.coordinate.longitude,let latitude = DDLocationManager.share.locationManager.location?.coordinate.latitude{
            para["longitude"] = "\(longitude)"
            para["latitude"] = "\(latitude)"
        }
        para["word"] = keyWord
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    ///获取签到界面数据
    @discardableResult
    func
        getBussinessSignPageData<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/sign"
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    /// 足迹-管理员选择团队列表
    /// 负责人：    高建波
    /// Url地址：   sign/choose-team
    /// GET
    @discardableResult
    func selectTeam<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/choose-team"
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    @discardableResult
    func getAllSignPoint<T>(type : ApiModel<T>.Type , team_id : String , create_at:String,success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/team-all-data"
        let string = self.convertTime(time: create_at)
        let para = ["team_id" :team_id ,"create_at" : string , "country_name":DDLocationManager.share.userLocateCountry.countryName,"country_code":DDLocationManager.share.userLocateCountry.countryCode , "screen_type":"2"]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    ///未签到人
    @discardableResult
    func notSignData<T>(type : ApiModel<T>.Type,create_at:String , team_id:String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/not-sign"
        let string = self.convertTime(time: create_at)
        let para = ["create_at":string ,"team_id":team_id ]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    ///  维护签到选择店铺列表
    func selectRepairShopList<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        var url =  "sign/shop-list"
        if let longitude = DDLocationManager.share.locationManager.location?.coordinate.longitude,let latitude = DDLocationManager.share.locationManager.location?.coordinate.latitude{
            url.append("/\(longitude)/\(latitude)")
            
        }
        let para = [ "country_name":DDLocationManager.share.userLocateCountry.countryName,"country_code":DDLocationManager.share.userLocateCountry.countryCode , "screen_type":"2"]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    @discardableResult
    func teamFootprintPage<T>(type : ApiModel<T>.Type,page:Int, create_at : String? = nil,team_id:String? = nil   , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/team-footmark"
        var para = [String:String]()
        para["page"] = "\(page)"
        //        if let create_at = create_at{
        //            if create_at.contains("年"){
        //                let dataFormate = DateFormatter()
        //                dataFormate.dateFormat = "yyyy年MM月dd日"
        //                let rempDate = dataFormate.date(from: create_at)
        //                dataFormate.dateFormat = "yyyy-MM-dd"
        //                let string = dataFormate.string(from: rempDate ?? Date())
        //                para["create_at"] = string
        //
        //            }else{
        //                para["create_at"] = create_at
        //            }
        //        }
        if let t = create_at{
            para["create_at"] = self.convertTime(time: t)
        }
        if let team_id = team_id{
            para["team_id"] = team_id
        }
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    @discardableResult
    func getPersonalSignDetail<T>(type : ApiModel<T>.Type , create_at : String , member_id:String, team_id : String,page:Int  , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/single-sign-view"
        let para = ["create_at" :create_at ,"member_id" : member_id,"team_id" : team_id , "page":"\(page)"]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    @discardableResult
    func getOneTimeSignDetail<T>(type : ApiModel<T>.Type , id : String , member_id:String,success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/single-detail"
        let para = ["id" :id ,"member_id" : member_id, "country_name":DDLocationManager.share.userLocateCountry.countryName,"country_code":DDLocationManager.share.userLocateCountry.countryCode , "screen_type":"2"]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    
    
    
    
    
    
    /*
     check version
     */
    @discardableResult
    func checkLatestAppVersion<T:Codable>(type : T.Type, success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "system/version"
        let para = ["token" : DDAccount.share.token ?? "" , "app_type" : "2"]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para ,needToken: false  , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func getNotificationStatus<T:Codable>(type : T.Type, success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "")/status"
        let  para = [
            "token" : DDAccount.share.token ?? ""
        ]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func setNotificationStatus<T:Codable>(type : T.Type,push_status:String? ,push_shock:String?,push_voice:String?, success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url  =  "member/\(DDAccount.share.id ?? "")/push"
        var  para = [
            "token" : DDAccount.share.token ?? ""
        ]
        if let pushStatus = push_status{para["push_status"] = pushStatus}
        if let pushShake = push_shock{para["push_shock"] = pushShake}
        if let pushVoice = push_voice{para["push_voice"] = pushVoice}
        return self.request(type: type , method: HTTPMethod.put, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func authenticateInfo<T:Codable>(type : T.Type, success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "member/\(DDAccount.share.id ?? "")/id"
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    
    @discardableResult
    func performAuthenticate<T:Codable>(type : T.Type,info:(name:String,gender:String,idNum:String,frontImg:String,backImg:String) , success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "member/\(DDAccount.share.id ?? "")/id"
        let para = [
            "name" : info.name ,
            "sex" : info.gender ,
            "id_number": info.idNum ,
            "id_front_image" : info.frontImg ,
            "id_back_image" : info.backImg
        ]
        return self.request(type: type , method: HTTPMethod.put, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
//    @discardableResult
//    func requestTencentSign<T:Codable>(type : T.Type , success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
//        let url =  "qcloud"
//        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
//    }
    
    
    @discardableResult
    func messagePage<T>(type : ApiModel<T>.Type,page : Int  , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "member/message"
        let para = ["page":"\(page)"]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    @discardableResult
    func homePage<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "system/index"
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    func testUrlSession() {
    }
    
    struct VersionModel  :  Codable{
        var name : String
        var message : String
        var code  : Int
        var type : String
    }
    
    
}












class DDRequestManager: NSObject {
    let version = "v\(DDCurrentAppVersion)/"
    var sessionManager : SessionManager!
    var token : String? = "token"
    let client = COSClient.init(appId: "1255626690", withRegion: "hk")
    static let share : DDRequestManager = {
        
        let man = DDRequestManager()
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval.init(10)
        let sessionDelegate = SessionDelegate()
        let urlSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        man.sessionManager = SessionManager.init(session: urlSession, delegate: sessionDelegate)
        let time = man.sessionManager.session.configuration.timeoutIntervalForRequest
        mylog(time )
        return man
    }()
    var networkStatus : (oldStatus : Bool , newStatus : Bool ) =  (oldStatus : false , newStatus : false )
    lazy var networkReachabilityManager: NetworkReachabilityManager? = {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = {status in
            self.networkStatus.oldStatus = self.networkStatus.newStatus
            switch status {
            case .notReachable:
                mylog("1")
                GDAlertView.alert("network_error_try_again"|?|, image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .unknown :
                mylog("2")
                GDAlertView.alert("network_error_try_again"|?|, image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                mylog("3")
                self.networkStatus.newStatus = true
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                self.networkStatus.newStatus = true
                mylog("4")
                break
            }
            NotificationCenter.default.post(name: NSNotification.Name("DDNetworkChanged"), object: nil, userInfo: ["status":self.networkStatus])
        }
        return reachabilityManager
    }()
    
}



extension DDRequestManager{
    
    

    
    //    @discardableResult
    //    private func requestApi<T:Codable>(type : ApiModel<T>.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil  , needToken: Bool  = true,autoAlertWhileFailure : Bool = true  , success: @escaping (T)->(),failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
    //        self.request(type: type, method: method, url: url, parameters: parameters, needToken: needToken, autoAlertWhileFailure: autoAlertWhileFailure, success: success, failure: failure, complate: complate)
    //    }
    //    
    
    
    /// request server api
    ///
    /// - Parameters:
    ///   - type: model type
    ///   - method: request method
    ///   - url: url
    ///   - parameters: parameters
    ///   - failure: invoke when mistakes
    ///   - success: invoke when success
    ///   - complate: invoke always (failure or success)
    
    private func requestServer<T>(type : ApiModel<T>.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil  , needToken: Bool  = true,autoAlertWhileFailure : Bool = true  , success:@escaping (ApiModel<T>)->(),failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
        //        let result = networkReachabilityManager?.startListening()
        //        mylog("是否  监听  成功  \(result)")
        mylog("\(networkReachabilityManager?.networkReachabilityStatus)")
        if let status = networkReachabilityManager?.isReachable , !status {
            ////            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            failure?(DDError.networkError)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("network_error_try_again"|?|, image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
        
        let urlFull = DomainType.api.rawValue + version + url
        var para = Parameters()
        if let parametersUnwrap = parameters{para = parametersUnwrap}
//        para["l"] = DDLanguageManager.languageIdentifier
        //        para["c"] = DDLanguageManager.countryCode
        para["l"] = "110"
//        if urlFull != DomainType.api.rawValue + "Initkey/rest"{//初始化接口不需要token

        if needToken {
            if let tokenReal = TestToken{ // DDAccount.share.token {
                para["token"] = tokenReal
            }else{
                
                
                mylog("token is nil")
                failure?(DDError.noToken)
                complate?()
                if autoAlertWhileFailure {
                    GDAlertView.alert("token为空,请退出并重新登录", image: nil, time: 2, complateBlock: nil)
                }
                return nil
            }
        }
        
//            if let tokenReal = DDAccount.share.token {
//                para["token"] = tokenReal
//            }else{
//
//
//                mylog("token is nil")
//                failure?(DDError.noToken)
//                complate?()
//                return nil
//            }
//        }
        
        //        let language = DDLanguageManager.countryCode
        let language = "110"
        var header = [String : String]()
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header["VERSIONID"] = "2.0"
        header["language"] = language
        
        if let url  = URL(string: urlFull){
            let task = DDRequestManager.share.sessionManager.request(url , method: method , parameters: para , headers:header).responseJSON(completionHandler: { (response) in
                //                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    
                    if let a = DDJsonCode.decodeAlamofireResponse(ApiModel<T>.self, from: response){
                        success(a)
                        complate?()
                    }else{
                        failure?(DDError.modelUnconvertable)
                        complate?()
                        if autoAlertWhileFailure {
                            GDAlertView.alert("server_data_type_error"|?|, image: nil, time: 2, complateBlock: nil)
                        }
                    }
//                    if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
//                        success(a)
//                        complate?()
//                    }else{
//                        failure?(DDError.modelUnconvertable)
//                        complate?()
//                    }
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    mylog(response.result.error?.localizedDescription)
                    if let error = response.result.error as? NSError{
                        if error.code == -1001{
                            failure?(DDError.serverError("request_time_out"|?|))
                            if autoAlertWhileFailure {
                                GDAlertView.alert("request_time_out"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                        }else if error.code == -999{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("cancle_request"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError("cancle_request"|?|))
                        }else{
                            if let errorMsg = response.result.error?.localizedDescription {
                                failure?(DDError.serverError(errorMsg))
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                                }
                            }else{
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                                }
                                failure?(DDError.otherError(nil))
                            }
                        }
                    }else{
                        if let errorMsg = response.result.error?.localizedDescription {
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError(errorMsg))
                        }else{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.otherError(nil))
                        }
                    }
                    complate?()
                }
            })
            return task
        }else{
            failure?(DDError.urlUnconvertable)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("url不合法", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
    }
    

    
    
    
    
    
    
    
    
    
    @discardableResult
    private func request<T:Codable>(type : T.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil  , needToken: Bool  = true,autoAlertWhileFailure : Bool = true  , success:@escaping (T)->() ,failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
        //        let result = networkReachabilityManager?.startListening()
        //        mylog("是否  监听  成功  \(result)")
        mylog("\(networkReachabilityManager?.networkReachabilityStatus)")
        if let status = networkReachabilityManager?.isReachable , !status {
            ////            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            failure?(DDError.networkError)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("network_error_try_again"|?|, image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
        
        let urlFull = DomainType.api.rawValue + version + url
        var para = Parameters()
        if let parametersUnwrap = parameters{para = parametersUnwrap}
        //        para["l"] = DDLanguageManager.languageIdentifier
        //        para["c"] = DDLanguageManager.countryCode
        para["l"] = "110"
        //        if urlFull != DomainType.api.rawValue + "Initkey/rest"{//初始化接口不需要token
        if needToken {
            if let tokenReal = DDAccount.share.token {
                para["token"] = tokenReal
            }else{
                
                
                mylog("token is nil")
                failure?(DDError.noToken)
                complate?()
                if autoAlertWhileFailure {
                    GDAlertView.alert("token为空,请退出并重新登录", image: nil, time: 2, complateBlock: nil)
                }
                return nil
            }
        }
        
        //            if let tokenReal = DDAccount.share.token {
        //                para["token"] = tokenReal
        //            }else{
        //
        //
        //                mylog("token is nil")
        //                failure?(DDError.noToken)
        //                complate?()
        //                return nil
        //            }
        //        }
        
        //        let language = DDLanguageManager.countryCode
        let language = "110"
        var header = [String : String]()
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header["VERSIONID"] = "2.0"
        header["language"] = language
        
        if let url  = URL(string: urlFull){
            let task = DDRequestManager.share.sessionManager.request(url , method: method , parameters: para , headers:header).responseJSON(completionHandler: { (response) in
                //                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    if let a = DDJsonCode.decode(T.self, from: response.data){
//                    if let a = DDJsonCode.decodeAlamofireResponse(T.self, from: response){
                        success(a)
                        complate?()
                    }else{
                        failure?(DDError.modelUnconvertable)
                        complate?()
                        if autoAlertWhileFailure {
                            GDAlertView.alert("server_data_type_error"|?|, image: nil, time: 2, complateBlock: nil)
                        }
                    }
                    //                    if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
                    //                        success(a)
                    //                        complate?()
                    //                    }else{
                    //                        failure?(DDError.modelUnconvertable)
                    //                        complate?()
                //                    }
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    mylog(response.result.error?.localizedDescription)
                    if let error = response.result.error as? NSError{
                        if error.code == -1001{
                            failure?(DDError.serverError("request_time_out"|?|))
                            if autoAlertWhileFailure {
                                GDAlertView.alert("request_time_out"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                        }else if error.code == -999{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("cancle_request"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError("cancle_request"|?|))
                        }else{
                            if let errorMsg = response.result.error?.localizedDescription {
                                failure?(DDError.serverError(errorMsg))
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                                }
                            }else{
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                                }
                                failure?(DDError.otherError(nil))
                            }
                        }
                    }else{
                        if let errorMsg = response.result.error?.localizedDescription {
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError(errorMsg))
                        }else{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("server_side_error"|?|, image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.otherError(nil))
                        }
                    }
                    complate?()
                }
            })
            return task
        }else{
            failure?(DDError.urlUnconvertable)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("url不合法", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
    }
    
    func convertTime(time:String) -> String{
        if time.contains("date_year"|?|){
            let dataFormate = DateFormatter()
            dataFormate.dateFormat = "yyyy\("date_year"|?|)MM\("date_month"|?|)dd\("date_day"|?|)"
            let rempDate = dataFormate.date(from: time)
            dataFormate.dateFormat = "yyyy-MM-dd"
            let string = dataFormate.string(from: rempDate ?? Date())
            return string
        }else{
            return time
        }
    }
    

}

extension DDRequestManager{
    //// 店家上传图片保存接口
    //type 2总店 , 1非总店
    @discardableResult
    func saveShopMediaUrl<T>(type : ApiModel<T>.Type, shop_id : String ,image_url : String ,imageSize:String,sha1HexString:String, shopType: String? = "" , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil) -> DataRequest? {
        let url  =  "my-shop/save-shop-image"
        var  para = ["token" : DDAccount.share.token ?? "" ]
        para["shop_id"] = shop_id
        para["image_url"] = image_url
        para["shop_type"] = shopType ?? ""
        para["image_sha"] = sha1HexString
        para["image_size"] = imageSize
        return self.requestServer(type: type , method: HTTPMethod.post, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    /// request sign
    func requestTencentSign<T:Codable>(type : T.Type, success:@escaping (T)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?  {
        let url  =  "qcloud"
        let  para = [ "token": DDAccount.share.token ?? "" ]
        return self.request(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
//    func testSha1Encode(imageFilePath:String , imageUrl:String) {
//        //        let data = UIImagePNGRepresentation(UIImage(named: "60b7a60ee8353be3")!)
//        let path = Bundle.main.path(forResource: "1540095110743.jpg", ofType: nil)
//        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
//        let str = data?.sha1().toHexString()
//        mylog("sha1 编码之后的字符串\(String(describing: str))")
//    }
//
    func uploadShopAdMediaToTencentYun(image:UIImage ,progressHandler:@escaping ( Int,  Int, Int)->(),compateHandler : @escaping (_ imageUrl:String? ,_ dataSize : String,_ sha1HexStr:String)->())  {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath = docuPath  {
            var fileNameInServer = "\(Date().timeIntervalSince1970 )"
            if fileNameInServer.contains("."){
                if let index = fileNameInServer.index(of: "."){
                    fileNameInServer.remove(at: index)
                }
            }
            let filePath = realDocuPath + "/\(fileNameInServer).JPEG"
            let filePathUrl = URL(fileURLWithPath: filePath, isDirectory: true )
            mylog(filePath)
            do{
//                UIImage.jpegData(compressionQuality:)'
                let _ = try image.jpegData(compressionQuality: 0.5)?.write(to: filePathUrl)
                let originData  = try? Data(contentsOf: filePathUrl )
                let a = originData?.sha1()
                let hexStr = a?.toHexString()
                let dataSize = originData?.count ?? 0
                if hexStr == nil {
                    compateHandler(nil,"" , "" )
                    try? FileManager.default.removeItem(atPath: filePath)
                    GDAlertView.alert("图片上传失败", image: nil, time: 1, complateBlock: nil)
                    return
                }
                self.requestTencentSign(type: [String:String].self, success: { (dict ) in
                    let signStr = dict["token"]
                    let id = DDAccount.share.id ?? "0"
                    let uploadTask = COSObjectPutTask.init(path: filePath, sign: signStr, bucket: "16media", fileName: fileNameInServer + ".JPEG", customAttribute: "temp", uploadDirectory: "member/\(id)", insertOnly: true)
                    
                    self.client?.completionHandler = {(/*COSTaskRsp **/resp, /*NSDictionary */context) in
                        try? FileManager.default.removeItem(atPath: filePath)
                        if let  resp = resp as? COSObjectUploadTaskRsp{
                            //                            mylog(context)
                            //                            mylog(resp.descMsg)
                            //                            mylog(resp.fileData)
                            //
                            mylog(resp.data)
                            dump(resp)
                            mylog(resp.sourceURL)//发给服务器
                            mylog(resp.httpsURL)
                            mylog(resp.objectURL)
                            mylog(resp.retCode)
                            if (resp.retCode == 0) {
                                //sucess
                                compateHandler(resp.sourceURL,"\(dataSize)" , hexStr!)
                            }else{
                                
                                compateHandler(nil ,"",  "")
                                GDAlertView.alert("图片上传失败", image: nil, time: 1, complateBlock: nil)
                            }
                        }else{
                            compateHandler(nil ,"",  "")
                        }
                        self.client?.progressHandler = nil
                    };
                    self.client?.progressHandler = {( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        progressHandler(Int(bytesWritten), Int(totalBytesWritten), Int(totalBytesExpectedToWrite))
                        mylog("\(bytesWritten)---\(totalBytesWritten)---\(totalBytesExpectedToWrite)")
                        //progress
                    }
                    self.client?.putObject(uploadTask)
                }, failure: { (error ) in
                    compateHandler(nil , "", "" );
                })
            }catch{
                mylog(error)
                compateHandler(nil,"","")
            }
            
            //            let filePath = realDocuPath.append//appendingPathComponent("Account.data")
        }else{
            compateHandler(nil,"","")
        }
    }
    
}
