//
//  TNCustomSwitch.swift
//  BeLilli
//
//  Created by apple on 22/01/22.
//

import UIKit

@IBDesignable

class CustomSwitch: UISwitch {
    
    var section : Int?
    
    var OnColor : UIColor! = UIColor(hexString: "#9DADA2")
    var OffColor : UIColor! = UIColor(hexString: "#DEDEDE")
    var Scale : CGFloat! = 1.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpCustomUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpCustomUserInterface()
    }
    
    
    func setUpCustomUserInterface() {
        
        //clip the background color
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        //Scale down to make it smaller in look
        self.transform = CGAffineTransform(scaleX: self.Scale, y: self.Scale);
                
        //set onTintColor : is necessary to make it colored
        self.onTintColor = self.OffColor
        
        //setup to initial state
        self.updateUI()
    }
    
    override func setOn(_ on: Bool, animated: Bool) {
        super.setOn(on, animated: true)
        updateUI()
    }
    
    func updateUI() {
        if self.isOn == true {
            self.thumbTintColor = self.OnColor
        }
        else {
            self.thumbTintColor = self.OffColor
        }
    }
    
    
}
