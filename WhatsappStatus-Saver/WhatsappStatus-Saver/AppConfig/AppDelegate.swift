//
//  AppDelegate.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 16/12/22.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMobileAds
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    var isAppOpenAdDisplay = Bool()
    var appOpenAd : GADAppOpenAd?
    var loadTime = Date()
    var isFirstTIme : Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        Defaults.set(0, forKey: "FirstClick")
        self.setupIAP()
        if Reachability.isConnectedToNetwork() {
            GADMobileAds.sharedInstance().start { (completion) in
                if !Defaults.bool(forKey: "adRemoved") {
                    AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
                    AdsManager.shared.loadInterstitialAd()
                }
            }
        }else {
            print("internet not connected")
        }
        return true
    }
    
    func setupIAP() {
        InAppManager.shared.completeTransition()
        InAppManager.shared.verifyReciept()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if !Defaults.bool(forKey: "adRemoved") {
            self.tryToPresentAd()
            self.isAppOpenAdDisplay = false
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.isAppOpenAdDisplay = true
        Flag = true
    }
}

extension AppDelegate
{
    func requestAppOpenAd() {
        appOpenAd = nil
        GADAppOpenAd.load(
            withAdUnitID: APP_OPEN_AD,
            request: GADRequest(),
            orientation: UIInterfaceOrientation.portrait,
            completionHandler: { [self] appOpenAd, error in
                if let error = error {
                    print("Failed to load app open ad: \(error)")
                    return
                }
                print("App open load")
                self.appOpenAd = appOpenAd
                
            })
    }
    
    func tryToPresentAd() {
        let ad = appOpenAd
        appOpenAd = nil
        if let ad = ad {
            if self.isAppOpenAdDisplay {
                let topVC = AdsManager.shared.topMostViewController
                print("topMostViewController",topVC)
                ad.present(fromRootViewController: topVC!)
                self.requestAppOpenAd()
            }
        } else {
            self.requestAppOpenAd()
        }
    }
    
}

