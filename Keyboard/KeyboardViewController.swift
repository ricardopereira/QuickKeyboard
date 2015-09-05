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

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.addString("ricardopereira.eu@gmail.com")
        dataSource.addString("Bom dia")
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ClassicCell")
        view.addSubview(tableView)
        
        let topBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 24))
        topBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        topBarView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(topBarView)
        
        var constraints = [NSLayoutConstraint]()
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)]
        view.addConstraints(constraints)

        
        constraints = []
        constraints += [NSLayoutConstraint(item: topBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 36.0)]
        topBarView.addConstraints(constraints)


        constraints = []
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 36.0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 180.0)]
        constraints += [NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)]
        view.addConstraints(constraints)
        
        tableView.reloadData()
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
    
    func didTapNextKeyboardButton() {
        advanceToNextInputMode()
    }

}

extension KeyboardViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let string = dataSource.items[indexPath.row]
        
        if let proxy  = textDocumentProxy as? UIKeyInput {
            proxy.insertText(string)
            proxy.insertText("\n")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
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
