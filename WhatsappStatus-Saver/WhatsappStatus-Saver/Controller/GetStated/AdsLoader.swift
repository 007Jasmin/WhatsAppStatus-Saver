//
//  AdsLoader.swift
//  TheMessenger
//
//  Created by Jasmin Upadhyay on 14/03/23.
//

import UIKit
import GoogleMobileAds

class AdsLoader: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lblLoding: UILabel!
    
    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()
    var interstitialAds: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadInterstitialAd()
    }
    
    func loadInterstitialAd(){
        
        if !Reachability.isConnectedToNetwork() {
            return
        }
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: INTERSITIAL_ADS_ID, request: request) { [self] (ad, error) in
            if error != nil {
                print("Interstitial load error \(error?.localizedDescription ?? "")")
            } else {
                print("Ads Loader Interstitial load")
                interstitialAds = ad
                interstitialAds?.fullScreenContentDelegate = self
                interstitialAds?.present(fromRootViewController: self)
            }
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.", error.localizedDescription)
        self.loadInterstitialAd()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        vc.isFromSplash = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        NotificationCenter.default.post(name: NSNotification.Name("IntersitialClose"), object: nil)
        loadInterstitialAd()
    }
   
}
