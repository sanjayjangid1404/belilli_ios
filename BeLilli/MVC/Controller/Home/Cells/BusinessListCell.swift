//
//  BusinessListCell.swift
//  BeLilli
//
//  Created by apple on 27/10/21.
//

import UIKit

protocol BusinessCellDelegate: AnyObject {
    func didselectAction(data: LandingDataProtocol?)
}

class BusinessListCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblCategoryType: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnTopView: UIButton!
    
     weak var delegate: BusinessCellDelegate?
    
    var data: LandingDataProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgUser.clipsToBounds = true
        imgUser.layer.cornerRadius = 12
        imgUser.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 12
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setup(heading: String, data: LandingDataProtocol?) {
        self.data = data
        if let data = data as? BusinessDTo {
            lblHeading.text = data.business_name
            lblDiscount.text = data.offer_title
            lblDistance.text = data.town
            lblCategoryType.textAlignment = .center
            lblCategoryType.text = (data.category_name ?? "")
            imgUser.sd_setImage(with: URL(string: ServiceUrls.baseUrlImage + (data.image ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
        }
    }
    
    @IBAction func buttonTopAction(_ sender: UIButton) {
        delegate?.didselectAction(data: self.data)
    }


}
