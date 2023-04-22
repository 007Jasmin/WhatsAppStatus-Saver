//
//  SplshVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 26/12/22.
//

import UIKit
import MaterialProgressBar

class SplshVC: UIViewController {
    
    @IBOutlet weak var progressView: LinearProgressBar!
    @IBOutlet weak var lbltitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.progressBarColor = UIColor(named: "themeColor") ?? UIColor()
        self.progressView.startAnimating()
        if !Defaults.bool(forKey: "adRemoved") {
            self.progressView.isHidden = false
            self.lbltitle.isHidden = false
            if AdsManager.shared.arrNativeAds.count == 0
            {
                AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
            }
        }
      
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if UserDefaults.standard.string(forKey: "LangCode") ?? "" == "" {
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "GetStartedVC") as! GetStartedVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
            else
            {
                if !Defaults.bool(forKey: "adRemoved") {
                    let vc = mainStoryBoard.instantiateViewController(withIdentifier: "AdsLoader") as! AdsLoader
                    self.navigationController?.pushViewController(vc, animated: false)
                }else{
                    let vc = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        self.navigationController?.navigationBar.isHidden = true
        if AdsManager.shared.arrNativeAds.count == 0
        {
            AdsManager.shared.createAndLoadNativeAds(numberOfAds: 1)
        }
    }
   
}
