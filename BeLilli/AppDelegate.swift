//
//  AppDelegate.swift
//  BeLilli
//
//  Created by apple on 31/01/23.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyStoreKit

enum ExploreType: String {
    case categoryMode
    case locationMode
    case searchMode
    case tabMode
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var selectedVC : UINavigationController?
    var tabbarHeight : Int = 66
    var homeSelectedCardIndex : Int = 0
    var navigationController : UINavigationController?
    var tabbar     : UITabBarController?
    var reach               : Reachability?
    let menuButton           = UIButton(frame: CGRect(x: 0, y: 0, width: 74, height: 74))
    
    var isHomeSearch: Bool = false
    var homeSearchText = ""
    var exploreType = ExploreType.tabMode
    var searchtxt = ""
    var categoryId = ""
    var locationId = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = .lightContent
        IQKeyboardManager.shared.enable = true
        if AppHelper.getStringForKey(ServiceKeys.user_id) != "" {
          self.setHomeView()
        }
        completeInappPurchaseTransactions()
        return true
    }

    func completeInappPurchaseTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }

    }

    func setHomeView() {

          UIView.transition(with: (appDelegate.window)!, duration: 0.5, options: .curveLinear, animations: {
                 let storyboard = UIStoryboard(name: "Home", bundle: nil)
                   let tabbar = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                   self.tabbar = tabbar
                   self.window = UIWindow(frame: UIScreen.main.bounds)
                   self.window?.rootViewController =  UINavigationController(rootViewController: tabbar)  //tabbar
                   self.window?.makeKeyAndVisible()
          }, completion: { completed in
          })
    }
    
    
    func setLogInView() {

          UIView.transition(with: (appDelegate.window)!, duration: 0.5, options: .curveLinear, animations: {
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let tabbar = storyboard.instantiateViewController(withIdentifier: "viewController") as! LoginViewController
                   self.window = UIWindow(frame: UIScreen.main.bounds)
                   self.window?.rootViewController =  UINavigationController(rootViewController: tabbar)  //tabbar
                   self.window?.makeKeyAndVisible()
          }, completion: { completed in
          })
    }
    
    
    func resetAll() {
        self.categoryId = ""
        self.locationId = ""
        self.searchtxt = ""
        self.exploreType = .tabMode
    }

}

