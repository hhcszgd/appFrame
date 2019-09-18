//
//  DDLanguage.swift
//  YiLuMedia
//
//  Created by WY on 2019/82/27.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit
//MARK: 语言包名
enum DDLanguageType : String , CaseIterable{
    case system = "Localizable"
    case english = "en"
    case hongkong = "zh-Hant"
    case simplified = "Simplified"
    /*DDLanguageType.allCases.first.rawValue*/
}
postfix operator |?|
postfix func |?| (textForKey : String  ) -> String {
    return DDLanguage.text(textForKey)
}

class DDLanguage: NSObject {
    //MARK:获取偏好设置里现存的当前语言包名
    static var LanguageTableName : String  {//当前语言包名(是en  , 还是 ah-Hant )
        get {
            return UserDefaults.standard.string(forKey: "COUNTRYCODE") ?? "zh-Hant" // 目前默认繁体中文  . "Localizable" 语言代表跟随系统            
        }
        set{
            UserDefaults.standard.set(LanguageTableName, forKey: "COUNTRYCODE")
        }
    }
    //MARK:获取国家码
    static func getCountryCode() -> String {
        if let phoneCode = UserDefaults.standard.object(forKey: "staticPhoneCode") as? String {
            return phoneCode
        }
        
        switch DDLanguage.LanguageTableName {
        case "zh-Hant":
            return "+852"
        default:
            return "+86"
        }

    }
    
    //MARK:通过国际化的方式获取对应key值的字符串
    static func text(_ byKey : String ) -> String {
        if LanguageTableName == "Localizable" {
             return NSLocalizedString(byKey, tableName: LanguageTableName, bundle: Bundle.main, value: "nil", comment: "")
        }
        
        if let languagePackagePath = Bundle.main.path(forResource: LanguageTableName, ofType: ".lproj" , inDirectory: nil ){
            if let languageFileBundle = Bundle.init(path: languagePackagePath){
                let value = languageFileBundle.localizedString(forKey: byKey, value: "noValueFor>\(byKey)", table: "Localizable")
                return value
            }else{
                print("找不到该语言bao")
                return "nil"
            }
        }else{
            print("找不到该语言")
            return "nil"
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:////////////////////////////////////////////更改语言相关//////////////////////////////////////////////////////
    
    class  func performChangeLanguage(targetLanguage : String)  {
        
        
//        let noticStr_currentLanguageIs = NSLocalizedString(LCurrentLanguageIs, tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 :@"当前语言是"   , 英文的花 : @"currentLanguageIs" (提示语也要国际化)
//        let noticeStr_changeing = NSLocalizedString(LLanguageChangeing, tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 @"语言更改中"  英文的话 @"languageChangeing" (提示语也要国际化)
//
//        if targetLanguage == LanguageTableName && targetLanguage == LFollowSystemLanguage {//切换前后语言相同 , 除了提示之外不做任何变化
//            GDAlertView.alert(self.text(LApplyAfterRestart) , image: nil, time: 2, complateBlock: nil)
//        }else if targetLanguage == LanguageTableName {//切换前后语言相同 , 除了提示之外不做任何变化
//            GDAlertView.alert("\(noticStr_currentLanguageIs)\(DDLanguageManager.text(LLanguageID) )", image: nil, time: 2, complateBlock: nil)
//
//        }else if (targetLanguage == LFollowSystemLanguage){//由自定义语言切换为跟随系统语言
//            if DDLanguageManager.text(LLanguageID)  ==  DDLanguageManager.gotcurrentSystemLanguage() {//当切换前的自定义语言跟当前系统语言一样时 ,只保存 ,不重新切换 (如何获取系统语言??)
//                GDAlertView.alert("当前语言已经是\(targetLanguage)", image: nil, time: 2, complateBlock: nil)
//                DDStorgeManager.standard.set(LFollowSystemLanguage, forKey: LLanguageTableName)
//            }else{//否则即保存又重新切换
//                GDAlertView.alert(self.text(LApplyAfterRestart), image: nil, time: 2, complateBlock: nil)//保存前提示
//                DDStorgeManager.standard.set(LFollowSystemLanguage, forKey: LLanguageTableName)
//            }
//        }else{//切换为自定义语言
//            let oldLanguageName = LanguageTableName
//            DDStorgeManager.standard.set(targetLanguage, forKey: LLanguageTableName)
//            //            if  GDLanguageManager.titleByKey(key: LLanguageID)  != nil {
//            if DDLanguageManager.text(LLanguageID) == "languageID"  {//gotTitleStr(key:)这个方法如果找不到键所对应的值 , 就把键返回,同时也说明本地没有相应的语言包
//                GDAlertView.alert("没有相应的语言包", image: nil, time: 2, complateBlock: nil)
//                DDStorgeManager.standard.set(oldLanguageName, forKey: LLanguageTableName)//顺便改回原来的语言
//            }else{
//                DDStorgeManager.standard.set(targetLanguage, forKey: LLanguageTableName)
//
//            }
//        }
        
    }
    
}


//提示语
let LCurrentLanguageIs  =  "currentLanguageIs"// = "当前语言已经是";
let  LLanguageChangeing  = "languageChangeing"// = "语言切换中 请稍后...";
let LConfirm = "confirm" //= "确定";
let LCancel = "cancel" //= "取消";
let LLanguageTableName = "LanguageTableName"
let LApplyAfterRestart = "applyAfterRestart"
///国家区号
var staticPhoneCode = DDLanguage.getCountryCode() {
    didSet{
        UserDefaults.standard.setValue(staticPhoneCode, forKey: "staticPhoneCode")
    }
}
