//
//  PlanListVC.swift
//  BeLilli
//
//  Created by apple on 06/11/21.
//

import UIKit
import SwiftyJSON
import SafariServices

class PlanListVC: BaseViewController {
    @IBOutlet weak var tblplan: UITableView!
    var planList =  [PlanDTo]()
    var isFromSignup: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tblplan.delegate = self
        tblplan.dataSource = self
        self.navTitle.text = "Plans"
        if self.isFromSignup {
            addRightBarButton()
        }
    }
    
    func addRightBarButton() {
        let rubricButton  = UIButton(type: UIButton.ButtonType.system)
        rubricButton.frame = CGRect(x: 0, y: 0, width: 90, height: 32)
        rubricButton.backgroundColor = UIColor.clear
        rubricButton.layer.cornerRadius = 16
        rubricButton.setTitle("Skip", for: .normal)
        rubricButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16.0)!
        rubricButton.setTitleColor(.white, for: .normal)
        rubricButton.addTarget(self, action: #selector(btnSkipAction), for: .touchUpInside)
        let rubricBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: rubricButton)
        self.navigationItem.setRightBarButtonItems([rubricBarButtonItem], animated: false)
    }

    @objc func btnSkipAction(_ sender: UIBarButtonItem) {
        appDelegate.setHomeView()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAllPlans()
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

extension PlanListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == planList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "planListStaticTableViewCell", for: indexPath) as! PlanListStaticTableViewCell
            cell.backgroundColor = .white
            cell.btnPrivacyPolicy.addTarget(self, action: #selector(btnPrivacyPolicyTapped(_:)), for: .touchUpInside)
            cell.btnTermsCondition.addTarget(self, action: #selector(btnTNCTapped(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "planListTableViewCell", for: indexPath) as! PlanListTableViewCell
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .white
                cell.lblPrice.textColor = .darkGray
                cell.lblDescription.textColor = .darkGray
                cell.lblTopText.textColor = .darkGray
                cell.lblpriceSign.textColor = .darkGray
                cell.btnSubscribe.setTitleColor(.darkGray, for: .normal)
                cell.btnSubscribe.borderColor1 = .gray
                cell.btnRestore.setTitleColor(.darkGray, for: .normal)
                cell.btnRestore.borderColor1 = .gray
                cell.lblRestoreDescription.textColor = .gray
            } else {
                cell.backgroundColor = CustomColor.appThemeColor
                cell.lblPrice.textColor = .white
                cell.lblDescription.textColor = .white
                cell.lblTopText.textColor = .white
                cell.lblpriceSign.textColor = .white
                cell.btnSubscribe.setTitleColor(.white, for: .normal)
                cell.btnSubscribe.borderColor1 = .white
                cell.btnRestore.setTitleColor(.white, for: .normal)
                cell.btnRestore.borderColor1 = .white
                cell.lblRestoreDescription.textColor = .white
            }
            cell.backgroundColor = indexPath.row % 2 == 0 ? .white : CustomColor.appThemeColor
            let obj = planList[indexPath.row]
            cell.lblPrice.text = obj.plan_cost
            cell.lblDescription.text = obj.description.html2String
            cell.lblTopText.text = obj.plan_type.uppercased()
            cell.lblpriceSign.text = "£"
            cell.btnSubscribe.addTarget(self, action: #selector(btnSubscribeAction), for: .touchUpInside)
            cell.btnSubscribe.tag = indexPath.row
            cell.btnRestore.addTarget(self, action: #selector(btnRestoreAction), for: .touchUpInside)
            cell.btnRestore.tag = indexPath.row

            if isMothlyPlan(planType: obj.plan_type) {
                cell.btnSubscribe.setTitle("Select monthly plan", for: .normal)
                cell.btnRestore.setTitle("Revalidate your subscription", for: .normal)
            } else if isYearlyPlan(planID: obj.plan_id ?? "0", planType: obj.plan_type) {
                cell.btnSubscribe.setTitle("Select annual plan", for: .normal)
                cell.btnRestore.setTitle("Revalidate your subscription", for: .normal)
            } else {
                cell.btnSubscribe.setTitle("Select annual plan", for: .normal)
                cell.btnRestore.setTitle("Revalidate your subscription", for: .normal)
            }
            return cell

        }
    }
    
    @objc func btnSubscribeAction(_ btn: UIButton) {
     
        let planobj = planList[btn.tag]
        performAutoRenewableSubscription(planID: planobj.id ?? "1", planType: planobj.plan_type)
    }
    
    @objc func btnRestoreAction(_ btn: UIButton) {
     
        let planobj = planList[btn.tag]
        performRestoreSubscription(planID: planobj.id ?? "1", planType: planobj.plan_type)
    }

    
    private func isMothlyPlan(planType: String) -> Bool {
        return planType == PlanType.monthly.rawValue
    }
    
    private func isYearlyPlan(planID: String, planType: String) -> Bool {
        return planType == PlanType.yearly.rawValue && planID == "2"
    }
    
    private func isYearlyPlanWithPrintedCard(planID: String, planType: String) -> Bool {
        return planID == "3"
    }

    private func performAutoRenewableSubscription(planID: String, planType: String) {
        var inappPlanId = monthlySubscriptionPlanId
        if isMothlyPlan(planType: planType) {
            inappPlanId = monthlySubscriptionPlanId
        } else if isYearlyPlan(planID: planID, planType: planType) {
            inappPlanId = yearlySubscriptionPlanId
        }
        
        hudShow()
        TNInAppPurchaseHandler.sharedInstance.purchaseSubscriptionPlan(planId: planID, planIdentifier: inappPlanId, promoCode: nil)  { (result, error) in
            DispatchQueue.main.async {
                self.hudHide()
                if result != nil {
                    Common.showAlert(alertMessage: "Subscription Added", alertButtons: ["Ok"]) { btn in
                        if self.isFromSignup {
                            appDelegate.setHomeView()
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                } else {
                    Common.showAlert(alertMessage: error?.localizedDescription ?? "Error in inapp purchase, Please try again later", alertButtons: ["Ok"]) { btn in
                    }
                }
            }
        }
    }
    
    private func performRestoreSubscription(planID: String, planType: String) {
        var inappPlanId = monthlySubscriptionPlanId
        if isMothlyPlan(planType: planType) {
            inappPlanId = monthlySubscriptionPlanId
        } else if isYearlyPlan(planID: planID, planType: planType) {
            inappPlanId = yearlySubscriptionPlanId
        }
        
        hudShow()
        TNInAppPurchaseHandler.sharedInstance.restoreSubscriptionPlans(planId: planID, planIdentifier: inappPlanId, promoCode: nil)  { (result, error) in
            DispatchQueue.main.async {
                self.hudHide()
                if result != nil {
                    Common.showAlert(alertMessage: "Subscription Added", alertButtons: ["Ok"]) { btn in
                        if self.isFromSignup {
                            appDelegate.setHomeView()
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                } else {
                    Common.showAlert(alertMessage: error?.localizedDescription ?? "Error in inapp purchase, Please try again later", alertButtons: ["Ok"]) { btn in
                    }
                }
            }
        }
    }

    
    @objc func btnPrivacyPolicyTapped(_ sender: UIButton){
        let safariVC = SFSafariViewController(url: URL(string: "https://www.thetncard.com/privacy-policy/")!)
        present(safariVC, animated: true, completion: nil)

    }
    
    @objc func btnTNCTapped(_ sender: UIButton){
        let safariVC = SFSafariViewController(url: URL(string: "https://www.thetncard.com/terms-and-conditions/")!)
        present(safariVC, animated: true, completion: nil)

    }
    
    func getAllPlans() {
        ServiceClass.sharedInstance.hitServiceForPLanList( completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                print_debug("response: \(parseData)")
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                    for obj in parseData["data"].arrayValue {
                    let objPlan = PlanDTo(fromJson:obj)
                        self.planList.append(objPlan)
                    }
                } else {
                    self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                }
            self.tblplan.reloadData()
            })
    }
}
