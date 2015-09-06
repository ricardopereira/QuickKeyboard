//
//  QuickString.swift
//  Quick
//
//  Created by Ricardo Pereira on 06/09/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import RealmSwift

class QuickString: Object {
    dynamic var value = ""
    dynamic var date = NSDate()
    dynamic var lastUsed = NSDate()
}
