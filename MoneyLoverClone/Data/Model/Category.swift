//
//  Category.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var identify = ""
    @objc dynamic var image = ""
    @objc dynamic var name = ""
    @objc dynamic var transactionType = ""

    convenience init(image: String, name: String, transactionType: String) {
        self.init()
        self.identify = UUID().uuidString
        self.image = image
        self.name = name
        self.transactionType = transactionType
    }
    
    override class func primaryKey() -> String? {
        return "identify"
    }
}
