//
//  ViewController.swift
//  Quick
//
//  Created by Ricardo Pereira on 31/08/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func askString(success: (String)->()) {
        let alertController = UIAlertController(title: "Quick String", message: nil, preferredStyle: .Alert)
        
        let addStringAction = UIAlertAction(title: "Add", style: .Default) { action in
            // Did press
            if let stringField = alertController.textFields?[0] as? UITextField {
                success(stringField.text)
            }
            
        }
        addStringAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        // Text field: string value
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "String"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { notification in
                addStringAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(addStringAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

