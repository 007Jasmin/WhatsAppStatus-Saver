//
//  GetStartedVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 29/12/22.
//

import UIKit

class GetStartedVC: UIViewController {
    
    @IBOutlet var btnCheck:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnContinue(_ sender: UIButton) {
        if self.btnCheck.isSelected == false
        {
            AlertWithMessage(self, message: "Please check privcay policy first.")
            return
        }
        if interstitialAd != nil {
            AdsManager.shared.presentInterstitialAd1(vc: self)
        }
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            let languageVC: LanguageSelectionVC = mainStoryBoard.instantiateViewController(withIdentifier: "LanguageSelectionVC") as! LanguageSelectionVC
            languageVC.isFromSplash = true
            self.navigationController?.pushViewController(languageVC, animated: true)
        }
    }
    
    @IBAction func btnCheck(_ sender:UIButton)
    {
        if sender.isSelected == true
        {
            sender.isSelected = false
            UserDefaults.standard.set(false, forKey: "PolicyCheck")
        }
        else
        {
            sender.isSelected = true
            UserDefaults.standard.set(true, forKey: "PolicyCheck")
        }
    }
    
    @IBAction func btnCheckPolicy(_ sender:UIButton)
    {
        let PrivacyPolicyVC: PrivacyPolicyVC = mainStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        self.navigationController?.pushViewController(PrivacyPolicyVC, animated: true)
    }

}
