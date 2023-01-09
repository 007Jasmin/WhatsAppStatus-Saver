//
//  HowToUseVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 26/12/22.
//

import UIKit

class HowToUseVC: UIViewController {
    
    @IBOutlet weak var collStep: UICollectionView!
    @IBOutlet var lblSetCount:UILabel!
    @IBOutlet var lblHeader:UILabel!
    @IBOutlet var btnNext:UIButton!
    @IBOutlet var btnPrevious:UIButton!
    
    var arrImage:[UIImage] = [UIImage(named:"1")!,UIImage(named:"2")!,UIImage(named:"3")!,UIImage(named:"4")!,UIImage(named:"5")!,UIImage(named:"6")!]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnPrevious.isHidden = true
        self.collStep.isPagingEnabled = true
    }
}
//Calling IBAction & Function
extension HowToUseVC
{
    @IBAction func btnBack(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnContinue(_ sender: UIButton)
    {
        
        let visibleItems: NSArray = self.collStep.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
      
        if nextItem.row < arrImage.count {
            self.collStep.scrollToItem(at: nextItem, at: .right, animated: true)
            self.lblSetCount.text = String(describing: "Step: \(nextItem.row + 1)")
        }
        
        if nextItem.row == 1
        {
            self.btnPrevious.isHidden = false
        }
        if nextItem.row == 5
        {
            self.btnNext.setTitle("Finish", for: .normal)
        }
        if nextItem.row == 6
        {
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func btnPrevious(_ sender: UIButton)
    {
        let visibleItems: NSArray = self.collStep.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
      
        if nextItem.row < arrImage.count {
            self.collStep.scrollToItem(at: nextItem, at: .right, animated: true)
            self.lblSetCount.text = String(describing: "Step: \(nextItem.row + 1)")
        }
        self.btnNext.setTitle("Next >", for: .normal)
        if nextItem.row == 0
        {
            self.btnPrevious.isHidden = true
        }
    }
}
//Calling CollectionView Methods
extension HowToUseVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
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
        return CGSize(width: MainScreenWidth - 60, height: collStep.frame.size.height)
    }
    
}
