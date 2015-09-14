//
//  QuickEditStringView.swift
//  Quick
//
//  Created by Ricardo Pereira on 12/09/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class QuickEditStringView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "QuickEditStringView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(view)
    }
    
}
