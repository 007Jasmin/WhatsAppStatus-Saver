//
//  MediaView.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 26/12/22.
//

import UIKit
import Photos
import PhotosUI
import SVProgressHUD

class MediaView: UIViewController {
    
    @IBOutlet var lblHeader:UILabel!
    @IBOutlet var lblStorage:UILabel!
    @IBOutlet var lblStorageVal:UILabel!
    @IBOutlet var lblImages:UILabel!
    @IBOutlet var lblImgfileSize:UILabel!
    @IBOutlet var lblImgCnt:UILabel!
    @IBOutlet var lblVideo:UILabel!
    @IBOutlet var lblVideofileSize:UILabel!
    @IBOutlet var lblVideoCnt:UILabel!
    @IBOutlet var sliderSize:UIView!
    @IBOutlet var lblPrecentage:UILabel!

    var albName:String = ""
    var albSize:Double = 0.0
    var imagesSize:Int = 0
    var videosSize:Double = 0.0
    var arrOfImage = [PHAsset]()
    var arrOfVideo = [PHAsset]()
    let imageManager = PHCachingImageManager.default();
    let options = PHImageRequestOptions()
    var sizeOnDisk: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: when)
        {
           // self.fetchCustomAlbumPhotos()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHeader.text = "Whats Cleaner".localized
        self.lblImages.text = "Images".localized
        self.lblVideo.text = "Videos".localized
        self.lblStorage.text = "STORAGE".localized
        
        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

                albumsPhoto.enumerateObjects({(collection, index, object) in
                    let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
                        print(photoInAlbum.count)
                        print(collection.localizedTitle)

                })
    }

}
//Calling IBAction & Function
extension MediaView
{
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMedia(_ sender: UIButton) {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "DisplayMediaVC") as! DisplayMediaVC
        if sender.tag == 10{
            vc.arrOfPHAsset = self.arrOfImage
            vc.headerVal = "Images".localized
        }else if sender.tag == 20{
            vc.arrOfPHAsset = self.arrOfVideo
            vc.headerVal = "Videos".localized
        }
        vc.objdone = {
            SVProgressHUD.show()
            self.sizeOnDisk = 0
            DispatchQueue.main.asyncAfter(deadline: when)
            {
                self.fetchCustomAlbumPhotos()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func fetchCustomAlbumPhotos()
    {
        self.arrOfImage.removeAll()
        self.arrOfVideo.removeAll()
        var MBSize:Double?
        
        let albumName = "WhatsApp"
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
        else { albumFound = false }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects{(object: AnyObject!,
                                      count: Int,
                                      stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                
                if asset.mediaType == .image
                {
                    self.arrOfImage.append(asset)
                }
                else if asset.mediaType == .video
                {
                    self.arrOfVideo.append(asset)
                }
                
                let resources = PHAssetResource.assetResources(for: asset)
                 
                self.options.deliveryMode = .fastFormat
                self.options.isSynchronous = true
                if let resource = resources.first {
                    let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                    var Disk: Int64 = 0
                    Disk = Int64(bitPattern: UInt64(unsignedInt64!))
                    self.sizeOnDisk = self.sizeOnDisk + Int64(bitPattern: UInt64(unsignedInt64!))
                    let sizeVal:String = String(format: "%.2f", Double(Disk) / (1024.0*1024.0))+" MB"
                    
                }
            }
        }
        print("sizeVal", self.sizeOnDisk)
        self.SetUpUI()
    }
    
    func SetUpUI()
    {
        let f1 = "Files:".localized
        self.lblImgCnt.text = "\(f1) \(self.arrOfImage.count)"
        self.lblVideoCnt.text = "\(f1) \(self.arrOfVideo.count)"
        
        let sizeVal1:Float =  Float(Double(sizeOnDisk) / (1024.0*1024.0))
        let str1:String = String(format: "%.2f", sizeVal1)
        print("total sizeVal",sizeVal1)
        
        let val:String = DiskStatus.totalDiskSpaceInGB.replacingOccurrences(of: " GB", with: "")
        let maxVal:Float = Float(val) ?? 0.0
        var currentVal:Float = Float(Double(sizeOnDisk) / (1024.0*1024.0*1024.0))
        
        let str:String = String(format: "%.2f", currentVal)
        currentVal = Float(str) ?? 0.00
        print("currentVal",currentVal)
        
        self.lblStorageVal.text = "\(str1) MB / \(DiskStatus.totalDiskSpaceInGB)"
        if sizeVal1 > 900.0
        {
            self.lblStorageVal.text = "\(currentVal) GB / \(DiskStatus.totalDiskSpaceInGB)"
        }
        
        let d = Float((currentVal * 100) / maxVal)
        let st = String(format: "%.2f", d)
        self.lblPrecentage.text = "\(st)%"
        
        let frame = CGRect(x: 0, y: 0, width: self.sliderSize.frame.width, height: self.sliderSize.frame.height)
        let circularSlider = CircularSlider(frame: frame)
        circularSlider.maximumAngle = 270.0
        circularSlider.unfilledArcLineCap = .round
        circularSlider.filledArcLineCap = .round
        circularSlider.lineWidth = 20
        circularSlider.maximumValue = maxVal
        circularSlider.currentValue = currentVal
        self.sliderSize.addSubview(circularSlider)
        circularSlider.transform = circularSlider.getRotationalTransform()
        
        self.CalculateImageSize()
        self.CalculateVideoSize()
        
        SVProgressHUD.dismiss()
    }
    
    func CalculateImageSize()
    {
        var sizeOnDisk: Int64 = 0
        for i in 0..<self.arrOfImage.count
        {
            let asset = self.arrOfImage[i]
            let resources = PHAssetResource.assetResources(for: asset)
             
            self.options.deliveryMode = .fastFormat
            self.options.isSynchronous = true
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                var Disk: Int64 = 0
                Disk = Int64(bitPattern: UInt64(unsignedInt64!))
                sizeOnDisk = sizeOnDisk + Int64(bitPattern: UInt64(unsignedInt64!))
                //print("sizeVal",sizeVal)
            }
        }
      
        let sizeVal1:Float =  Float(Double(sizeOnDisk) / (1024.0*1024.0))
        var currentVal:Float = Float(Double(sizeOnDisk) / (1024.0*1024.0*1024.0))
        let str:String = String(format: "%.2f", currentVal)
        self.lblImgfileSize.text = NSString(format: "%@ %.2f MB", "Total sizes :".localized,sizeVal1) as String
        if sizeVal1 > 900.0
        {
            self.lblImgfileSize.text = NSString(format: "%@ %@ GB", "Total sizes :".localized,str) as String
        }
        
        
    }
    
    func CalculateVideoSize()
    {
        var sizeOnDisk: Int64 = 0
        for i in 0..<self.arrOfVideo.count
        {
            let asset = self.arrOfVideo[i]
            let resources = PHAssetResource.assetResources(for: asset)
             
            self.options.deliveryMode = .fastFormat
            self.options.isSynchronous = true
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                var Disk: Int64 = 0
                Disk = Int64(bitPattern: UInt64(unsignedInt64!))
                sizeOnDisk = sizeOnDisk + Int64(bitPattern: UInt64(unsignedInt64!))
                //print("sizeVal",sizeVal)
            }
        }
        let sizeVal1:Float =  Float(Double(sizeOnDisk) / (1024.0*1024.0))
        var currentVal:Float = Float(Double(sizeOnDisk) / (1024.0*1024.0*1024.0))
        let str:String = String(format: "%.2f", currentVal)
        self.lblVideofileSize.text = NSString(format: "%@ %.2f MB", "Total sizes :".localized,sizeVal1) as String
        if sizeVal1 > 900.0
        {
            self.lblVideofileSize.text = NSString(format: "%@ %@ GB", "Total sizes :".localized,str) as String
        }
       
    }
}
