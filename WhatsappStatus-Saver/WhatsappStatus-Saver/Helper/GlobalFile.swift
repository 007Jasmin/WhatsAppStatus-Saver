//
//  GlobalFile.swift
//  BloodPressureApp
//
//  Created by ERASOFT on 12/11/22.
//

import Foundation
import UIKit

func didEnterHomeScreens()
{
    let HomeVC: HomeVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    HomeVC.tabBarItem.selectedImage = UIImage(named: "ic_knowledge_selected")?.withRenderingMode(.alwaysOriginal)
    HomeVC.tabBarItem.image = UIImage(named: "ic_knowledge_unselected")?.withRenderingMode(.alwaysOriginal)
    HomeVC.tabBarItem.title = "Home"
   // HomeVC.isFromSplash = true
    
    let HowToUseVC: HowToUseVC = mainStoryBoard.instantiateViewController(withIdentifier: "HowToUseVC") as! HowToUseVC
    HowToUseVC.tabBarItem.selectedImage = UIImage(named: "ic_tracker_selected")?.withRenderingMode(.alwaysOriginal)
    HowToUseVC.tabBarItem.image = UIImage(named: "ic_tracker_unselected")?.withRenderingMode(.alwaysOriginal)
    HowToUseVC.tabBarItem.title = "How to Use"
    
    let MediaView: MediaView = mainStoryBoard.instantiateViewController(withIdentifier: "MediaView") as! MediaView
    MediaView.tabBarItem.selectedImage = UIImage(named: "ic_settings_selected")?.withRenderingMode(.alwaysOriginal)
    MediaView.tabBarItem.image = UIImage(named: "ic_settings_unselected")?.withRenderingMode(.alwaysOriginal)
    MediaView.tabBarItem.title = "Media"
   
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#0D0D0D").withAlphaComponent(0.3)], for: .normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FF3F80")], for: .selected)
//        let bgView = UIImageView(image: UIImage(named: "tab"))
//        bgView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 85)
//        tabBarVc.tabBar.addSubview(bgView)
//        tabBarVc.tabBar.sendSubviewToBack(bgView)
    tabBarVc.tabBar.layer.borderWidth = 0.0
    tabBarVc.tabBar.layer.borderColor = UIColor.clear.cgColor
    tabBarVc.tabBar.clipsToBounds = true
    tabBarVc.tabBar.backgroundColor = UIColor.white
    tabBarVc.viewControllers = [HomeVC,HowToUseVC,MediaView]
    tabBarVc.tabBar.barTintColor = UIColor.clear
    tabBarVc.tabBar.tintColor = UIColor.clear
    tabBarVc.tabBar.layer.borderWidth = 1
    tabBarVc.tabBar.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    tabBarVc.selectedViewController = HomeVC
    let nav = UINavigationController(rootViewController: tabBarVc)
    nav.navigationBar.isHidden = true
    appDelegate.window?.rootViewController = nav
}

class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [StartColor.cgColor, EndColor.cgColor]
        l.startPoint = CGPoint(x: 0.25, y: 0.5)
        l.endPoint = CGPoint(x: 0.75, y: 0.5)
        l.cornerRadius = self.frame.height / 2
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

class WhiteImageView : UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor.white
    }
}

class GrayImageView : UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor.lightGray
    }
}

class ViewBorderRadius : UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup()
    {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hexString: "#858585").cgColor
        self.layer.cornerRadius = 10
    }
}

func AlertWithMessage(_ vc:UIViewController,message:String)
{
    let dialogBox = UIAlertController(title: APPNAME, message: message, preferredStyle: .alert)
    dialogBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    vc.present(dialogBox, animated: true, completion: nil)
}
