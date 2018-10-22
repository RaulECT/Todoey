//
//  Category.swift
//  Todoey
//
//  Created by Raul  Canul on 10/15/18.
//  Copyright © 2018 Raul  Canul. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
