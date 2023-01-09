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

//App Details
let APPNAME                             = "WhatsApp Status Saver"
let APPID                               = ""
let RateLink                            = "https://itunes.apple.com/app/id\(APPID)?mt=8&action=write-review"
let AppURL                              = "https://itunes.apple.com/app/id\(APPID)?mt=8"
let PRIVACYPOLICY                       = "https://www.privacypolicycenter.com/view_custom.php?v=S2ZXZnJhdkk2ajhWUlJCcnVVeVJFZz09&n=Blood-Pressure-Tracker"
let termsLink                           = ""
let EMAIL                               = "erasoft.gaurav@gmail.com"


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
///*
let ADMOB_KEYS_CONFIG = "ca-app-pub-3940256099942544~1458002511"
let INTERSITIAL_ADS_ID = "ca-app-pub-3940256099942544/4411468910"
let NATIVE_ADS_ID = "ca-app-pub-3940256099942544/3986624511"
let BANNER_ADS_ID = "ca-app-pub-3940256099942544/2934735716"
let APP_OPEN_AD = "ca-app-pub-3940256099942544/5662855259"
//*/

//MARK: -LIVE
/*
let ADMOB_KEYS_CONFIG = "ca-app-pub-7598743053801828~4805802255"
let INTERSITIAL_ADS_ID = "ca-app-pub-7598743053801828/3532001613"
let NATIVE_ADS_ID = "ca-app-pub-7598743053801828/2218919946"
let BANNER_ADS_ID = ""
let APP_OPEN_AD = "ca-app-pub-7598743053801828/4487072200"
*/

