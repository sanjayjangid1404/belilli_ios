//
//  NotifcationTableViewCell.swift
//  BeLilli
//
//  Created by apple on 30/10/21.
//

import UIKit

class NotifcationTableViewCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
