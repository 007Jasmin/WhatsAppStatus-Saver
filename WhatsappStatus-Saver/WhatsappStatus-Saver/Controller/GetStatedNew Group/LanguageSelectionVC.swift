//
//  LanguageSelectionVC.swift
//  BloodPressureApp
//
//  Created by ERASOFT on 11/11/22.
//

import UIKit
import GoogleMobileAds

class LanguageCell:UITableViewCell
{
    @IBOutlet var lbltitle:UILabel!
    @IBOutlet var lblSubStr:UILabel!
    @IBOutlet var lblShortCode:UILabel!
    @IBOutlet var imageV:UIImageView!
    @IBOutlet var lblLine:UILabel!
    @IBOutlet var btnSelect:UIButton!
    @IBOutlet var mainView:UIView!
}

class LanguageSelectionVC: UIViewController {

    @IBOutlet var lblHeader:UILabel!
    @IBOutlet var tblLanguageList: UITableView!
    @IBOutlet var constBackButtonWidth: NSLayoutConstraint!
    @IBOutlet var constTblHeight: NSLayoutConstraint!
    @IBOutlet weak var MainImageView: UIImageView!
    @IBOutlet weak var nativeAdPlaceholder: GADNativeAdView!
    @IBOutlet weak var media_view: GADMediaView!
    @IBOutlet weak var callToActionView: UIButton!
    @IBOutlet weak var ad_icon: UIImageView!
    @IBOutlet weak var ad_title: UILabel!
    @IBOutlet weak var ad_description: UILabel!
    @IBOutlet var constNativeAdsView:NSLayoutConstraint!
    
    var arrLanguage = [[String : Any]]()
    var selectedIndex:Int = -1
    var isFromSplash:Bool = false
    var objDone:objectCancel?
    var adLoader: GADAdLoader!
    var arrNativeAds: GADNativeAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constNativeAdsView.constant = 0
        if AdsManager.shared.arrNativeAds.count > 0
        {
            self.arrNativeAds = AdsManager.shared.arrNativeAds[0]
            self.loadNativeAds()
        }
        self.constBackButtonWidth.constant = 50
        self.lblHeader.text = "Choose the Language"//.localizeString(string: langVal)
        if isFromSplash == true
        {
            self.constBackButtonWidth.constant = 0
            //langVal = "en"
        }
        self.SetSettingArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
       // self.loadNativeAds()
        if AdsManager.shared.arrNativeAds.count == 0
        {
            AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
        }
    }

}
//MARK: - Calling Functions & IBAction
extension LanguageSelectionVC
{
    func SetSettingArray()
    {
        arrLanguage = [["name":"English","color":UIColor(hexString: "#1BD92E"),"code":"en"],
                       ["name":"Françias","color":UIColor(hexString: "#00A3FF"),"code":"fr"],
                       ["name":"Español","color":UIColor(hexString: "#FFA748"),"code":"es"],
                       ["name":"Deutsch","color":UIColor(hexString: "#29BFA4"),"code":"de"],
                       ["name":"Italiano","color":UIColor(hexString: "#FF6969"),"code":"it"],
                       ["name":"Português","color":UIColor(hexString: "#C059FF"),"code":"pt"]
        ] as? [[String : Any]] ?? [[String : Any]]()
        
        self.constTblHeight.constant = CGFloat(self.arrLanguage.count * 70)
        self.tblLanguageList.reloadData()
    }
    
    func loadNativeAds()
    {
        constNativeAdsView.constant = 0
        self.arrNativeAds = AdsManager.shared.arrNativeAds[0]
        self.ad_title.text = arrNativeAds.headline
        self.ad_description.text = "\(arrNativeAds.body ?? "")"
        
        self.callToActionView.setTitle(arrNativeAds.callToAction, for: .normal)
        self.nativeAdPlaceholder.isUserInteractionEnabled = false
        
        self.nativeAdPlaceholder.callToActionView = self.callToActionView
        self.nativeAdPlaceholder.iconView = self.ad_icon
        self.nativeAdPlaceholder.headlineView = self.ad_title
        //        self.nativeAdPlaceholder.bodyView = self.ad_description
        (self.nativeAdPlaceholder.bodyView as? UILabel)?.text = "\(arrNativeAds.body ?? "")"
        self.media_view.contentMode = .scaleAspectFit
        
        self.media_view.mediaContent = arrNativeAds.mediaContent
        // UI accordingly.
        let mediaContent = arrNativeAds.mediaContent
        if mediaContent.hasVideoContent {
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            mediaContent.videoController.delegate = self
        } else {
            print("Ad does not contain a video.")
        }
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = self.media_view, arrNativeAds.mediaContent.aspectRatio > 0 {
            print(mediaView)
        }
        
        self.ad_icon.image = arrNativeAds.icon?.image
        self.ad_icon.isHidden = arrNativeAds.icon == nil
        
        self.nativeAdPlaceholder.nativeAd = arrNativeAds
        //constNativeAdsView.constant = 300
    }
    
