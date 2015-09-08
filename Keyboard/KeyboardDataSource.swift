//
//  KeyboardDataSource.swift
//  Quick
//
//  Created by Ricardo Pereira on 06/09/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import UIKit
import RealmSwift

class KeyboardDataSource: NSObject, UITableViewDataSource {
    
    static let CellIdentifier = "Cell"
    
    private lazy var objects = Realm().objects(QuickString).sorted("date")
    
    override init() {
        super.init()
    }
    
    var items: Results<QuickString> {
        return objects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(KeyboardDataSource.CellIdentifier, forIndexPath: indexPath) as! UITableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let realm = Realm()
            
            tableView.beginUpdates()
            realm.write {
                realm.delete(self.items[indexPath.row])
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }
    
}
