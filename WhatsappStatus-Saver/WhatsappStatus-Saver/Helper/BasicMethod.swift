//
//  BasicMethod.swift
//  Contact List
//
//  Created by Jksol-Niketan on 29/12/21.
//

import Foundation
//
//  BasicMethod.swift
//  xdender
//
//  Created by Chandani on 20/07/20.
//  Copyright © 2020 Jksol Infotech. All rights reserved.
//
import Foundation

import SVProgressHUD
class BasicMethod
{
    
    //MARK: - header function
    class func getStatusBarHeight() -> CGFloat
    {
        
       var statusBarHeight: CGFloat = 0
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
       return statusBarHeight
    }

    class func setHederHeight() -> CGFloat{
//        let app = UIApplication.shared
        let height = getStatusBarHeight()
        print("Height ----> \(height)")
        if height > 40.0 {
            return 90
        }else{
            return 65
        }
    }
   
    //MARK: - toast
   class  func showToast(message:String)
    {
 
        
        let toastLabel = UILabel(frame: CGRect(x:  (appDelegate.window?.rootViewController?.view.frame.size.width)!/2 - 150, y:  (appDelegate.window?.rootViewController?.view.frame.size.height)!-100, width: 300, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.font = UIFont.systemFont(ofSize: 15)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17
        toastLabel.clipsToBounds  =  true;
       // appDelegate.window?.rootViewController?.view.addSubview(toastLabel);
        
       UIApplication.shared.windows[UIApplication.shared.windows.count - 1].addSubview(toastLabel)
        UIView.animate(withDuration: 5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }

   
    
    
  
      
   
      
}

