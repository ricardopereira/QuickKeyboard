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
    let nextKeyboardButton = UIButton.buttonWithType(.Custom) as! UIButton
    let newStringButton = UIButton.buttonWithType(.Custom) as! UIButton
    let editButton = UIButton.buttonWithType(.Custom) as! UIButton
    let settingsButton = UIButton.buttonWithType(.Custom) as! UIButton

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: KeyboardDataSource.CellIdentifier)
        
        setupUI()
        
        // Set Realm notification block
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

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
        advanceToNextInputMode()
    }
    
    func didTouchNewButton(Sender: AnyObject) {
        let realm = Realm()
        
        realm.write {
            realm.create(QuickString.self, value: ["", NSDate()])
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let realm = Realm()
            
            realm.write {
                realm.delete(self.dataSource.items[indexPath.row])
            }
        }
    }

}

extension KeyboardViewController {
    
    func setupUI() {
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(tableView)
        
        let topBarHeight: CGFloat = 36.0
        let topBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, topBarHeight))
        topBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        topBarView.backgroundColor = view.backgroundColor
        view.addSubview(topBarView)
        
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextKeyboardButton.setTitle("Next keyboard", forState: .Normal)
        nextKeyboardButton.addTarget(self, action: Selector("didTouchNextKeyboardButton:"), forControlEvents: .TouchUpInside)
        topBarView.addSubview(nextKeyboardButton)
        
        newStringButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        newStringButton.setTitle("New", forState: .Normal)
        newStringButton.addTarget(self, action: Selector("didTouchNewButton:"), forControlEvents: .TouchUpInside)
        topBarView.addSubview(newStringButton)
        
        /*
        editButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        editButton.setTitle("Edit", forState: .Normal)
        editButton.addTarget(self, action: Selector("didTouchEditButton:"), forControlEvents: .TouchUpInside)
        topBarView.addSubview(editButton)
        
        settingsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        settingsButton.setTitle("Settings", forState: .Normal)
        settingsButton.addTarget(self, action: Selector("didTouchSettingsButton:"), forControlEvents: .TouchUpInside)
        topBarView.addSubview(settingsButton)
        */
        
        let marginButtons: CGFloat = 5.0
        var constraints = [NSLayoutConstraint]()
        
        // Top bar
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)]
        view.addConstraints(constraints)
        
        constraints = []
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: topBarHeight)]
        topBarView.addConstraints(constraints)
        
        // Next keyboard button
        constraints = []
        constraints += [NSLayoutConstraint(item: nextKeyboardButton, attribute: .Top, relatedBy: .Equal, toItem: topBarView, attribute: .Top, multiplier: 1.0, constant: marginButtons)]
        constraints += [NSLayoutConstraint(item: nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: topBarView, attribute: .Left, multiplier: 1.0, constant: marginButtons)]
        topBarView.addConstraints(constraints)
        
        // Add button
        constraints = []
        constraints += [NSLayoutConstraint(item: newStringButton, attribute: .Top, relatedBy: .Equal, toItem: topBarView, attribute: .Top, multiplier: 1.0, constant: marginButtons)]
        constraints += [NSLayoutConstraint(item: newStringButton, attribute: .Left, relatedBy: .Equal, toItem: nextKeyboardButton, attribute: .Right, multiplier: 1.0, constant: marginButtons)]
        topBarView.addConstraints(constraints)
        
        
        // TableView
        constraints = []
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: topBarView, attribute: .Bottom, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)]
        view.addConstraints(constraints)
    }
    
}
