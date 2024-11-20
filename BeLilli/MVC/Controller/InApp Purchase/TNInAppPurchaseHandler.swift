//
//  TNInAppPurchaseHandler.swift
//  BeLilli
//
//  Created by apple on 22/12/21.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import SwiftyJSON

// testbelilli@gmail.com    Test@123
// test_belilli@gmail.com    Sandbox@2023

let sharedScreat: String = "3917c789ba3c49e7a71df255b72532a5"
let monthlySubscriptionPlanId: String = "com.belilli.monthlysubscription"
let yearlySubscriptionPlanId: String = "com.belilli.yearlysubscription"

enum PlanType: String {
    case monthly = "monthly"
    case yearly  = "annual"
    case yearlyCard = "annual + card"
}

enum DeviceType: String {
    case android = "android"
    case iOS = "ios"
}

class TNInAppPurchaseHandler: NSObject {
    
    static let sharedInstance = TNInAppPurchaseHandler()
    var plan_id = "3"
        
    func handleInAppPurchase() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                        let receiptData = SwiftyStoreKit.localReceiptData
                        if let receiptString = receiptData?.base64EncodedString(options: []) {
                            // Verify Receipt and save to server
                            if purchase.transaction.transactionIdentifier == monthlySubscriptionPlanId{
                                self.plan_id = "1"
                            } else if purchase.transaction.transactionIdentifier == yearlySubscriptionPlanId{
                                self.plan_id = "2"
                            }
                            DispatchQueue.main.async {
                                self.verifyReceiptFromServer(receipt: receiptString, userId: AppHelper.getStringForKey(ServiceKeys.user_id), isRestore: false, completion: nil)
                            }

                        }
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    print("Store Kit issue")
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    func purchaseSubscriptionPlan(planId: String, planIdentifier:String, promoCode:String?, completion:((_ result:VerificationPlan?, _ error:SKError?) -> Void)?) {
        self.plan_id = planId
        SwiftyStoreKit.purchaseProduct(planIdentifier, atomically: true) { result in
            switch result {
            case .success(let purchase):
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                let receiptData = SwiftyStoreKit.localReceiptData
                if let receiptString = receiptData?.base64EncodedString(options: []) {
                    self.verifyReceiptFromServer(receipt: receiptString, userId: AppHelper.getStringForKey(ServiceKeys.user_id), isRestore: false, completion: { (status, result) in
                        if status {
                            completion?(result,nil)
                        } else {
                            let error = SKError.init(_nsError: NSError.init(domain: "Validation failed from the server, Please try again later", code: 500, userInfo: nil))
                            completion?(nil, error)
                        }
                    })
                } else {
                    let error = SKError.init(_nsError: NSError.init(domain: "Receipt not found, Please try again later", code: 500, userInfo: nil))
                    completion?(nil,error)
                }
            case .error(let error):
                print(error.localizedDescription)
                completion?(nil,error)
            }
        }
    }
    
    func restoreSubscriptionPlans(planId: String, planIdentifier:String, promoCode:String?, completion: @escaping((_ result:VerificationPlan?, _ error:SKError?) -> Void)) {
        self.plan_id = planId
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                let error = SKError.init(_nsError: NSError.init(domain: "Restore Failed as not found any subscription", code: 500, userInfo: nil))
                
                completion(nil,error)
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.productId == planIdentifier {//if purchase.needsFinishTransaction {
                        //SwiftyStoreKit.finishTransaction(purchase.transaction)
                        
                        let receiptData = SwiftyStoreKit.localReceiptData
                        if let receiptString = receiptData?.base64EncodedString(options: []) {
                            self.verifyReceiptFromServer(receipt: receiptString, userId: AppHelper.getStringForKey(ServiceKeys.user_id), isRestore: true, promoCode: promoCode, completion: { (status, result) in
                                if status {
                                    completion(result,nil)
                                } else {
                                    let error = SKError.init(_nsError: NSError.init(domain: "Validation failed from the server, Please try again later", code: 500, userInfo: nil))
                                    completion(nil, error)
                                }
                            })
                        } else {
                            let error = SKError.init(_nsError: NSError.init(domain: "Receipt not found, Please try again later", code: 500, userInfo: nil))
                            completion(nil,error)
                        }
                        break
                    }
                }
            }else {
                let error = SKError.init(_nsError: NSError.init(domain: "Not found any subscrption", code: 500, userInfo: nil))
                completion(nil,error)
            }
        }
    }
    
    func verifyReceipt(planIdentifier:String, environment:AppleReceiptValidator.VerifyReceiptURLType, completion: ((_ result:VerifySubscriptionResult?, _ error:ReceiptError?) -> Void)?) {
        verifyReceipt(environment: environment) { (result) in
            switch result {
            case .success(let receipt):
                let productIds: Set = [planIdentifier]
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                completion?(purchaseResult,nil)
            case .error(let error):
                completion?(nil,error)
            }
        }
    }
    
    private func verifyReceipt(environment: AppleReceiptValidator.VerifyReceiptURLType ,completion:@escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedScreat)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func getSubscriptionPlanInfo(planIdentifier:String, completion: ((_ result:RetrieveResults?) -> Void)?) {
        SwiftyStoreKit.retrieveProductsInfo([planIdentifier]) { result in
            print("In-App product: \(result)")
            completion?(result)
        }
    }
    
    func fetchReceipt(completion: ((_ result:String?, _ error:ReceiptError?) -> Void)?) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
                completion?(encryptedReceipt,nil)
            case .error(let error):
                print("Fetch receipt failed: \(error)")
                completion?(nil,error)
            }
        }
    }
    
    func verifyReceiptFromServer(receipt: String, userId: String, isRestore: Bool, promoCode: String? = nil , completion: ((_ status: Bool, _ data: VerificationPlan?) -> Void)?) {
        
        guard !userId.isEmpty else {
            return
        }
        
        var params = [String:Any]()
        params["user_id"] = userId
        //params["plan_id"] = plan_id
        params["payment_method"] = DeviceType.iOS.rawValue
        params["payment_status"] = "paid"
        params["receipt"] = receipt
        //params["isrestore"] = isRestore
        params["payment_date"]   = Utilities.convertToString(date:Date(),formatOut:DateFormat_dd_amm_yyyy)
        params["app_password"] = sharedScreat
        
        ServiceClass.sharedInstance.hitServiceForupdatesubscription( params: params, completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            print_debug("response: \(parseData)")
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                let verificationPlan = VerificationPlan(error: "Success", success: true)
                //appDelegate.setHomeView()
                completion?(true,verificationPlan )
            } else {
                let verificationPlan = VerificationPlan(error: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, success: false)
                completion?(false,verificationPlan)
//                Common.showAlert(alertMessage: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, alertButtons: ["Ok"]) { btn in
//                }
            }
        })
    }
}

class VerificationPlan {
    var error: String = ""
    var success: Bool = false
    
    init(error: String, success: Bool) {
        self.error = error
        self.success = success
    }
}
