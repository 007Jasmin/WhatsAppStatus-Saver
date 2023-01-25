//
//  SettingsVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 30/12/22.
//

import UIKit
import MessageUI
import Foundation

class SettingsVC: UIViewController {

    @IBOutlet var tblSettings: UITableView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var lblPremiumTitle: UILabel!
    @IBOutlet var lblPremiumSubStr: UILabel!
    @IBOutlet var btnBuyNow: UIButton!
    
    var arrFeatures = [[String : Any]]()
    var mailView: MFMailComposeViewController = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.SetSettingArray()
        self.lblHeader.text = "Settings".localized
        self.lblPremiumTitle.text = "Upgrade to Premium".localized
        self.lblPremiumSubStr.text = "Get premium to unlock feature".localized
        self.btnBuyNow.setTitle(" \("BUY NOW".localized) ", for: .normal)
    }

}
//Calling IBAction & Function
extension SettingsVC
{
    func SetSettingArray()
    {
        arrFeatures = [
            ["name":"Share app".localized,"image":UIImage(named:"ic_share")!],
            ["name":"Feedback".localized,"image":UIImage(named:"ic_feedback")!],
            ["name":"Privacy Policy".localized,"image":UIImage(named:"ic_policy")!],
            ["name":"Rate Us".localized,"image":UIImage(named:"ic_rateus")!],
            ["name":"Terms of Use".localized,"image":UIImage(named:"ic_terms")!],
            ["name":"How to get photo status?".localized,"image":UIImage(named:"ic_data")!]
        ] as? [[String : Any]] ?? [[String : Any]]()
        self.tblSettings.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBuyNow(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "In_AppPremiumVC") as! In_AppPremiumVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
//Calling Tableview Methods
extension SettingsVC:UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.arrFeatures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if self.arrFeatures.count > 0 && self.arrFeatures.count > indexPath.row
        {
            let dicVal:NSDictionary = self.arrFeatures[indexPath.row] as? NSDictionary ?? [:]
            cell.lbltitle.text = dicVal.value(forKey: "name") as? String ?? ""
            cell.imageV.image = dicVal.value(forKey: "image") as? UIImage ?? UIImage()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0
        {
            let text = NSString(format: "Hi!\nShare this app to your friends & family😉.\nAmazing!\nhttps://apps.apple.com/us/app/%@",APPID) as String
            let textToShare = [ text ]
            let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = []
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            self.present(activityVC, animated: true, completion: nil)
            
        }
        else if indexPath.row == 1
        {
            let appVersion:String = Bundle.applicationVersionNumber + "(" + Bundle.applicationBuildNumber + ")"
            let strVal:String = "--------------------------------------\nDevice:  \(UIDevice.modelName)\niOS Version:  \(UIDevice.current.systemVersion)\n App version:  \(appVersion)\n--------------------------------------\nWrite your message here!"
            mailView = MFMailComposeViewController()
            mailView.mailComposeDelegate = self
            mailView.setToRecipients(["erasoft.gaurav@gmail.com"])
            mailView.setSubject("Blood Pressure App".localized)
            mailView.setMessageBody(strVal, isHTML: false)
            self.present(mailView, animated: true, completion: nil)
        }
        else if indexPath.row == 2
        {
            let PrivacyPolicyVC: PrivacyPolicyVC = mainStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.navigationController?.pushViewController(PrivacyPolicyVC, animated: true)
            
        }
        else if indexPath.row == 3
        {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "RatingVc") as! RatingVc
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
        else if indexPath.row == 4
        {
            
        }
        else if indexPath.row == 5
        {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ContinuePolicyVC") as! ContinuePolicyVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
   
}
//Tableview CEll
class SettingCell:UITableViewCell
{
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var imageV: UIImageView!
    @IBOutlet var mainView: UIView!
}
