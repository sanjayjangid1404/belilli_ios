//
//  PageCollectionViewCell.swift
//  ASOEBI
//
//  Created by apple on 21/09/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var constraintH: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    
}
