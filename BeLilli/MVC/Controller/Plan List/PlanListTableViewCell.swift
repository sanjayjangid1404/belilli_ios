//
//  PlanListTableViewCell.swift
//  BeLilli
//
//  Created by apple on 06/11/21.
//

import UIKit

class PlanListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTopText: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblpriceSign: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var lblRestoreDescription: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class PlanListStaticTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnTermsCondition: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

