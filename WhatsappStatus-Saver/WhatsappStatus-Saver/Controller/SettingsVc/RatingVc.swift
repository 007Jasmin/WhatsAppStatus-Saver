//
//  RatingVc.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 19/01/23.
//

import UIKit

class RatingVc: UIViewController {
    
    @IBOutlet var popUpView: UIView!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var RatingImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        floatRatingView.backgroundColor = UIColor.clear
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.popUpView.isHidden = true
        self.lblTitle.text = "Enjoying Status Saver?".localized
        self.lblDescription.text = "Tap a star to rate it on the App Store.".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.popUpView.isHidden = false
            self.popUpView.pulsateRateUs()
        }
    }
   
}
//Calling Function & IbAction
extension RatingVc
{
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        if let url = URL.init(string: RateLink){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
//Floting RateDelegate
extension RatingVc: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
       print("isUpdating",self.floatRatingView.rating)
        if self.floatRatingView.rating == 1.0
        {
            self.RatingImg.image = UIImage(named: "ic_rate1") ?? UIImage()
        }
        if self.floatRatingView.rating == 2.0
        {
            self.RatingImg.image = UIImage(named: "ic_rate2") ?? UIImage()
        }
        if self.floatRatingView.rating == 3.0
        {
            self.RatingImg.image = UIImage(named: "ic_rate3") ?? UIImage()
        }
        if self.floatRatingView.rating == 4.0
        {
            self.RatingImg.image = UIImage(named: "ic_rate4") ?? UIImage()
        }
        if self.floatRatingView.rating == 5.0
        {
            self.RatingImg.image = UIImage(named: "ic_rate5") ?? UIImage()
        }
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print("didUpdate",self.floatRatingView.rating)
    }
    
}
