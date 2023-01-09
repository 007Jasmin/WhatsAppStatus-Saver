//
//  MobikeConnectionView.swift
//  xdender
//
//  Created by Chadani on 8/16/20.
//  Copyright © 2020 Jksol Infotech. All rights reserved.
//

import UIKit
import Foundation
import Photos

class PhotoZoomingView: UIView,UIScrollViewDelegate
{
    
    let kCONTENT_XIB_NAME = "PhotoZoomingView"
    var fullscreen = false {
        didSet {
            guard oldValue != fullscreen else { return }
            UIView.animate(withDuration: 0.3) {
       //        self.updateNavigationBar()
 //               self.updateStatusBar()
              //  self.updateBackgroundColor()
            }
        }
    }
    let imageView: UIImageView = UIImageView(frame: .zero)
    let scrollView = UIScrollView(frame: .zero)
    private let imageManager = PHCachingImageManager.default()
    var asset: PHAsset? {
        didSet {
           // updateNavigationTitle()
            
            guard let asset = asset else {
                imageView.image = nil
                return
            }
            
            // Load image for preview
            imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: PhotoHelper.fetch.preview.photoOptions) { [weak self] (image, _) in
                guard let image = image else { return }
                self?.imageView.image = image
            }
        }
    }
    @IBOutlet var contentView: UIView!
    
    //MARK: - init fucntion
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit();
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapRecognizer)
        commonInit();
    }
    
    private func commonInit()
    {
        let nib = UINib(nibName: kCONTENT_XIB_NAME, bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        self.setup();
    }
    
    //MARK: - intially setup
    private func setup()
    {
        setupScrollView();
        setupImageView();
        
    }
   
    private func setupScrollView()
    {
        
        scrollView.frame = contentView.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        if #available(iOS 11.0, *)
        {
            // Allows the imageview to be 'under' the navigation bar
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
    }
    
    private func setupImageView()
    {
      
        imageView.frame = scrollView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
       
    }
    //MARK: - scrollviewDeleagte
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       
       
        return imageView
    }

   @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
        
        if scale != scrollView.zoomScale {
            let point = gestureRecognizer.location(in: imageView)

            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
            
        }
       else
       {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
        
    }
    
//    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
//        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
//
//        if scale != scrollView.zoomScale { // zoom in
//            let point = gestureRecognizer.location(in: imageView)
//
//            let scrollSize = scrollView.frame.size
//            let size = CGSize(width: scrollSize.width / scale,
//                              height: scrollSize.height / scale)
//            let origin = CGPoint(x: point.x - size.width / 2,
//                                 y: point.y - size.height / 2)
//            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
//        } else {
//            scrollView.contentInset = .zero
//        }
//    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
         
        
        if scrollView.zoomScale > 1 {
            
            fullscreen = true

            guard let image = imageView.image else { return }
            guard let zoomView = viewForZooming(in: scrollView) else { return }

            let widthRatio = zoomView.frame .width / image.size.width
            let heightRatio = zoomView.frame.height / image.size.height

            let ratio = widthRatio < heightRatio ? widthRatio:heightRatio

            let newWidth = image.size.width * ratio
            let newHeight = image.size.height * ratio

            let left = 0.5 * (newWidth * scrollView.zoomScale > zoomView.frame.width ? (newWidth - zoomView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
            let top = 0.5 * (newHeight * scrollView.zoomScale > zoomView.frame.height ? (newHeight - zoomView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

            scrollView.contentInset = UIEdgeInsets(top: top.rounded(), left: left.rounded(), bottom: top.rounded(), right: left.rounded())
        } else {
            scrollView.contentInset = .zero
        }
    }
   
}


