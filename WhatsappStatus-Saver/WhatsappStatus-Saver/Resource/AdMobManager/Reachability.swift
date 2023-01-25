//
//  Reachability.swift
//  ChargingDemo1
//
//  Created by Ravi Patel on 01/09/21.
//  Copyright © 2021 Ravi Patel. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

public class Reachability {
    
    class public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    public func showInternetAlert() {
        let alert = UIAlertController(title: "Alert!", message: "Please connet to internet", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController?.present(alert, animated: true)
    }
    
    
}
