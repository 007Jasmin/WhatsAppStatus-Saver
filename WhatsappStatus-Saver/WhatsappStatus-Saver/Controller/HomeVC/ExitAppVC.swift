//
//  AddViewVC.swift
//  VLCPlayer
//
//  Created by Deep on 23/08/22.
//

import UIKit
import GoogleMobileAds

class ExitAppVC: UIViewController
{
    //MARK: - Outlets
    @IBOutlet weak var advertiseView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var lctAddViewHeight: NSLayoutConstraint!
    @IBOutlet weak var MainImageView: UIImageView!
    @IBOutlet weak var nativeAdPlaceholder: GADNativeAdView!
    @IBOutlet weak var media_view: GADMediaView!
    @IBOutlet weak var callToActionView: UIButton!
    @IBOutlet weak var ad_icon: UIImageView!
    @IBOutlet weak var ad_title: UILabel!
    @IBOutlet weak var ad_description: UILabel!
    
    //MARK: - Properties
    var arrNativeAds:GADNativeAd?
    
    //MARK: - Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            lctAddViewHeight.constant = 600
        }
        else
        {
            lctAddViewHeight.constant = 500
        }
    }
    
    func viewAnimationBottomToUp()  {
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseInOut], animations: {
            
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                self.addView.frame = CGRect(x: 0, y: self.addView.bounds.origin.y, width: self.view.frame.width, height: 600.0)
            }
            else
            {
                self.addView.frame = CGRect(x: 0, y: self.addView.bounds.origin.y, width: self.view.frame.width, height: 500.0)
            }
            
        }) { (finished) in
            if finished {
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.nativeAdPlaceholder.isHidden = true
        if !Defaults.bool(forKey: "adRemoved") {
            if AdsManager.shared.arrNativeAds.count > 0
            {
                self.arrNativeAds = AdsManager.shared.arrNativeAds[0]
                self.loadNativeAds()
            } else{
                AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
            }
        }
        viewAnimationBottomToUp()
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
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        addView.addHeaderRadius(25)
    }
    
    //MARK: - Actions
    @IBAction func onBtnExitApp(_ sender: UIButton)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
    }
    
    @IBAction func btnDismiss(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }
}
