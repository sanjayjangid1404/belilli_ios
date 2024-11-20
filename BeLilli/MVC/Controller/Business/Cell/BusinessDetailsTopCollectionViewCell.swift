//
//  BusinessDetailsTopCollectionViewCell.swift
//  BeLilli
//
//  Created by apple on 02/03/23.
//

import UIKit

class BusinessDetailsTopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setUpValues(value: String, isRedColor: Bool) {
        titleLabel.text = "  \(value)  "
        mainView.cornerRadius = mainView.frame.height/2
        mainView.clipsToBounds = true
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = isRedColor ? UIColor.red.cgColor : UIColor.blue.cgColor
        titleLabel.textColor = isRedColor ? UIColor.red : UIColor.blue
        
    }
}
