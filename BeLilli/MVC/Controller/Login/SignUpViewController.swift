//
//  SignUpViewController.swift
//
//
//  Created by apple on 08/05/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: BaseViewController {
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_last_name: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    @IBOutlet weak var mainView: UIView!
   

    @IBOutlet weak var create_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlaceHolderColor(text_field:txt_email , placeholder: "Email address")
        setPlaceHolderColor(text_field: txt_password, placeholder: "Password")
        setPlaceHolderColor(text_field:txt_name , placeholder: "First name")
        setPlaceHolderColor(text_field: txt_last_name, placeholder: "Last name")
        setPlaceHolderColor(text_field: txt_ConfirmPassword, placeholder: "Reconfirm password")

        txt_password.isSecureTextEntry = true
        txt_ConfirmPassword.isSecureTextEntry = true

        txt_email.delegate = self
        txt_password.delegate = self
        txt_name.delegate = self
        txt_last_name.delegate = self
        txt_ConfirmPassword.delegate = self

       
        //transparentNavigationController()
        self.imageButtom.isHidden = true
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively

    }
    
    

    //Check Validation
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        
        if txt_name.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            showAlert(txt_Enter_first_Name)
            return false
        } else  if (txt_name.text?.count)! < 3 {
            showAlert(txt_Enter_first_Name_count)
            return false
        } else if (txt_last_name.text?.isBlank)! {
            showAlert(txt_Enter_l_Name)
            return false
        }else if (txt_name.text?.count)! < 3 {
            showAlert(txt_Enter_lastt_Name_count)
            return false
        } else if(txt_email.text!.isBlank){
            showAlert(txt_Enter_Email_Id)
            return false
        } else if(!txt_email.text!.isEmail) {
            showAlert(err_valid_email)
          return false
        } else if(txt_password.text!.isBlank){
            showAlert(txt_Enter_Password)
            return false
        } else if(txt_password.text!.count < 6 ){
            showAlert(txt_Password_length)
            return false
        } else if(txt_ConfirmPassword.text!.isBlank){
            showAlert(txt_Enter_ConfrimPassword)
            return false
        } else if(txt_password.text != txt_ConfirmPassword.text){
            showAlert(txt_Password_equal)
            return false
        }

        
        return  true
    }
 
    @IBAction func btn_tap_payment(_ sender: Any) {
//        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "planListVC") as! PlanListVC
//        vc.isFromSignup = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btn_tap_sign_in(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_tap_reset_password(_ sender: Any) {
        let strybrd = UIStoryboard(name: "Main", bundle: nil)
        let vc = strybrd.instantiateViewController(withIdentifier: "forgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_tap_create_account(_ sender: Any) {
        if checkValidation() {
    
            var userInfo = [String : Any]()
            userInfo["first_name"] =  self.txt_name.text
            userInfo["last_name"] =  self.txt_last_name.text
            userInfo["password" ] = self.txt_password.text
            userInfo["email"] =  self.txt_email.text
            userInfo["device_id"] =  AppHelper.getStringForKey(ServiceKeys.device_token)
            userInfo["device_type"] =  DeviceType.iOS.rawValue

            ServiceClass.sharedInstance.hitServiceForRegister(userInfo , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                    print_debug("response: \(parseData)")
                    if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                        let user = User(fromJson:parseData)
                        AppHelper.setStringForKey(user.last_name!, key: ServiceKeys.last_name)
                        AppHelper.setStringForKey(user.first_name!, key: ServiceKeys.first_name)
                        AppHelper.setStringForKey(user.email, key: ServiceKeys.email)
                        AppHelper.setStringForKey(user.id, key: ServiceKeys.user_id)
                        
//                        AppHelper.setStringForKey(user.postcode, key: ServiceKeys.postal)
//                        AppHelper.setStringForKey(user.town, key: ServiceKeys.town)
//                        AppHelper.setStringForKey(user.title, key: ServiceKeys.title)
//                        AppHelper.setStringForKey(user.address_line_one, key: ServiceKeys.address1)
//                        AppHelper.setStringForKey(user.address_line_two, key: ServiceKeys.address2)
//                        AppHelper.setStringForKey(user.county, key: ServiceKeys.county)
//                        AppHelper.setStringForKey(user.dob, key: ServiceKeys.dob)
//                        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "planListVC") as! PlanListVC
//                        vc.isFromSignup = true
//                        self.navigationController?.pushViewController(vc, animated: true)
                        appDelegate.setHomeView()
                    } else {
                        // AppHelper.showALertWithTag(0, title: txt_AppName, message:errorDict?[ServiceKeys.keyErrorMessage] as? String , delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                        self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                    }
                })
            
        }
    }

}


extension SignUpViewController : UITextFieldDelegate {
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txt_name:
            _ = txt_last_name.becomeFirstResponder()
        case txt_last_name:
            _ = txt_email.becomeFirstResponder()
        case txt_email:
            _ = txt_password.becomeFirstResponder()
        case txt_password:
            _ = txt_ConfirmPassword.becomeFirstResponder()
        default:
          textField.resignFirstResponder()
      }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_name ||  textField == txt_last_name {
            let maxLength = 50
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return (newString.length <= maxLength) && string.canBeConverted(to: .ascii)
        }
        return string.canBeConverted(to: .ascii)
    }
    
    
}
