//
//  HomeVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 26/12/22.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet var lblHeader:UILabel!
    @IBOutlet var lblWebScan:UILabel!
    @IBOutlet var lblCleaner:UILabel!
    @IBOutlet var lblMesg:UILabel!
    @IBOutlet var lblRemoveAds:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeader.text = "Status Saver"
        self.lblWebScan.text = "Whats Web Scan"
        self.lblCleaner.text = "Whats Cleaner"
        self.lblMesg.text = "Direct Chat"
        self.lblRemoveAds.text = "Remove Ads"
    }
    
}
//Calling IBAction & Function
extension HomeVC
{
    
    @IBAction func btnOpenWebView(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "WebWhatsAppView") as! WebWhatsAppView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDirectMessage(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "DirectMessageVC") as! DirectMessageVC
        self.navigationController?.pushViewController(vc, animated: true)
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
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "LanguageSelectionVC") as! LanguageSelectionVC
        vc.selectedIndex = Defaults.integer(forKey: "LangIndex")
        self.navigationController?.pushViewController(vc, animated: true)
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
}
