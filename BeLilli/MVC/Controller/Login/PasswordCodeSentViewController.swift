//
//  PasswordCodeSentViewController.swift
//  ASOEBI
//
//  Created by My mac on 23/06/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class PasswordCodeSentViewController: BaseViewController {
    
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var lblText: UILabel!
    var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lblText.text =  "An email has been sent to \n \(email)"
    }
    
    
    
    
    //MARK:- Sign in Clicked
    
    @IBAction func btnSignClicked(_ sender: UIButton) {
    
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self ) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




