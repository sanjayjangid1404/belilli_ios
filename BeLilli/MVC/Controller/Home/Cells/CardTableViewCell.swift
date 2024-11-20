//
//  CardTableViewCell.swift
//  BeLilli
//
//  Created by apple on 17/01/22.
//

import UIKit

protocol CardTapDelegate: AnyObject {
    func didCardTapped()
    func didInactiveCardTapped()
}


class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName  : UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    @IBOutlet weak var veCard   : UIView!
    @IBOutlet weak var vwPaymentBack   : UIView!
    @IBOutlet weak var btnSubscription   : UIButton!
    
    weak var cardDelegate : CardTapDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        veCard.applyShadowWithCornerRadius(color: .lightGray, opacity: 0.2, radius: 8, edge: .All, shadowSpace: 8, cornerRadius: 8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        veCard.applyShadowWithCornerRadius(color: .lightGray, opacity: 0.2, radius: 8, edge: .All, shadowSpace: 8, cornerRadius: 8)
        self.veCard.layoutIfNeeded()
        self.layoutIfNeeded()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.veCard.addGestureRecognizer(tap)
        
        let tapOnInactive = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnInactive(_:)))
        self.vwPaymentBack.addGestureRecognizer(tapOnInactive)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        cardDelegate?.didCardTapped()
    }
    
    @objc func handleTapOnInactive(_ sender: UITapGestureRecognizer? = nil) {
        cardDelegate?.didInactiveCardTapped()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(objPlan : PlanDTo?) {
        
        lblName.text = (objPlan?.first_name ?? "") + " " + (objPlan?.last_name ?? "")
        lblNumber.text = objPlan?.membership_no
        lblExpiry.text = objPlan?.end_date
        
        if isUserSubscriptionActive(subscriptionStatus: objPlan?.subscription_status ?? "0") {
            lblActive.text = "Active"
            lblActive.textColor = UIColor(hexString: "#159505")
            vwPaymentBack.isHidden = true
        } else {
            lblActive.text = "Inactive"
            lblActive.textColor = .red
            vwPaymentBack.isHidden = false
        }
    }
    
    private func isUserSubscriptionActive(subscriptionStatus: String) -> Bool {
        return subscriptionStatus == SubscriptionStatus.active.rawValue
    }

}
