//
//  SplshVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 26/12/22.
//

import UIKit

class SplshVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        self.navigationController?.navigationBar.isHidden = true
        if !Defaults.bool(forKey: "adRemoved") {
            if AdsManager.shared.arrNativeAds.count == 0
            {
                AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
            }
        }
      
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            if UserDefaults.standard.string(forKey: "LangCode") ?? "" == ""
            {
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as! GetStartedVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
            else
            {
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.isFromSplash = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
   
}
