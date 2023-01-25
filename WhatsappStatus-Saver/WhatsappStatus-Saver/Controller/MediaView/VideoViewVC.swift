//
//  VideoViewVC.swift
//  WhatsappStatus-Saver
//
//  Created by Jasmin Upadhyay on 11/01/23.
//

import UIKit
import AVKit
import AVFoundation
import Photos
import SVProgressHUD

class VideoViewVC: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var timer = Timer()
    var video: AVAsset?
    var videoAsset = [PHAsset]()
    var selectedIndex = Int()
    var headerTitle:String = ""
    var player = AVPlayer()
    var isPlaying = Bool()
    var objCancel:objectSelect?
    var menuArray:[String] = ["Delete".localized, "Share".localized,"Info".localized]
    var menuImgArray:[UIImage] = [UIImage(named: "ic_deleteview")!,UIImage(named: "ic_shareView")!,UIImage(named: "ic_info")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setSliderData), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
//Calling IBAction & Function
extension VideoViewVC
{
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPlayPause(_ sender: Any) {
        if self.isPlaying {
            self.player.pause()
            self.playButton.isSelected = false
            self.isPlaying = false
            
        } else {
            
            self.player.play()
            self.playButton.isSelected = true
            self.isPlaying = true
        }
    }
    
    @IBAction func btnNextVideo(_ sender: Any) {
        
        print("video playing:")
        if selectedIndex + 1 < videoAsset.count {
            selectedIndex = selectedIndex + 1
            playVideo()
        }
    }
    
    @IBAction func btnMore(_ sender: UIButton) {
        FTPopOverMenu.showForSender(sender: sender,with: self.menuArray,menuImageArray: self.menuImgArray,popOverPosition: .automatic,config: self.configWithMenuStyle(),done: { (selectedIndex) in
            print(selectedIndex)
            if selectedIndex == 0
            {
                self.deleteAssest()
            }
            else if selectedIndex == 1
            {
                self.sharevideo()
            }
            else if selectedIndex == 2
            {
                self.OpenInfo()
            }
            
        },cancel: {
            
        })
    }
    
    @IBAction func btnPreviousVideo(_ sender: Any) {
        if selectedIndex - 1 >= 0 {
            selectedIndex = selectedIndex - 1
            playVideo()
        }
    }
    
    func configWithMenuStyle() -> FTConfiguration
        {
            let config = FTConfiguration()
            config.backgoundTintColor = UIColor.white
            config.borderColor = UIColor.lightGray
            config.menuWidth = 100
            config.menuSeparatorColor = UIColor.lightGray
            config.menuRowHeight = 50
            config.cornerRadius = 6
            config.textColor = UIColor.black
            config.textAlignment = NSTextAlignment.center
            return config
        }
    
    func playVideo() {
        videoAsset[selectedIndex].getURL { (url) in
            self.player.pause()
            self.player = AVPlayer(url: url!)
            let playerLayer = AVPlayerLayer(player: self.player)
            DispatchQueue.main.async {
                playerLayer.frame = self.playerView.bounds
                self.playerView.layer.sublayers?.removeAll()
                self.playerView.layer.addSublayer(playerLayer)
                self.player.play()
                self.playButton.isSelected = true
                self.isPlaying = true
                self.setSliderData()
                self.lblHeader.text = self.videoAsset[self.selectedIndex].originalFileName
            }
        }
    }
    
    @objc func setSliderData() {
        self.startTime.text = formatTimeFor(seconds: Int(player.currentItem?.currentTime().seconds ?? 0))
        self.sliderView.value = Float(player.currentItem?.currentTime().seconds ?? 0)
        if (player.currentItem?.duration.seconds ?? 0) > 0 {
            self.endTime.text = formatTimeFor(seconds: Int(player.currentItem?.duration.seconds ?? 0) - Int(player.currentTime().seconds))
            self.sliderView.maximumValue = Float(player.currentItem?.duration.seconds ?? 0)
            if self.sliderView.value >= self.sliderView.maximumValue {
                
                playVideo()
            }
        }
    }
    
    func formatTimeFor(seconds: Int) -> String {
        let result = getHoursMinutesSecondsFrom(seconds: seconds)
        let hoursString = "\(result.hours)"
        var minutesString = "\(result.minutes)"
        if minutesString.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        var secondsString = "\(result.seconds)"
        if secondsString.count == 1 {
            secondsString = "0\(result.seconds)"
        }
        var time = "\(hoursString):"
        if result.hours >= 1 {
            time.append("\(minutesString):\(secondsString)")
        }
        else {
            time = "\(minutesString):\(secondsString)"
        }
        return time
    }
    
    func getHoursMinutesSecondsFrom(seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func deleteAssest()
    {
        if let currentAsset = self.videoAsset[self.selectedIndex] as? PHAsset
        {
            let str = currentAsset.localIdentifier
            let arr = str.split(separator: "/")
            let videoURL = URL.init(string: "assets-library://asset/asset.MOV?id=\(arr[0])&extMOV")
            let library = PHPhotoLibrary.shared()
            library.performChanges({
                let assetsToBeDeleted = PHAsset.fetchAssets(withALAssetURLs: [videoURL!], options: nil) as? PHFetchResult
                if let aDeleted = assetsToBeDeleted {
                    PHAssetChangeRequest.deleteAssets(aDeleted)
                }
            }, completionHandler: { success, error in
                
                if success {
                    SVProgressHUD.showSuccess(withStatus: "Delete Successfully...")
                    SVProgressHUD.dismiss(withDelay: 0.3)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.player.pause()
                        self.playerView.layer.sublayers?.removeAll()
                        if let index = self.videoAsset.firstIndex(of: currentAsset) {
                            self.videoAsset.remove(at: index)
                        }
                        self.objCancel?(self.videoAsset)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    SVProgressHUD.dismiss()
                }
            })
        }
    }
    
    func sharevideo()
    {
        self.videoAsset[self.selectedIndex].getURL { (url) in
            let activityViewController = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
            DispatchQueue.main.async {
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    func OpenInfo()
    {
        if let currentAsset = self.videoAsset[self.selectedIndex] as? PHAsset
        {
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
            vc.asset = currentAsset
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
    }
}
