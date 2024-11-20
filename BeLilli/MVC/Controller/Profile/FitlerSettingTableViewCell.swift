//
//  FitlerSettingTableViewCell.swift
//  BeLilli
//
//  Created by apple on 16/01/22.
//

import UIKit

class FitlerSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var lbllblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var switchFilter: CustomSwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
