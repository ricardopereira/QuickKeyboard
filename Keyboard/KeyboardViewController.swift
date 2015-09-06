//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Ricardo Pereira on 31/08/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import RealmSwift

class KeyboardViewController: UIInputViewController {
    
    let tableView = UITableView()
    let dataSource = KeyboardDataSource()
    
    var notificationToken: NotificationToken?
    
    // UI
    var toolBarView: UIView!
    var toolBarTopConstraint: NSLayoutConstraint!
    let nextKeyboardButton = UIButton.buttonWithType(.Custom) as! UIButton
    let newStringButton = UIButton.buttonWithType(.Custom) as! UIButton
    let editButton = UIButton.buttonWithType(.Custom) as! UIButton
    let settingsButton = UIButton.buttonWithType(.Custom) as! UIButton
    let textField = UITextField()

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: KeyboardDataSource.CellIdentifier)
        //tableView.setEditing(true, animated: true)
        
        setupUI()
        
        toolBarView.backgroundColor = UIColor.blueColor()
        
        // Set Realm notification block
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        toolBarView.hidden = true
        toolBarTopConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    func setupColors(appearence: UIKeyboardAppearance) {
        var textColor: UIColor
        
        switch appearence {
        case .Dark:
            textColor = UIColor.whiteColor()
        default:
            textColor = UIColor.blackColor()
        }
        
        nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
        newStringButton.setTitleColor(textColor, forState: .Normal)
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
        let proxy = self.textDocumentProxy as! UITextDocumentProxy
        // Colors
        if let keyboardAppearance = proxy.keyboardAppearance {
            setupColors(keyboardAppearance)
        }
    }
    
    
    // MARK: - Actions
    
    func didTouchNextKeyboardButton() {
        println("didTouchNextKeyboardButton")
        advanceToNextInputMode()
    }
    
    func didTouchNewButton(Sender: AnyObject) {
        println("didTouchNewButton")
        toolBarView.hidden = true
        toolBarTopConstraint.constant = 36.0
        
        let realm = Realm()
        
        realm.write {
            realm.create(QuickString.self, value: ["ricardopereira.eu@gmail.com ", NSDate()])
        }
    }

}

extension KeyboardViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.items[indexPath.row]
        
        if let proxy  = textDocumentProxy as? UIKeyInput {
            proxy.insertText(item.value)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.text = dataSource.items[indexPath.row].value
    }

}

extension KeyboardViewController {
    
    func setupUI() {
        // Table View
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(tableView)
        
        // Bars
        let barHeight: CGFloat = 36.0
        
        let menuBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, barHeight))
        menuBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        menuBarView.backgroundColor = view.backgroundColor
        view.addSubview(menuBarView)
        
        toolBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, barHeight))
        toolBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        toolBarView.backgroundColor = view.backgroundColor
        view.addSubview(toolBarView)
        
        // Buttons
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextKeyboardButton.setTitle("Next keyboard", forState: .Normal)
        nextKeyboardButton.addTarget(self, action: Selector("didTouchNextKeyboardButton:"), forControlEvents: .TouchUpInside)
        menuBarView.addSubview(nextKeyboardButton)
        
        newStringButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        newStringButton.setTitle("New", forState: .Normal)
        newStringButton.addTarget(self, action: Selector("didTouchNewButton:"), forControlEvents: .TouchUpInside)
        menuBarView.addSubview(newStringButton)
        
        /*
        editButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        editButton.setTitle("Edit", forState: .Normal)
        editButton.addTarget(self, action: Selector("didTouchEditButton:"), forControlEvents: .TouchUpInside)
        menuBarView.addSubview(editButton)
        
        settingsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        settingsButton.setTitle("Settings", forState: .Normal)
        settingsButton.addTarget(self, action: Selector("didTouchSettingsButton:"), forControlEvents: .TouchUpInside)
        menuBarView.addSubview(settingsButton)
        */
        
        // Layout
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let marginButtons: CGFloat = 5.0
        var constraints: [NSLayoutConstraint] = []
        
        // Menu bar: bottom
        constraints += [NSLayoutConstraint(item: menuBarView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -barHeight)]
        constraints += [NSLayoutConstraint(item: menuBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: menuBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)]
        view.addConstraints(constraints)

        menuBarView.addConstraints([NSLayoutConstraint(item: menuBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: barHeight)])
        
        // Tool bar: top
        constraints = []
        constraints += [NSLayoutConstraint(item: toolBarView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: toolBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: toolBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)]
        view.addConstraints(constraints)

        toolBarTopConstraint = NSLayoutConstraint(item: toolBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: barHeight)
        toolBarView.addConstraint(toolBarTopConstraint)

        
        // Next keyboard button
        constraints = []
        constraints += [NSLayoutConstraint(item: nextKeyboardButton, attribute: .Top, relatedBy: .Equal, toItem: menuBarView, attribute: .Top, multiplier: 1.0, constant: marginButtons)]
        constraints += [NSLayoutConstraint(item: nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: menuBarView, attribute: .Left, multiplier: 1.0, constant: marginButtons)]
        menuBarView.addConstraints(constraints)
        
        // Add button
        constraints = []
        constraints += [NSLayoutConstraint(item: newStringButton, attribute: .Top, relatedBy: .Equal, toItem: menuBarView, attribute: .Top, multiplier: 1.0, constant: marginButtons)]
        constraints += [NSLayoutConstraint(item: newStringButton, attribute: .Left, relatedBy: .Equal, toItem: nextKeyboardButton, attribute: .Right, multiplier: 1.0, constant: marginButtons)]
        menuBarView.addConstraints(constraints)
        
        /*
        let views: [NSObject:AnyObject] = ["toolBar":toolBarView, "table":tableView, "menuBar":menuBarView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[toolBar]-[table]-[menuBar]-0@999-|", options: .allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[table]|", options: .allZeros, metrics: nil, views: views))
        */
        
        // Table View
        constraints = []
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: toolBarView, attribute: .Bottom, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)]
        view.addConstraints(constraints)
        tableView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 100))
    }
    
}
