//
//  DisplayMediaVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 06/01/23.
//

import UIKit
import Photos
import SVProgressHUD

class DisplayMediaVC: UIViewController {
    
    @IBOutlet var lblHeader:UILabel!
    @IBOutlet var lblNoData:UILabel!
    @IBOutlet var btnDelete:UIButton!
    @IBOutlet var btnDeleteIcon:UIButton!
    @IBOutlet var collAssest:UICollectionView!
    @IBOutlet var constBtnDeleteHeight:NSLayoutConstraint!
    @IBOutlet var closeView:UIView!
    @IBOutlet var deleteView:UIView!
    @IBOutlet var noDataView:UIView!
    
    var multipleSelectedArray:[PHAsset] = []
    var arrOfPHAsset:[PHAsset] = []
    let imageManager = PHCachingImageManager.default();
    var targetSize: CGSize = .zero
    var isEnableMultipleDelete:Bool = false
    let options = PHImageRequestOptions()
    var headerVal:String = ""
    var objdone:objectCancel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblNoData.text = "No files found".localized
        self.deleteView.isHidden = true
        self.noDataView.isHidden = false
        if arrOfPHAsset.count > 0
        {
            self.deleteView.isHidden = false
            self.noDataView.isHidden = true
        }
        self.lblHeader.text = headerVal
        self.closeView.isHidden = true
        self.constBtnDeleteHeight.constant = 0
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        collAssest.addGestureRecognizer(longPress)
    }
   
}
//Calling IBAction & Function
extension DisplayMediaVC
{
    @IBAction func btnBack(_ sender: Any) {
        objdone?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        self.isEnableMultipleDelete = true
        self.collAssest.reloadData()
        self.constBtnDeleteHeight.constant = 60
        self.closeView.isHidden = false
        self.deleteView.isHidden = true
    }
    
    @IBAction func btnCloseMultipleDelete(_ sender: Any) {
        self.isEnableMultipleDelete = false
        self.collAssest.reloadData()
        self.constBtnDeleteHeight.constant = 0
        self.closeView.isHidden = true
        self.deleteView.isHidden = false
    }
    
    @IBAction func btnMultipleDelete(_ sender: Any) {
        
        SVProgressHUD.show()
        let assetArray : NSMutableArray = NSMutableArray()
        assetArray.addObjects(from: self.multipleSelectedArray)
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assetArray)
        } completionHandler: { (isDone, error) in
            if isDone {
                SVProgressHUD.showSuccess(withStatus: "Delete Successfully...")
                SVProgressHUD.dismiss(withDelay: 0.3)
                DispatchQueue.main.async {
                    for i in 0..<self.multipleSelectedArray.count
                    {
                        let assest = self.multipleSelectedArray[i]
                        if let index = self.arrOfPHAsset.firstIndex(of: assest) {
                            self.arrOfPHAsset.remove(at: index)
                        }
                    }
                    self.closeView.isHidden = true
                    self.deleteView.isHidden = false
                    self.isEnableMultipleDelete = false
                    self.collAssest.reloadData()
                    self.constBtnDeleteHeight.constant = 0
                }
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: collAssest)
            if let indexPath = collAssest.indexPathForItem(at: touchPoint) {
                self.multipleSelectedArray.append(self.arrOfPHAsset[indexPath.item] ?? PHAsset())
                self.isEnableMultipleDelete = true
                self.collAssest.reloadData()
                self.constBtnDeleteHeight.constant = 60
                self.closeView.isHidden = false
                self.deleteView.isHidden = true
            }
        }
    }
    
    @objc func checkBoxSelection(_ sender:UIButton)
    {
        let asset = self.arrOfPHAsset[sender.tag]
        
        if self.multipleSelectedArray.contains(asset ?? PHAsset()) {
            if let index = self.multipleSelectedArray.firstIndex(of: asset) {
                self.multipleSelectedArray.remove(at: index)
            }
        }
        else{
            self.multipleSelectedArray.append(asset ?? PHAsset())
        }
        self.collAssest.reloadData()
        
        if self.multipleSelectedArray.count > 0{} else {
            self.closeView.isHidden = true
            self.deleteView.isHidden = false
            self.isEnableMultipleDelete = false
            self.collAssest.reloadData()
            self.constBtnDeleteHeight.constant = 0
        }
    }
    
}
//Calling collectionView Methods
extension DisplayMediaVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfPHAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.btnSelect.isHidden = true
        cell.imageV.layer.cornerRadius = 10
        let widthVal = (MainScreenWidth - 20) / 4
        let imageSize = CGSize(width: widthVal,
                               height: widthVal)
        if self.arrOfPHAsset.count > 0 && self.arrOfPHAsset.count > indexPath.item
        {
            let asset = self.arrOfPHAsset[indexPath.row]
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { (image, _) in
                guard let image = image else { return }
                cell.imageV.image = image
            }
            cell.asset = self.arrOfPHAsset[indexPath.row]
            cell.btnSelect.tag = indexPath.item
            cell.btnSelect.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
            if self.isEnableMultipleDelete == true {
                cell.btnSelect.isHidden = false
            }
            
            if self.multipleSelectedArray.contains(cell.asset ?? PHAsset()) {
                cell.btnSelect.isSelected = true
            } else {
                cell.btnSelect.isSelected = false
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let asset = self.arrOfPHAsset[indexPath.item]
        if let cell:ImageCell = self.collAssest.cellForItem(at: indexPath) as? ImageCell {
            if !isEnableMultipleDelete {
                
                if let asset = cell.asset {
                    if asset.mediaType == .video
                    {
                        let joinarr  = arrOfPHAsset.filter({$0.mediaType == .video})
                        let index = joinarr.firstIndex { $0.localIdentifier == asset.localIdentifier } ?? 0
                        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "VideoViewVC") as! VideoViewVC
                        vc.videoAsset = joinarr
                        vc.selectedIndex = index
                        vc.objCancel = {(arrPhAssest) in
                            self.arrOfPHAsset = []
                            self.arrOfPHAsset = arrPhAssest
                            self.collAssest.reloadData()
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        let joinarr  = Array(self.arrOfPHAsset)
                        let index = joinarr.index { $0.localIdentifier == asset.localIdentifier } ?? 0
                        
                        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ImageViewVC") as! ImageViewVC
                        vc.currentIndex = index
                        vc.fetchResult = joinarr
                        vc.asset = asset
                        vc.objCancel = {(arrPhAssest) in
                            self.arrOfPHAsset = []
                            self.arrOfPHAsset = arrPhAssest
                            self.collAssest.reloadData()
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            else
            {
                if self.multipleSelectedArray.contains(asset ?? PHAsset()) {
                    if let index = self.multipleSelectedArray.firstIndex(of: asset) {
                        self.multipleSelectedArray.remove(at: index)
                    }
                }
                else{
                    self.multipleSelectedArray.append(asset ?? PHAsset())
                }
                self.collAssest.reloadData()
                if self.multipleSelectedArray.count > 0{} else {
                    self.closeView.isHidden = true
                    self.deleteView.isHidden = false
                    self.isEnableMultipleDelete = false
                    self.collAssest.reloadData()
                    self.constBtnDeleteHeight.constant = 0
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthVal = (MainScreenWidth - 20) / 4
        return CGSize(width: widthVal, height: widthVal)
    }
}
//ColectionView Cell
class ImageCell:UICollectionViewCell
{
    @IBOutlet var imageV:UIImageView!
    @IBOutlet var btnSelect:UIButton!
    @IBOutlet var mainView:UIView!
    
    var asset: PHAsset?
}
