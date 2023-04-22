//
//  HomeVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 26/12/22.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController {
    
    @IBOutlet var lblHeader:UILabel!
    @IBOutlet var lblWebScan:UILabel!
    @IBOutlet var lblCleaner:UILabel!
    @IBOutlet var lblMesg:UILabel!
    @IBOutlet var lblRemoveAds:UILabel!
    @IBOutlet weak var nativeAdPlaceholder: GADNativeAdView!
    @IBOutlet weak var media_view: GADMediaView!
    @IBOutlet weak var callToActionView: UIButton!
    @IBOutlet weak var ad_icon: UIImageView!
    @IBOutlet weak var ad_title: UILabel!
    @IBOutlet weak var ad_description: UILabel!
    @IBOutlet var constNativeAdsView:NSLayoutConstraint!
    
    var arrNativeAds:GADNativeAd?
    var isFromSplash:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if !Defaults.bool(forKey: "adRemoved") {
            if AdsManager.shared.arrNativeAds.count == 0{
                AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
            }
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeader.text = "Status Saver".localized
        self.lblWebScan.text = "Whats Web Scan".localized
        self.lblCleaner.text = "Whats Cleaner".localized
        self.lblMesg.text = "Direct Chat".localized
        self.lblRemoveAds.text = "Remove Ads".localized
        
        self.nativeAdPlaceholder.isHidden = true
        self.constNativeAdsView.isActive = true
        if !Defaults.bool(forKey: "adRemoved") {
            
            if AdsManager.shared.arrNativeAds.count > 0
            {
                self.arrNativeAds = AdsManager.shared.arrNativeAds[0]
                self.loadNativeAds()
                self.constNativeAdsView.isActive = false
            }
        }
    }
    
}
//MARK: - Calling IBAction & Function
extension HomeVC
{
    @IBAction func btnExitApp(_ sender: UIButton)
    {
        if Defaults.bool(forKey: "RatingDone") == false{
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "RatingVc") as! RatingVc
            vc.modalPresentationStyle = .overCurrentContext
            vc.objCancel = {
                self.dismiss(animated: false, completion: nil)
                self.ExtiApp()
            }
            self.present(vc, animated: false, completion: nil)
        }else{
            self.ExtiApp()
        }
    }
    
    @IBAction func btnOpenWebView(_ sender: UIButton) {
        if Defaults.bool(forKey: "adRemoved") == true {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "WebWhatsAppView") as! WebWhatsAppView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "In_AppPremiumVC") as! In_AppPremiumVC
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDirectMessage(_ sender: UIButton) {
        if !Defaults.bool(forKey: "adRemoved") {
            if Defaults.integer(forKey: "FirstClick") == 0 || Defaults.integer(forKey: "FirstClick") == 3
            {
                Defaults.set(1, forKey: "FirstClick")
                if Defaults.integer(forKey: "FirstClick") == 3 {
                    Defaults.set(0, forKey: "FirstClick")
                }
                if interstitialAd != nil {
                    AdsManager.shared.presentInterstitialAd1(vc: self)
                }
                DispatchQueue.main.asyncAfter(deadline: when){
                    let vc = mainStoryBoard.instantiateViewController(withIdentifier: "DirectMessageVC") as! DirectMessageVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if Defaults.integer(forKey: "FirstClick") == 1 {
                Defaults.set(2, forKey: "FirstClick")
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "DirectMessageVC") as! DirectMessageVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if Defaults.integer(forKey: "FirstClick") == 2{
                Defaults.set(3, forKey: "FirstClick")
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "DirectMessageVC") as! DirectMessageVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "DirectMessageVC") as! DirectMessageVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnCleaner(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "MediaView") as! MediaView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRemoveAds(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "In_AppPremiumVC") as! In_AppPremiumVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnLanguage(_ sender: UIButton) {
        if !Defaults.bool(forKey: "adRemoved") {
            if interstitialAd != nil {
                AdsManager.shared.presentInterstitialAd1(vc: self)
            }
            DispatchQueue.main.asyncAfter(deadline: when)
            {
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "LanguageSelectionVC") as! LanguageSelectionVC
                vc.selectedIndex = Defaults.integer(forKey: "LangIndex")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "LanguageSelectionVC") as! LanguageSelectionVC
            vc.selectedIndex = Defaults.integer(forKey: "LangIndex")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnHowToUse(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "HowToUseVC") as! HowToUseVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @IBAction func btnSettings(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadNativeAds()
    {
        self.ad_title.text = arrNativeAds?.headline
        self.ad_description.text = "\(arrNativeAds?.body ?? "")"
        
        self.callToActionView.setTitle(arrNativeAds?.callToAction, for: .normal)
        self.nativeAdPlaceholder.isUserInteractionEnabled = false
        
        self.nativeAdPlaceholder.callToActionView = self.callToActionView
        self.nativeAdPlaceholder.iconView = self.ad_icon
        self.nativeAdPlaceholder.headlineView = self.ad_title
        (self.nativeAdPlaceholder.bodyView as? UILabel)?.text = "\(arrNativeAds?.body ?? "")"
        self.media_view.contentMode = .scaleAspectFit
        
        self.media_view.mediaContent = arrNativeAds?.mediaContent
        self.ad_icon.image = arrNativeAds?.icon?.image
        if arrNativeAds?.icon?.image == nil{
            self.ad_icon.image = UIImage(named: "ic_ads")
        }
        self.nativeAdPlaceholder.nativeAd = arrNativeAds
        self.nativeAdPlaceholder.isHidden = false
    }
    
    func ExtiApp(){
        let ExitAppVC = mainStoryBoard.instantiateViewController(withIdentifier: "ExitAppVC") as! ExitAppVC
        ExitAppVC.modalPresentationStyle = .overFullScreen
        self.present(ExitAppVC, animated: true)
    }
}
