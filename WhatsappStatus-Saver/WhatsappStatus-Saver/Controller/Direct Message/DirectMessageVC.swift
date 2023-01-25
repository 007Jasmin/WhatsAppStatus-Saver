//
//  DirectMessageVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 28/12/22.
//

import UIKit
import GoogleMobileAds

class DirectMessageVC: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblContactNo: UITextField!
    @IBOutlet weak var txtMessage: KMPlaceholderTextView!
    @IBOutlet weak var btnAddContact: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet var imgCountry: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet weak var MainImageView: UIImageView!
    @IBOutlet weak var nativeAdPlaceholder: GADNativeAdView!
    @IBOutlet weak var media_view: GADMediaView!
    @IBOutlet weak var callToActionView: UIButton!
    @IBOutlet weak var ad_icon: UIImageView!
    @IBOutlet weak var ad_title: UILabel!
    @IBOutlet weak var ad_description: UILabel!
    @IBOutlet var constNativeAdsView:NSLayoutConstraint!
    
    var arrNativeAds:GADNativeAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.constNativeAdsView.constant = 0
        if !Defaults.bool(forKey: "adRemoved") {
            if AdsManager.shared.arrNativeAds.count > 0
            {
                self.arrNativeAds = AdsManager.shared.arrNativeAds[0]
                self.loadNativeAds()
            }else{
                AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
            }
        }
        self.btnAddContact.layer.borderColor = UIColor(named: "themeColor")?.cgColor
        self.btnAddContact.layer.borderWidth = 1
      
        let countryName:String = Defaults.string(forKey: "countryLocal") ?? "IN"
        self.lblCountryCode.text = NSString(format: "%@ %@", Defaults.string(forKey: "countryLocal") ?? "",Defaults.string(forKey: "countryCode") ?? "+91") as String
        self.imgCountry.image = UIImage(named: "flag_\(countryName.lowercased())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblHeader.text = "Direct Message".localized
        self.lblContactNo.placeholder = "Enter Number".localized
        self.txtMessage.placeholder = "Type your message here..".localized
        self.btnSend.setTitle("Send".localized, for: .normal)
        self.btnAddContact.setTitle("Add Contact".localized, for: .normal)
        
        self.lblContactNo.isUserInteractionEnabled = true
        self.txtMessage.isUserInteractionEnabled = true
        
        if Defaults.bool(forKey: "KeyboardDisable") == true
        {
            self.lblContactNo.isUserInteractionEnabled = false
            self.txtMessage.isUserInteractionEnabled = false
        }
    }
    
}
//MARK: - Calling functions & IBAction
extension DirectMessageVC
{
   
    @IBAction func btnSendMessage(_ sender: Any)
    {
        let msgVal = self.txtMessage.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let strVal:String = NSString(format: "https://wa.me/%@?text=%@", self.lblContactNo.text ?? "", msgVal ?? "") as? String ?? ""
        var url = URL(string: strVal)
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing WhatsApp")
                }
            }
        }
    }
    
    @IBAction func btnAddContact(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isEditing = false
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCountry(_ sender:UIButton)
    {
        let SelectCountryCode: SelectCountryCode = mainStoryBoard.instantiateViewController(withIdentifier: "SelectCountryCode") as! SelectCountryCode
        SelectCountryCode.modalPresentationStyle = .overCurrentContext
        SelectCountryCode.objectCancel = {
            self.dismiss(animated: true, completion: nil)
            let countryName:String = Defaults.string(forKey: "countryLocal") ?? ""
            self.lblCountryCode.text = NSString(format: "%@ %@", Defaults.string(forKey: "countryLocal") ?? "",Defaults.string(forKey: "countryCode") ?? "+91") as String
            self.imgCountry.image = UIImage(named: "flag_\(countryName.lowercased())")
        }
        self.present(SelectCountryCode, animated: true, completion: nil)
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
        self.ad_icon.isHidden = arrNativeAds?.icon == nil
        
        self.nativeAdPlaceholder.nativeAd = arrNativeAds
        self.nativeAdPlaceholder.isHidden = false
        self.constNativeAdsView.constant = 250
    }
    
}
