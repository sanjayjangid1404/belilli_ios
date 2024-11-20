//
//  SubscriptionViewController.swift
//  BeLilli
//
//  Created by apple on 25/12/21.
//

import UIKit
import SwiftyJSON

enum SubscriptionStatus: String
{
    case inactive = "0"
    case active   = "1"
}

class SubscriptionViewController: BaseViewController {
    
    @IBOutlet weak var vwPaymentBack   : UIView!
    @IBOutlet weak var vwMainPayment  : UIView!
    @IBOutlet weak var vwContainer  : UIView!

    @IBOutlet weak var lblAcive  : UILabel!
    @IBOutlet weak var lblInAcive  : UILabel!

    @IBOutlet weak var lblName2  : UILabel!
    @IBOutlet weak var lblNumber2: UILabel!
    @IBOutlet weak var lblExpiry2: UILabel!
    @IBOutlet weak var lblType2: UILabel!

    
    var objPlan : PlanDTo?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navTitle.text = "Account"
        reset()
        vwContainer.applyShadowWithCornerRadius(color: .lightGray, opacity: 0.2, radius: 8, edge: .All, shadowSpace: 8, cornerRadius: 8)
        lblAcive.isHidden = true
        lblInAcive.isHidden = true
        vwPaymentBack.isHidden = true
        vwMainPayment.isHidden = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        getSubscriptiondetail()
    }

    func reset() {
        
        lblName2.text = ""
        lblNumber2.text = ""
        lblExpiry2.text = ""
        lblType2.text = ""

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    private func isUserSubscriptionActive(subscriptionStatus: String) -> Bool {
        return subscriptionStatus == SubscriptionStatus.active.rawValue
    }
    
    func setUp() {
        
        lblName2.text = (objPlan?.first_name ?? "") + " " + (objPlan?.last_name ?? "")
        lblNumber2.text = objPlan?.email
        lblExpiry2.text = objPlan?.end_date
        lblType2.text =  "Monthly Subscription Plan"
        
        if isUserSubscriptionActive(subscriptionStatus: objPlan?.subscription_status ?? "0") {
            vwPaymentBack.isHidden = true
            vwMainPayment.isHidden = false
            vwContainer.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
            lblAcive.isHidden = false
            lblInAcive.isHidden = true
        } else {
            vwPaymentBack.isHidden = false
            vwMainPayment.isHidden = true
            vwContainer.backgroundColor = .white
            lblAcive.isHidden = true
            lblInAcive.isHidden = false
        }
    }
    
    @IBAction func btnPaymentAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSubscriptiondetail() {
        ServiceClass.sharedInstance.hitServiceForsubscriptiondetail( params: ["user_id": AppHelper.getStringForKey(ServiceKeys.user_id)], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            print_debug("response: \(parseData)")
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.objPlan = PlanDTo(fromJson:parseData["data"])
                AppHelper.setStringForKey(self.objPlan?.subscription_status, key: ServiceKeys.keySubscriptionStatus)
                self.setUp()
            } else {
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
    }
    
}

