//
//  CategoryCollectionViewCell.swift
//  BeLilli
//
//  Created by apple on 10/10/22
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblHead: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgContainerView.dropShadow(cornerRadius: 12, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], color: .darkGray, offset: .zero, opacity: 0.7, shadowRadius: 5)
        self.layoutIfNeeded()
    }
    

    
}
