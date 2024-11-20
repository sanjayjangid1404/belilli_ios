//
//  ForgotPasswordViewController.swift
//  ASOEBI
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForgotPasswordViewController: BaseViewController {
    
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlaceHolderColor(text_field:txt_email , placeholder: "Enter your email address")
        setCorner()
    }
    
    private func setCorner() {
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 20
        emailView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        emailView.isHidden = true
    }
    
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
        return  true
    }
    
    @IBAction func btn_ResendEmailAction(_ sender: Any) {
        forgotPasswordAPICall()
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_tap_submit(_ sender: Any) {
        forgotPasswordAPICall()
    }
    
    private func forgotPasswordAPICall() {
        if checkValidation() {
            let userInfo = ["email": self.txt_email.text ?? ""]
            
            ServiceClass.sharedInstance.hitServiceForForgotPassword(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                print_debug("response: \(parseData)")
                
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                    
                        self.emailDescriptionLabel.text =  "An email has been sent to \(self.txt_email.text ?? "") Check your inbox and spam folder, and click the reset link and you’re all set"
                        self.emailView.isHidden = false
                        self.mainView.isHidden = true
                    
                } else {
                    self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                }
            })
        }
    }
    
}
