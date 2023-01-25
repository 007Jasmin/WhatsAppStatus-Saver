//
//  InAppManager.swift
//  Rock Finder
//
//  Created by Sagar Lukhi on 05/07/22.
//

import Foundation
import SwiftyStoreKit
import StoreKit
import UIKit
import SVProgressHUD

class InAppManager: NSObject {
    
    static let shared = InAppManager()
    
    // MARK: - Complite pending transactions
    func completeTransition() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    debugPrint("Default Method Called")
                }
            }
        }
    }
    
    // MARK: - Receipt Verify
    func verifyReciept() {
        var isPurched = false
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedsecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                guard let dict = receipt["latest_receipt_info"] as? [[String:Any]] else { return }
                for k in dict {
                    let productId = k["product_id"] as! String
                    // Verify the purchase of a Subscription
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable, // or .nonRenewing (see below)
                        productId: productId,
                        inReceipt: receipt)
                    
                    switch purchaseResult {
                        
                    case .purchased(let expiryDate, let items):
                        debugPrint("\(productId) is valid until \(expiryDate)\n\(items)\n")
                        isPurched = true
                        Defaults.set(true, forKey: "adRemoved")
                        Defaults.synchronize()
                        
                    case .expired(let expiryDate, let items):
                        debugPrint("\(productId) is expired since \(expiryDate)\n\(items)\n")
                        if !isPurched{
                            Defaults.set(false, forKey: "adRemoved")
                            Defaults.synchronize()
                        }
                        
                    case .notPurchased:
                        debugPrint("The user has never purchased \(productId)")
                        if !isPurched{
                            Defaults.set(false, forKey: "adRemoved")
                            Defaults.synchronize()
                        }
                    }
                }
                
            case .error(let error):
                debugPrint("Receipt verification failed: \(error)")
            }
        }
    }
    
    // MARK: - Retrive Information About Product
    func retriveProductInfo(arrProduct: Set<String>, completion: @escaping (Set<SKProduct>) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(arrProduct) { result in
            completion(result.retrievedProducts)
        }
    }
    
    // MARK: - Purchas Product
    func purchaseProduct(productId: String) {
        SVProgressHUD.show(withStatus: "Purchasing....")
        
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            SVProgressHUD.dismiss()
            
            switch result {
            case .success(let purchase):
                debugPrint("Purchase Success: \(purchase.productId)")
                SVProgressHUD.showSuccess(withStatus: "Purchase Successfully !")
                Defaults.set(true, forKey: "adRemoved")
                Defaults.synchronize()
                
            case .error(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                switch error.code {
                case .unknown: debugPrint("Unknown error. Please contact support")
                case .clientInvalid: debugPrint("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: debugPrint("The purchase identifier was invalid")
                case .paymentNotAllowed: debugPrint("The device is not allowed to make the payment")
                case .storeProductNotAvailable: debugPrint("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: debugPrint("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: debugPrint("Could not connect to the network")
                case .cloudServiceRevoked: debugPrint("User has revoked permission to use this cloud service")
                default: debugPrint((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Restore In App Purchas
    func restoreProduct() {
        SVProgressHUD.show(withStatus: "Restoring....")
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            SVProgressHUD.dismiss()
            if results.restoreFailedPurchases.count > 0 {
                debugPrint("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                debugPrint("Restore Success: \(results.restoredPurchases)")
                SVProgressHUD.showSuccess(withStatus: "Restore Successfully...")
            } else {
                //                displayToast("Nothing to Restore")
                SVProgressHUD.showError(withStatus: "Nothing to Restore")
            }
        }
    }
}
