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
    var menuBarView: UIView!
    // UI Interaction
    let nextKeyboardButton = KeyboardKeyButton.buttonWithType(.System) as! KeyboardKeyButton
    let newStringButton = KeyboardKeyButton.buttonWithType(.System) as! KeyboardKeyButton

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: KeyboardDataSource.CellIdentifier)
        
        setupUI()
        
        // Migration
        let config = Realm.Configuration(schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // https://realm.io/docs/swift/latest/api/Classes/Migration.html#/s:FC10RealmSwift9Migration10deleteDataFS0_FSSSb
                    migration.deleteData(QuickString.className())
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = Realm()
        
        // Set Realm notification block
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    deinit {
        if let token = notificationToken {
            Realm().removeNotification(token)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //toolBarView.hidden = true
        //toolBarTopConstraint.constant = 0
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
        nextKeyboardButton.tintColor = textColor
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
    
    func didTouchNewStringButton(Sender: AnyObject) {
        println("didTouchNewButton")
        if let newString = UIPasteboard.generalPasteboard().string {
            let realm = Realm()
            // Query using an NSPredicate
            let predicate = NSPredicate(format: "value = %@", newString)
            let result = realm.objects(QuickString).filter(predicate)
            // Result
            if result.count == 0 {
                realm.write {
                    realm.create(QuickString.self, value: [newString, NSDate()])
                }
            }
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


// MARK: - Layout

struct Constants {
    
    // Bars
    static let barHeight: CGFloat = 48.0
    
}

extension KeyboardViewController {
    
    func prepareViews() {
        // Table View
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(tableView)
        
        menuBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, Constants.barHeight))
        menuBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        menuBarView.backgroundColor = view.backgroundColor
        view.addSubview(menuBarView)
        
        // Buttons
        nextKeyboardButton.setImage(UIImage(named: "Globe"), forState: .Normal)
        nextKeyboardButton.addTarget(self, action: Selector("didTouchNextKeyboardButton:"), forControlEvents: .TouchUpInside)
        nextKeyboardButton.prepareForLayout()
        nextKeyboardButton.setupKey()
        menuBarView.addSubview(nextKeyboardButton)
        
        newStringButton.setTitle("+", forState: .Normal)
        newStringButton.addTarget(self, action: Selector("didTouchNewStringButton:"), forControlEvents: .TouchUpInside)
        newStringButton.prepareForLayout()
        newStringButton.setupKey()
        menuBarView.addSubview(newStringButton)
    }
    
    func layoutViews() {
        // Layout
        let marginButtons: CGFloat = 4.0
        let buttonSize = CGSizeMake(40, 40)
        var constraints: [NSLayoutConstraint] = []
        
        // Menu bar: bottom
        constraints += [NSLayoutConstraint(item: menuBarView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -Constants.barHeight)]
        constraints += [NSLayoutConstraint(item: menuBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: menuBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)]
        view.addConstraints(constraints)
        
        menuBarView.addConstraints([NSLayoutConstraint(item: menuBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: Constants.barHeight)])
        
        // Next keyboard button
        constraints = []
        constraints += [NSLayoutConstraint(item: nextKeyboardButton, attribute: .Top, relatedBy: .Equal, toItem: menuBarView, attribute: .Top, multiplier: 1.0, constant: marginButtons)]
        constraints += [NSLayoutConstraint(item: nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: menuBarView, attribute: .Left, multiplier: 1.0, constant: marginButtons)]
        menuBarView.addConstraints(constraints)
        
        nextKeyboardButton.setLayout(buttonSize)
        
        // New String button
        constraints = []
        constraints += [NSLayoutConstraint(item: newStringButton, attribute: .Top, relatedBy: .Equal, toItem: menuBarView, attribute: .Top, multiplier: 1.0, constant: marginButtons)]
        constraints += [NSLayoutConstraint(item: newStringButton, attribute: .Left, relatedBy: .Equal, toItem: nextKeyboardButton, attribute: .Right, multiplier: 1.0, constant: marginButtons)]
        menuBarView.addConstraints(constraints)
        
        newStringButton.setLayout(buttonSize)
        
        /*
        let views: [NSObject:AnyObject] = ["toolBar":toolBarView, "table":tableView, "menuBar":menuBarView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[toolBar]-[table]-[menuBar]-0@999-|", options: .allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[table]|", options: .allZeros, metrics: nil, views: views))
        */
        
        // Table View
        constraints = []
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)]
        view.addConstraints(constraints)
        tableView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 120))
    }
    
    func setupUI() {
        prepareViews()
        layoutViews()
    }
    
}
