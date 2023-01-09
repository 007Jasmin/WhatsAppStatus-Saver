//
//  MediaView.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 26/12/22.
//

import UIKit
import Photos
import PhotosUI

class MediaView: UIViewController {
    
    @IBOutlet var lblHeader:UILabel!
    @IBOutlet var lblStorage:UILabel!
    @IBOutlet var lblImages:UILabel!
    @IBOutlet var lblImgfileSize:UILabel!
    @IBOutlet var lblImgCnt:UILabel!
    @IBOutlet var lblVideo:UILabel!
    @IBOutlet var lblVideofileSize:UILabel!
    @IBOutlet var lblVideoCnt:UILabel!

    var albName:String = ""
    var albSize:Double = 0.0
    var imagesSize:Int = 0
    var videosSize:Double = 0.0
    var arrOfImage = [PHAsset]()
    var arrOfVideo = [PHAsset]()
    let imageManager = PHCachingImageManager.default();
    let options = PHImageRequestOptions()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCustomAlbumPhotos()
       
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
            vc.headerVal = "Images"
        }else if sender.tag == 20{
            vc.arrOfPHAsset = self.arrOfVideo
            vc.headerVal = "Videos"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    func fetchCustomAlbumPhotos()
    {
        self.arrOfImage.removeAll()
        self.arrOfVideo.removeAll()
        var MBSize:Double?
        var sizeOnDisk: Int64 = 0
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
                /*imageManager.requestImage(for: asset, targetSize: .zero, contentMode: .aspectFill, options: self.options) { (image, _) in
                    guard let image = image else { return }
                   
                    let imgData = NSData(data: image.jpegData(compressionQuality: 0)!)
                    var imageSize: Int = imgData.count
                    print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
                    print("asest image size",image.size)
                }*/
                
                if let resource = resources.first {
                    let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                    var Disk: Int64 = 0
                    Disk = Int64(bitPattern: UInt64(unsignedInt64!))
                    sizeOnDisk = sizeOnDisk + Int64(bitPattern: UInt64(unsignedInt64!))
                    let sizeVal:String = String(format: "%.2f", Double(Disk) / (1024.0*1024.0))+" MB"
                    print("sizeVal",sizeVal)
                }
                asset.requestContentEditingInput(with: nil) { (contentEditingInput, _) in
//                    do {
//                        let fileSize:Int = try contentEditingInput?.fullSizeImageURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).fileSize ?? 0
//                       // print("fileSize",fileSize)
//                        self.imagesSize = self.imagesSize + fileSize
//                        //print("self.imagesSize",self.imagesSize)
//                    } catch let error {
//                        fatalError("error: \(error)")
//                    }
                }
               
            }
            self.lblImgCnt.text = "Files: \(self.arrOfImage.count)"
            self.lblVideoCnt.text = "Files: \(self.arrOfVideo.count)"
            let sizeVal1:String = String(format: "%.2f", Double(sizeOnDisk) / (1024.0*1024.0))+" MB"
            print("sizeVal1",sizeVal1)
        }
    }
}
