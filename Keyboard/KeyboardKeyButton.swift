//
//  KeyboardKeyButton.swift
//  Quick
//
//  Created by Ricardo Pereira on 08/09/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class KeyboardKeyButton: UIButton {
    
    func setupKey() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
        layer.cornerRadius = 4.0
        backgroundColor = UIColor(red: 171, green: 178, blue: 186, alpha: 1.0)
    }
    
    func prepareForLayout() {
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func setLayout(size: CGSize) {
        // Remove old constraints
        removeConstraints(constraints())
        // Set new ones
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 0, constant: size.width))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 0, constant: size.height))
    }
    
}