    @IBAction func btnBack(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btndone(_ sender:UIButton)
    {
//        if UserDefaults.standard.string(forKey: "LangCode") == ""
//        {
//            UserDefaults.standard.set("en", forKey: "Lang")
//        }
        langVal = UserDefaults.standard.string(forKey: "LangCode") ?? ""
        
        if isFromSplash == true
        {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ContinuePolicyVC") as! ContinuePolicyVC
            vc.isFromSplash = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else
        {
            objDone?()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension LanguageSelectionVC: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("native ads failed to load")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        self.ad_title.text = nativeAd.headline
        self.ad_description.text = "\t \(nativeAd.body ?? "")"
        
        self.callToActionView.setTitle(nativeAd.callToAction, for: .normal)
        self.nativeAdPlaceholder.isUserInteractionEnabled = false
        
        self.nativeAdPlaceholder.callToActionView = self.callToActionView
        self.nativeAdPlaceholder.iconView = self.ad_icon
        self.nativeAdPlaceholder.headlineView = self.ad_title
        //        self.nativeAdPlaceholder.bodyView = self.ad_description
        (self.nativeAdPlaceholder.bodyView as? UILabel)?.text = "\t \(nativeAd.body ?? "")"
        self.media_view.contentMode = .scaleAspectFit
        
        self.media_view.mediaContent = nativeAd.mediaContent
        // UI accordingly.
        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            mediaContent.videoController.delegate = self
        } else {
            print("Ad does not contain a video.")
        }
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = self.media_view, nativeAd.mediaContent.aspectRatio > 0 {
            print(mediaView)
        }
        
        self.ad_icon.image = nativeAd.icon?.image
        self.ad_icon.isHidden = nativeAd.icon == nil
        
        self.nativeAdPlaceholder.nativeAd = nativeAd
        constNativeAdsView.constant = 300
        
    }
}
extension LanguageSelectionVC: GADVideoControllerDelegate
{
  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
  }
}


// MARK: - GADNativeAdDelegate implementation
extension LanguageSelectionVC: GADNativeAdDelegate {

  func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }
}


//MARK: - Tableview Methods
extension LanguageSelectionVC: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.arrLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as? LanguageCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.btnSelect.isSelected = false
        cell.mainView.layer.borderColor = UIColor(hexString: "#A4A4A4").cgColor
        cell.mainView.layer.borderWidth = 1
        cell.mainView.layer.cornerRadius = 10
        if self.arrLanguage.count > 0 && self.arrLanguage.count > indexPath.row
        {
            let dicVal:NSDictionary = self.arrLanguage[indexPath.row] as? NSDictionary ?? [:]
            cell.lbltitle.text = dicVal.value(forKey: "name") as? String ?? ""
            let code = dicVal.value(forKey: "code") as? String ?? ""
            cell.lblShortCode.text = code.uppercased()
            cell.imageV.backgroundColor = dicVal.value(forKey: "color") as? UIColor ?? UIColor()
            if selectedIndex == indexPath.row
            {
               cell.btnSelect.isSelected = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let dicVal:NSDictionary = self.arrLanguage[indexPath.row] as? NSDictionary ?? [:]
        Defaults.set(dicVal.value(forKey: "name") as? String ?? "", forKey: "Lang")
        Defaults.set(dicVal.value(forKey: "code") as? String ?? "", forKey: "LangCode")
        Defaults.set(self.selectedIndex, forKey: "LangIndex")
        self.tblLanguageList.reloadData()
    }
 

}
