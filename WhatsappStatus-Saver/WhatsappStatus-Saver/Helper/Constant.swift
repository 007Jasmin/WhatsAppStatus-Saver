//
//  Constant.swift
//  BloodPressureApp
//
//  Created by ERASOFT on 04/11/22.
//

import Foundation
import UIKit
import Photos

let MainScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let MainScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let Defaults = UserDefaults.standard;
let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
var langVal:String = UserDefaults.standard.string(forKey: "LangCode") ?? ""
var Flag = false
let when = DispatchTime.now() + 2.2 

//App Details
let APPNAME                             = "Status Saver - Photo Saver"
let APPID                               = "1667716909"
let RateLink                            = "https://itunes.apple.com/app/id\(APPID)?mt=8&action=write-review"
let AppURL                              = "https://itunes.apple.com/app/id\(APPID)?mt=8"
let PRIVACYPOLICY                       = "https://www.privacypolicycenter.com/view_custom.php?v=YThSR3VOL2hyL2VTL2lnQ1FQUldwdz09&n=Status-Saver---Photo-Saver"
let termsLink                           = "https://www.privacypolicycenter.com/view_custom.php?v=SnRHaWp2OVYwY0ZXSC9TSzNxaDRXUT09&n=Status-Saver---Photo-Saver"

//In-App Purchase
let sharedsecret = "6d75e682089b416c845cf7c41a5f3efe"
var IN_APP_PURCHASE_IDS = ["com.erasoft.StatusSaverApp.weekly","com.erasoft.StatusSaverApp.monthly","com.erasoft.StatusSaverApp.yearly"]
let expiredate = "Expiredate"

//StoryBoatd
var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

//Tabbar Object
var tabBarVc = UITabBarController()

//Database Object
//var db : DBHelper = DBHelper()

//Typealise Object
typealias objectCancel = () -> Void
typealias objectSelect = (_ arrPhAssest : [PHAsset]) -> Void

//Color
var StartColor = UIColor(hexString: "#FF217A")
var EndColor = UIColor(hexString: "#FF4D4D")

//Google Ads
//MARK: - Test
/*
let ADMOB_KEYS_CONFIG = "ca-app-pub-3940256099942544~1458002511"
let INTERSITIAL_ADS_ID = "ca-app-pub-3940256099942544/4411468910"
let NATIVE_ADS_ID = "ca-app-pub-3940256099942544/3986624511"
let BANNER_ADS_ID = "ca-app-pub-3940256099942544/2934735716"
let APP_OPEN_AD = "ca-app-pub-3940256099942544/5662855259"
*/

//MARK: -LIVE
///*
let ADMOB_KEYS_CONFIG = "ca-app-pub-7527011236989823~4818782064"
let INTERSITIAL_ADS_ID = "ca-app-pub-7527011236989823/7931761062"
let NATIVE_ADS_ID = "ca-app-pub-7527011236989823/9664748787"
let BANNER_ADS_ID = "ca-app-pub-7527011236989823/9244842738"
let APP_OPEN_AD = "ca-app-pub-7527011236989823/6618679393"
//*/

