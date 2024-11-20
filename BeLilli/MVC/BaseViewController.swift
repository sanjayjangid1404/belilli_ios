//
//  BaseViewController.swift
//  pikopako
//
//  Created by Ajay Vyas on 5/14/18.
//  Copyright © 2018 XtreemSolution. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Toast
import SwiftyJSON
import Kingfisher



class BaseViewController: UIViewController {
    
    
    var backButton = UIButton()
    var imageButtom = UIImageView()
    var rightView = UIView()
    var slideButton = UIButton()
    var slideImage = UIImageView()
    var navTitle: UILabel!
    var backgroundImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = CustomColor.appThemeColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            navigationBarAppearance.backgroundColor = CustomColor.appThemeColor
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 32))
        backButton.backgroundColor = .clear
        let widthConstraint = backButton.widthAnchor.constraint(equalToConstant: 60)
        let heightConstraint = backButton.heightAnchor.constraint(equalToConstant: 32)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        navTitle = UILabel()
        navTitle.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        navTitle.frame = CGRect(x: 0, y: 0, width:self.view.frame.width/2 + 30, height: 44)
        navTitle.numberOfLines = 2
        navTitle.textAlignment = NSTextAlignment.center
        navTitle.text = ""
        navTitle.textColor = UIColor.white
        navTitle.backgroundColor = .clear
        navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        //        navTitle.center = (self.navigationItem.titleView?.center)!
        
        imageButtom = UIImageView(frame:CGRect(x: 0 , y: 0 , width: 30, height: 30))
        
        let closeImage = UIImage(named:"back")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageButtom.tintColor = UIColor.white
        imageButtom.image = closeImage
        
        let widthConstraint1 = imageButtom.widthAnchor.constraint(equalToConstant: 30)
        let heightConstraint1 = imageButtom.heightAnchor.constraint(equalToConstant:30)
        heightConstraint1.isActive = true
        widthConstraint1.isActive = true
        
        backButton.addSubview(imageButtom)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        backButton.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.isHidden     = true
        backgroundImage.layer.zPosition = -1
        backgroundImage.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(backgroundImage)
        
//        appDelegate.selectedVC = self.navigationController

        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    @objc func notificationButtonClicked(_ sender: UIButton) {
        //        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        //   let vc = storyboard.instantiateViewController(withIdentifier: "notificationViewController") as! NotificationViewController
        //   self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setPlaceHolderColor(text_field : UITextField,placeholder : String,name: String = "") {
        
        text_field.setLeftPaddingPoints(10)
        
        text_field.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "454545")])
        text_field.setRightPaddingPoints(10)
        if name != "" {
            text_field.setLeftPaddingPoints(5)
            Utilities.setleftViewIcon(name: name, field: text_field)
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let dict = notification.object as! NSDictionary? {
            if let index = dict["index"] as? Int{
                if index == 0 {
                    self.tabBarController?.selectedIndex = 2
                }
                else if index == 1 {
                    self.tabBarController?.selectedIndex = 4
                }
                else if index == 2 {
                    self.tabBarController?.selectedIndex = 2
                    //                    let storyboard = UIStoryboard(name: "Common", bundle: nil)
                    //                    let vc = storyboard.instantiateViewController(withIdentifier: "tabBarViewController") as! TabBarViewController
                    //                    vc.selectedIndex = 2
                    //                    appDelegate.window?.rootViewController = vc
                    //                    appDelegate.window?.makeKeyAndVisible()
                    AppHelper.delay(0.5) {
                        
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier1"), object: index)
                    }
                    
                }
                    
                else if index == 3 {
                    self.tabBarController?.selectedIndex = 1
                }
                else if index == 4 {
                    //                    self.tabBarController?.selectedIndex = 2
                    //                    let storyboard = UIStoryboard(name: "Common", bundle: nil)
                    //                    let vc = storyboard.instantiateViewController(withIdentifier: "tabBarViewController") as! TabBarViewController
                    //                    vc.selectedIndex = 2
                    //                    appDelegate.window?.rootViewController = vc
                    //                    appDelegate.window?.makeKeyAndVisible()
                    //                    AppHelper.delay(0.5) {
                    //
                    //                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier1"), object: index)
                    //                    }
                }
                else if index == 5 {
                    //                    self.tabBarController?.selectedIndex = 2
                    //                    let storyboard = UIStoryboard(name: "Common", bundle: nil)
                    //                    let vc = storyboard.instantiateViewController(withIdentifier: "tabBarViewController") as! TabBarViewController
                    //                    vc.selectedIndex = 2
                    //                    appDelegate.window?.rootViewController = vc
                    //                    appDelegate.window?.makeKeyAndVisible()
                    //                    AppHelper.delay(0.5) {
                    //
                    //                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier1"), object: index)
                    //                    }
                }
            }
        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.view.endEditing(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAlert(_ msge: String) {
        Common.showAlert(alertMessage: msge, alertButtons: ["Ok"]) { btn in
        }
    }
    
    
    // register scroll view
    
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    func makeToast(_ txt: String){
        self.view.hideToast()
        self.view.makeToast(txt, duration: 1.5, position: "CSToastPositionCenter")
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Remove observer for keybord Show/Hide
        
        
        self.view.endEditing(true)
    }
    

    
    //hud show and hide
    
    func hudShow()  {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hudHide()  {
        SVProgressHUD.dismiss()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }

    
    func transparentNavigationController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func hideNavigationController() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "img_bottomBackground"),for: .default)
        
        self.navigationController?.navigationBar.barTintColor  = CustomColor.nav_color
    }
    
    func showNavigationWithColor() {
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = CustomColor.blackThemeColor
    }
    
    func setTitle(title:String) {
        self.title = title
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 14)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColor.pageTitleColor]
    }
    
    func addShadowToBar() {
        let shadowView = UIView(frame: self.navigationController!.navigationBar.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.4 // your opacity
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2) // your offset
        shadowView.layer.shadowRadius =  4 //your radius
        self.view.addSubview(shadowView)
    }
    
    
    func removeAllData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    func logout(){
        let device_token = AppHelper.getStringForKey(ServiceKeys.device_token)
       
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let _ = appDelegate.window {
            AppHelper.setStringForKey(device_token, key: ServiceKeys.device_token)
            appDelegate.setLogInView()
        }
    }
    
    
    
    
}

