//
//  FirstScreenViewController.swift
//  BeLilli
//
//  Created by apple on 09/10/21.
//

import UIKit

class FirstScreenViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.backButton.isHidden = true
    }
    

    @IBAction func btn_tap_SignIn(_ sender: Any) {
        let strybrd = UIStoryboard(name: "Main", bundle: nil)
        let vc = strybrd.instantiateViewController(withIdentifier: "viewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btn_tap_signUp(_ sender: Any) {
        let strybrd = UIStoryboard(name: "Main", bundle: nil)
        let vc = strybrd.instantiateViewController(withIdentifier: "signUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
