//
//  ViewController.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 16/12/22.
//

import UIKit
import WebKit
import AVFoundation
import IQKeyboardManagerSwift

class WebWhatsAppView: UIViewController, WKUIDelegate,WKNavigationDelegate{
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var menuView: UIView!
    @IBOutlet var constheaderViewHeight: NSLayoutConstraint!
    @IBOutlet var constzoomViewHeight: NSLayoutConstraint!
    @IBOutlet var constMenuViewHeight: NSLayoutConstraint!
    @IBOutlet var btnDarkMode: UIButton!
    @IBOutlet var btnZoom: UIButton!
    @IBOutlet var btnKeyboard: UIButton!
    @IBOutlet var btnKeyboard1: UIButton!
    @IBOutlet var imgKeyboard: UIImageView!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnRefresh: UIButton!
    @IBOutlet var btnDarkMode1: UIButton!
    @IBOutlet var btnZoom1: UIButton!
    @IBOutlet var fullUIStackView: UIStackView!
    
    var documentInteractionController:UIDocumentInteractionController!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeader.text = "Whats Web Scan".localized
        self.constMenuViewHeight.constant = 0
        self.constzoomViewHeight.constant = 0
        webView.navigationDelegate = self
        webView.uiDelegate = self
        let myURL = URL(string:"https://web.whatsapp.com")
        let myRequest = URLRequest(url: myURL!)
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1.2 Safari/605.1.15"
        webView.load(myRequest)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
       
        if Defaults.bool(forKey: "KeyboardDisable") == true
        {
            self.imgKeyboard.image = UIImage(named:"ic_keyboard_disable")
            self.btnKeyboard.isSelected = true
            self.btnKeyboard1.isSelected = true
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
        }
    }
}
//Calling IBAction & Function
extension WebWhatsAppView
{
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRefresh(_ sender: UIButton) {
        webView.reload()
    }
    
    @IBAction func btnInfo(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "HowToUseVC") as! HowToUseVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @IBAction func btnKeyBoard(_ sender: UIButton) {
        if sender.isSelected == true
        {
            self.imgKeyboard.image = UIImage(named:"ic_keybord_enable")
            self.btnKeyboard.isSelected = false
            self.btnKeyboard1.isSelected = false
            sender.isSelected = false
            Defaults.set(false, forKey: "KeyboardDisable")
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        else
        {
            self.imgKeyboard.image = UIImage(named:"ic_keyboard_disable")
            self.btnKeyboard.isSelected = true
            self.btnKeyboard1.isSelected = true
            sender.isSelected = true
            Defaults.set(true, forKey: "KeyboardDisable")
            self.view.endEditing(true)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        if sender.isSelected == true
        {
            self.constMenuViewHeight.constant = 0
            sender.isSelected = false
        }
        else
        {
            self.constMenuViewHeight.constant = 150
            sender.isSelected = true
        }
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        clear()
        self.constMenuViewHeight.constant = 0
        if self.constzoomViewHeight.constant != 0
        {
            self.constzoomViewHeight.constant = 0
            self.constheaderViewHeight.constant = 100
        }
    }
    
    @IBAction func btnZoom(_ sender: UIButton) {
        if sender.isSelected == true
        {
            sender.isSelected = false
            self.btnZoom.isSelected = false
            self.btnZoom1.isSelected = false
            self.constheaderViewHeight.constant = 100
            self.constzoomViewHeight.constant = 0
        }
        else
        {
            self.constheaderViewHeight.constant = 80
            self.constzoomViewHeight.constant = 120
            sender.isSelected = true
            self.btnZoom.isSelected = true
            self.constMenuViewHeight.constant = 0
        }
    }
    
    @IBAction func btnDarkTheme(_ sender: UIButton) {
        if sender.isSelected == true
        {
            setTheme(theme: .light)
            self.headerView.backgroundColor = UIColor(named: "themeColor")
            self.zoomView.backgroundColor = UIColor(named: "themeColor")
            self.menuView.backgroundColor = UIColor(hexString: "F4F4F4")
            sender.isSelected = false
            self.btnDarkMode.isSelected = false
            self.btnDarkMode1.isSelected = false
        }
        else
        {
            setTheme(theme: .dark)
            self.headerView.backgroundColor = UIColor(hexString: "393E41")
            self.zoomView.backgroundColor = UIColor(hexString: "393E41")
            self.menuView.backgroundColor = UIColor(hexString: "393E41")
            sender.isSelected = true
            self.btnDarkMode.isSelected = true
        }
    }
    @IBAction func btnUpDownZoomView(_ sender: UIButton) {
        if sender.isSelected == true
        {
            sender.isSelected = false
            self.fullUIStackView.isHidden = false
            self.constzoomViewHeight.constant = 120
        }
        else
        {
            sender.isSelected = true
            self.fullUIStackView.isHidden = true
            self.constzoomViewHeight.constant = 80
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        self.view.endEditing(true)
    }
    
    func clear()
    {
        URLCache.shared.removeAllCachedResponses()
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
                self.webView.reload()
            }
        }
    }
    
   func setTheme(theme : UIUserInterfaceStyle) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        if theme == .light {
            keyWindow?.overrideUserInterfaceStyle = .light
        } else if theme == .dark {
            keyWindow?.overrideUserInterfaceStyle = .dark
        } else {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                keyWindow?.overrideUserInterfaceStyle = .dark
            } else {
                keyWindow?.overrideUserInterfaceStyle = .light
            }
        }
    }
    
}
