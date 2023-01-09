//
//  In-AppPremiumVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 06/01/23.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//Calling IBAction & Function
extension In_AppPremiumVC
{
    @IBAction func onBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnMonth(_ sender: UIButton) {
        self.btnMonth.isSelected = true
        self.btnWeek.isSelected = false
        self.btnYear.isSelected = false
    }
    
    @IBAction func btnYear(_ sender: UIButton) {
        self.btnYear.isSelected = true
        self.btnWeek.isSelected = false
        self.btnMonth.isSelected = false
    }
    
    @IBAction func btnWeekSelect(_ sender:UIButton)
    {
        self.btnWeek.isSelected = true
        self.btnYear.isSelected = false
        self.btnMonth.isSelected = false
    }
}
