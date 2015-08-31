//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Ricardo Pereira on 31/08/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    let tableView = UITableView()

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Table
        tableView.delegate = self
        tableView.dataSource = KeyboardDataSource(list: [])
    
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton.buttonWithType(.System) as! UIButton
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.nextKeyboardButton)
    
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as! UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}

extension KeyboardViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.textLabel?.text = list[indexPath.row]
    }
    
}

class KeyboardDataSource<T: NSArray>: NSObject, UITableViewDataSource {
    
    let list: T
    
    init(list: T) {
        self.list = list
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("ClassicCell", forIndexPath: indexPath) as! UITableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
}
