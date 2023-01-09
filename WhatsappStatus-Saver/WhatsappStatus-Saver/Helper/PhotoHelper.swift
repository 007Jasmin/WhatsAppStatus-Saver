//
//  PhotoHelper.swift
//  Gallery
//
//  Created by Richa Mangukiya on 9/12/21.
//

import Foundation
import Photos
import UIKit

public struct PhotoHelper {
    
    public static var fetch: Fetch = Fetch()
    
    //MARK:  -  Fetch Class
    public class Fetch {
        
        public lazy var preview = Preview()
        
        /// Album fetch settings
        public lazy var album = Album()
        
        /// Asset fetch settings
        public lazy var assets = Assets()
        
        //MARK: - preview
        public class Preview
        {
            public lazy var photoOptions: PHImageRequestOptions = {
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true
                options.resizeMode = .exact;
                
                options.deliveryMode = .highQualityFormat
                return options
            }()
            
            public lazy var livePhotoOptions: PHLivePhotoRequestOptions = {
                let options = PHLivePhotoRequestOptions()
                options.isNetworkAccessAllowed = true
                return options
            }();
            
            public lazy var videoOptions: PHVideoRequestOptions = {
                let options = PHVideoRequestOptions()
                options.isNetworkAccessAllowed = true
                return options
            }()
        }
    }
    
    public class Album {
        /// Fetch options for albums/collections
        public lazy var options: PHFetchOptions = {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d ", PHAssetMediaType.image.rawValue)
            return fetchOptions
        }()
        
        /// Fetch results for asset collections you want to present to the user
        @available(iOS 9, *)
        public lazy var fetchResults: [PHFetchResult<PHAssetCollection>] = [
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: options)
        ]
    }
    
    //MARK: - assets class
     public class Assets
     {
         /// Fetch options for assets
         
         /// Simple wrapper around PHAssetMediaType to ensure we only expose the supported types.
         public enum MediaTypes
         {
             case image
             case video
             
             fileprivate var assetMediaType: PHAssetMediaType {
                 switch self {
                 case .image:
                     return .image
                 case .video:
                     return .video
                 }
             }
         }
        public lazy var supportedMediaTypes: Set<MediaTypes> = [.image, .video]
         
         public lazy var options: PHFetchOptions = {
             let fetchOptions = PHFetchOptions()
             
             fetchOptions.sortDescriptors = [
                 NSSortDescriptor(key: "creationDate", ascending: false)];
             
             let rawMediaTypes = supportedMediaTypes.map { $0.assetMediaType.rawValue }
             let predicate = NSPredicate(format: "mediaType IN %@", rawMediaTypes)
             fetchOptions.predicate = predicate
             
             return fetchOptions
         }()
         
     }
    
    @available(iOS 9, *)
    public static var albums: [PHAssetCollection] = {
        // We don't want collections without assets.
        // I would like to do that with PHFetchOptions: fetchOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        // But that doesn't work...
        // This seems suuuuuper ineffective...
        return fetch.album.fetchResults.filter {
            $0.count > 0
        }.flatMap {
            $0.objects(at: IndexSet(integersIn: 0..<$0.count))
        }.filter {
            // We can't use estimatedAssetCount on the collection
            // It returns NSNotFound. So actually fetch the assets...
            let assetsFetchResult = PHAsset.fetchAssets(in: $0, options: fetch.assets.options)
            return assetsFetchResult.count > 0
        }
    }()
    
    static func FetchImagesFromAlbum(in album: PHAssetCollection,completion: @escaping(_ result: PHFetchResult<PHAsset>) -> ())
    {
    
        let options = PhotoHelper.fetch.assets.options
        // Fetch many assets can take several seconds even on a fast device.
        // So dispatch the fetching to a background queue so it doesn't hang the UI
        DispatchQueue.global(qos: .userInteractive).async
        {
            
            let fetchResult = PHAsset.fetchAssets(in: album, options: options)
            DispatchQueue.main.async
            {
                completion(fetchResult)
            }
        }
        
    }
    
    public static func FetchAlbumImage(in album: PHAssetCollection,completion: @escaping(_ result: PHAsset?) -> ())
    
    {
        
        // let options = photoHelper.fetch.assets.options
        let fetchOptions = PhotoHelper.fetch.assets.options.copy() as! PHFetchOptions
        fetchOptions.fetchLimit = 1
        // Fetch many assets can take several seconds even on a fast device.
        // So dispatch the fetching to a background queue so it doesn't hang the UI
        DispatchQueue.global(qos: .userInteractive).async {
            
            if let asset = PHAsset.fetchAssets(in: album, options: fetchOptions).firstObject {
                completion(asset)
            }
            completion(nil)
        }
    }
}

extension PHAsset
{
    var originalFileName: String? {
        var result: String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                result = resource.originalFilename
            }
        }
        return result
    }
    
    func getOriginalImage(completionHandler : @escaping ((_ img : UIImage?) -> Void))
    {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            if(result != nil)
            {
                completionHandler(result)
            }
            else
            {
                completionHandler(nil)
            }
        })
    }
    
    func getURL (completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            self.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL)
            })
        }
        else if self.mediaType == .video
        {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: { (_ avAsset, _ audioMix, _ info)  in
                guard (avAsset as? AVURLAsset) != nil else
                {
                    completionHandler(nil)
                    return;
                }
                if let urlAsset = avAsset as? AVURLAsset
                {
                    
                    let localVideoUrl = urlAsset.url
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
        
    }
}
