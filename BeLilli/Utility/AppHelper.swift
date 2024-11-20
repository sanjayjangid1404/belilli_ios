//
//  AppHelper.swift
//  Panther
//
//  Created by Manish Jangid on 7/27/17.
//  Copyright © 2017 Manish Jangid. All rights reserved.
//

import Foundation
import  UIKit

var activityIndicator:UIActivityIndicatorView?

class AppHelper: NSObject, UIAlertViewDelegate{
    
    var loadingView: UIView!
    
    // save to user default
    class func setStringForKey (_ value: String? , key: String!) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key! as String)
        defaults.synchronize()
    }
    // get from user default
    class func getStringForKey ( _ key: String?) -> String {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key! as String)
        if (value != nil) {
            return value!
        }
        return ""
    }
    
    // save to user default
    class func setBoolForKey (_ value: Bool? , key: String!) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key! as String)
        defaults.synchronize()
    }
    // get from user default
    class func getBoolForKey ( _ key: String?) -> Bool{
        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: key! as String)
        return value
    }
    
    // save to user default
    class func setValueForKey (_ value: AnyObject? , key: String!) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key! as String)
        defaults.synchronize()
    }
    // get from user default
    class func getValueForKey ( _ key: String?) -> AnyObject?{
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key! as String)
        if (value != nil) {
            return value! as AnyObject
        }
        return nil
    }
    
    
    // remove from user default
    class  func removeFromUserDefaultForKey(_ key: String!) {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key! as String)
        if (value != nil) {
            defaults.removeObject(forKey: key! as String)
        }
        defaults.synchronize()
        
    }
    
    class func getFont(_ size : CGFloat) -> UIFont {
        return UIFont(name: "Varela Round", size: size)!
    }
   
    //MARK: AlertView
    class func showALertWithTag(_ tag:Int, title:String, message:String?,delegate:AnyObject!, cancelButtonTitle:String?, otherButtonTitle:String?)
    {
        let alert = UIAlertView()
        
        alert.tag = tag
        alert.title = title
        alert.message = message
        alert.delegate = delegate
        if (cancelButtonTitle != nil)
        {
            alert.addButton(withTitle: cancelButtonTitle!)
        }
        if (otherButtonTitle != nil)
        {
            alert.addButton(withTitle: otherButtonTitle!)
        }
        
        alert.show()
        
    }
    
    //MARK:- Add Delay
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
   
    
   
    
}
