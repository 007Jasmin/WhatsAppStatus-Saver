//
//  In-AppPurchaseVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 14/02/23.
//

import UIKit
import SwiftyStoreKit

class In_AppPurchaseVC: UIViewController {
    
    @IBOutlet var lblHeader1: UILabel!
    @IBOutlet var lblHeader2: UILabel!
    @IBOutlet var lblUnlock: UILabel!
    @IBOutlet var lblRemove: UILabel!
    @IBOutlet var lblCancle: UILabel!
    @IBOutlet var lblStandard: UILabel!
    @IBOutlet var lblStandardDec: UILabel!
    @IBOutlet var lblStandardPrice: UILabel!
    @IBOutlet var lblPopular: UILabel!
    @IBOutlet var lblPopularDec: UILabel!
    @IBOutlet var lblPopularPrice: UILabel!
    @IBOutlet var lblSpecial: UILabel!
    @IBOutlet var lblSpecialDec: UILabel!
    @IBOutlet var lblSpecialPrice: UILabel!
    @IBOutlet var lblCurrentPlan: UILabel!
    @IBOutlet var lblCurrentPlanVal: UILabel!
    @IBOutlet var lblBottom1: UILabel!
    @IBOutlet var lblBottom2: UILabel!
    @IBOutlet var lblBottom3: UILabel!
    @IBOutlet var btnTerms: UIButton!
    @IBOutlet var btnPolicy: UIButton!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var btnWeek: UIButton!
    @IBOutlet var btnMonth: UIButton!
    @IBOutlet var btnYear: UIButton!
    @IBOutlet var constStackWidth: NSLayoutConstraint!
    @IBOutlet var viewStandard: UIView!
    @IBOutlet var viewPopular: UIView!
    @IBOutlet var viewSpecial: UIView!
    
    var selectedIndex : Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.SetUpUI()
    }
  
}
//Calling IBAction & Function
extension In_AppPurchaseVC
{
    func SetUpUI()
    {
        DispatchQueue.main.async { [self] in
            getLocalPrice()
        }
        self.lblHeader1.text = "Premium Access".localized
        self.lblHeader2.text = "Upgrade to Premium and Download unlimited status and Unlock all the features".localized
        self.lblUnlock.text = "Unlock all features".localized
        self.lblRemove.text = "Remove ads".localized
        self.lblCancle.text = "Cancle anytime".localized
        self.lblStandard.text = "Standard".localized
        self.lblStandardDec.text = "1 Week subscription".localized
        self.lblPopular.text = "Popular".localized
        self.lblPopularDec.text = "1 Month subscription".localized
        self.lblSpecial.text = "Special Offer".localized
        self.lblSpecialDec.text = "1 Year subscription".localized
        self.lblBottom1.text = "By counting you agree to our".localized
        self.lblBottom2.text = "and".localized
        self.lblBottom3.text = "Subscription will auto-renew. Cancle anytime.".localized
        self.lblCurrentPlan.text = "Your Current plan is".localized
        self.btnTerms.setTitle("".localized, for: .normal)
        self.btnPolicy.setTitle("".localized, for: .normal)
        self.btnContinue.setTitle("Continue".localized, for: .normal)
        self.btnRestore.setTitle("Restore Purchase".localized, for: .normal)
        self.constStackWidth.constant = 180
        self.constStackWidth.isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            self.constStackWidth.isActive = false
        }
        if Defaults.bool(forKey: "adRemoved") == false
        {
            self.lblCurrentPlanVal.text = ": Nil"
        }
        else
        {
            self.lblCurrentPlanVal.text = ": \(Defaults.string(forKey: "prductID") ?? "")"
        }
    }
    
    @IBAction func onBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnMonth(_ sender: UIButton) {
        self.selectedIndex = 1
        self.addBorder(tagVal: sender.tag)
    }
    
    @IBAction func btnYear(_ sender: UIButton) {
        self.selectedIndex = 2
        self.addBorder(tagVal: sender.tag)
    }
    
    @IBAction func btnWeek(_ sender:UIButton)
    {
        self.selectedIndex = 0
        self.addBorder(tagVal: sender.tag)
    }
    
    @IBAction func btnPurchase(_ sender: UIButton) {
        if selectedIndex == -1
        {
            AlertWithMessage(self, message: "Please select atleast One Subscription..".localized)
            return
        }
        InAppManager.shared.purchaseProduct(productId: IN_APP_PURCHASE_IDS[self.selectedIndex])
    }
    
    @IBAction func btnRestorePurchase(_ sender: UIButton) {
        InAppManager.shared.restoreProduct()
    }
    
    @IBAction func btnTerms(_ sender: UIButton) {
        let PrivacyPolicyVC: PrivacyPolicyVC = mainStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        PrivacyPolicyVC.isForPrivacy = false
        self.navigationController?.pushViewController(PrivacyPolicyVC, animated: true)
    }
    
    @IBAction func btnPolicy(_ sender: UIButton) {
        let PrivacyPolicyVC: PrivacyPolicyVC = mainStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        self.navigationController?.pushViewController(PrivacyPolicyVC, animated: true)
    }
    
    func getLocalPrice() {
        InAppManager.shared.retriveProductInfo(arrProduct: [IN_APP_PURCHASE_IDS[0],IN_APP_PURCHASE_IDS[1],IN_APP_PURCHASE_IDS[2]]) { result in
            for product in result {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                debugPrint("Product: \(product.localizedDescription), price: \(priceString)")
                if product.productIdentifier == IN_APP_PURCHASE_IDS[0] {
                    self.lblStandardPrice.text = "\(priceString)"
                } else if product.productIdentifier == IN_APP_PURCHASE_IDS[1] {
                    self.lblPopularPrice.text = "\(priceString)"
                }else if product.productIdentifier == IN_APP_PURCHASE_IDS[2] {
                    self.lblSpecialPrice.text = "\(priceString)"
                }
            }
        }
    }
    
    func addBorder(tagVal:Int)
    {
        if tagVal == 10
        {
            self.viewStandard.layer.borderWidth = 1.5
            self.viewStandard.layer.borderColor = UIColor.white.cgColor
            
            self.viewPopular.layer.borderWidth = 0
            self.viewPopular.layer.borderColor = UIColor.clear.cgColor
            
            self.viewSpecial.layer.borderWidth = 0
            self.viewSpecial.layer.borderColor = UIColor.clear.cgColor
        }
        else if tagVal == 20
        {
            self.viewStandard.layer.borderWidth = 0
            self.viewStandard.layer.borderColor = UIColor.clear.cgColor
            
            self.viewPopular.layer.borderWidth = 1.5
            self.viewPopular.layer.borderColor = UIColor.white.cgColor
            
            self.viewSpecial.layer.borderWidth = 0
            self.viewSpecial.layer.borderColor = UIColor.clear.cgColor
        }
        else if tagVal == 30
        {
            self.viewStandard.layer.borderWidth = 0
            self.viewStandard.layer.borderColor = UIColor.clear.cgColor
            
            self.viewPopular.layer.borderWidth = 0
            self.viewPopular.layer.borderColor = UIColor.clear.cgColor
            
            self.viewSpecial.layer.borderWidth = 1.5
            self.viewSpecial.layer.borderColor = UIColor.white.cgColor
        }
    }
}
