//
//  ImageVideoViewVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 07/01/23.
//

import UIKit
import Photos
import SVProgressHUD

class ImageViewVC: UIViewController {
    
    @IBOutlet weak var photosCollectionview: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var BottamBar: UIStackView!
    
    var fetchResult = [PHAsset]()
    var fullViewImage = UIImage()
    var currentIndex:Int = 0
    var currentAsset:PHAsset?
    var asset: PHAsset?
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var objCancel:objectSelect?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.BottamBar.layer.borderWidth = 0.5
        self.BottamBar.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.fetchResult.count > 0 {
            self.currentAsset = self.fetchResult[self.currentIndex]
        }
       
        centeredCollectionViewFlowLayout = photosCollectionview.collectionViewLayout as! CenteredCollectionViewFlowLayout
        
        photosCollectionview.decelerationRate = UIScrollView.DecelerationRate.fast
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.bounds.width * 1.0,
            height: photosCollectionview.bounds.height * 1.0 * 1.0);
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
            self.centeredCollectionViewFlowLayout.scrollToPage(index: self.currentIndex, animated: false)
            if self.fetchResult.count > 0 {
                self.lblHeader.text = self.fetchResult[self.currentIndex].originalFileName
            }
        }
    }

}
//Calling IBAction & Function
extension ImageViewVC
{
    @IBAction func btnBack(_ sender: Any) {
        self.objCancel!(self.fetchResult)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        SVProgressHUD.show()
        let str = currentAsset?.localIdentifier
        let arr = str?.split(separator: "/")
        let imgURL = URL.init(string: "assets-library://asset/asset.JPG?id=\(arr?[0] ?? "")&extJPG")
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            let assetsToBeDeleted = PHAsset.fetchAssets(withALAssetURLs: [imgURL!], options: nil) as? PHFetchResult
            if let aDeleted = assetsToBeDeleted {
                PHAssetChangeRequest.deleteAssets(aDeleted)
            }
        }, completionHandler: { success, error in
            if success
            {
                SVProgressHUD.showSuccess(withStatus: "Delete Successfully...")
                SVProgressHUD.dismiss(withDelay: 0.3)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let index = self.fetchResult.firstIndex(of: self.currentAsset!) {
                        self.fetchResult.remove(at: index)
                    }
                    self.photosCollectionview.reloadData()
                }
            } else {
                SVProgressHUD.dismiss()
                
            }
        })
    }
    
    @IBAction func btnShare(_ sender: Any) {
        var objectsToShare = [AnyObject]()
        self.currentAsset!.getOriginalImage { (img) in
            if let image = img {
                objectsToShare.append(image)
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil);
                activityVC.excludedActivityTypes = []
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                self.present(activityVC, animated: true, completion: nil)
            } else {
               
            }
        }
    }
    
    @IBAction func btnInfo(_ sender: Any) {
        if let asset = self.currentAsset {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
            vc.asset = asset
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
    }
}
//Calling ScrolleView Methods
extension ImageViewVC
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        if let index = centeredCollectionViewFlowLayout.currentCenteredPage
        {
            currentAsset = self.fetchResult[index]
            self.fetchResult[index].getURL { (url) in
                print("\(url):\( self.fetchResult[index].pixelWidth)*\( self.fetchResult[index].pixelHeight)...\(self.fetchResult[index].creationDate?.creationDateStr)")
            }
            self.lblHeader.text = self.fetchResult[index].originalFileName
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let index = centeredCollectionViewFlowLayout.currentCenteredPage
        {
            let cell = photosCollectionview.dequeueReusableCell(withReuseIdentifier: "PhotosPreviewCollectionViewCell", for: IndexPath(item: index, section: 0)) as? PhotosPreviewCollectionViewCell
            photosCollectionview.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        
        if let index = centeredCollectionViewFlowLayout.currentCenteredPage
        {
            self.lblHeader.text = self.fetchResult[index].originalFileName
        }
    }
}
//Calling collectionView Methods
extension ImageViewVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.fetchResult.count > 0
        {
            return self.fetchResult.count
        }
        else if self.fullViewImage != nil
        {
            return 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosPreviewCollectionViewCell", for: indexPath) as? PhotosPreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        if self.fetchResult.count > 0 {
            let asset =  self.fetchResult[indexPath.row]
            cell.asset = asset
            print(asset.mediaType)
            cell.photozoominView.isHidden = false
        } else {
            cell.image = self.fullViewImage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = collectionView.bounds.width;
        let cell_width =  width;
        let height = collectionView.bounds.height
        return CGSize(width: cell_width, height: height)
    }
}
//CollectionView Cell
class PhotosPreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photozoominView: PhotoZoomingView!
    var asset: PHAsset?{
        didSet {
            guard let asset = asset else{ return }
            self.photozoominView.asset = asset
        }
    }

    var image: UIImage?{
        didSet {
            guard let image = image else{ return }
            self.photozoominView.imageView.image = image
        }
    }
}

