//
//  BannerCollectionViewCell.swift
//  BeLilli
//
//  Created by apple on 09/10/21.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDescriptionText: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnRedeem: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    
}
