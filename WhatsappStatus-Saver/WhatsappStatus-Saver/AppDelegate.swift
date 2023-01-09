//
//  AppDelegate.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 16/12/22.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        if Reachability.isConnectedToNetwork() {
            GADMobileAds.sharedInstance().start { (completion) in
                AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
                AdsManager.shared.loadInterstitialAd()
            }
            
        }else {
            print("internet not connected")
        }
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }
}

