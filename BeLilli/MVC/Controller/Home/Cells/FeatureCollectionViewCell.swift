//
//  FeatureCollectionViewCell.swift
//  BeLilli
//
//  Created by apple on 04/02/23.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblCategoryType: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUser.clipsToBounds = true
        imgUser.layer.cornerRadius = 12
        imgUser.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 12
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        mainView.layer.cornerRadius = 12
        mainView.layer.borderColor = UIColor.lightGray.cgColor
        mainView.layer.borderWidth = 1.0
        
    }
    
    func setup(heading: String, data: BusinessDTo?) {
                
        if let data = data {
            lblHeading.text = data.business_name
            lblDiscount.text = data.offer_title
            lblDistance.text = data.town
            lblCategoryType.textAlignment = .center
            lblCategoryType.text = (data.category_name ?? "") 
            
            imgUser.sd_setImage(with: URL(string: ServiceUrls.baseUrlImage + (data.image ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder_icon"))
        }
    }

}
