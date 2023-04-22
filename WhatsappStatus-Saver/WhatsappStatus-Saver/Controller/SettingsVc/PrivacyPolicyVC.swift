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
    
    var isForPrivacy:Bool = true
    var URLStr:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if isForPrivacy == true
        {
            lblHeader.text = "Privacy Policy".localized
            URLStr = PRIVACYPOLICY
        }
        else
        {
            lblHeader.text = "Terms of Use".localized
            URLStr = termsLink
        }
        if let urlVal = URL(string: URLStr)
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
