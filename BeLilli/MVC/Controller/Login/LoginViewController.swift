//
//  LoginViewController.swift
//  ASOEBI
//
//  Created by apple on 06/05/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SwiftyJSON


class LoginViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btn_enter: UIButton!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnback: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_password.isSecureTextEntry = true
        txt_password.delegate = self
        txt_email.delegate = self
        setPlaceHolderColor(text_field:txt_email , placeholder: "Email address")
        setPlaceHolderColor(text_field: txt_password, placeholder: "Password")
        
        if self.navigationController?.viewControllers.count ?? 0 == 1 {
            btnback.isHidden = true
        }
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
    //Check Validation
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        
        if(txt_email.text!.isBlank){
            showAlert(txt_Enter_Email_Id)
            return false
        }
        if(!txt_email.text!.isEmail)
        {
            showAlert(err_valid_email)
            return false
        }
        if(txt_password.text!.isBlank){
            
           showAlert(txt_Enter_Password)
            return false
        }
        
        return  true
    }
    

    @IBAction func btn_tap_forgot_password(_ sender: Any) {
        let strybrd = UIStoryboard(name: "Main", bundle: nil)
        let vc = strybrd.instantiateViewController(withIdentifier: "forgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_tap_signUp(_ sender: Any) {
        let strybrd = UIStoryboard(name: "Main", bundle: nil)
        let vc = strybrd.instantiateViewController(withIdentifier: "signUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Login API call
    @IBAction func btn_tapped_enter(_ sender: Any) {
        appDelegate.setHomeView()
        if checkValidation() {
            let userInfo = ["email": self.txt_email.text ?? "",
                            "password" : self.txt_password.text ?? "",
                            "device_id" : AppHelper.getStringForKey(ServiceKeys.device_token),
                            "device_type" : DeviceType.iOS.rawValue]
            
            ServiceClass.sharedInstance.hitServiceForEmailLogin(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                print_debug("response: \(parseData)")
                
                
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                    
                    let user = User(fromJson:parseData)
                    print(user)
                    AppHelper.setStringForKey(user.last_name!, key: ServiceKeys.last_name)
                    AppHelper.setStringForKey(user.first_name!, key: ServiceKeys.first_name)
                    AppHelper.setStringForKey(user.email, key: ServiceKeys.email)
                    AppHelper.setStringForKey(user.phone_no, key: ServiceKeys.phone_no)
                    AppHelper.setStringForKey(user.hash, key: ServiceKeys.token)
                    AppHelper.setStringForKey(user.profile_photo, key: ServiceKeys.profile_image)
                    AppHelper.setStringForKey(user.id, key: ServiceKeys.user_id)
                    
                    AppHelper.setStringForKey(user.postcode, key: ServiceKeys.postal)
                    AppHelper.setStringForKey(user.town, key: ServiceKeys.town)
                    AppHelper.setStringForKey(user.title, key: ServiceKeys.title)
                    AppHelper.setStringForKey(user.address_line_one, key: ServiceKeys.address1)
                    AppHelper.setStringForKey(user.address_line_two, key: ServiceKeys.address2)
                    AppHelper.setStringForKey(user.dob, key: ServiceKeys.dob)
                    
                    appDelegate.setHomeView()
                } else {
              
                    self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                }
            })
        }
    }
}

