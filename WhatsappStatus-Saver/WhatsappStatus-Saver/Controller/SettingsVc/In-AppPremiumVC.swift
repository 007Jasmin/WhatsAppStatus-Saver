//
//  In-AppPremiumVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 06/01/23.
//

import UIKit
import SwiftyStoreKit

class In_AppPremiumVC: UIViewController {
    
    @IBOutlet var lblHeader1: UILabel!
    @IBOutlet var lblHeader2: UILabel!
    @IBOutlet var lblPremium: UILabel!
    @IBOutlet var lblBasic: UILabel!
    @IBOutlet var lblWebScan: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblCleaner: UILabel!
    @IBOutlet var lblSaver: UILabel!
    @IBOutlet var lblAds: UILabel!
    @IBOutlet var lblWeek: UILabel!
    @IBOutlet var lblMonth: UILabel!
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblBottom1: UILabel!
    @IBOutlet var lblBottom2: UILabel!
    @IBOutlet var btnVal: UIButton!
    @IBOutlet var btnWeek: UIButton!
    @IBOutlet var btnMonth: UIButton!
    @IBOutlet var btnYear: UIButton!
    
    var selectedIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.SetUpUI()
    }
}
//Calling IBAction & Function
extension In_AppPremiumVC
{
    
    func SetUpUI()
    {
        DispatchQueue.main.async { [self] in
            getLocalPrice()
        }
        self.lblHeader1.text = "Premium Access".localized
        self.lblHeader2.text = "Upgrade to Premium and Download unlimited status and Unlock all the features".localized
        self.lblPremium.text = "PREMIUM".localized
        self.lblBasic.text = "BASIC".localized
        self.lblWebScan.text = "Whats Web Scan".localized
        self.lblMessage.text = "Direct Chat".localized
        self.lblCleaner.text = "Whats Cleaner".localized
        self.lblSaver.text = "Status Saver".localized
        self.lblAds.text = "No Ads".localized
        self.lblBottom1.text = "OR TRY LIMITED VERSION".localized
        self.lblBottom2.text = "By counting you agree to our Terms and Privacy policies Subscription will auto-renew. Cancle anytime.".localized
        self.btnVal.setTitle("START FREE TRIAL".localized, for: .normal)
    }
    
    @IBAction func onBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnMonth(_ sender: UIButton) {
        self.selectedIndex = 1
        self.btnMonth.isSelected = true
        self.btnWeek.isSelected = false
        self.btnYear.isSelected = false
    }
    
    @IBAction func btnYear(_ sender: UIButton) {
        self.selectedIndex = 2
        self.btnYear.isSelected = true
        self.btnWeek.isSelected = false
        self.btnMonth.isSelected = false
    }
    
    @IBAction func btnWeekSelect(_ sender:UIButton)
    {
        self.selectedIndex = 0
        self.btnWeek.isSelected = true
        self.btnYear.isSelected = false
        self.btnMonth.isSelected = false
    }
    
    @IBAction func btnPurchase(_ sender: UIButton) {
        InAppManager.shared.purchaseProduct(productId: IN_APP_PURCHASE_IDS[self.selectedIndex])
    }
    
    func getLocalPrice() {
        InAppManager.shared.retriveProductInfo(arrProduct: [IN_APP_PURCHASE_IDS[0],IN_APP_PURCHASE_IDS[1],IN_APP_PURCHASE_IDS[2]]) { result in
            for product in result {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                debugPrint("Product: \(product.localizedDescription), price: \(priceString)")
                if product.productIdentifier == IN_APP_PURCHASE_IDS[0] {
                    self.lblWeek.text = priceString
                } else if product.productIdentifier == IN_APP_PURCHASE_IDS[1] {
                    self.lblMonth.text = priceString
                }else if product.productIdentifier == IN_APP_PURCHASE_IDS[2] {
                    self.lblYear.text = priceString
                }
            }
        }
    }
}
