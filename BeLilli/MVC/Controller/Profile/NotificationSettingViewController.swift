//
//  NotificationSettingViewController.swift
//  BeLilli
//
//  Created by apple on 04/03/23.
//

import UIKit

class NotificationSettingViewController: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "Settings"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }

}
