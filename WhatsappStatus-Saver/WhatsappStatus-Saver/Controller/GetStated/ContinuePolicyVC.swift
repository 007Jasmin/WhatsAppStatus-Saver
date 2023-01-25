//
//  ContinuePolicyVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 29/12/22.
//

import UIKit

class ContinuePolicyVC: UIViewController {
    
    @IBOutlet weak var collStep: UICollectionView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet var lblSetCount:UILabel!
    @IBOutlet var lblPrivacyText:UILabel!
    @IBOutlet var constBackButtonWidth: NSLayoutConstraint!
    @IBOutlet var btnNext:UIButton!
    @IBOutlet var btnPrevious:UIButton!
    
    var arrImage:[UIImage] = [UIImage(named:"1")!,UIImage(named:"2")!,UIImage(named:"3")!,UIImage(named:"4")!,UIImage(named:"5")!,UIImage(named:"6")!]
    var isSetp6:Bool = false
    var isFromSplash:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetUpUI()
    }
}
//Calling IBAction & Function
extension ContinuePolicyVC
{
    @IBAction func btnBack(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue(_ sender: UIButton)
    {
        
        let visibleItems: NSArray = self.collStep.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
      
        if nextItem.row < arrImage.count {
            self.collStep.scrollToItem(at: nextItem, at: .right, animated: true)
            self.pagecontrol.currentPage = nextItem.row
            self.lblSetCount.text = String(describing: "\("Step:".localized) \(nextItem.row + 1)")
        }
        
        if nextItem.row == 1
        {
            self.btnPrevious.isHidden = false
        }
        if nextItem.row == 5
        {
            self.btnNext.setTitle("Continue".localized, for: .normal)
        }
        
        if nextItem.row == 6
        {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func btnPrevious(_ sender: UIButton)
    {
        let visibleItems: NSArray = self.collStep.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
      
        if nextItem.row < arrImage.count {
            self.collStep.scrollToItem(at: nextItem, at: .right, animated: true)
            self.pagecontrol.currentPage = nextItem.row
            self.lblSetCount.text = String(describing: "\("Step:".localized) \(nextItem.row + 1)")
        }
        self.btnNext.setTitle("Next".localized, for: .normal)
       
        if nextItem.row == 0
        {
            self.btnPrevious.isHidden = true
        }
    }
    
    @IBAction func btnCheckPolicy(_ sender:UIButton)
    {
        let PrivacyPolicyVC: PrivacyPolicyVC = mainStoryBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        self.navigationController?.pushViewController(PrivacyPolicyVC, animated: true)
    }
    
    func SetUpUI()
    {
        self.lblPrivacyText.text = "By counting you agree to our Terms and Privacy policies Subscription will auto-renew. Cancle anytime.".localized
        self.btnPrevious.isHidden = true
        self.pagecontrol.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.collStep.isPagingEnabled = true
        self.pagecontrol.currentPage = 0
        self.constBackButtonWidth.constant = 50
        self.lblPrivacyText.isHidden = true
        if isFromSplash == true
        {
            self.lblPrivacyText.isHidden = false
            self.constBackButtonWidth.constant = 0
        }
        self.lblSetCount.text = String(describing: "\("Step:".localized) 1")
        self.btnPrevious.isHidden = true
        self.collStep.isPagingEnabled = true
        self.btnPrevious.setTitle("Previous".localized, for: .normal)
        self.btnNext.setTitle("Next".localized, for: .normal)
        if langVal == "fr"
        {
            arrImage = [UIImage(named:"ic_fr1")!,UIImage(named:"ic_fr2")!,UIImage(named:"ic_fr3")!,UIImage(named:"ic_fr4")!,UIImage(named:"ic_fr5")!,UIImage(named:"ic_fr6")!]
        }
        if langVal == "es"
        {
            arrImage = [UIImage(named:"ic_es1")!,UIImage(named:"ic_es2")!,UIImage(named:"ic_es3")!,UIImage(named:"ic_es4")!,UIImage(named:"ic_es5")!,UIImage(named:"ic_es6")!]
        }
        if langVal == "nl"
        {
            arrImage = [UIImage(named:"ic_nl1")!,UIImage(named:"ic_nl2")!,UIImage(named:"ic_nl3")!,UIImage(named:"ic_nl4")!,UIImage(named:"ic_nl5")!,UIImage(named:"ic_nl6")!]
        }
        if langVal == "it"
        {
            arrImage = [UIImage(named:"ic_it1")!,UIImage(named:"ic_it2")!,UIImage(named:"ic_it3")!,UIImage(named:"ic_it4")!,UIImage(named:"ic_it5")!,UIImage(named:"ic_it6")!]
        }
        if langVal == "pt"
        {
            arrImage = [UIImage(named:"ic_pt1")!,UIImage(named:"ic_pt2")!,UIImage(named:"ic_pt3")!,UIImage(named:"ic_pt4")!,UIImage(named:"ic_pt5")!,UIImage(named:"ic_pt6")!]
        }
        
        self.collStep.reloadData()
    }
}
//Calling CollectionView Methods
extension ContinuePolicyVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HowToUseCell", for: indexPath) as! HowToUseCell
        if self.arrImage.count > 0 && self.arrImage.count > indexPath.item
        {
            cell.imgcell.image = self.arrImage[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MainScreenWidth - 20, height: collStep.frame.size.height)
    }
    
}
//Calling CollectionView Cell
class HowToUseCell: UICollectionViewCell
{
    @IBOutlet weak var imgcell: UIImageView!
}
