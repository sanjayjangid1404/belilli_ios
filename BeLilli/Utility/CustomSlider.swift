//
//  CustomSlider.swift
//  BeLilli
//
//  Created by apple on 04/02/23.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
     var thumbTextLabel = UILabel()

    private var thumbFrame: CGRect {
        thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbTextLabel.text = "\(Int(value))" // change text as per required
        thumbTextLabel.frame = CGRect(x: thumbFrame.origin.x, y: thumbFrame.maxY - 5, width: 100, height: 30) // change width as per length of your text
        thumbTextLabel.center = CGPoint(x: thumbFrame.midX, y: thumbTextLabel.center.y)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(thumbTextLabel)
        // MARK: formate your label
        thumbTextLabel.font =  UIFont.systemFont(ofSize: 12, weight: .medium)
        thumbTextLabel.textAlignment = .center
        thumbTextLabel.textColor = .white
        thumbTextLabel.layer.zPosition = layer.zPosition + 1
    }
}
