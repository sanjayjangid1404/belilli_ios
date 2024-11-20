//
//  ActivityTableViewCell.swift
//  BeLilli
//
//  Created by apple on 05/03/23.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(data: BusinessDTo?) {
        guard let dataObj = data  else { return }
        businessNameLabel.text = dataObj.business_name
        discountLabel.text = dataObj.offer_name
        dateLabel.text = dataObj.redeem_date
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
