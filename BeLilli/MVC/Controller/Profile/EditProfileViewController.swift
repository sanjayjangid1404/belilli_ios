//
//  EditProfileViewController.swift
//  BeLilli
//
//  Created by apple on 03/11/21.
//

import UIKit

class EditProfileViewController: BaseViewController {
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "My details"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        txtFirstName.delegate = self

        txtEmail.delegate = self
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtEmail.isUserInteractionEnabled = false
        
        setPlaceHolderColor(text_field:txtFirstName , placeholder: "First name")
        setPlaceHolderColor(text_field:txtLastName , placeholder: "Last name")
        setPlaceHolderColor(text_field: txtEmail, placeholder: "Email address")
        setPlaceHolderColor(text_field:txtNewPassword , placeholder: "New Password")
        setPlaceHolderColor(text_field: txtConfirmPassword, placeholder: "Confirm password")
        
        txtNewPassword.isSecureTextEntry = true
        txtConfirmPassword.isSecureTextEntry = true
        setValues()
    }
    
    func setValues() {
        txtFirstName.text = AppHelper.getStringForKey(ServiceKeys.first_name)
        txtLastName.text = AppHelper.getStringForKey(ServiceKeys.last_name)
        txtEmail.text =  AppHelper.getStringForKey(ServiceKeys.email)
     
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func checkValidationForPassword() -> Bool {
        self.view.endEditing(true)
        if(txtNewPassword.text!.isBlank){
            showAlert(txt_Enter_new_Password)
            return false
        } else if(txtNewPassword.text!.count < 6 ){
            showAlert(txt_Password_length)
            return false
        } else if(txtConfirmPassword.text!.isBlank){
            showAlert(txt_Enter_ConfrimPassword)
            return false
        } else if(txtNewPassword.text != txtConfirmPassword.text){
            showAlert(txt_Password_equal)
            return false
        }
        
        return  true
    }
    
    private func checkValidationForProfile() -> Bool {
        self.view.endEditing(true)
        if txtFirstName.text?.trimmingCharacters(in: .whitespaces).count == 0 {
             showAlert(txt_Enter_first_Name)
             return false
         } else  if (txtFirstName.text?.count)! < 3 {
             showAlert(txt_Enter_first_Name_count)
             return false
         }
         else if (txtLastName.text?.isBlank)! {
             showAlert(txt_Enter_l_Name)
             return false
         }else if (txtLastName.text?.count)! < 3 {
             showAlert(txt_Enter_lastt_Name_count)
             return false
         }
         return true
         
    }

    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if checkValidationForPassword() {
            changePasswordAPICall()
        }
    }
    
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        if checkValidationForProfile() {
            submitAPICall()
        }
    }
        
    func changePasswordAPICall() {
        var params = [String:Any]()
        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
        params["new_password"] = txtNewPassword.text

        ServiceClass.sharedInstance.hitServiceForResetNewPassword(params) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                                
                Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { btn in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
            
        }
    }
    
    func submitAPICall() {
        var params = [String:Any]()
        params["user_id"] = AppHelper.getStringForKey(ServiceKeys.user_id)
        params["first_name"] = txtFirstName.text
        params["last_name"] = txtLastName.text

        ServiceClass.sharedInstance.hitServiceForEditProfile(params: params) { type, parseData, errorDict in
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                let user = User(fromJson:parseData)
                AppHelper.setStringForKey(user.last_name!, key: ServiceKeys.last_name)
                AppHelper.setStringForKey(user.first_name!, key: ServiceKeys.first_name)
                Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { btn in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
            
        }
    }
 
}


extension EditProfileViewController : UITextFieldDelegate {
 
    // MARK: - Text Field Methods
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          switch textField {
          case txtFirstName:
              _ = txtNewPassword.becomeFirstResponder()
          case txtLastName:
              _ = txtNewPassword.becomeFirstResponder()
          case txtNewPassword:
              _ = txtConfirmPassword.becomeFirstResponder()
          default:
            textField.resignFirstResponder()
        }
          return true
      }

}

