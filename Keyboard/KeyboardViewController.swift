//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Ricardo Pereira on 31/08/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    let tableView = UITableView()
    let dataSource = KeyboardDataSource()
    
    let nextKeyboardButton = UIButton.buttonWithType(.Custom) as! UIButton
    let addStringButton = UIButton.buttonWithType(.Custom) as! UIButton

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.addString("Thank you")
        dataSource.addString("very")
        dataSource.addString("much")
        dataSource.addString("for")
        dataSource.addString("your")
        dataSource.addString("help")
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ClassicCell")
        
        setupUI()
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
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
        
        addStringButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        addStringButton.setTitle("Add", forState: .Normal)
        addStringButton.addTarget(self, action: Selector("didTouchAddButton:"), forControlEvents: .TouchUpInside)
        topBarView.addSubview(addStringButton)
        
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
        constraints += [NSLayoutConstraint(item: addStringButton, attribute: .Top, relatedBy: .Equal, toItem: topBarView, attribute: .Top, multiplier: 1.0, constant: marginButtons)]
        constraints += [NSLayoutConstraint(item: addStringButton, attribute: .Left, relatedBy: .Equal, toItem: nextKeyboardButton, attribute: .Right, multiplier: 1.0, constant: marginButtons)]
        topBarView.addConstraints(constraints)
        
        
        // TableView
        constraints = []
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: topBarView, attribute: .Bottom, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)]
        view.addConstraints(constraints)
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
        addStringButton.setTitleColor(textColor, forState: .Normal)
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
    
    func didTouchAddButton() {
        
    }

}

extension KeyboardViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let string = dataSource.items[indexPath.row]
        
        if let proxy  = textDocumentProxy as? UIKeyInput {
            proxy.insertText(string)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.text = dataSource.items[indexPath.row]
    }

}

class KeyboardDataSource: NSObject, UITableViewDataSource {

    private var list: [String] = []

    override init() {
        super.init()
    }
    
    var items: [String] {
        return list
    }
    
    func addString(value: String) {
        list.append(value)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("ClassicCell", forIndexPath: indexPath) as! UITableViewCell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

}
