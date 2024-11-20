//
//  ExploreTableViewCell.swift
//  BeLilli
//
//  Created by apple on 15/10/21.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnLike: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.imgUser!.image = nil

    }


}
