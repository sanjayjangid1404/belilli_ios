//
//  TNClickableLabel.swift
//  BeLilli
//
//  Created by Suresh Jangid on 05/01/22.
//

import UIKit

class TNClickableLabel: UILabel {
    
    fileprivate var tapGestureRecognizerAction : (() -> Void)?
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action()
        }
    }

}
