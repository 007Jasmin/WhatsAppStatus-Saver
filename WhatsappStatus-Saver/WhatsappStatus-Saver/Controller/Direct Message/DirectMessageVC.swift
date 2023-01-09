//
//  DirectMessageVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 28/12/22.
//

import UIKit

class DirectMessageVC: UIViewController {
    
    @IBOutlet weak var lblContactNo: UITextField!
    @IBOutlet weak var txtMessage: KMPlaceholderTextView!
    @IBOutlet weak var btnAddContact: UIButton!
    @IBOutlet var imgCountry: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtMessage.placeholder = "Type your message here.."
        self.btnAddContact.layer.borderColor = UIColor(named: "themeColor")?.cgColor
        self.btnAddContact.layer.borderWidth = 1
      
        let countryName:String = Defaults.string(forKey: "countryLocal") ?? "IN"
        self.lblCountryCode.text = NSString(format: "%@ %@", Defaults.string(forKey: "countryLocal") ?? "",Defaults.string(forKey: "countryCode") ?? "+91") as String
        self.imgCountry.image = UIImage(named: "flag_\(countryName.lowercased())")
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
    
}
