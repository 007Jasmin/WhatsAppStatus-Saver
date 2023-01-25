//
//  AdsManager.swift
//  ChargingDemo1
//
//  Created by Ravi Patel on 02/09/21.
//

import Foundation
import UIKit
import GoogleMobileAds
//import SVProgressHUD

protocol AdsManagerDelegate {
    func NativeAdLoad()
    func DidDismissFullScreenContent()
    func NativeAdsDidFailedToLoad()
}

var interstitialAd: GADInterstitialAd?
var isNativeLoad : Bool = false

class AdsManager: NSObject {
    
    static let shared = AdsManager()
    var delegate: AdsManagerDelegate?
    
    var adLoader: GADAdLoader!
    var arrNativeAds = [GADNativeAd]()
    
    //MARK: - TOP VIEW CONTROLLER
    
    var topMostViewController: UIViewController? {
        var currentVc = UIApplication.shared.keyWindow?.rootViewController
        print("currentVc",currentVc)
        while let presentedVc = currentVc?.presentedViewController {
            print("presentedVc",presentedVc)
            if let navVc = (presentedVc as? UINavigationController)?.viewControllers.last {
                currentVc = navVc
            } else if let tabVc = (presentedVc as? UITabBarController)?.selectedViewController {
                currentVc = tabVc
            } else {
                currentVc = presentedVc
            }
        }
        return currentVc
    }
    
    //MARK: - LOAD INTERSTITIAL ADS
    func loadInterstitialAd(){
        
        if !Reachability.isConnectedToNetwork() {
            return
        }
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: INTERSITIAL_ADS_ID, request: request) { [self] (ad, error) in
            if error != nil {
                print("Interstitial load error \(error?.localizedDescription ?? "")")
            } else {
                print("Interstitial load")
                interstitialAd = ad
                interstitialAd?.fullScreenContentDelegate = self
            }
        }
        
    }
    
    
    
    //MARK: - LOAD NATIVE ADS
    
    func createAndLoadNativeAds(numberOfAds: Int) {
        
        if !Reachability.isConnectedToNetwork() {
            return
        }
        arrNativeAds.removeAll()
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = numberOfAds
        
        adLoader = GADAdLoader(adUnitID: NATIVE_ADS_ID, rootViewController: topMostViewController,
                               adTypes: [GADAdLoaderAdType.native],
                               options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    
    
    //MARK: - PRESENT (INTERSITITAL, NATIVE) ADS
    func showInterstitialAd (_ isLoader:Bool = false, isRandom:Bool = false, ratio:Int = 3,shouldMatchRandom : Int = 2){
        if interstitialAd != nil {
            if isLoader {
//                SVProgressHUD.show(withStatus: "Loding Ads..")
//                SVProgressHUD.dismiss(withDelay: 1) {
//                    self.checkRandomAndPresentInterstitial(isRandom: isRandom, ratio: ratio, shouldMatchRandom: shouldMatchRandom)
//                }
            }else{
                self.checkRandomAndPresentInterstitial(isRandom: isRandom, ratio: ratio, shouldMatchRandom: shouldMatchRandom)
            }
        }
    }
    
    func checkRandomAndPresentInterstitial( isRandom:Bool, ratio:Int,shouldMatchRandom :Int){
        if isRandom{
            let isRandomMatch = Int.random(in: 1 ... ratio) == shouldMatchRandom
            if isRandomMatch {
                self.presentInterstitialAd()
            }
        }else {
            self.presentInterstitialAd()
        }
    }
    
    func presentInterstitialAd() {
        DispatchQueue.main.async {
            if let topVc = self.topMostViewController {
                interstitialAd?.present(fromRootViewController: topVc)
            }
        }
    }
    
    func presentInterstitialAd1(vc:UIViewController) {
        DispatchQueue.main.async {
            if interstitialAd != nil {
                interstitialAd!.present(fromRootViewController: vc)
            }else{
                print("intersitial not load")
            }
        }
    }
    
    
}


// MARK: - Interstitial Delegate
extension AdsManager: GADFullScreenContentDelegate {
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.", error.localizedDescription)
        loadInterstitialAd()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.delegate?.DidDismissFullScreenContent()
    }
    
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        NotificationCenter.default.post(name: NSNotification.Name("IntersitialClose"), object: nil)
        loadInterstitialAd()
//        self.delegate?.DidDismissFullScreenContent()
    }
    
}


// MARK: - NativeAd Loader Delegate
extension AdsManager: GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        isNativeLoad = true
        NotificationCenter.default.post(name: NSNotification.Name("nativeAdsLoad"), object: nil)
        print("Native ads load")
        
        let view = GADMediaView()
        view.mediaContent = nativeAd.mediaContent
        print("mediaviews",view.subviews.count)
        
        arrNativeAds.append(nativeAd)
        self.delegate?.NativeAdLoad()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        isNativeLoad = false
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        //        arrNativeAds.removeAll()
        //self.delegate?.NativeAdsDidFailedToLoad()
    }
    
}

