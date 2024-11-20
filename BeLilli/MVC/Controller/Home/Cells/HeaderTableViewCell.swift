//
//  HeaderTableViewCell.swift
//  BeLilli
//
//  Created by apple on 03/02/23.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TNView: UIView!
    @IBOutlet weak var headingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(dataObj: HomeDTo?) {
        TNView.isHidden = !(dataObj?.isTNShow ?? false)
        if let sectionText = dataObj?.sectionName {
            headingLabel.text = sectionText
        }
    }
    
}
