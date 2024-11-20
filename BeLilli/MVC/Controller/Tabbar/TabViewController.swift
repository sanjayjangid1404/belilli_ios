//
//  TabViewController.swift
//  Maxillofacia
//
//  Created by apple on 06/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


class TabViewController:
    UITabBarController,
    UITabBarControllerDelegate {

    let customTabBarView: UIView = {

        let view = UIView(frame: .zero)

        view.backgroundColor = .white
        view.layer.cornerRadius = 0
        view.layer.maskedCorners = []
        view.clipsToBounds = true

        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2.0)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 5.0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
       
        addCustomTabBarView()
        hideTabBarBorder()
        setupTabBar()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBarView.frame = tabBar.frame
    }

    override func viewDidAppear(_ animated: Bool) {
//        var newSafeArea = UIEdgeInsets()
//        newSafeArea.bottom += customTabBarView.bounds.size.height
//        self.children.forEach({$0.additionalSafeAreaInsets = newSafeArea})
    }

    private func addCustomTabBarView() {
        customTabBarView.frame = tabBar.frame
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(self.tabBar)
    }

    func hideTabBarBorder()  {
        let tabBar = self.tabBar
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
    }

    func setupTabBar() {
        let storyboard1 = UIStoryboard(name: "Home", bundle: nil)
        let storyboard2 = UIStoryboard(name: "Fav", bundle: nil)
        let storyboard3 = UIStoryboard(name: "Scanner", bundle: nil)
        let storyboard4 = UIStoryboard(name: "Activity", bundle: nil)
        
        
        
       let vc1 = (storyboard1.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController)
       
        let vc4 = (storyboard4.instantiateViewController(withIdentifier: "activityViewController") as! ActivityViewController)
        let vc2 = storyboard2.instantiateViewController(withIdentifier: "favoriteViewController") as! FavoriteViewController
        let vc3 = storyboard3.instantiateViewController(withIdentifier: "qRScannerViewController") as! QRScannerViewController
        
         let nv1 = UINavigationController(rootViewController: vc1)
         let nv2 = UINavigationController(rootViewController: vc2)
         let nv3 = UINavigationController(rootViewController: vc3)
         let nv4 = UINavigationController(rootViewController: vc4)

        nv1.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home_unselected"), selectedImage: UIImage(named: "home_selected"))
        nv2.tabBarItem = UITabBarItem.init(title: "Favourites", image: UIImage(named: "favourite_unselected"), selectedImage: UIImage(named: "favourite_selected"))
        nv4.tabBarItem = UITabBarItem.init(title: "Activity", image: UIImage(named: "activity_selected"), selectedImage: UIImage(named: "activity_selected"))
        nv3.tabBarItem = UITabBarItem.init(title: "Redeem", image: UIImage(named: "barcode_unselected"), selectedImage: UIImage(named: "barcode_selected"))
        
        self.setViewControllers([nv1, nv2, nv3, nv4], animated: false)
        UITabBar.appearance().tintColor = CustomColor.appTabBarTintColor
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 12)!], for: .selected)
        self.viewDidLayoutSubviews()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if item.title == "Explore" {
//            appDelegate.resetAll()
//        }
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
