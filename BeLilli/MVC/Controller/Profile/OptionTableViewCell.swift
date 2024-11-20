//
//  OptionTableViewCell.swift
//  BeLilli
//
//  Created by apple on 06/11/21.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var imgOption: UIImageView!
    @IBOutlet weak var lblOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
