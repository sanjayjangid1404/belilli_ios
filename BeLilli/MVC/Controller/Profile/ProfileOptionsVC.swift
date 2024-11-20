//
//  ProfileOptionsVC.swift
//  BeLilli
//
//  Created by apple on 06/11/21.
//

import UIKit
import SwiftyJSON

class ProfileOptionsVC:  BaseViewController {
    
    @IBOutlet weak var tblOption: UITableView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var objPlan : PlanDTo?

    let optionsArr  = [ ("Personal details",""),
                        ("Account",""),
                        ("Settings",""),
                        ("Privacy/terms",""),
                        ("Log out","")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "My Belilli"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tblOption.delegate = self
        tblOption.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

//        lblUserName.text =  "Hi there " + AppHelper.getStringForKey(ServiceKeys.first_name) + " " + AppHelper.getStringForKey(ServiceKeys.last_name)

//        getSubscriptiondetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getSubscriptiondetail() {
        ServiceClass.sharedInstance.hitServiceForsubscriptiondetail( params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            print_debug("response: \(parseData)")
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.objPlan = PlanDTo(fromJson:parseData["data"]["user"])
                AppHelper.setStringForKey(self.objPlan?.subscription_status, key: ServiceKeys.keySubscriptionStatus)
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
    }
    
    private func isUserSubscriptionActive(subscriptionStatus: String) -> Bool {
        return subscriptionStatus == SubscriptionStatus.active.rawValue
    }

}

extension ProfileOptionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionTableViewCell", for: indexPath) as! OptionTableViewCell
        cell.lblOption.textColor = (indexPath.row == optionsArr.count - 1) ? CustomColor.appThemeColor : .lightGray
        cell.lblOption.text = optionsArr[indexPath.row].0
        if indexPath.row == optionsArr.count-1 {
            cell.lblOption.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
            cell.lblOption.textColor = UIColor(red: 77.0/255.0, green: 64.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        }else {
            cell.lblOption.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
            cell.lblOption.textColor = UIColor(red: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "editProfileViewController") as! EditProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
            self.navigationController?.pushViewController(vc, animated: true)

        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "notificationSettingViewController") as! NotificationSettingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "webViewViewController") as! WebViewViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            
            Common.showAlert(alertMessage: txt_LogoutAlert, alertButtons: ["Yes","No"]) { btnTitle in
                btnTitle == "Yes" ? self.logoutApiCall(): nil
            }

        default:
            break
        }
    }
    
    func logoutApiCall() {
        ServiceClass.sharedInstance.hitServiceForLogout( params: ["email": AppHelper.getStringForKey(ServiceKeys.email)], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            print_debug("response: \(parseData)")
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.logout()
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
    }
    
    func shareApplication() {
        let someText:String = "Click here to download the Belilli App"
        let appUrl = "https://apps.apple.com/us/app/the-tn-card/id1601211699"
        
  //      https://itunes.apple.com/us/app/kidsmart/id1320743814?ls=1&mt=8
        let objectsToShare:URL = URL(string: appUrl)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToFlickr]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
