//
//  AccountViewController.swift
//  BeLilli
//
//  Created by apple on 14/05/23.
//

import UIKit
import SafariServices


class AccountViewController: BaseViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var revalidateButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var planDateLabel: UILabel!
    
    @IBOutlet weak var subscriptionPlantextLabel: UILabel!
    @IBOutlet weak var subscribedView: UIView!
    @IBOutlet weak var detailedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = "Subscription Plan"
        
        // Do any additional setup after loading the view.
        textLabel.text = "Your current subscription: @%"
        setViewsAccordingToPlan(isSubScribePlan: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setViewsAccordingToPlan(isSubScribePlan: Bool) {
        if isSubScribePlan {
            detailedView.isHidden = true
            subscribedView.isHidden = false
        } else {
            detailedView.isHidden = false
            subscribedView.isHidden = true
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func privacyPolicyButtonAction(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.thetncard.com/privacy-policy/")!)
        //present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func termsAndConditionButtonAction(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.thetncard.com/terms-and-conditions/")!)
        //present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func revalidateButtonAction(_ sender: UIButton) {
        performRestoreSubscription(planID: "1", planType: "Monthly")
    }
    
    @IBAction func subscribeButtonAction(_ sender: UIButton) {
        performAutoRenewableSubscription(planID: "1", planType: "Monthly")
    }
    
    private func performAutoRenewableSubscription(planID: String, planType: String) {
        let inappPlanId = monthlySubscriptionPlanId
        
        hudShow()
        TNInAppPurchaseHandler.sharedInstance.purchaseSubscriptionPlan(planId: planID, planIdentifier: inappPlanId, promoCode: nil)  { (result, error) in
            DispatchQueue.main.async {
                self.hudHide()
                if result != nil {
                    Common.showAlert(alertMessage: "Subscription Added", alertButtons: ["Ok"]) { btn in
                        
                    }
                    
                } else {
                    Common.showAlert(alertMessage: error?.localizedDescription ?? "Error in inapp purchase, Please try again later", alertButtons: ["Ok"]) { btn in
                    }
                }
            }
        }
    }
    
    private func performRestoreSubscription(planID: String, planType: String) {
        let inappPlanId = monthlySubscriptionPlanId
        
        hudShow()
        TNInAppPurchaseHandler.sharedInstance.restoreSubscriptionPlans(planId: planID, planIdentifier: inappPlanId, promoCode: nil)  { (result, error) in
            DispatchQueue.main.async {
                self.hudHide()
                if result != nil {
                    Common.showAlert(alertMessage: "Subscription Added", alertButtons: ["Ok"]) { btn in
                        
                    }
                    
                } else {
                    Common.showAlert(alertMessage: error?.localizedDescription ?? "Error in inapp purchase, Please try again later", alertButtons: ["Ok"]) { btn in
                    }
                }
            }
        }
    }
    
}
