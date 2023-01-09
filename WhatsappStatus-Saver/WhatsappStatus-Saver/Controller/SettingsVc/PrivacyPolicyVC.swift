//
//  PrivacyPolicyVC.swift
//  CallerID
//
//  Created by ERASOFT on 19/09/22.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {
    
    @IBOutlet var webivew:WKWebView!
    @IBOutlet weak var lblHeader: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text = "Privacy Policy"//.localizeString(string: langVal)
        if let urlVal = URL(string: PRIVACYPOLICY)
        {
            let rqeURL = URLRequest(url: urlVal)
            if rqeURL != nil
            {
                webivew.load(rqeURL)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
    }
    
    @IBAction func BackBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
