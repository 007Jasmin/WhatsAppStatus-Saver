//
//  InfoViewController.swift
//  PhotosApp
//
//  Created by Apple on 21/12/22.
//

import UIKit
import Photos

class InfoVC: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDimension: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblFilePath: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblDimensionTitle: UILabel!
    @IBOutlet weak var lblSizeTitle: UILabel!
    @IBOutlet weak var lblFilePathTitle: UILabel!
    @IBOutlet weak var lblFileNameTitle: UILabel!
    @IBOutlet weak var lblProperties: UILabel!
    
    var assetURL:URL?
    var asset:PHAsset?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblDateTitle.text = "Date:".localized
        self.lblDimensionTitle.text = "Dimesions:".localized
        self.lblSizeTitle.text = "Size:".localized
        self.lblFileNameTitle.text = "Name: ".localized
        self.lblFilePathTitle.text = "File Path:".localized
        self.lblProperties.text = "Properties".localized
        
        self.popUpView.isHidden = true;
        if let a = self.asset {
            a.getURL { (url) in
                if let u = url {
                    self.lblFilePath.text = "\(u)"
                } else {
                    self.lblFilePath.text = "..."
                }
            }
            self.lblDimension.text = "\(a.pixelWidth)*\(a.pixelHeight)"
            self.lblFileName.text = "\(a.originalFileName ?? "")"
            self.lblDate.text = "\(a.creationDate?.creationDateStr ?? "")"
            let resources = PHAssetResource.assetResources(for: a)
            var sizeOnDisk: Int64? = 0
            
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
                
                self.lblSize.text = String(format: "%.2f", Double(sizeOnDisk!) / (1024.0*1024.0))+" MB"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.popUpView.isHidden = false
            self.popUpView.pulsateRateUs()
        }
    }
    
    @IBAction func onDoneBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
