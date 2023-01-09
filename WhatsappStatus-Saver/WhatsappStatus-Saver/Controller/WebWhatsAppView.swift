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
    @IBOutlet var imgData: UIImageView!
    
    var documentInteractionController:UIDocumentInteractionController!
    var menuArray:[String] = ["", "", ""]
    var menuImgArray:[UIImage] = [UIImage(named: "ic_darkmode")!,UIImage(named: "ic_maximize")!,UIImage(named: "ic_logout")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func getData(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        //document.getElementsByTagName('#img')[0].innerHTML;
        
        //        webView.evaluateJavaScript("document.getElementsByClassName('i0jNr')[2].src") { (result, error) in
        //            let str:String = result as! String
        //            if str.contains("https:")
        //            {
        //                self.webView.evaluateJavaScript("document.getElementsByClassName('i0jNr')[5].src") { (result, error) in
        //                    let str:String = result as! String
        //                    let url = URL(string: str)
        //                    self.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
        //                            let session = URLSession.shared
        //                            session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
        //                        let task = session.downloadTask(with: url!) { localURL, _, error in
        //                                if let localURL = localURL {
        //                                  print("localURL",localURL)
        //                                } else {
        //
        //                                }
        //                            }
        //                            task.resume()
        //                        }
        //                }
        //            }
        //            else
        //            {
        //                let val = str.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")//.replacingOccurrences(of: ")", with: "")
        //                  print(val)
        //                  if let decodedData = Data(base64Encoded: val, options: .ignoreUnknownCharacters) {
        //                      let image1:UIImage = UIImage(data: decodedData) ?? UIImage()
        //                      self.imgData.image = image1
        //                      UIImageWriteToSavedPhotosAlbum(image1, self, nil, nil)
        //                  }
        //            }
        //
        ////            if let result = result {
        ////                print("Label is updated with message: \(result)")
        ////            } else if let error = error {
        ////                print("An error occurred: \(error)")
        ////            }
        //        }
        //        webView.evaluateJavaScript("document.getElementsByClassName('i0jNr')[3].src") { (result, error) in
        ////            let str:String = result as! String
        ////          let val = str.replacingOccurrences(of: "(data:image/jpeg;base64,", with: "").replacingOccurrences(of: ")", with: "")
        //            print(result)
        ////            if let result = result {
        ////                print("Label is updated with message: \(result)")
        ////            } else if let error = error {
        ////                print("An error occurred: \(error)")
        ////            }
        //        }
        //        webView.evaluateJavaScript("document.getElementsByClassName('i0jNr')[5].src") { (result, error) in
        //            print("result",result)
        //            if let url = URL(string: result as! String)
        //            {
        //            self.testDownloadBlob(navigationURL: url)
        //            }
        //        }
        /*   var script = """
         var width = 1920;
         var height = 1080;
         
         
         var canvas = document.createElement('canvas');  // Dynamically Create a Canvas Element
         canvas.width  = width;  // Set the width of the Canvas
         canvas.height = height;  // Set the height of the Canvas
         var ctx = canvas.getContext("2d");  // Get the "context" of the canvas
         var img = document.getElementsByClassName('i0jNr')[5];  // The id of your image container
         ctx.drawImage(img,0,0,width,height);  // Draw your image to the canvas
         
         
         var jpegFile = canvas.toDataURL("image/jpeg");
         """*/
        //        let script = """
        //    var url = 'blob:https://web.whatsapp.com/ccab151b-348f-4065-8e4d-47846f0cf59b'; // document.getElementById("img1").src; // 'img1' is the thumbnail - I had to put an id on it
        //    var canvas = document.getElementById('MyCanvas');
        //    var img = new Image();
        //    img.src = url;
        //    img.onload = function () {
        //        var myImage = canvas.toDataURL('image/jpg');
        //    }
        //"""
        //
        //            self.webView.evaluateJavaScript(script) { (results, error) in
        //                print(results)
        //                print(error)
        //            }
    }
    
    func testDownloadBlob(navigationURL: URL) {
        
        //            var script = ""
        //            script = script + "var xhr = new XMLHttpRequest();"
        //            script = script + "xhr.open('GET', '\(navigationURL.absoluteString)', true);"
        //            script = script + "xhr.responseType = 'blob';"
        //            script = script + "window.webkit.messageHandlers.readBlob.postMessage('making sure script called');"
        //            script = script + "xhr.onload = function(e) { if (this.status == 200) { var blob = this.response; window.webkit.messageHandlers.readBlob.postMessage(blob); var reader = new window.FileReader(); reader.readAsBinaryString(blob); reader.onloadend = function() { window.webkit.messageHandlers.readBlob.postMessage(reader.result); }}};"
        //            script = script + "xhr.send();"
        
        var script = """
  function toDataURL(url, callback) {
         var httpRequest = new XMLHttpRequest();
         httpRequest.onload = function() {
            var fileReader = new FileReader();
               fileReader.onloadend = function() {
                  callback(fileReader.result);
               }
               fileReader.readAsDataURL(httpRequest.response);
         };
         httpRequest.open('GET', url);
         httpRequest.responseType = 'blob';
         httpRequest.send();
      }
      toDataURL(
         'http://placehold.it/512x512',
          function(dataUrl) {
            document.write('<a href="'+dataUrl+'" download>Save as</a><img src="'+dataUrl+'"></a>');
         }
      )
    
"""
        
        self.webView.evaluateJavaScript(script) { (results, error) in
            print(results)
            print(error)
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
       
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        FTPopOverMenu.showForSender(sender: sender,with: self.menuArray,menuImageArray: self.menuImgArray,popOverPosition: .automatic,config: self.configWithMenuStyle(),done: { (selectedIndex) in
            print(selectedIndex)
            if selectedIndex == 0
            {
                self.setTheme(theme: .dark)
            }
            else if selectedIndex == 1
            {
               
            }
            else if selectedIndex == 2
            {
                self.clear()
            }
        },cancel: {
            
        })
    }
    
    func configWithMenuStyle() -> FTConfiguration
    {
        let config = FTConfiguration()
        config.backgoundTintColor = UIColor(hexString:"#F4F4F4")
        config.borderColor = UIColor.clear
        config.menuWidth = 50
        config.menuSeparatorColor = UIColor.clear
        config.menuRowHeight = 40
        config.cornerRadius = 6
        config.textColor = UIColor.black
        config.textAlignment = NSTextAlignment.center
        
        return config
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
